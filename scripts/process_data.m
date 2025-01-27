% Add path to scripts/functions
addpath('functions')

% Data directory location
data_dir = "..\data";

test_plans = {"0.4-2.0_perf", "1.6-2.0_perf", "1.6-2.0_perf_2", ...
    "Re_dep_4.0", "uncertainty_runs"};

process_test_plan(data_dir, test_plans)