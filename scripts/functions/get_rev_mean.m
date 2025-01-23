% -------------------------------------------------------------------------
% Trims ACS and NI data from AFT Test Bed to be within a region of 
% steady-state operation. The 'stop' time is selected based on the last
% full revolution of the rotor. 
% 
% Input(s):
%   rho = water density
%   nu = water viscosity
%   n_revs = number of rotor revolutions during a given towing run 
%   inst_perf = struct() of instantanous performance data during
%   steady-state operation (CP, CT, CQ, C_Mx, C_My, U_inf, omega, Re_c,
%   etc.)
%
% Output(s):
%   rev_mean = struct() of unprocessed ACS data trimmed to only include
%              steady-state operation (stop time coincides with last full
%              rotor revolution)
% -------------------------------------------------------------------------

function rev_mean = get_rev_mean(rho, nu, n_revs, inst_perf)
    rev_mean = struct();
    
    % TURBINE POSITION DATA HAS UNITS OF [DEG / 6]
    % 60 DEG IS EQUIVALENT TO 360 DEG BASED ON HOW THE ROTARY ENCODER WAS
    % CONFIGURED IN ACS 

    turbine_pos = unwrap(inst_perf.turbine_pos);
    start_angle = turbine_pos(1); % actual starting azimuth angle

    % pre-allocate
    rev_edgewise = zeros(1, n_revs);
    rev_flapwise = zeros(1, n_revs);
    rev_thrust = zeros(1, n_revs);
    rev_torque = zeros(1, n_revs);

    rev_C_P = zeros(1, n_revs);
    rev_C_T = zeros(1, n_revs);
    rev_C_Q = zeros(1, n_revs);
    rev_C_Mx = zeros(1, n_revs);
    rev_C_My = zeros(1, n_revs);
    rev_Re_D = zeros(1, n_revs);
    rev_Re_c = zeros(1, n_revs);
    rev_omega = zeros(1, n_revs);
    rev_TSR = zeros(1, n_revs);
    rev_angle = {zeros(1, n_revs)};

    for i = 1 : n_revs
        end_angle = start_angle + 60; % [deg / 6]
        ind = find(turbine_pos > start_angle & turbine_pos <= end_angle);

        [rev_edgewise(i), ~, ~] = stats(inst_perf.edgewise(ind));
        [rev_flapwise(i), ~, ~] = stats(inst_perf.flapwise(ind));
        [rev_thrust(i), ~, ~] = stats(inst_perf.thrust(ind));
        [rev_torque(i), ~, ~] = stats(inst_perf.torque(ind));

        [rev_C_P(i), ~, ~] = stats(inst_perf.C_P(ind));
        [rev_C_T(i), ~, ~] = stats(inst_perf.C_T(ind)); 
        [rev_C_Q(i), ~, ~] = stats(inst_perf.C_Q(ind));
        [rev_C_Mx(i), ~, ~] = stats(inst_perf.C_Mx(ind));
        [rev_C_My(i), ~, ~] = stats(inst_perf.C_My(ind));
        [rev_Re_D(i), ~, ~] = stats(inst_perf.Re_D(ind));
        [rev_Re_c(i), ~, ~] = stats(inst_perf.Re_c(ind));
        [rev_omega(i), ~, ~] = stats(inst_perf.omega(ind));
        [rev_TSR(i), ~, ~] = stats(inst_perf.TSR(ind));

        % start back at 0 degrees when 360 degrees is reached
        rev_angle{i} = turbine_pos(ind) - ...
            floor((start_angle(1) / 60.0)) * 60.0; % [deg / 6]
        angle_ind = find(rev_angle{i} > 60);

        if ~isempty(angle_ind)
            rev_angle{i}(angle_ind) = rev_angle{i}(angle_ind) - ...
                floor(rev_angle{i}(angle_ind(1)) / 60.0) * 60.0;
        end

        start_angle = end_angle;
    end

    [rev_mean.U_inf, ~, ~] = stats(inst_perf.U_inf);
    
    % RHS consists of the the average value computed over each full 
    % revolution during a test run 
    rev_mean.edgewise = rev_edgewise;
    rev_mean.flapwise = rev_flapwise;
    rev_mean.thrust = rev_thrust;
    rev_mean.torque = rev_torque;

    rev_mean.omega = rev_omega;
    rev_mean.TSR = rev_TSR;
    rev_mean.C_P = rev_C_P;
    rev_mean.C_T = rev_C_T;
    rev_mean.C_Q = rev_C_Q;
    rev_mean.C_Mx = rev_C_Mx;
    rev_mean.C_My = rev_C_My;
    rev_mean.Re_c = rev_Re_c;
    rev_mean.Re_D = rev_Re_D;
    
    % now, take final average of each value computed over the total number 
    % of complete revolutions 
    [rev_mean.m_edgewise, ~, rev_mean.stddev_edgewise] = stats(rev_edgewise);
    [rev_mean.m_flapwise, ~, rev_mean.stddev_flapwise] = stats(rev_flapwise);
    [rev_mean.m_thrust, ~, ~] = stats(rev_thrust);
    [rev_mean.m_torque, ~, ~] = stats(rev_torque);

    [rev_mean.m_U_inf, ~, ~] = stats(inst_perf.U_inf);
    [rev_mean.m_omega, ~, ~] = stats(rev_omega);
    [rev_mean.m_TSR, ~, rev_mean.stddev_TSR] = stats(rev_TSR);
    [rev_mean.m_C_P, ~, rev_mean.stddev_C_P] = stats(rev_C_P);
    [rev_mean.m_C_T, ~, rev_mean.stddev_C_T] = stats(rev_C_T);
    [rev_mean.m_C_Q, ~, rev_mean.stddev_C_Q] = stats(rev_C_Q);
    [rev_mean.m_C_Mx, ~, rev_mean.stddev_C_Mx] = stats(rev_C_Mx);
    [rev_mean.m_C_My, ~, rev_mean.stddev_C_My] = stats(rev_C_My);
    [rev_mean.m_Re_c, ~, ~] = stats(rev_Re_c);
    [rev_mean.m_Re_D, ~, ~] = stats(rev_Re_D);

    % Compute blockage-corrected performance parameters for U_inf, C_P,
    % C_T, and TSR using method from Holsby and Vogel (Ross & Polagye,
    % 2020)
    [U_inf_p, C_P_p, C_T_p, TSR_p] = blockage_correction(rev_mean.U_inf, ...
        rev_mean.m_C_T, rev_mean.m_C_P, rev_mean.m_TSR, 'HV');

    c = 0.06385; % blade chord length @ 70% span [m]
    
    % Calculate new U_rel and Re_c values based on the adjusted U_inf and
    % TSR values from the blockage correction above 
    rR = 0.7010112000;
    U_rel = U_inf_p * ...
        sqrt(1 + TSR_p^2 * rR^2); % relative velocity at ~70% span, [m/s]
    Re_c = (U_rel * c) / nu; % chord-based Re at ~70% span

    rev_mean.m_Re_c_p = Re_c;
    rev_mean.m_U_inf_p = U_inf_p;
    rev_mean.m_C_P_p = C_P_p;
    rev_mean.m_C_T_p = C_T_p;
    rev_mean.m_TSR_p = TSR_p;
    rev_mean.rho = rho;
    
    % rev_mean.stddev_omega = std(movmean(inst_perf.omega, 500, 'omitnan'), ...
    %     'omitnan');
    % rev_mean.stddev_U_inf = std(movmean(inst_perf.U_inf, 500, 'omitnan'), ...
    %     'omitnan');
end