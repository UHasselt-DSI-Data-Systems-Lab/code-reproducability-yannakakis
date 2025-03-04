#!/usr/bin/env bash

# DEFAULT UMBRA CONFIG BUT WITH LOOKUP & EXPAND ENABLED

mv results/benchmark_umbra_le.csv results/benchmark_umbra_le.csv.old
mkdir -p results/
export UMBRA_VERSIONNOTE=v18.base.lookup.filter.agg
export UMBRA_EAGERAGGOVERHEAD=4
export UMBRA_DATABASE_QUERYBUFFERSIZE=25G
export UMBRA_JOINORDER=L
export UMBRA_EXPAND3=1
export UMBRA_VERBOSITY=log
export UMBRA_COMPILATIONMODE=o
export UMBRA_OPTIMIZER_INDEXOVERHEAD=999999999
export UMBRA_INDEX_METHOD=U

# To disable sideway information passing
export UMBRA_OPTIMIZER_SIDEWAYINFORMATIONPASSING=0  

# To disable bloom filters
export UMBRA_LOOKUPFILTER=0 

# To disable l&e
# export UMBRA_JOINORDER=a 

# To disable multiway joins
export UMBRA_MULTIWAY=d

# To disable eager aggregation:
export UMBRA_EAGERAGGOVERHEAD=99999999999 

# To force hash joins
export UMBRA_OPTIMIZER_MUSTHASHJOIN=1 

# To disable pullup of group-bys above joins that could form a groupjoin (on/off)
export UMBRA_PULLUPGROUPJOINS=0 

# hash table mode 
export UMBRA_ENGINE_HASHTABLE_IMPLEMENTATION=a # (The default hash table mode (Auto:'a' (default), Chaining:'c', RobinHood:'r'))

# To disable the use of sample for TableScan
# export UMBRA_USESAMPLE=0 

# To ensure a single thread
export UMBRA_ASYNC_IO_WORKER_THREADS=1 

# We use empty.sql so that docker maps the project directory as well
bin/sql "" empty.sql scripts/benchmark_umbra_le.sql
