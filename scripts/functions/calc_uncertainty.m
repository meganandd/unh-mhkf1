% Calculate the combined standard uncertainty of a quantity
function unc = calc_uncertainty(rev_mean, qty, system_unc)
    N = length(rev_mean.(qty));
    % 
    % R = 0.5; % turbine radius, [m]
    % A = 1/2 * pi * R^2; % turbine swept area, [m^2]
    % rho = rev_mean.rho;
    % 
    % s_U_inf = std(rev_mean.U_inf, 'omitnan');
    % s_omega = std(rev_mean.omega, 'omitnan');
    % s_torque = std(rev_mean.torque, 'omitnan');
    % s_thrust = std(rev_mean.thrust, 'omitnan');
    % s_edgewise = std(rev_mean.edgewise, 'omitnan');
    % s_flapwise = std(rev_mean.flapwise, 'omitnan');
    % 
    % m_U_inf = rev_mean.m_U_inf;
    % m_omega = rev_mean.m_omega;
    % m_torque = rev_mean.m_torque;
    % m_thrust = rev_mean.m_thrust;
    % m_edgewise = rev_mean.m_edgewise;
    % m_flapwise = rev_mean.m_flapwise;

    if strcmp(qty, "C_P")
        p_CP = std(rev_mean.C_P) / sqrt(N);
        
        % p_CP = sqrt(((2 * m_omega / (rho * A * m_U_inf^3)) * ...
        %     s_torque / sqrt(N))^2 + ((2 * m_torque / ...
        %     (rho * A * m_U_inf^3)) * s_omega / sqrt(N))^2 + ...
        %     ((-6 * m_torque * m_omega / (rho * A * m_U_inf^4)) * ...
        %     s_U_inf / sqrt(N))^2);

       random_unc = p_CP;

    elseif strcmp(qty, "C_T")
        p_CT = std(rev_mean.C_T) / sqrt(N);

        % p_CT = sqrt(((2 / (rho * A * m_U_inf^2)) * ...
        %     s_thrust / sqrt(N))^2 + ...
        %     ((-4 * m_thrust / (rho * A * m_U_inf^3)) * ...
        %     s_U_inf^2 / sqrt(N))^2);

        random_unc = p_CT;

    elseif strcmp(qty, "C_Q")
        p_CQ = std(rev_mean.C_Q) / length(N);

        % p_CQ = sqrt(((2 / (rho * A * m_U_inf^2)) * ...
        %     s_torque / sqrt(N))^2 + ...
        %     ((-4 * m_torque / (rho * A * m_U_inf^3)) * ...
        %     s_U_inf^2 / sqrt(N))^2);

        random_unc = p_CQ;

    elseif strcmp(qty, "C_Mx")
        p_CMx = std(rev_mean.C_Mx) / sqrt(N);

        % p_CMx = sqrt(((2 / (rho * A * m_U_inf^2)) * ...
        %     s_edgewise / sqrt(N))^2 + ...
        %     ((-4 * m_edgewise / (rho * A * m_U_inf^3)) * ...
        %     s_U_inf^2 / sqrt(N))^2);

        random_unc = p_CMx;
    else
        p_CMy = std(rev_mean.C_My) / sqrt(N);

        % p_CMy = sqrt(((2 / (rho * A * m_U_inf^2)) * ...
        %     s_flapwise / sqrt(N))^2 + ...
        %     ((-4 * m_flapwise / (rho * A * m_U_inf^3)) * ...
        %     s_U_inf^2 / sqrt(N))^2);

        random_unc = p_CMy;
    end

    unc = sqrt(random_unc^2 + system_unc^2);
end