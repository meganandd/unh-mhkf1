function [inst_perf, n_revs, tare_vals, rho, nu] = get_inst_perf(acs_info, ...
    acs_data, ni_info, ni_data, meta_path, data_dir)

    c = 0.06385; % blade chord length @ 70% span [m]
    D = 1; % turbine diameter [m]
    A = 1/4 * pi * D^2; % turbine rotor area [m^2]
    % mu = 0.00089; % dynamic viscosity [m^2/s]

    % calculate carriage velocity from NI linear encoder data & resample to
    % match length of ACS datasets, overwrites carriage_vel in acs_data
    acs_data.carriage_vel = calc_tow_speed(ni_data.time, ...
        ni_data.carriage_pos, acs_data.time);

    % tare INF4 load cell channels using resting values before motion 
    tare_vals = tare_inf4(acs_data);

    % trim relevant data to only include steady state operation
    [trim_acs, trim_ni, n_revs] = get_steady_times(data_dir, ...
        meta_path, acs_data, ni_data);

    % filter any large spikes from data using standard deviation filter
    % (mostly necessary for turbine RPM)
    % ACS data filtering
    for i = 1 : length(acs_info.Groups.Datasets)
        name = acs_info.Groups.Datasets(i).Name;
        [filter_acs, ~, ~, ~] = stdev_n(trim_acs.(name), 3, 6);
        % re-assign
        trim_acs.(name) = filter_acs;
    end

    % NI data filtering
    for i = 1 : length(ni_info.Groups.Datasets)
        name = ni_info.Groups.Datasets(i).Name;
        [filter_ni, ~, ~, ~] = stdev_n(trim_ni.(name), 3, 6);
        % re-assign
        trim_ni.(name) = filter_ni;
    end
    
    % water density [kg/m^3]
    % (°F − 32) × 5/9 = °C
    water_temp = (mean(trim_ni.water_temp, 'omitnan') - 32)  * 5/9;

    rho = water.density(water_temp); 
    nu = water.viscosity(water_temp);

    rpm = trim_acs.turbine_rpm;
    U_inf = trim_acs.carriage_vel;

    edgewise = trim_acs.load_cell_ch1 - tare_vals.ch1;
    flapwise = trim_acs.load_cell_ch2 - tare_vals.ch2;
    thrust = trim_acs.load_cell_ch3 - tare_vals.ch3;
    torque = trim_acs.load_cell_ch4 - tare_vals.ch4;

    % correct for load-cell channel crosstalk 
    [edgewise, flapwise, thrust, torque] = ...
        crosstalk_correction(edgewise, flapwise, thrust, torque);
    
    % calculate instantaneous performance parameters
    omega = (2 * pi * rpm) / 60; % angular velocity of turbine shaft
    TSR = (omega * (D / 2)) ./ U_inf; % tip speed ratio
    C_P = (torque .* omega) ./ ...
        (1/2 * rho * A * U_inf.^3); % performance coefficient
    C_Q = torque ./ ...
        (1/2 * rho * A * (D / 2) * U_inf.^2); % torque coefficient
    C_T = thrust ./ (1/2 * rho * A * U_inf.^2); % thrust coefficient
    % bending moment coefficients
    C_Mx = edgewise ./ (1/2 * rho * A * (D / 2) * U_inf.^2); % edgewise
    C_My = flapwise ./ (1/2 * rho * A * (D / 2) * U_inf.^2); % flapwise
    Re_D = (U_inf * D) / nu; % Re based on turbine diameter 

    rR = 0.7010112000; 
    U_rel = U_inf .* ...
        sqrt(1 + TSR.^2 * rR^2); % relative velocity at ~70% span, [m/s]
    Re_c = (U_rel * c) / nu; % chord-based Re at ~70% span

    % make struct() for results
    inst_perf = struct();

    inst_perf.time = trim_acs.time;
    inst_perf.turbine_pos = trim_acs.turbine_pos;
    inst_perf.omega = omega;
    inst_perf.rpm = rpm;
    inst_perf.U_inf = U_inf;
    inst_perf.TSR = TSR;

    inst_perf.edgewise = edgewise;
    inst_perf.flapwise = flapwise;
    inst_perf.thrust = thrust;
    inst_perf.torque = torque;
    
    inst_perf.C_P = C_P;
    inst_perf.C_Q = C_Q;
    inst_perf.C_T = C_T;

    inst_perf.C_Mx = C_Mx;
    inst_perf.C_My = C_My;

    inst_perf.Re_D = Re_D;
    inst_perf.Re_c = Re_c;
end
