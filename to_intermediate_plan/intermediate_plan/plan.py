# In memory representation of a query plan.

from __future__ import annotations
import json
from json import JSONEncoder
from typing import Generator
import re
from .field import Field
from .equivalence_classes import EquivalenceClasses


def traverse_preorder(node: TreeNode) -> Generator[TreeNode, None, None]:
    """Traverse the tree in preorder and yield each node.

    Args:
        node (TreeNode): Root node of the tree.

    Returns:
        Generator[TreeNode, None, None]: Generator of [TreeNode]s.
    """

    yield node
    for child in node.children:
        yield from traverse_preorder(child)


def traverse_postorder(node: TreeNode) -> Generator[TreeNode, None, None]:
    """Traverse the tree in postorder and yield each node.

    Args:
        node (TreeNode): Root node of the tree.

    Returns:
        Generator[TreeNode, None, None]: Generator of [TreeNode]s.
    """

    for child in node.children:
        yield from traverse_postorder(child)
    yield node


def replace_aliases(text: str, aliases: dict[str, str]) -> str:
    """Replace aliases in text with their corresponding relation names.

    e.g: `t.id = midx.movie_id` -> `title.id = movie_info_idx.movie_id`"""
    # Define a regular expression pattern to match "alias.attr"
    pattern = re.compile(
        r"\b(" + "|".join(re.escape(alias) for alias in aliases.keys()) + r")\.(\w+)\b"
    )

    # Define a function to replace the alias with the relation name
    def replace_match(match):
        alias = match.group(1)
        attr = match.group(2)
        relation = aliases[alias]
        return f"{relation}.{attr}"

    # Substitute all occurrences of the pattern
    return pattern.sub(replace_match, text)


def field_in_list(field: Field, field_list: list[Field]) -> bool:
    """Check that a field occurs exactly once in a list of fields."""
    n_matches = 0
    for f in field_list:
        if field.cmp_qualified(f):
            n_matches += 1

    return n_matches == 1


class Plan:
    """Represents a query plan.
    Holds total execution time (None if not measured) and the root of the tree.
    """

    def __init__(self, execution_time: float | None, root: TreeNode):
        self.execution_time = execution_time
        self.root = root
        self.aliases: dict[str, str] = {}

    def __str__(self):
        return f"Plan(execution_time={self.execution_time}, root={self.root})"

    def __repr__(self):
        return str(self)

    def to_json(self, indent=4):
        return json.dumps(self, cls=TreeEncoder, indent=indent)

    def try_make_valid(self, equivalence_classes: EquivalenceClasses = EquivalenceClasses()):
        """Try to make the plan valid if it is not already. Errors if this is not possible.

        For example, a hashjoin condition `c` contains a field `R.a` that is not in the output schema of any of the child nodes,
        but `S.a` is. Because `R.a` was previously joined with `S.a`, it is valid to replace `R.a` with `S.a` in `c`.
        """
        # recursively try to make the plan valid
        # Errors when this is not possible.
        for node in traverse_postorder(self.root):
            node.try_make_valid(equivalence_classes)


class TreeEncoder(JSONEncoder):
    def default(self, o):
        def remove_key_recursively(d: dict, key_to_remove: str) -> dict:
            """
            Recursively removes all entries with the specified key from a nested dictionary.

            :param d: The dictionary to clean.
            :param key_to_remove: The key to remove from the dictionary.
            :return: The cleaned dictionary with all occurrences of the key removed.
            """
            if isinstance(d, dict):
                # Use dictionary comprehension to filter out the unwanted key
                return {
                    k: remove_key_recursively(v, key_to_remove)
                    for k, v in d.items()
                    if k != key_to_remove
                }
            elif isinstance(d, list):
                # If the current element is a list, recursively apply the function to each element
                return [remove_key_recursively(item, key_to_remove) for item in d]
            else:
                # If it's neither a dict nor a list, return the item as is
                return d

        result = o.__dict__
        return remove_key_recursively(result, "output")  # do not include output in the json


class TreeNode:
    """Node in a query plan tree.
    Holds the name of the node, execution time (None if not measured),
    actual number of rows (None if not measured), and child nodes.
    """

    def __init__(
        self,
        name: str,
        output: list[Field],
        children: list[TreeNode],
        execution_time: float | None,
        actual_rows: int | None,
        estimated_cardinality: int | None = None,
    ):
        self.name = name
        self.output = output
        self.execution_time = execution_time
        self.actual_rows = actual_rows
        self.estimated_cardinality = estimated_cardinality
        self.children = children

    def __str__(self):
        return f"TreeNode(name={self.name}, children={self.children}, execution_time={self.execution_time}, actual_rows={self.actual_rows}, ec={self.estimated_cardinality})"

    def __repr__(self):
        return str(self)

    def replace_aliases(self, aliases: dict[str, str]):
        """Recursively replace all aliases by their full relation name in the tree rooted at this node."""
        for field in self.output:
            field.replace_alias(aliases)

        for child in self.children:
            child.replace_aliases(aliases)

    def try_make_valid(self, equivalence_classes: EquivalenceClasses):
        pass  # default implementation


