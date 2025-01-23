function unc = calc_perf_uncertainty(rev_mean)
    unc = struct();

    R = 0.5; % turbine radius, [m]
    A = 1/2 * pi * R^2; % turbine swept area, [m^2]
    rho = rev_mean.rho;

    % systematic uncertainty estimates
    % uncertainty of rotor speed is found by taking the standard deviation
    % of the moving mean over an interval of 500 samples (corresponds to
    % half a second of data) 
    bx_omega = 1.2783e-4 / 2;
    bx_U_inf = 0.5e-5 / 2; 

    % rectangular distribution, divide by sqrt(3)
    bx_thrust = ((0.105 / 100) * 1885) / sqrt(3);
    bx_torque = ((0.180/ 100) * 222) / sqrt(3);
    bx_edgewise = ((0.084 / 100) * 47) / sqrt(3);
    bx_flapwise = ((0.216 / 100) * 172) / sqrt(3);

    % C_P
    omega = rev_mean.m_omega;
    torque = rev_mean.m_torque;
    U_inf = rev_mean.m_U_inf;

    b_CP = sqrt((2 * omega / (rho * A * U_inf^3))^2 * bx_torque^2 + ...
                   (2 * torque / (rho * A * U_inf^3))^2 * bx_omega^2 + ...
                   (-6 * torque * omega / (rho * A * U_inf^4))^2 * bx_U_inf^2);
    unc_CP = calc_uncertainty(rev_mean, 'C_P', b_CP);

    unc.b_C_P = b_CP;
    unc.unc_C_P = unc_CP;

    % C_T
    thrust = rev_mean.m_thrust;
    b_CT = sqrt((2 / (rho * A * U_inf^2))^2 * bx_thrust^2 + ...
        (-4 * thrust / (rho * A * U_inf^3))^2 * bx_U_inf^2);
    unc_CT = calc_uncertainty(rev_mean, 'C_T', b_CT);

    unc.b_C_T = b_CT;
    unc.unc_C_T = unc_CT;

    % C_Q
    torque = rev_mean.m_torque;
    b_CQ = sqrt((2 / (rho * A * R * U_inf^2))^2 * bx_torque^2 + ...
        (-4 * torque / (rho * A * R * U_inf^3))^2 * bx_U_inf^2);
    unc_CQ = calc_uncertainty(rev_mean, 'C_Q', b_CQ);

    unc.b_C_Q = b_CQ;
    unc.unc_C_Q = unc_CQ;

    % C_Mx
    edgewise = rev_mean.m_edgewise;
    b_CMx = sqrt((2 / (rho * A * R * U_inf^2))^2 * bx_edgewise^2 + ...
        (-4 * edgewise / (rho * A * R * U_inf^3))^2 * bx_U_inf^2);
    unc_CMx = calc_uncertainty(rev_mean, 'C_Mx', b_CMx);

    unc.b_C_Mx = b_CMx;
    unc.unc_C_Mx = unc_CMx;

    % C_My
    flapwise = rev_mean.m_flapwise;
    b_CMy = sqrt((2 / (rho * A * R * U_inf^2))^2 * bx_flapwise^2 + ...
        (-4 * flapwise / (rho * A * R * U_inf^3))^2 * bx_U_inf^2);
    unc_CMy = calc_uncertainty(rev_mean, 'C_My', b_CMy);

    unc.b_C_My = b_CMy;
    unc.unc_C_My = unc_CMy;

    % TSR
    b_TSR = sqrt((R / (U_inf))^2 * bx_omega^2 + ...
        (-omega * R / (U_inf^2))^2 * bx_U_inf^2);
    unc_TSR = calc_uncertainty(rev_mean, 'TSR', b_TSR);

    unc.b_TSR = b_TSR;
    unc.unc_TSR = unc_TSR;

    unc.TSR = round(rev_mean.m_TSR, 1);
    unc.U_inf = rev_mean.m_U_inf;

    % expanded uncertainty 
    [unc.U95_C_P, unc.DOF_C_P] = calc_exp_unc(rev_mean, b_CP, ...
        unc_CP, 'C_P');
    [unc.U95_C_T, unc.DOF_C_T] = calc_exp_unc(rev_mean, b_CT, ...
        unc_CP, 'C_T');
    [unc.U95_C_Q, unc.DOF_C_Q] = calc_exp_unc(rev_mean, b_CQ, ...
        unc_CQ, 'C_Q');
    [unc.U95_C_Mx, unc.DOF_C_Mx] = calc_exp_unc(rev_mean, b_CMx, ...
        unc_CMx, 'C_Mx');
    [unc.U95_C_My, unc.DOF_C_My] = calc_exp_unc(rev_mean, b_CMy, ...
        unc_CMy, 'C_My');
    [unc.U95_TSR, unc.DOF_TSR] = calc_exp_unc(rev_mean, b_TSR, ...
        unc_TSR, 'TSR');

    % percent uncertainty 
    unc.perc_C_P = (unc.U95_C_P / rev_mean.m_C_P) * 100;
    unc.perc_C_T = (unc.U95_C_T / rev_mean.m_C_T) * 100;
    unc.perc_C_Q = (unc.U95_C_Q / rev_mean.m_C_Q) * 100;
    unc.perc_C_Mx = (unc.U95_C_Mx / rev_mean.m_C_Mx) * 100;
    unc.perc_C_My = (unc.U95_C_My / rev_mean.m_C_My) * 100;
    unc.perc_TSR = (unc.U95_TSR / rev_mean.m_TSR) * 100;
end