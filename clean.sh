#!/bin/sh

# Remove results created by "run_queries.sh"

root=$(pwd)

# Remove query plans and their categorization
rm -rf "$root"/2phase_nsa/categories

for benchmark in imdb_duckdb stats_duckdb ce_duckdb
do
rm -rf "$root"/query_plans/"$benchmark"/2_original_with_aliases
rm -rf "$root"/query_plans/"$benchmark"/3_no_filters_and_projections
rm -rf "$root"/query_plans/"$benchmark"/3_IR_no_filters_and_projections
rm -rf "$root"/query_plans/"$benchmark"/yannakakis
done

# Remove experiment results
for benchmark in imdb statsceb ce
do
    rm -f  "$root"/experiments/"$benchmark"/timings.csv
    rm -f  "$root"/experiments/"$benchmark"/timings_agg.csv
    rm -f  "$root"/experiments/"$benchmark"/timings_revision.csv
    rm -f  "$root"/experiments/"$benchmark"/timings_agg_revision.csv
    rm -rf "$root"/experiments/"$benchmark"/output
    rm -rf "$root"/experiments/"$benchmark"/output_revision

done

rm -f "$root"/umbra/results/*.csv
