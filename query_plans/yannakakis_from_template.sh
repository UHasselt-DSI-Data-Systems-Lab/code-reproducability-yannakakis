#!/bin/bash

# Usage: ./yannakakis_from_template.sh <templates_folder> <IR_folder>

# Given a template file that looks as follows:

# {
#     "semijoin_plan": {
#         "guard":"t",
#         "children": [
#             {
#                 "guard": "mc", "children": [
#                     {"guard":"mi_idx", "children": [{"guard":"it", "children": []}]},
#                     {"guard":"ct", "children": []}
#                 ]
#             }
#         ]
#     },
#     "replacements": []
# }

# Fill in the "replacements" field with info from the binary join plan (in IR format).
# And subsequently convert the .template file into a .json file that is the final 2NSA (or yannakakis) plan.

# Do this for all templates in the <templates_folder> folder.

templates_folder=$1
IR_folder=$2

for template in "$templates_folder"/*.template
do
    query_name=$(basename -- "$template")
    query_name="${query_name%.*}" # drop extension

    binary_join_plan="$IR_folder/$query_name/run_1.json"
    
    python ./finalize_template.py -t "$template" -b "$binary_join_plan"
    python ./yannakakis_from_template.py -t "$template" -b "$binary_join_plan"
done
