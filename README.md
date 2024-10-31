# Reproducability Package - Yannakakis in Column Stores
This repository contains supplemental material for reproducing the results reported our paper *Instance-Optimal Acyclic Join Processing Without Regret: Engineering the Yannakakis Algorithm in Column Stores*. Full version will be uploaded soon.

The repository is organized as follows:

- [**2phase_nsa**](./2phase_nsa/): Code for converting binary plans to 2NSA plans.
- [**benchmarks**](./benchmarks/): Benchmark queries and data.
- [**duckdb**](./duckdb/): Fork of DuckDB.
- [**duckdb_scripts**](./duckdb_scripts/): Scripts for loading data and running queries in DuckDB.
- [**experiments**](./experiments/): Experiment scripts and results.
- [**intermediate_to_df_plan**](./intermediate_to_df_plan/): Rust code for running query plans (binary & 2NSA plans) in Datafusion.
- [**query_plans**](./query_plans/): Binary and 2NSA query plans specified in JSON format for all benchmark queries.
- [**yannakakis-join-implementation**](./yannakakis-join-implementation/): Yannakakis implementation in Datafusion. (dependency of [intermediate_to_df_plan](./intermediate_to_df_plan/))


## Analyze Results

If you only want to analyze our results reported in the paper, you can skip the following steps and inspect the results in the [experiments](./experiments/) folder. For the CE benchmark, the output folder was too large for GitHub, so we only uploaded the [compressed version](./experiments/ce/output.tar.xz). You should extract it (in the same folder) before running the analysis notebooks.

```bash

## Run Experiments

Be aware that results might differ from machine to machine. We conducted all experiments on a Ubuntu 22.04.4 LTS machine with an Intel Core i7-11800 CPU and 32GB of RAM. Prerequisites for running the experiments are (between brackets are the versions we used):

- Rust (1.74.1) with nightly toolchain
- Python (3.10.12) & pip (22.0.2)
- Make (4.3)


We provided some bash script to make it easier to run the experiments: [setup.sh](./setup.sh), [clean.sh](./clean.sh), and [run_queries.sh](./run_queries.sh). They should be executed from the root directory and also in the following order:

```bash
# cwd = root directory of this repository

# Download datasets, build DuckDB, build Yannakakis implementation,...
chmod +x setup.sh
./setup.sh

# Remove all experiment results that are currently in the repo (query plans, csv files, ...)
chmod +x clean.sh
./clean.sh

# Run all benchmark queries (DuckDB-bin, Datafusion-bin, Datafusion-2NSA)
chmod +x run_queries.sh
./run_queries.sh
```
