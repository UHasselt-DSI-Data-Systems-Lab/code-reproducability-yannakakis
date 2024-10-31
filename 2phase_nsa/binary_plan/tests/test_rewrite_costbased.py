from binary_plan.binary_plan import BinaryJoinNode, LeafNode, is_well_behaved, pretty_print
from binary_plan.rewrite_costbased import (
    make_well_behaved,
    get_well_behaved_plans,
    WellBehavedPlans,
)


def test_rewrite_costbased_ternary1():
    # P = (R(a,b) ⋈ S(b,c)) ⋈ T(c,d)

    R = LeafNode("R", {0, 1}, 1)
    S = LeafNode("S", {1, 2}, 1)
    T = LeafNode("T", {2, 3}, 1)

    RS = BinaryJoinNode(R, S, {1})
    plan = BinaryJoinNode(RS, T, {2})

    assert not is_well_behaved(plan)

    candidates = get_well_behaved_plans(plan)

    assert candidates.len() == 3

    for plan, _ in candidates.iter():
        assert is_well_behaved(plan)

    # Only one of the three candidates has cost 0,
    # and should always be picked as the "best" plan:
    # R(a,b) ⋈ (S(b,c) ⋈ T(c,d))

    ST = BinaryJoinNode(S, T, {2})
    expected_plan = BinaryJoinNode(R, ST, {1})

    assert make_well_behaved(plan) == expected_plan


def test_statsceb_q28():
    # P = R(b) ⋈ (S(r) ⋈ (T(b,r) ⋈ U(r)))

    R = LeafNode("R", {1}, 328064)
    S = LeafNode("S", {0}, 79851)
    T = LeafNode("T", {1, 0}, 18395)
    U = LeafNode("U", {0}, 8065)

    TU = BinaryJoinNode(T, U, {0})
    STU = BinaryJoinNode(S, TU, {0})
    plan = BinaryJoinNode(R, STU, {1})

    assert not is_well_behaved(plan)

    candidates = get_well_behaved_plans(plan)

    for plan, _ in candidates.iter():
        assert is_well_behaved(plan)

    # Test that the one with the lowest cost is:
    # R(b) ⋈ ((T(b,r) ⋈ U(r)) ⋈ S(r))

    TU = BinaryJoinNode(T, U, {0})
    TU_S = BinaryJoinNode(TU, S, {0})
    expected = BinaryJoinNode(R, TU_S, {1})

    assert make_well_behaved(plan) == expected
