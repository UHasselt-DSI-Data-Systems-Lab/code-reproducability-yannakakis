# Description: Parse the JSON output of DuckDB's EXPLAIN ANALYZE command into a Plan object
# Usage: python parse_duckdb_plan.py <file_path>
# Or use the parse_plan function in another script

# Supports self-joins. It assumes that SeqScan nodes contain the alias name (not the original relation name).

import json
import warnings
import re

from .plan import (
    MergeJoinNode,
    NestedLoopJoinNode,
    TreeNode,
    Plan,
    HashJoinNode,
    FilterNode,
    SequentialScanNode,
    ProjectionNode,
    AggregateNode,
    parse_join_condition,
    traverse_preorder,
)
from .field import Field
from .equivalence_classes import EquivalenceClasses


def get(node, key):
    """Get the value of a key from a dictionary, or return None if the key is not present."""
    if key in node:
        return node[key]
    return None


def rewrite_aggregate_expression(expr: str, child_output: list[Field] | None) -> list[str]:
    """Rewrite aggregate expression to valid SQL syntax.
    e.g: `"min(#0)\nmin(#1)\nmin(#2)"` to `["min(mc.note)","min(t.title)","min(t.production_year)"]`
    where #0 refers to the first field in the child output, #1 to the second, etc.

    Note that this is only possible if the child schema is given.
    If not, then '#0' etc. won't be replaced, and `"min(#0)\nmin(#1)\nmin(#2)"` will be rewritten to `["min(#0)","min(#1)","min(#2)"]`.
    """

    if child_output is None:
        return expr.split("\n")

    # Define a function to replace the placeholder with the corresponding field name
    def replace_placeholder(match) -> str:
        index = int(match.group(1))
        if 0 <= index < len(child_output):
            field = child_output[index]
            return str(field)
        else:
            raise IndexError(f"Projection attribute #{index} out of range")

    # Use regex to find all placeholders in the format #i
    pattern = re.compile(r"#(\d+)")

    # Split the expression by lines, replace placeholders, and join with commas
    return [pattern.sub(replace_placeholder, line) for line in expr.split("\n")]


def parse_extra_info_from_seqscan(extra_info: str) -> tuple[str, list[Field], str | None, int]:
    """Get the relation, projection, filter (opt) and estimated cardinality from the extra_info string of a sequential scan node."""
    parts = extra_info.split("\n[INFOSEPARATOR]\n")

    ec = parts[-1]
    assert ec.startswith("EC: "), f"Expected 'EC:', got: {ec}"
    ec = int(ec[3:].strip())
    parts = parts[:-1]

    relation: str = parts[0]
    projection = parts[1].split("\n")
    proj = [Field.from_str(field) for field in projection]

    for field in proj:
        field.table_name = relation

    if len(parts) > 2:
        filter = parts[2][len("Filters: ") :]  # Skip the "Filters: " prefix
        filter = filter.strip("\n")  # Trim leading and trailing newlines
    else:
        filter = None

    return relation, proj, filter, ec


def parse_extra_info_from_filter(extra_info: str) -> tuple[str, int]:
    """Get the filter condition and estimated cardinality from the extra_info string of a filter node."""
    # eg: "(it.id >= 99)\n[INFOSEPARATOR]\nEC: 1"
    parts = extra_info.split("\n[INFOSEPARATOR]\n")
    ec = parts[-1]
    assert ec.startswith("EC:"), f"Expected 'EC:', got: {ec}"
    ec = int(ec[3:].strip())
    parts = parts[:-1]

    if len(parts) != 1:
        warnings.warn(f"Filter node extra_info has unexpected format: {extra_info}")
    return parts[0], ec


def parse_extra_info_from_projection(extra_info: str) -> list[Field]:
    """Get the projection fields from the extra_info string of a projection node."""
    # eg: "mc.note\nt.title\nt.production_year\n"
    # eg: "#0\n#1\n#2\n"
    attrs: list[str] = extra_info.strip("\n").split("\n")
    return [Field.from_str(attr) for attr in attrs]


def parse_extra_info_from_hashjoin(extra_info: str) -> tuple[str, str]:
    """Returns the join type and join condition from the extra_info string of a hash join node."""
    # eg: "INNER\nComment.hasCreator_PersonId = Person_knows_Person.Person1Id\nPost.hasCreator_PersonId = Person_knows_Person.Person2Id\n\n[INFOSEPARATOR]\nEC: 114245953\n",
    # join type = "inner", join condition = "mi_idx.info_type_id = it.id"
    parts = extra_info.split("\n\n[INFOSEPARATOR]\n")
    parts = parts[:-1]  # remove final part (contains the estimated cost)
    parts = parts[0].split("\n")
    join_type, remainder = parts[0], parts[1:]
    return (join_type, " AND ".join(remainder))


