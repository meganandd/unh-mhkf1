function [V_0_p, C_P_p, C_T_p, TSR_p] = blockage_correction(V_0, C_T, ...
    C_P, TSR, method)

    method = string(method);

    g = 9.81; % acceleration due to gravity [m/s^2]
    D = 1; % turbine diameter [m]
    A_T = 1/4 * pi * D^2; % turbine rotor area [m^2]

    b = 3.66; % UNH tow-tank width [m] 
    h = 2.44; % UNH tow-tank depth [m]
    A_C = b * h; % UNH tow-tank cross-sectional area [m^2]

    d_0 = h; % water depth [m]

    beta = A_T / A_C; % blockage ratio

    Fr = V_0 / sqrt(g * d_0); % Froude number
    
    % Applies blockage correction method from Holsby and Vogel (see Ross
    % & Polagye 2020 for equations)
    if strcmp(method, 'HV')
        F = @(u)HV_blockage(u, V_0, C_T, beta, Fr);
        init_u_2 = V_0 + 0.01;
        
        u_2 = fsolve(F, init_u_2);
        
        u_1 = solve_HV(u_2, V_0, C_T, beta, Fr);
    
        u_T = (u_1(1) * (u_2 - V_0) * (2 * g * d_0 - u_2^2 - (u_2 * V_0))) / ...
            (2 * beta * g * d_0 * (u_2 - u_1(1)));

        V_0_p = (V_0 * ((u_T / V_0)^2 + (C_T / 4))) / (u_T / V_0);

    % Applies blockage correction method from Barnsley and Wellicome (see
    % Ross & Polagye 2020 for equations)
    elseif strcmp(method, 'BW')
        % System of equations used for Barnsley and Wellicome blockage
        % method in 'BW_blockage.m'
        F = @(u2_u1)BW_blockage(beta, C_T, u2_u1);
        init_u2_u1 = 1.1;

        u2_u1 = fsolve(F, init_u2_u1);
        [V0_u1, uT_u1] = solve_BW(u2_u1, beta, C_T);
        uT_V0 = uT_u1 / V0_u1(1);
        V_0_p = (V_0 * (uT_V0^2 + (C_T / 4))) / uT_V0;
    end

    C_P_p = C_P * (V_0 / V_0_p)^3;
    C_T_p = C_T * (V_0 / V_0_p)^2;
    TSR_p = TSR * (V_0 / V_0_p);
end