//! Metrics for tracking the performance of the semi-join operator.

use datafusion::physical_plan::metrics::{self, ExecutionPlanMetricsSet, MetricBuilder};

#[derive(Clone, Debug)]
pub(super) struct SemiJoinMetrics {
    /// Total time spent by this operator.
    /// This includes the build time and the semijoin time.
    pub total_time: metrics::Time,

    /// Total time spent materializing the child groupby results
    pub build_time: metrics::Time,
    /// Total time spent by semijoining the guard tuples with the child groupby results
    pub semijoin_time: metrics::Time,

    /// Number of rows in guard batch
    pub guard_input_rows: metrics::Count,
}

impl SemiJoinMetrics {
    pub fn new(partition: usize, metrics: &ExecutionPlanMetricsSet) -> Self {
        let total_time = MetricBuilder::new(metrics).elapsed_compute(partition);
        let build_time: metrics::Time = MetricBuilder::new(metrics).subset_time("build", partition);
        let semijoin_time: metrics::Time =
            MetricBuilder::new(metrics).subset_time("semijoin", partition);
        let guard_input_rows = MetricBuilder::new(metrics).counter("guard_input_rows", partition);

        Self {
            total_time,
            build_time,
            semijoin_time,
            guard_input_rows,
        }
    }
}
