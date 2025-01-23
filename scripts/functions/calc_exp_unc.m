function [U_95, nu_x] = calc_exp_unc(rev_mean, b, comb_unc, qty)
    N = length(rev_mean.(qty));
    rel_unc = 0.25; % assumed to be 0.25
    
    % s_x used to calculate DOF 
    s_x = rev_mean.("stddev_" + string(qty));
    s_x = s_x / sqrt(N);
    nu_s_x = N - 1; 

    nu_b = 0.5 * rel_unc^-2;
    nu_x = ((s_x^2 + b^2)^2) / (s_x^4 / nu_s_x + b^4 / nu_b);

    t = tinv(0.95, nu_x);
    U_95 = t * comb_unc;
end