def rewrite_filter_condition(condition: str) -> str:
    """Rewrite filter condition to valid SQL syntax.
    e.g: contains(chn.name, 'man') -> ctn.name LIKE '%man%'
    e.g: mi.info ~~ 'Japan:%2007%' -> mi.info LIKE 'Japan:%2007%'
    e.g: prefix(cn.name, 'Lionsgate') -> cn.name LIKE 'Lionsgate%'
    """
    # Define the pattern for the "contains" function
    contains_pattern = r"contains\(([^,]+),\s*'([^']+)'\)"
    contains_replacement = r"\1 LIKE '%\2%'"

    # Define the pattern for the "~~" operator
    tilde_pattern = r"([^~\s]+)\s*~~\s*'([^']+)'"
    tilde_replacement = r"\1 LIKE '\2'"

    # Define the pattern for the "prefix" function
    prefix_pattern = r"prefix\(([^,]+),\s*'([^']+)'\)"
    prefix_replacement = r"\1 LIKE '\2%'"

    # Perform the substitutions
    condition = re.sub(contains_pattern, contains_replacement, condition, flags=re.IGNORECASE)
    condition = re.sub(tilde_pattern, tilde_replacement, condition, flags=re.IGNORECASE)
    condition = re.sub(prefix_pattern, prefix_replacement, condition, flags=re.IGNORECASE)

    return condition


def parse_filter_node(node) -> FilterNode:
    # Must have one child
    assert len(node["children"]) == 1, "Filter node must have one child."
    child = node["children"][0]

    # If child is a hash join (join_type="MARK"),
    # then it is a rewriting of a "IN-clause"
    # we do not explicitly represent this 'join' in our tree
    #
    # e.g. filter: "IN (...)\n[INFOSEPARATOR]\nEC: 26834"
    # e.g. mark join: "MARK\nk.keyword = #0\n\n[INFOSEPARATOR]\nEC: 134170\n"
    has_in_clause = child["name"] == "HASH_JOIN" and "MARK" in child["extra_info"]
    if has_in_clause:
        attr: str = (
            child["extra_info"].split("\n\n[INFOSEPARATOR]\n")[0].split("\n")[1].split(" = ")[0]
        )
        in_clause, ec = parse_extra_info_from_filter(node["extra_info"])
        condition: str = attr + " " + in_clause
        children = child["children"]
        assert len(children) == 2, "Hash Join node must have two children."
        c1, c2 = children
        assert c1["name"] == "COLUMN_DATA_SCAN" or c2["name"] == "COLUMN_DATA_SCAN"
        if c1["name"] == "COLUMN_DATA_SCAN":
            child = c2
        else:
            child = c1
    else:
        condition, ec = parse_extra_info_from_filter(node["extra_info"])

    # Rewrite the filter condition to valid SQL syntax
    condition = rewrite_filter_condition(condition)
    condition = condition.replace("\n", " AND ")

    return FilterNode(
        condition,
        child=parse_duckdb_treenode(child),
        execution_time=get(node, "timing"),
        actual_rows=get(node, "cardinality"),
        estimated_cardinality=ec,
    )


def parse_hashjoin_node(node) -> HashJoinNode:
    # Must have two children:
    # - the left (1st) child is the probe side
    # - the right (2nd) child is the build side
    assert len(node["children"]) == 2, "Hash Join node must have two children."
    probe_child, build_child = node["children"]
    probe_child = parse_duckdb_treenode(probe_child)
    build_child = parse_duckdb_treenode(build_child)
    join_type, join_condition = parse_extra_info_from_hashjoin(node["extra_info"])
    assert join_type == "INNER", "Only inner hash joins are supported."

    return HashJoinNode(
        probe_child=probe_child,
        build_child=build_child,
        execution_time=get(node, "timing"),
        actual_rows=get(node, "cardinality"),
        condition=join_condition,
    )


