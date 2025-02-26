import json
from os import path


def replace_top_projection(data):
    if "root" in data and data["root"].get("name") == "PROJECTION":
        if (
            "children" in data["root"]
            and len(data["root"]["children"]) == 1
            and data["root"]["children"][0].get("name") == "AGGREGATE"
        ):
            data["root"] = data["root"]["children"][0]  # Replace PROJECTION with its child
    return data


for query in ["17a", "17b", "17c"]:
    filename = path.join("3_IR_no_filters_and_projections", query, "run_1.json")

    # Load JSON from file
    with open(filename, "r") as file:
        json_data = json.load(file)

    # Replace top-most PROJECTION node
    json_data = replace_top_projection(json_data)

    # Write updated JSON back to file
    with open(filename, "w") as file:
        json.dump(json_data, file, indent=4)
