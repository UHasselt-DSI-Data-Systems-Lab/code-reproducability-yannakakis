from binary_plan.to_semijoin_plan import MultiSemiJoin
from binary_plan.binary_plan import BinaryJoinNode, LeafNode


def test_binaryjoin_to_semijoin():
    # Create a binary join plan
    # R(ab) ⋈ S(bc)
    R = LeafNode("R", {0, 1}, 0)
    S = LeafNode("S", {1, 2}, 0)
    RS = BinaryJoinNode(R, S, {1})

    semijoin_plan = MultiSemiJoin.from_wellbehaved_plan(RS)

    # Check that the semijoin plan is correct
    assert semijoin_plan.guard == "R"
    assert len(semijoin_plan.children) == 1
    assert semijoin_plan.children[0].guard == "S"
    assert len(semijoin_plan.children[0].children) == 0


def test_right_deep_ternary_plan_to_semijoin_plan():
    # Create a right-deep ternary join plan
    # R(ab) ⋈ (S(bc) ⋈ T(cd))
    R = LeafNode("R", {0, 1}, 0)
    S = LeafNode("S", {1, 2}, 0)
    T = LeafNode("T", {2, 3}, 0)
    ST = BinaryJoinNode(S, T, {2})
    RST = BinaryJoinNode(R, ST, {1})

    semijoin_plan = MultiSemiJoin.from_wellbehaved_plan(RST)

    # Check that the semijoin plan is correct
    # Should be R ⋉ (S ⋉ T)
    assert semijoin_plan.guard == "R"
    assert len(semijoin_plan.children) == 1
    assert semijoin_plan.children[0].guard == "S"
    assert len(semijoin_plan.children[0].children) == 1
    assert semijoin_plan.children[0].children[0].guard == "T"
    assert len(semijoin_plan.children[0].children[0].children) == 0


def test_left_deep_ternary_plan_to_semijoin_plan():
    # Create a left-deep ternary join plan
    # (R(ab) ⋈ S(bc)) ⋈ T(ad)

    R = LeafNode("R", {1, 2}, 0)
    S = LeafNode("S", {2, 3}, 0)
    T = LeafNode("T", {1, 4}, 0)

    RS = BinaryJoinNode(R, S, {2})
    RST = BinaryJoinNode(RS, T, {1})

    semijoin_plan = MultiSemiJoin.from_wellbehaved_plan(RST)

    # Check that the semijoin plan is correct
    # Should be one multisemijoin with R as guard and children [S, T]

    assert semijoin_plan.guard == "R"
    assert len(semijoin_plan.children) == 2
    assert semijoin_plan.children[0].guard == "S"
    assert len(semijoin_plan.children[0].children) == 0
    assert semijoin_plan.children[1].guard == "T"
    assert len(semijoin_plan.children[1].children) == 0


def test_bushy_plan_to_semijoin_plan():
    # Create bushy plan:  R(ab) ⋈ ((S(bce) ⋈ U(ef)) ⋈ T(cd))

    R = LeafNode("R", {1, 2}, 0)
    S = LeafNode("S", {2, 3, 5}, 0)
    T = LeafNode("T", {3, 4}, 0)
    U = LeafNode("U", {5, 6}, 0)

    SU = BinaryJoinNode(S, U, {5})
    SUT = BinaryJoinNode(SU, T, {3})
    RSUT = BinaryJoinNode(R, SUT, {2})

    semijoin_plan = MultiSemiJoin.from_wellbehaved_plan(RSUT)

    # Check that the semijoin plan is correct
    # Should be two multisemijoins: First one has guard R and one child.
    # Second one has guard S and two children: U and T

    assert semijoin_plan.guard == "R"
    assert len(semijoin_plan.children) == 1
    assert semijoin_plan.children[0].guard == "S"
    assert len(semijoin_plan.children[0].children) == 2
    assert semijoin_plan.children[0].children[0].guard == "U"
    assert len(semijoin_plan.children[0].children[0].children) == 0
    assert semijoin_plan.children[0].children[1].guard == "T"
    assert len(semijoin_plan.children[0].children[1].children) == 0
