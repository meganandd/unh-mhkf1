function F = BW_blockage(beta, C_T, u2_u1)
    uT_u1 = (-1 + sqrt(1 + beta*((u2_u1)^2 - 1))) / (beta * (u2_u1 - 1));

    V0_u1_1 = u2_u1 - beta * uT_u1 * (u2_u1 - 1);

    V0_u1_2 = sqrt(((u2_u1)^2 - 1) / C_T);

    F = V0_u1_1 - V0_u1_2;
end