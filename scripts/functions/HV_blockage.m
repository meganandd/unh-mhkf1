% Houlsby and Vogel 
function F = HV_blockage(u, V_0, C_T, beta, Fr)
    u1_1 = (Fr^2 * u^4 - ((4 + 2 * Fr^2) * V_0^2 * u^2) + ...
        (8 * V_0^3 * u) - (4 * V_0^4) + (4 * beta * C_T * V_0^4) + ...
        (Fr^2 * V_0^4)) / ((-4 * Fr^2 * u^3) + ...
        ((4 * Fr^2 + 8) * V_0^2 * u) - 8 * V_0^3);
    
    u1_2 = sqrt(u^2 - C_T * V_0^2);

    F = u1_2 - u1_1;
end
