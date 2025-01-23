% -------------------------------------------------------------------------
% Trims ACS and NI data from AFT Test Bed to be within a region of 
% steady-state operation. The 'stop' time is selected based on the last
% full revolution of the rotor. 
% 
% Input(s):
%   data_dir = location of 'MHKF1-1m' folder
%   meta_path = location of metadata .JSON file for a particulr test run 
%   acs_data = struct() of raw data from ACS
%   ni_data = struct() of raw data from NI 
%
% Output(s):
%   trim_acs = struct() of unprocessed ACS data trimmed to only include
%              steady-state operation (stop time coincides with last full
%              rotor revolution)
%   trim_ni = struct() of unprocessed NI data trimmed to only include
%              steady-state operation
%   n_revs = number of full revolutions completed in steady region
% -------------------------------------------------------------------------

function [trim_acs, trim_ni, n_revs] = ...
    get_steady_times(data_dir, meta_path, acs_data, ni_data)

    % unwrap turbine position data 
    turbine_pos = abs(unwrap(acs_data.turbine_pos)); % [deg / 6]

    % use unique time values only 
    unique_ind = find(unique(acs_data.time));

    acs_data.time = acs_data.time(unique_ind);
    acs_data.carriage_vel = acs_data.carriage_vel(unique_ind);
    acs_data.turbine_pos = turbine_pos(unique_ind);
    acs_data.turbine_rpm = acs_data.turbine_rpm(unique_ind);
    acs_data.load_cell_ch1 = acs_data.load_cell_ch1(unique_ind);
    acs_data.load_cell_ch2 = acs_data.load_cell_ch2(unique_ind);
    acs_data.load_cell_ch3 = acs_data.load_cell_ch3(unique_ind);
    acs_data.load_cell_ch4 = acs_data.load_cell_ch4(unique_ind);

    trim_acs = struct();
    trim_ni = struct();

    [vel, tsr] = read_json(meta_path);
    % initial guesses for steady times in 'Data/Config/Steady times/' 
    steady_csv = fullfile(data_dir, ...
        '\Config\Steady times\' + string(vel) + '.csv');
    % import steady times into struct
    steady_times = table2struct(readtable(steady_csv));

    if ~isreal(tsr)
        % specified TSR
        set_tsr = str2double(tsr);
    else
        set_tsr = tsr;
    end
    
    % find appropriate start and stop times for specified tsr
    times = steady_times([steady_times.tsr] == set_tsr);
    if isempty(times)
        times = steady_times([steady_times.tsr] == str2double(set_tsr));
    end

    start = times.t1; % start time (stabilized)
    stop = times.t2; % end time (stabilized, but not full rotation)

    % find azimuth angle at start and stop times 
    start_angle = turbine_pos(find(round(acs_data.time, 2) ...
        == start, 1, 'first')); % [deg / 6] 

    % if find() doesn't work above, find the next closest start index 
    if isempty(start_angle)
        [~, start_index] = min(abs(round(acs_data.time, 4) - ...
            start));
        start_angle = turbine_pos(start_index);
    end
   
    stop_angle = turbine_pos(find(round(acs_data.time, 2) ...
        == stop, 1, 'first')); % [deg / 6]

    % if find() doesn't work above, find the next closest stop index 
    if isempty(stop_angle)
        [~, stop_idx_init] = min(abs(round(acs_data.time, 4) - ...
            stop));
        stop_angle = turbine_pos(stop_idx_init);
    end
    
    % number of blade passes
    n_passes = floor((stop_angle - start_angle) / 20);
    
    % number of revolutions
    n_revs = floor((stop_angle - start_angle) / 60);

    stop_angle = start_angle + (n_passes * 20);

    stop_index = find(round(turbine_pos, 2) == ...
            round(stop_angle, 2), 1, 'first');
    
    % if find() doesn't work above, find the next closest stop index 
    if isempty(stop_index)
        [~, stop_index] = min(abs(round(turbine_pos, 2) - ...
            round(stop_angle, 2)));
    end

    % end time for full rotations
    stop = round(acs_data.time(stop_index), 3);

    start_acs = find(round(acs_data.time, 2) == start, 1, 'first');
    
    if isempty(start_acs)
        start_acs = start_index;
    end

    stop_acs = stop_index;

    % truncate ACS data to steady region
    trim_acs.carriage_vel = ...
        acs_data.carriage_vel(start_acs : stop_acs);
    trim_acs.load_cell_ch1 = ...
        acs_data.load_cell_ch1(start_acs : stop_acs);
    trim_acs.load_cell_ch2 = ...
        acs_data.load_cell_ch2(start_acs : stop_acs);
    trim_acs.load_cell_ch3 = ...
        acs_data.load_cell_ch3(start_acs : stop_acs);
    trim_acs.load_cell_ch4 = ...
        acs_data.load_cell_ch4(start_acs : stop_acs);
    trim_acs.time = ...
        acs_data.time(start_acs : stop_acs);
    trim_acs.turbine_pos = ...
        acs_data.turbine_pos(start_acs : stop_acs);
    trim_acs.turbine_rpm = ...
        acs_data.turbine_rpm(start_acs : stop_acs);

    % sampling rate of NI data
    delta_ni = round(1 / (ni_data.time(2) - ni_data.time(1)));

    start_ni = fix(start * delta_ni);
    stop_ni = fix(stop * delta_ni);

    % truncate NI data to steady region
    trim_ni.time = ...
        ni_data.time(start_ni : stop_ni);
    trim_ni.carriage_pos = ...
        ni_data.carriage_pos(start_ni : stop_ni);
    trim_ni.aft_temp = ...
        ni_data.aft_temp(start_ni : stop_ni);
    trim_ni.fore_temp = ...
        ni_data.fore_temp(start_ni : stop_ni);
    trim_ni.resistor_temp = ...
        ni_data.resistor_temp(start_ni : stop_ni);
    trim_ni.water_temp = ...
        ni_data.water_temp(start_ni : stop_ni);
end