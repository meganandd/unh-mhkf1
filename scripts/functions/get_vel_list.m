% -------------------------------------------------------------------------
% Generates a list of all tow-speeds used in a given list of test plan(s)
% 
% Input(s):
%   data_dir = location of 'MHKF1-1m' folder
%   test_plan = test plan name (found in 'Raw' folder)
%
% Output(s):
%   vel_list = list of tow speeds completed in a test run; used when
%   creating legend entries in 'plot_test_plan'
% -------------------------------------------------------------------------

function vel_list = get_vel_list(data_dir, test_plan)
    test_name = string(test_plan);

    processed_path = fullfile(data_dir, 'Data\Processed\' + ...
        test_name + '\' + test_name + '.csv');

    processed_plan = table2struct(readtable(processed_path));

    vel_list = unique([processed_plan.tow_speed_nom]);
end