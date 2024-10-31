#!/bin/bash

# Create persistent DuckDB database and load data into it
# Usage: load_into_duckdb.sh <database> <import_script>
# e.g., load_into_duckdb.sh ./imdb.db load_imdb_data.sql


database=$1         # Database, must end with .db
import_script=$2    # .sql script that creates tables and loads data into them

duckdb_path="../duckdb/build/release/duckdb"

# Exit if <database> already exists
if [ -f "$database" ]; then
    echo "Database $database already exists."
    exit 1
fi

# # create duckdb database
# $duckdb_path "$database" << EOF
# .tables
# EOF

# We must execute the $import_data script from the same directory where it is located
# because it possibly uses relative paths to load the data
cwd=$(pwd)
cd "$(dirname "$import_script")" || exit

# Load data into database
"$cwd/$duckdb_path" "$cwd"/"$database" << EOF
.read '$(basename -- "$import_script")'
EOF

cd "$cwd" || exit
