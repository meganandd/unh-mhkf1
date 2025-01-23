function exp_unc_combined = ...
    calc_multi_exp_unc(sys_unc, n, mean, std, dof)
    % Calculate expanded uncertainty using values from multiple runs.

    % Note that this function assumes the statistic is a mean value, 
    % therefore the combined standard deviation is divided by `sqrt(N)`.

    % parameters:
    % ----------
    % sys_unc : numpy array of systematic uncertainties
    % n : numpy array of numbers of samples per set
    % std : numpy array of sample standard deviations
    % dof : numpy array of degrees of freedom

    % mean of sysmatic uncertainties 
    [sys_unc, ~, ~] = stats(sys_unc);
    std_combined = combine_std(n, mean, std);
    std_combined = std_combined / sqrt(sum(n));

    std_unc_combined = sqrt(std_combined^2 + sys_unc^2);
    dof = sum(dof);

    t_combined = tinv(0.95, dof);
    exp_unc_combined = t_combined * std_unc_combined;
end