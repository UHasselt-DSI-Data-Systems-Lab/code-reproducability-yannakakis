\o -
\set repeat 10
\set parallel 1
\set timeout 1800000 -- (ms)

-- \record results/benchmark_umbra_le.csv job:
-- \c db/job.db
-- \i scripts/job/job_test

\record results/benchmark_umbra_le.csv statsceb:
\c db/statsceb.db
\i scripts/statsceb/statsceb_all