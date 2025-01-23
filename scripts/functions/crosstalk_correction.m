function [edgewise_corr, flapwise_corr, thrust_corr, torque_corr] = ...
    crosstalk_correction(edgewise, flapwise, thrust, torque)

    % Find indices with NaN values
    [edgewise_nans, ~] = find(isnan(edgewise));
    [flapwise_nans, ~] = find(isnan(flapwise));
    [thrust_nans, ~] = find(isnan(thrust));
    [torque_nans, ~] = find(isnan(torque));

    % Turn all NaNs to zeros to avoid errors (will be changed back)
    edgewise(isnan(edgewise)) = 0;
    flapwise(isnan(flapwise)) = 0;
    thrust(isnan(thrust)) = 0;
    torque(isnan(torque)) = 0;

    % Correct for crosstalk on blade root load cell channels
    edgewise_FS = 47; % Full-scale measurement for edgewise load cell [N-m]
    flapwise_FS = 172; % Full-scale measurement for flapwise load cell [N-m]
    
    % Edgewise calibration loads, [N-m]
    edgewise_loads = [0 5.65 16.95 28.25 39.54 46.89]; 
    edgewise_response = 2.992; % [mV]

    % Response from flapwise bending moment channel during edgewise
    % calibration, [mV]
    flapwise_CT = [0 0.003333333 0.01 0.0175 0.023333333 0.0275];
    % Find flapwise crosstalk response at the full-scale edgewise load
    flapwise_CT_FS = interp1(edgewise_loads, flapwise_CT, edgewise_FS, ...
        'linear', 'extrap');

    % Flapwise calibration loads, [N-m]
    flapwise_loads = [0 33.9 67.79 101.69 135.58 171.74];
    flapwise_response = 10.9125; % [mV]
    
    % Response from edgwise bending moment channel during flapwise
    % calibration, [mV]
    edgewise_CT = [0 -0.01 -0.023333333 -0.033333333 -0.045 -0.058333333];
    % Find edgewise crosstalk response at the full-scale flapwise load
    edgewise_CT_FS = interp1(flapwise_loads, edgewise_CT, flapwise_FS, ...
        'linear', 'extrap');

    % 2 x 2 matrix
    % Load cell channel response corresponding to full-scale loading
    % divided by full-scale load 
    A_bending = ...
    [(edgewise_response / edgewise_FS) (edgewise_CT_FS / flapwise_FS);
        (flapwise_CT_FS / edgewise_FS) (flapwise_response / flapwise_FS)];

    % Take inverse of A matrix to find mV-to-engineering units multiplier
    % 2 x 2 matrix
    K_bending = inv(A_bending);
    
    % Bending moment channel outputs in mV
    O_edgewise = edgewise / (edgewise_FS / edgewise_response);
    O_flapwise = flapwise / (flapwise_FS / flapwise_response);

    % bending_corrected = K_bending * O_bending;
    edgewise_corr = O_edgewise * K_bending(1, 1) + ...
        O_flapwise * K_bending(1, 2);
    flapwise_corr = O_edgewise * K_bending(2, 1) + ...
        O_flapwise * K_bending(2, 2);
    
    % Correct for crosstalk on rotor torque/thrust load cell 
    thrust_FS = 1885.0;
    torque_FS = 222.0;

    thrust_loads = [0.00 222.41 667.23 1112.06 1556.88 1890.49]; % [N]
    % thrust response at FS capacity from calibration certification 
    thrust_response = 4.82895; % [mV]
    
    % torque crosstalk [mV] when loading thrust channel 
    torque_CT = [0.00000 0.01013 0.02967 0.04933 0.06981 0.08485];
    % torque crosstalk at thrust FS
    torque_CT_FS = interp1(thrust_loads, torque_CT, thrust_FS); % [mV]

    torque_loads = [0.00 40.67 81.35 122.02 162.70 221.00]; % [N-m]
    torque_response = 9.63208; % [mV]

    thrust_CT = [0.00000 -0.01238 -0.02520 -0.03851 -0.05263 ...
        -0.07311]; % [mV]
    thrust_CT_FS = interp1(torque_loads, thrust_CT, torque_FS, ...
        'linear', 'extrap'); % [mV]
    
    A_rotor = ...
    [(thrust_response / thrust_FS) (thrust_CT_FS / torque_FS);
        (torque_CT_FS / thrust_FS) (torque_response / torque_FS)];

    % take inverse of A matrix to find mV-to-engineering units multiplier
    K_rotor = inv(A_rotor);

    % bending moment channel outputs in mV
    O_thrust = thrust / (thrust_FS / thrust_response);
    O_torque = torque / (torque_FS / torque_response);

    thrust_corr = O_thrust * K_rotor(1, 1) + ...
        O_torque * K_rotor(1, 2);
    torque_corr =  O_thrust * K_rotor(2, 1) + ...
        O_torque * K_rotor(2, 2);

    % make original NaN values NaNs again
    edgewise_corr(edgewise_nans) = NaN;
    flapwise_corr(flapwise_nans) = NaN;
    thrust_corr(thrust_nans) = NaN;
    torque_corr(torque_nans) = NaN;
end
