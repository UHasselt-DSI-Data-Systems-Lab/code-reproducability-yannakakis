\o -
\set repeat 10
\set parallel 1
\set timeout 1800000 -- (ms)

\record results/benchmark_umbra_default.csv job:
\c db/job.db
\i scripts/job/job_all

\record results/benchmark_umbra_default.csv statsceb:
\c db/statsceb.db
\i scripts/statsceb/statsceb_all

\record results/benchmark_umbra_default.csv ce:
\c db/ce.db
\i scripts/ce/ce_all