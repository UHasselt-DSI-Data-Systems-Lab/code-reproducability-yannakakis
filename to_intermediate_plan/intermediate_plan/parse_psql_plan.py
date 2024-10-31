# Description: Parse the JSON output of postgres' EXPLAIN ANALYZE command into a Plan object
# Usage: python parse_psql_plan.py <file_path>
# Or use the parse_plan function in another script

import json
import warnings
import re

from intermediate_plan.plan import (
    TreeNode,
    Plan,
    HashJoinNode,
    FilterNode,
    NestedLoopJoinNode,
    SequentialScanNode,
    MergeJoinNode,
    AggregateNode,
    traverse_preorder,
)
from intermediate_plan.field import Field


def get(node, key):
    """Get the value of a key from a dictionary, or return None if the key is not present."""
    if key in node:
        return node[key]
    return None


def parse_hashjoin_node(node) -> HashJoinNode:
    # Must have two children
    # One of them is hashed (node type = "Hash"), this is the build side
    # The other one is probed, can be anything
    children = node["Plans"]
    assert len(children) == 2, "Hash Join node must have two children."
    assert (
        children[0]["Node Type"] == "Hash" or children[1]["Node Type"] == "Hash"
    ), "One HashJoin child must be a Hash node."

    if children[0]["Node Type"] == "Hash":
        build_child = children[0]
        probe_child = children[1]
    else:
        build_child = children[1]
        probe_child = children[0]

    # build_side is now a node with name 'hash'
    # the child of that node is the actual input that is hashed
    join_condition: str = node["Hash Cond"]
    join_condition = join_condition.lstrip("(").rstrip(")")  # remove leading and trailing brackets

    assert len(build_child["Plans"]) == 1, "Hash node must have one child."
    build_child = build_child["Plans"][0]
    return HashJoinNode(
        probe_child=parse_plan_node(probe_child),
        build_child=parse_plan_node(build_child),
        execution_time=get(node, "Actual Total Time"),
        actual_rows=get(node, "Actual Rows"),
        condition=join_condition,
    )


def parse_nestedloop_node(node) -> NestedLoopJoinNode:
    children = node["Plans"]
    assert len(children) == 2, "Nested Loop node must have two children."
    assert "Join Filter" in node, "Nested Loop node must have a Join Filter."

    # One of the children can be a "Materialize" node, which we skip
    if children[0]["Node Type"] == "Materialize":
        child1 = children[0]["Plans"][0]
        child2 = children[1]
    elif children[1]["Node Type"] == "Materialize":
        child1 = children[0]
        child2 = children[1]["Plans"][0]
    else:
        child1, child2 = children

    join_condition: str = node["Join Filter"]
    join_condition = join_condition.lstrip("(").rstrip(")")  # remove leading and trailing brackets

    return NestedLoopJoinNode(
        outer_child=parse_plan_node(child1),
        inner_child=parse_plan_node(child2),
        execution_time=get(node, "Actual Total Time"),
        actual_rows=get(node, "Actual Rows"),
        condition=join_condition,
    )


def get_aggregate_exprs(output: list[str], group_key: list[str] | None) -> list[str]:
    """An aggregate node in json has:
    - an output field (which contains groupby + aggregate expressions), and
    - a group by field (if it is a grouped aggregate)
    but no aggregate expression field.

    This function constructs the aggregate expression from the output and group by fields.
    """
    if group_key is None:
        # Output fields are all aggregate expressions
        return output
    else:
        # We must subtract the group by fields from the output fields to get the aggregate expressions

        group_keys_unqualified: set[Field] = set(
            [Field.from_str(field).to_unqualified() for field in group_key]
        )

        return [
            field
            for field in output
            if Field.from_str(field).to_unqualified() not in group_keys_unqualified
        ]


def transform_in_clause(in_clause: str) -> str:
    """Rewrite `IN (str1,str2,str3)` to `IN ('str1','str2','str3')`"""
    # Define the regular expression pattern to match "IN (str1,str2,str3)"
    pattern = re.compile(r"IN \(([^)]+)\)")

    # Define a function to replace the match
    def replace_match(match):
        # Get the content inside the parentheses
        content = match.group(1)

        # Split the content by commas and strip whitespace
        items = [item.strip() for item in content.split(",")]

        # Join the items with single quotes and commas
        replaced_content = ",".join(f"'{item}'" for item in items)

        # Return the modified string
        return f"IN ({replaced_content})"

    # Perform the substitution using the defined function
    output_string = pattern.sub(replace_match, in_clause)

    return output_string


