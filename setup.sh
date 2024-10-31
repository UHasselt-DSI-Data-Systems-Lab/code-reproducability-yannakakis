#!/bin/sh

root=$(pwd)

# Make all scripts executable
chmod +x "$root"/benchmarks/download_datasets.sh
chmod +x "$root"/duckdb_scripts/load_into_duckdb.sh
chmod +x "$root"/duckdb_scripts/execute_queries_duckdb.sh
chmod +x "$root"/duckdb_scripts/remove_intermediate_filters_and_projections.sh
chmod +x "$root"/duckdb_scripts/visualize_duckdb_plans.sh
chmod +x "$root"/query_plans/imdb_duckdb/create_IR_plans.sh
chmod +x "$root"/query_plans/stats_duckdb/create_IR_plans.sh
chmod +x "$root"/query_plans/ce_duckdb/create_IR_plans.sh
chmod +x "$root"/query_plans/yannakakis_from_template.sh
chmod +x "$root"/experiments/imdb/run.sh
chmod +x "$root"/experiments/statsceb/run.sh
chmod +x "$root"/experiments/ce/run.sh


# Download datasets
cd "$root"/benchmarks || exit
./download_datasets.sh


# Build DuckDB
cd "$root"/duckdb || exit
GEN=ninja make

# Build Rust crates
cd "$root"/yannakakis-join-implementation || exit
cargo build --release
cd "$root"/intermediate_to_df_plan || exit
cargo build --release

# Load data into DuckDB database
cd "$root"/duckdb_scripts || exit
./load_into_duckdb.sh ./imdb.db "$root"/benchmarks/imdb/load_data_duckdb.sql
./load_into_duckdb.sh ./stats.db "$root"/benchmarks/stats-ceb/load_data_duckdb.sql
./load_into_duckdb.sh ./ce.db "$root"/benchmarks/ce/load_data_duckdb.sql
