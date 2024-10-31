#!/bin/bash

# Convert all .json plans produced by DuckDB to .html plans.
# Searches recursively for all .json files in <infolder> and creates a .html file in the same directory.
#
# Usage: visualize_duckdb_plans.sh <infolder>
# e.g., visualize_duckdb_plans.sh ./imdb_query_plans

QUERY_PLANS_FOLDER=$1

cd "$QUERY_PLANS_FOLDER" || exit

# For each folder
for dir in *; do
    cd "$dir" || exit
    # For each file in the folder
    for file in *; do
        # Convert JSON plan to HTML
        python ./query_graph.py "$file" 
    done
    cd ..
done

