# Check whether a plan is left-deep, right-deep or bushy.

from intermediate_plan.plan import TreeNode, Plan
from enum import Enum


class PlanType(Enum):
    LEFT_DEEP = 1
    RIGHT_DEEP = 2
    BUSHY = 3


def join_in_left_subtree(root: TreeNode) -> bool:
    if len(root.children) == 0:
        return False

    elif len(root.children) == 1:
        return join_in_left_subtree(root.children[0])
    else:  # binary node
        assert len(root.children) == 2
        if contains_join(root.children[0]):
            return True
        return join_in_left_subtree(root.children[1])


def join_in_right_subtree(root: TreeNode) -> bool:
    if len(root.children) == 0:
        return False

    if "JOIN" in root.name:
        if contains_join(root.children[1]):
            return True
    else:
        assert len(root.children) == 1

    return join_in_right_subtree(root.children[0])


def contains_join(root: TreeNode) -> bool:
    if "JOIN" in root.name:
        return True

    for child in root.children:
        if contains_join(child):
            return True

    return False


def is_left_deep(plan: Plan) -> bool:
    return not join_in_right_subtree(plan.root)


def is_right_deep(plan: Plan) -> bool:
    return not join_in_left_subtree(plan.root)


def type(plan: Plan) -> PlanType:
    if is_left_deep(plan):
        return PlanType.LEFT_DEEP
    elif is_right_deep(plan):
        return PlanType.RIGHT_DEEP
    else:
        return PlanType.BUSHY
