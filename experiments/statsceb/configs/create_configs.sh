#!/bin/bash

root_dir="../../.."
parquet_data="$root_dir/benchmarks/stats-ceb/parquet-zstd"
binary_join_plans="$root_dir/query_plans/stats_duckdb/3_IR_no_filters_and_projections"
yannakakis_plans="$root_dir/query_plans/stats_duckdb/yannakakis"

# for each file in $yannakakis_plans
for yann_plan in "$yannakakis_plans"/*.json
do 
    query_name=$(basename "$yann_plan" .json)
    bj_plan="$binary_join_plans/$query_name/run_1.json"

    # create a config file for each query
    # example of config file:
    # {
    #     "query": "1a",
    #     "plans": [
    #         {
    #             "method": "BinaryJoin",
    #             "path": "../../../query_plans/imdb_duckdb/3_IR_no_filters_and_projections/1a/run_1.json"
    #         },
    #         {
    #             "method": "Yannakakis",
    #             "path": "../../../query_plans/imdb_duckdb/yannakakis/1a.json"
    #         }
    #     ]
    # }

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