def rewrite_filter_condition(condition: str) -> str:
    """Rewrite filter condition to valid SQL syntax."""
    # Replace "= ANY (...)" by "IN (...)"
    any_pattern = re.compile(r"= ANY \(\'{([^}]+)}\'::text\[\]\)", re.IGNORECASE)
    condition = any_pattern.sub(r"IN (\1)", condition)
    condition = transform_in_clause(condition)

    # Replace "(rel.name)::text" by "rel.name"
    condition = re.sub(r"\((\w+\.\w+)\)::text", r"\1", condition)

    # Replace "'str'::text" by "'str'"
    condition = re.sub(r"'([^']+)'::text", r"'\1'", condition)

    # Replace " !~~ " by " NOT LIKE "
    condition = re.sub(r" !~~ ", r" NOT LIKE ", condition)

    # Replace " ~~ " by " LIKE "
    condition = re.sub(r" ~~ ", r" LIKE ", condition)

    return condition


def rewrite_aggr_expr(aggr_expr: str) -> str:
    # Replace "(rel.name)::text" by "rel.name"
    return re.sub(r"\((\w+\.\w+)\)::text", r"\1", aggr_expr)


def parse_plan_node(node):
    """Recursively parse a plan node from JSON into TreeNode objects."""
    name = node["Node Type"]

    match name:

        case "Aggregate":
            child = node["Plans"][0]
            group_keys: list[str] | None = get(node, "Group Key")  # format: ["attr1", "attr2", ...]
            output_str: list[str] = node["Output"]
            aggregate_exprs = get_aggregate_exprs(output_str, group_keys)

            return AggregateNode(
                child=parse_plan_node(child),
                execution_time=get(node, "Actual Total Time"),
                actual_rows=get(node, "Actual Rows"),
                group_by=([Field.from_str(key) for key in group_keys] if group_keys else None),
                aggregate=[rewrite_aggr_expr(expr) for expr in aggregate_exprs],
            )

        case "Hash Join":
            return parse_hashjoin_node(node)

        # case "Nested Loop":
        #     return parse_nestedloop_node(node)

        case "Merge Join":
            children = node["Plans"]
            assert len(children) == 2, "Merge Join node must have two children."
            # both children are "Sort" nodes with one child, we skip the sort nodes
            child1 = children[0]["Plans"][0]
            child2 = children[1]["Plans"][0]
            return MergeJoinNode(
                child1=parse_plan_node(child1),
                child2=parse_plan_node(child2),
                execution_time=get(node, "Actual Total Time"),
                actual_rows=get(node, "Actual Rows"),
                condition=node["Merge Cond"],
            )

        case "Seq Scan":
            rel = node["Relation Name"]
            filter = get(node, "Filter")
            if filter is not None:
                filter = rewrite_filter_condition(filter)

            return SequentialScanNode(
                rel,
                get(node, "Actual Total Time"),
                get(node, "Actual Rows"),
                [Field.from_str(field) for field in node["Output"]],
                filter,
            )

        case _:
            raise NotImplementedError(
                f"Postgres node type {name} not supported in in-memory data representation of a query plan."
            )


def collect_aliases(plan_as_json) -> dict[str, str]:
    """Collect aliases from the plan JSON.
    Return a dictionary that maps alias to relation name."""
    aliases: dict[str, str] = {}

    def collect_aliases_recursive(node):
        if "Alias" in node and "Relation Name" in node:
            aliases[node["Alias"]] = node["Relation Name"]
        for child in node.get("Plans", []):
            collect_aliases_recursive(child)

    collect_aliases_recursive(plan_as_json[0]["Plan"])
    return aliases


def json_to_plan(json_data) -> Plan:
    """Convert JSON data into a Plan object."""
    plan_dict = json_data[0]
    root_node = parse_plan_node(plan_dict["Plan"])
    execution_time = get(plan_dict, "Execution Time")
    return Plan(execution_time, root_node)


def load_json(file_path: str):
    with open(file_path, "r") as file:
        data = json.load(file)
    return data


def parse_psql_plan(file_path: str) -> Plan:
    """
    Parse the JSON output of Postgres' EXPLAIN ANALYZE command into a Plan object

    Args:
        file_path (str): Path to the JSON file containing the plan
    """
    plan_as_json = load_json(file_path)
    plan = json_to_plan(plan_as_json)
    aliases = collect_aliases(plan_as_json)
    # plan.root.replace_aliases(aliases)
    plan.aliases = aliases
    return plan


if __name__ == "__main__":
    import sys

    if len(sys.argv) != 2:
        print("Usage: python script.py <file_path>")
    else:
        file_path = sys.argv[1]
        plan = parse_psql_plan(file_path)
        print(plan.to_json(indent=4))