class AggregateNode(TreeNode):
    def __init__(
        self,
        child: TreeNode,
        execution_time: float | None,
        actual_rows: int | None,
        group_by: list[Field] | None,
        aggregate: list[str],
    ):
        # Aggregate expressions become output fields
        output = [Field(None, agg) for agg in aggregate]
        super().__init__("AGGREGATE", output, [child], execution_time, actual_rows)
        self.group_by = group_by
        self.aggregate = aggregate

    def replace_aliases(self, aliases: dict[str, str]):
        if self.group_by is not None:
            for field in self.group_by:
                field.replace_alias(aliases)
        self.aggregate = [replace_aliases(agg, aliases) for agg in self.aggregate]
        for field in self.output:
            field.field_name = replace_aliases(field.field_name, aliases)

        super().replace_aliases(aliases)


def parse_join_condition(condition: str) -> list[tuple[Field, Field]]:
    # CURRENTLY ASSUMES A SINGLE EQUIJOIN CONDITION

    # Split the input string into two parts
    left, right = condition.split("=")

    # Remove any extraneous whitespace and quotes
    left = left.strip().strip('"')
    right = right.strip().strip('"')

    # Helper function to parse individual field strings
    def parse_field(field_str: str) -> Field:
        if "." in field_str:
            table_name, field_name = field_str.split(".")
            return Field(table_name, field_name)
        else:
            return Field(None, field_str)

    # Parse both sides of the equation
    left_field_obj = parse_field(left)
    right_field_obj = parse_field(right)

    # Return as a list of a single tuple
    return [(left_field_obj, right_field_obj)]


