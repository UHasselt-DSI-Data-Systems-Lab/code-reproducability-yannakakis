#!/usr/bin/env bash

# The set -e option instructs bash to immediately exit if any command [1] has a non-zero exit status. 
# set -u affects variables. When set, a reference to any variable you haven't previously defined - with the exceptions of $* and $@ - is an error, and causes the program to immediately exit.
# set -o pipefail This setting prevents errors in a pipeline from being masked. If any command in a pipeline fails, that return code will be used as the return code of the whole pipeline. By default, the pipeline's return code is that of the last command even if it succeeds. 
set -euo pipefail

BIN=${1:-bin}
DB=${2:-db}
SCRIPTDIR="$PWD"
SQL="$SCRIPTDIR/$BIN/sql"
DBFILE="$SCRIPTDIR/$DB/job.db"

echo "Generating JOB database $DBFILE"

mkdir -p scripts/job/data
cd scripts/job/data

mkdir -p "$SCRIPTDIR/$DB"
"$SQL" -createdb "$DBFILE" "$SCRIPTDIR/scripts/job/schema_no_constraints.sql" "$SCRIPTDIR/scripts/job/load.sql"
