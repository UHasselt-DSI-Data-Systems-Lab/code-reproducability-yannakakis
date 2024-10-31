#!/bin/bash

root_dir="../../.."
binary_join_plans="$root_dir/query_plans/ce_duckdb/3_IR_no_filters_and_projections"
yannakakis_plans="$root_dir/query_plans/ce_duckdb/yannakakis"

# for each file in $yannakakis_plans
for yann_plan in "$yannakakis_plans"/*.json
do 
    query_name=$(basename "$yann_plan" .json)
    bj_plan="$binary_join_plans/$query_name/run_1.json"

    config_file="./$query_name.json"
    echo "{" > $config_file
    echo "    \"query\": \"$query_name\"," >> $config_file
    echo "    \"plans\": [" >> $config_file
    echo "        {" >> $config_file
    echo "            \"method\": \"BinaryJoin\"," >> $config_file
    echo "            \"path\": \"$bj_plan\"" >> $config_file
    echo "        }," >> $config_file
    echo "        {" >> $config_file
    echo "            \"method\": \"Yannakakis\"," >> $config_file
    echo "            \"path\": \"$yann_plan\"" >> $config_file
    echo "        }" >> $config_file
    echo "    ]" >> $config_file
    echo "}" >> $config_file
    
done
