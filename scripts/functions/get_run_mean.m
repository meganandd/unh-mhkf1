function run_mean = get_run_mean(rho, nu, inst_perf)
    run_mean = struct();
    
    [mean_edgewise, ~, ~] = stats(inst_perf.edgewise);
    [mean_flapwise, ~, ~] = stats(inst_perf.flapwise);
    [mean_thrust, ~, ~] = stats(inst_perf.thrust);
    [mean_torque, ~, ~] = stats(inst_perf.torque);

    [mean_C_P, ~, ~] = stats(inst_perf.C_P);
    [mean_C_Q, ~, ~] = stats(inst_perf.C_Q);
    [mean_C_T, ~, ~] = stats(inst_perf.C_T);
    [mean_C_Mx, ~, ~] = stats(inst_perf.C_Mx);
    [mean_C_My, ~, ~] = stats(inst_perf.C_My);
    [mean_Re_D, ~, ~] = stats(inst_perf.Re_D);
    [mean_Re_c, ~, ~] = stats(inst_perf.Re_c);
    [mean_omega, ~, ~] = stats(inst_perf.omega);
    [mean_TSR, ~, ~] = stats(inst_perf.TSR);

    [mean_U_inf, ~, ~] = stats(inst_perf.U_inf);
    [mean_rpm, ~, ~] = stats(inst_perf.rpm);

    % blockage correction for time-averaged tow-speed, C_P, C_T, and TSR
    [U_inf_p, C_P_p, C_T_p, TSR_p] = blockage_correction(mean_U_inf, ...
        mean_C_T, mean_C_P, mean_TSR, 'HV');

    c = 0.06385; % blade chord length @ 70% span [m]

    rR = 0.7010112000;
    U_rel = U_inf_p * ...
        sqrt(1 + TSR_p^2 * rR^2); % relative velocity at ~70% span, [m/s]
    Re_c = (U_rel * c) / nu; % chord-based Re at ~70% span

    run_mean.edgewise = mean_edgewise;
    run_mean.flapwise = mean_flapwise;
    run_mean.thrust = mean_thrust;
    run_mean.torque = mean_torque;

    run_mean.U_inf = mean_U_inf;
    run_mean.U_inf_p = U_inf_p;
    run_mean.RPM = mean_rpm;
    run_mean.omega = mean_omega;
    run_mean.TSR = mean_TSR;
    run_mean.TSR_p = TSR_p;
    run_mean.C_P = mean_C_P;
    run_mean.C_P_p = C_P_p;
    run_mean.C_Q = mean_C_Q;
    run_mean.C_T = mean_C_T;
    run_mean.C_T_p = C_T_p;
    run_mean.C_Mx = mean_C_Mx;
    run_mean.C_My = mean_C_My;
    run_mean.Re_c = mean_Re_c;
    run_mean.Re_c_p = Re_c;
    run_mean.Re_D = mean_Re_D;

    run_mean.rho = rho;
end