class HashJoinNode(TreeNode):
    def __init__(
        self,
        build_child: TreeNode,
        probe_child: TreeNode,
        execution_time: float | None,
        actual_rows: int | None,
        condition: str,
    ):
        # ensure that the first child is the probe side and the second child is the build side
        children = [probe_child, build_child]
        # the output schema is the output schema of the first child + the output schema of the second child
        output = probe_child.output + build_child.output
        super().__init__("HASHJOIN", output, children, execution_time, actual_rows)
        self.condition: list[tuple[Field, Field]] = parse_join_condition(condition)

    def try_fix_join_condition(
        self, new_conditions: list[tuple[Field, Field]], eq_classes: EquivalenceClasses
    ):
        """If current condition is invalid, try to replace it with a new condition.

        Args:
            new_conditions (list[tuple[Field,Field]]): List of equijoin conditions from original query.
            eq_classes (EquivalenceClasses): Equivalence classes according to the original query.
        """
        # Check if current condition is invalid
        assert len(self.condition) == 1, "HashJoinNode only supports a single join condition."
        left, right = self.condition[0]
        if left == right:
            # current condition is invalid, try replace it with a new condition

            # if a descendant is a filter, followed by a seqscan, the filter can also contain the wrong attribute
            # we need to verify the filter condition as well
            for node in traverse_preorder(self.children[0]):
                if isinstance(node, FilterNode):
                    node.try_fix_filter_condition()
            for node in traverse_preorder(self.children[1]):
                if isinstance(node, FilterNode):
                    node.try_fix_filter_condition()
            # if isinstance(self.children[0], FilterNode):
            #     self.children[0].try_fix_filter_condition()
            # if isinstance(self.children[1], FilterNode):
            #     self.children[1].try_fix_filter_condition()

            # Check if any of the new conditions are valid
            for new_condition in new_conditions:
                # the new equijoin condiiton f1=f2 does not know what is probe or build side, so we must check both f1=f2 and f2=f1
                new_left, new_right = new_condition
                for new_left, new_right in [
                    (new_condition[0], new_condition[1]),  # f1=f2
                    (new_condition[1], new_condition[0]),  # f2=f1
                ]:
                    if new_left == left and new_right != right:
                        # candidate: replace right with new_right
                        # check if new_right is in the output schema of the build child
                        if field_in_list(new_right, self.children[1].output):
                            replacement = f"{new_left}={new_right}"
                            self.condition = [(new_left, new_right)]
                            return
                    elif new_right == right and new_left != left:
                        # candidate: replace left with new_left
                        # check if new_left is in the output schema of the probe child
                        if field_in_list(new_left, self.children[0].output):
                            replacement = f"{new_left}={new_right}"
                            self.condition = [(new_left, new_right)]
                            return

            # Last resort: try to replace a field by an equivalent field that is in the output schema of the child
            if not field_in_list(left, self.children[0].output):
                # try to find an 'equivalent' field that is in the output schema of the probe child
                equivalent_fields = eq_classes.get_equivalence_class(left)
                if equivalent_fields is not None:
                    for equivalent_field in equivalent_fields:
                        if field_in_list(equivalent_field, self.children[0].output):
                            # replace left with an equivalent field
                            replacement = f"{equivalent_field}={right}"
                            self.condition = [(equivalent_field, right)]
                            return

            if not field_in_list(right, self.children[1].output):
                # try to find an 'equivalent' field that is in the output schema of the build child
                equivalent_fields = eq_classes.get_equivalence_class(right)
                if equivalent_fields is not None:
                    for equivalent_field in equivalent_fields:
                        if field_in_list(equivalent_field, self.children[1].output):
                            # replace right with an equivalent field
                            replacement = f"{left}={equivalent_field}"
                            self.condition = [(left, equivalent_field)]
                            return

            # No valid replacement found
            raise Exception(
                f"Could not find a valid replacement for the join condition {self.condition}."
            )

    def replace_aliases(self, aliases: dict[str, str]):
        """Recursively replace all aliases by their full relation name in the tree rooted at this node."""
        for field1, field2 in self.condition:
            field1.replace_alias(aliases)
            field2.replace_alias(aliases)
        # self.condition = replace_aliases(self.condition, aliases)

        super().replace_aliases(aliases)

    def try_make_valid(self, equivalence_classes: EquivalenceClasses):
        probe_output = self.children[0].output
        build_output = self.children[1].output

        for field1, field2 in self.condition:
            for field, output_schema in [(field1, probe_output), (field2, build_output)]:
                if not field_in_list(field, output_schema):
                    # try to find an 'equivalent' field that is in the output schema of the probe child

                    equivalent_fields = equivalence_classes.get_equivalence_class(field)

                    if equivalent_fields is not None:
                        intersect = equivalent_fields.intersection(set(output_schema))
                        if len(intersect) == 0:
                            # Equivalent fields found, but none of them are in the output schema
                            raise Exception(
                                f"Hash join field {field} not found in the output schema of the child node {output_schema}."
                            )
                        else:
                            # replace field1 with an equivalent field
                            equivalent_field = intersect.pop()
                            field.table_name = equivalent_field.table_name
                            field.field_name = equivalent_field.field_name
                    else:
                        # No equivalent fields found
                        raise Exception(
                            f"Hash join field {field} not found in the output schema of the child node {output_schema}: \n\t{field} has no equivalent fields. Equijoin condition: {self.condition}, equivalence classes: {equivalence_classes}"
                        )

                else:
                    # field is in output_schema, OK.
                    continue

        equivalence_classes.update(self.condition)


class NestedLoopJoinNode(TreeNode):
    def __init__(
        self,
        outer_child: TreeNode,
        inner_child: TreeNode,
        execution_time: float | None,
        actual_rows: int | None,
        condition: str,
    ):
        # ensure that the first child is the outer side and the second child is the inner side
        children = [outer_child, inner_child]
        # the output schema is the output schema of the first child + the output schema of the second child
        output = outer_child.output + inner_child.output
        # ensure that the first child is the outer side and the second child is the inner side
        super().__init__("NESTEDLOOPJOIN", output, children, execution_time, actual_rows)
        self.condition = condition


class MergeJoinNode(TreeNode):
    def __init__(
        self,
        child1: TreeNode,
        child2: TreeNode,
        execution_time: float | None,
        actual_rows: int | None,
        condition: str,
    ):
        output = child1.output + child2.output
        super().__init__("MERGEJOIN", output, [child1, child2], execution_time, actual_rows)
        self.condition: list[tuple[Field, Field]] = parse_join_condition(condition)

    def replace_aliases(self, aliases: dict[str, str]):
        """Recursively replace all aliases by their full relation name in the tree rooted at this node."""
        for field1, field2 in self.condition:
            field1.replace_alias(aliases)
            field2.replace_alias(aliases)
        # self.condition = replace_aliases(self.condition, aliases)

        super().replace_aliases(aliases)

    def try_make_valid(self, equivalence_classes: EquivalenceClasses):
        probe_output = self.children[0].output
        build_output = self.children[1].output

        for field1, field2 in self.condition:
            if not (field_in_list(field1, probe_output) or field_in_list(field1, build_output)):
                raise Exception(
                    f"Hash join field {field1} not found in the output schema of the child nodes."
                )

            if not (field_in_list(field2, probe_output) or field_in_list(field2, build_output)):
                raise Exception(
                    f"Hash join field {field2} not found in the output schema of the child nodes."
                )

        equivalence_classes.update(self.condition)


