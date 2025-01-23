function [V0_u1, uT_u1] = solve_BW(u2_u1, beta, C_T)
    uT_u1 = (-1 + sqrt(1 + beta*((u2_u1)^2 - 1))) / (beta * (u2_u1 - 1));
    
    V0_u1_1 = u2_u1 - beta * uT_u1 * (u2_u1 - 1);
    V0_u1(1) = V0_u1_1;

    V0_u1_2 = sqrt(((u2_u1)^2 - 1) / C_T);
    V0_u1(2) = V0_u1_2;
end