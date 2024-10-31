from binary_plan.util import ir_file_to_binary_plan
from binary_plan.binary_plan import (
    BinaryJoinNode,
    LeafNode,
    is_well_behaved,
    check_well_behaved_conditions,
)
import os
import pandas as pd


def categorize_plan(plan: BinaryJoinNode | LeafNode) -> dict:
    (satisfies_1a, satisfies_1b) = check_well_behaved_conditions(plan)
    well_behaved = satisfies_1a and satisfies_1b

    return {
        "well_behaved": well_behaved,
        "1a": satisfies_1a,
        "1b": satisfies_1b,
    }


def categorize_plans_in_dir(in_dir: str, outfile: str):
    categories = []

    for query_dir in os.listdir(in_dir):
        if not os.path.isdir(os.path.join(in_dir, query_dir)):
            continue

        infile = os.path.join(in_dir, query_dir, "run_1.json")

        if os.path.exists(infile):
            binary_plan = ir_file_to_binary_plan(infile)
            category = {"query": query_dir}
            category.update(categorize_plan(binary_plan))
            categories.append(category)

    df = pd.DataFrame(categories)
    df.to_csv(outfile, index=False)


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Categorize binary join plans")
    parser.add_argument(
        "-i", "--input_dir", help="Input directory containing query plans in IR format."
    )
    parser.add_argument("-o", "--output_file", help="Non-existing csv file to store categories.")
    args = parser.parse_args()

    # check if input dir exists
    if not os.path.exists(args.input_dir):
        raise FileNotFoundError(f"Input directory {args.input_dir} not found")

    # check if output csv file does not exist
    if os.path.exists(args.output_file):
        raise FileExistsError(f"Output file {args.output_file} already exists")

    categorize_plans_in_dir(args.input_dir, args.output_file)