class FilterNode(TreeNode):
    def __init__(
        self,
        condition: str,
        child: TreeNode,
        execution_time: float | None,
        actual_rows: int | None,
        estimated_cardinality: int | None,
    ):
        # output schema equals the output schema of the child
        output = child.output
        super().__init__(
            "FILTER", output, [child], execution_time, actual_rows, estimated_cardinality
        )
        self.condition = condition

    def replace_aliases(self, aliases: dict[str, str]):
        self.condition = replace_aliases(self.condition, aliases)
        super().replace_aliases(aliases)

    def try_fix_filter_condition(self):
        # Helper function to parse individual field strings
        def parse_field(field_str: str) -> Field:
            if "." in field_str:
                table_name, field_name = field_str.split(".")
                return Field(table_name, field_name)
            else:
                return Field(None, field_str)

        # extract fields from self.condition
        fields = re.findall(r"\b\w+\.\w+\b", self.condition)

        # If there is only one field, and that the child is a seqscan with a single output field,
        # then we can replace the field with the output field of the child.

        if (
            len(fields) == 1
            and isinstance(self.children[0], SequentialScanNode)
            and len(self.children[0].output) == 1
        ):
            field = parse_field(fields[0])

            # if the field is in the output schema of the child, condition is ok.
            # else, replace the field with the output field of the child
            if field_in_list(field, self.children[0].output):
                return
            else:
                new_condition = self.condition.replace(
                    fields[0], self.children[0].output[0].__str__()
                )
                self.condition = new_condition

        # If there is only one field f, and the child is a seqscan with multiple output fields,
        # and f is not one of them, then the filter condition is invalid and we cannot fix it.
        if (
            len(fields) == 1
            and isinstance(self.children[0], SequentialScanNode)
            and len(self.children[0].output) > 1
        ):
            field = parse_field(fields[0])
            if not field_in_list(field, self.children[0].output):
                raise Exception(f"Invalid filter condition: {self.condition}")


class ProjectionNode(TreeNode):
    def __init__(
        self,
        on: list[Field],
        child: TreeNode,
        execution_time: float | None,
        actual_rows: int | None,
    ):
        super().__init__("PROJECTION", on, [child], execution_time, actual_rows)
        self.on = on

    def replace_aliases(self, aliases: dict[str, str]):
        for field in self.on:
            field.replace_alias(aliases)

        super().replace_aliases(aliases)

    def try_make_valid(self, equivalence_classes: EquivalenceClasses):
        """Each projection attribute must be present in the output schema of the child node."""
        if isinstance(self.children[0], AggregateNode):
            # we're dropping aliases in aggregates, so we won't find the projection fields in the child's output schema anyway.
            return

        child_output = self.children[0].output
        for field in self.on:
            if not field_in_list(field, child_output):
                equivalent_fields = equivalence_classes.get_equivalence_class(field)

                if equivalent_fields is not None:
                    intersect = equivalent_fields.intersection(set(child_output))
                    if len(intersect) == 0:
                        # Equivalent fields found, but none of them are in the output schema
                        raise Exception(
                            f"Projection field {field} not found in the output schema of the child node, child output: {child_output}."
                        )
                    else:
                        # replace field with an equivalent field
                        equivalent_field = intersect.pop()
                        field.table_name = equivalent_field.table_name
                        field.field_name = equivalent_field.field_name
                else:
                    # No equivalent fields found
                    raise Exception(
                        f"Projection field {field} not found in the output schema of the child node, child output: {child_output}."
                    )
            else:
                # Field is in output schema of child, OK.
                continue


class SequentialScanNode(TreeNode):
    def __init__(
        self,
        relation: str,
        execution_time: float | None,
        actual_rows: int | None,
        estimated_cardinality: int | None,
        projection: list[Field],
        opt_filter: str | None = None,
    ):
        # output = projection
        # make qualified names for the output fields
        # for field in output:
        #     if field.table_name is None:
        #         field.table_name = relation
        super().__init__(
            "SEQUENTIALSCAN", projection, [], execution_time, actual_rows, estimated_cardinality
        )
        self.relation = relation
        self.opt_filter = opt_filter
        self.projection = projection

    def replace_aliases(self, aliases: dict[str, str]):
        # for field in super().output:
        #     field.replace_alias(aliases)
        if self.opt_filter is not None:
            self.opt_filter = replace_aliases(self.opt_filter, aliases)

        super().replace_aliases(aliases)
