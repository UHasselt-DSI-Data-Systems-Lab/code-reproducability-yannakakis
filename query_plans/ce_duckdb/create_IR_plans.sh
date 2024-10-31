#!/bin/bash

# Run this script with cwd set to the same directory as this script.

# Convert all DuckDB query plans to IR format (.json + .html)


TO_IR_SCRIPT=../../to_intermediate_plan/to_intermediate_plan.py # path to the script to convert query plans to IR format
aliases_map="../../benchmarks/ce/preprocessed_queries/aliases_map.json" # alias -> relation_name mapping

# Function that converts all duckdb plans in <infolder> to IR format in <outfolder> (.json + .html)
to_ir () {
    local infolder=$1
    local outfolder=$2

    # check that outfolder does not exist yet
    if [ -d "$outfolder" ]; then
        echo "Error: $outfolder already exists!"
        exit 1
    fi

    mkdir "$outfolder"
    echo -n "Converting DuckDB plans in $infolder to IR format... "
    python $TO_IR_SCRIPT -q "$infolder" -o "$outfolder" --dbms duckdb --aliases $aliases_map > "$outfolder"/log.txt
    echo "DONE!"
}


# Query epinions_acyclic_215_17 contains an invalid join condition that is not detected by the script that converts the plans to IR format.
# We manually fix it here.
python ./fix_epinions_acyclic_215_17.py


# Convert plans with aliases to IR format
# infolder="./2_original_with_aliases"
# outfolder="./2_IR_original_with_aliases"
# to_ir $infolder $outfolder

# Convert plans with aliases but without intermediate FILTER+PROJECTION to IR format
infolder="./3_no_filters_and_projections"
outfolder="./3_IR_no_filters_and_projections"
to_ir $infolder $outfolder