def parse_projection_node(node) -> ProjectionNode:
    child = parse_duckdb_treenode(node["children"][0])
    # Detect whether child is the special filter node for IN-clauses.
    # In DuckDB, the output schema of these filter nodes contains an extra boolean attribute on the right,
    # indicating whether the IN-clause is satisfied or not (which is already computed by the MARK join node)
    # This boolean attribute is excluded from the intermediate plan format, but we must take it into account when parsing the DuckDB's projection attributes!
    special_filter = isinstance(child, FilterNode) and "IN (" in child.condition

    on: list[Field] = parse_extra_info_from_projection(node["extra_info"])
    new_on: list[Field] = []

    for field in on:
        match = re.compile(r"#(\d+)").search(field.__str__())  # match "#0", "#1", etc.
        if match:
            # replace positional reference by actual field
            nr = int(match.group(1))
            if special_filter and nr == len(child.output):
                # Skip references to the boolean IN-clause attribute
                continue
            new_field = child.output[nr]
            new_on.append(new_field)
        else:
            new_on.append(field)

    return ProjectionNode(new_on, child, get(node, "timing"), get(node, "cardinality"))


def parse_seq_scan_node(node) -> SequentialScanNode:
    rel, projection, filter, ec = parse_extra_info_from_seqscan(node["extra_info"])
    if filter is not None:
        filter = filter.replace("\n", " AND ")

    return SequentialScanNode(
        rel, get(node, "timing"), get(node, "cardinality"), ec, projection, filter
    )


def parse_duckdb_treenode(node) -> TreeNode:
    name = node["name"]

    match name:

        case "UNGROUPED_AGGREGATE":
            child = parse_duckdb_treenode(node["children"][0])
            if isinstance(child, ProjectionNode):
                child_schema = child.on
            else:
                child_schema = None
            return AggregateNode(
                child,
                execution_time=get(node, "timing"),
                actual_rows=get(node, "cardinality"),
                group_by=None,
                aggregate=rewrite_aggregate_expression(node["extra_info"], child_schema),
            )

        case "HASH_JOIN":
            return parse_hashjoin_node(node)

        case "FILTER":
            return parse_filter_node(node)

        case "PROJECTION":
            return parse_projection_node(node)

        case "SEQ_SCAN ":
            return parse_seq_scan_node(node)

        case _:
            raise NotImplementedError(
                f"DuckDB node type {name} not supported in in-memory data representation of a query plan."
            )


def complete_IN_clause(sql_query: str, filter_condition: str) -> str:
    """
    DuckDB generates a filter node with condition 'attr IN (...)'.
    This function replaces the '(...)' in the filter condition with the actual content from the SQL query.
    """
    # Define a regular expression to find the "attr IN (...)" patterns in the pattern_string
    pattern = re.compile(r"(\w+)\s+IN\s+\(\.\.\.\)")

    # Define a function to find and replace each IN clause
    def replace_in_clause(match):
        attr = match.group(1)

        # Define a regular expression to find the actual IN clause content in the SQL query
        # in_clause_pattern = re.compile(rf"{attr}\s+IN\s+\(([^)]+)\)", re.IGNORECASE)
        in_clause_pattern = re.compile(
            rf"{attr}\s+IN\s+\(\s*('(?:[^']|'')*'(?:\s*,\s*'(?:[^']|'')*')*)\s*\)", re.IGNORECASE
        )

        # Find the actual IN clause content in the SQL query
        sql_match = in_clause_pattern.search(sql_query)
        if not sql_match:
            raise ValueError(f"No IN clause found in the SQL query for attribute '{attr}'")

        actual_content = sql_match.group(1)

        # Replace (...) with the actual content
        return f"{attr} IN ({actual_content})"

    # Replace all "attr IN (...)" patterns in the pattern_string
    replaced_pattern_string = pattern.sub(replace_in_clause, filter_condition)

    return replaced_pattern_string


def add_info_from_query(plan: Plan, sql_query: str):
    """Add info to `plan` that is not represent in the JSON plan,
    and can only be retrieved from the SQL query."""
    for node in traverse_preorder(plan.root):
        if isinstance(node, FilterNode):
            node.condition = complete_IN_clause(sql_query, node.condition)


def json_to_plan(duckdb_plan) -> Plan:
    total_time = get(duckdb_plan, "timing")
    children = duckdb_plan.get("children")
    assert len(children) == 1  # root node contains global information, skip it
    node = children[0]

    # If root of the plan is "RESULT_COLLECTOR", then skip it
    if node["name"] == "RESULT_COLLECTOR":
        node = node["children"][0]

    root = parse_duckdb_treenode(node)
    return Plan(execution_time=total_time, root=root)


def load_json(file_path: str):
    with open(file_path, "r") as file:
        data = json.load(file)
    return data


def remove_unused_aliases(sql_query: str, aliases: dict[str, str]) -> dict[str, str]:
    """Remove aliases from the `aliases` dictionary that do not occur in the SQL query.
    Returns a new dictionary with only the aliases that are used in the query."""

    def extract_from_clause(sql_query):
        """Extracts the FROM clause from the SQL query without the FROM keyword."""

        # Regex pattern to match everything after FROM until another SQL keyword or end of query
        pattern = r"\bFROM\b\s+([^;]*?)(?=\bWHERE\b|\bJOIN\b|\bGROUP BY\b|\bORDER BY\b|$)"

        # Search for the FROM clause using the regex pattern
        match = re.search(pattern, sql_query, re.IGNORECASE | re.DOTALL)

        # If a match is found, return the FROM clause without the FROM keyword
        if match:
            return match.group(1).strip()
        else:
            raise ValueError("No FROM clause found in the SQL query.")

    from_clause = extract_from_clause(sql_query)
    aliases_in_from_clause: set[str] = set([x.strip() for x in from_clause.split(",")])
    used_aliases = set()
    for alias in aliases:
        if alias in aliases_in_from_clause:
            used_aliases.add(alias)
    return {alias: aliases[alias] for alias in used_aliases}


def fix_hashjoin_conditions(plan: Plan, query: str):
    """Sometimes, a hash join condition can be like `u.id=u.id`.
    One of the fields in the original condition was replaced by an equivalent field.
    This function restores the original condition from the sql query."""

    def extract_where_clause(query: str):
        # Pattern to match the WHERE clause in SQL
        where_pattern = re.compile(r"\bWHERE\b\s+(.*)$", re.IGNORECASE | re.DOTALL)

        # Find the WHERE clause using the pattern
        match = where_pattern.search(query)

        # If a match is found, return the WHERE clause
        if match:
            return match.group(1).strip()
        else:
            raise ValueError("No WHERE clause found in the SQL query.")

    def extract_equijoin_conditions(from_clause: str):
        # Pattern to match equijoin conditions in SQL (e.g., "table1.col1 = table2.col2")
        join_pattern = re.compile(
            r"([a-zA-Z0-9_]+\.[a-zA-Z0-9_]+\s*=\s*[a-zA-Z0-9_]+\.[a-zA-Z0-9_]+)", re.IGNORECASE
        )

        # Find all equijoin conditions using the pattern
        equijoin_conditions = join_pattern.findall(from_clause)

        return equijoin_conditions

    where_clause = extract_where_clause(query)
    equijoin_conditions = extract_equijoin_conditions(where_clause)
    equijoin_conditions = [c for cs in equijoin_conditions for c in parse_join_condition(cs)]

    eq_classes = EquivalenceClasses()  # equivalence classes according to original sql query
    for equijoin in equijoin_conditions:
        eq_classes.update([equijoin])

    for node in traverse_preorder(plan.root):
        if isinstance(node, HashJoinNode):
            node.try_fix_join_condition(equijoin_conditions, eq_classes)

    # print(f"Finding equijoin conditions in where clause: {query}, found {equijoin_conditions}")


def parse_duckdb_plan_with_selfjoins(file_path: str, aliases: dict[str, str]) -> Plan:
    """
    Parse the JSON output of DuckDB's EXPLAIN ANALYZE command into a Plan object

    Args:
        file_path (str): Path to the JSON file containing the plan
    """

    def replace_alias_in_seqscan(plan: Plan, aliases: dict[str, str]):
        """Replace aliases in SeqScan node with their original relation names."""
        for node in traverse_preorder(plan.root):
            if isinstance(node, SequentialScanNode):
                alias = node.relation
                if alias in aliases:
                    node.relation = aliases[alias]
                else:
                    raise ValueError(
                        f"Trying to map alias '{alias}' to its original relation name, but alias not found in the aliases dictionary."
                    )

    data = load_json(file_path)
    query = data["extra-info"]
    aliases = remove_unused_aliases(query, aliases)
    plan = json_to_plan(data)
    fix_hashjoin_conditions(plan, query)
    add_info_from_query(plan, query)
    replace_alias_in_seqscan(plan, aliases)
    plan.aliases = aliases

    return plan


# if __name__ == "__main__":
#     import sys

#     if len(sys.argv) != 2:
#         print("Usage: python script.py <file_path>")
#     else:
#         file_path = sys.argv[1]
#         plan = parse_duckdb_plan_with_selfjoins(file_path)
#         plan.try_make_valid()
#         print(plan.to_json(indent=4))
