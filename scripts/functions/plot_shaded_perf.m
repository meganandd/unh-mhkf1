function plot_shaded_perf(data_dir, tow_speed)
    test_plan = '1.6-2.0_perf';
    vel_list = get_vel_list(data_dir, test_plan);

    C = [86 143 166
        23 158 212
        68 68 158
        113 68 158
        218 181 255] / 255;

    markers = ["square", "o", "diamond", "pentagram", "^"];
    
    processed_path = fullfile(data_dir, 'processed\');
    plan_1 = readtable(fullfile(processed_path, ...
        '0.4-2.0_perf\0.4-2.0_perf.csv'));
    plan_2 = readtable(fullfile(processed_path, ...
        '1.6-2.0_perf\1.6-2.0_perf.csv'));
    plan_3 = readtable(fullfile(processed_path, ...
        '1.6-2.0_perf_2\1.6-2.0_perf_2.csv'));

    [plan_1, ~] = sortrows(plan_1, [2, 3]);
    [plan_2, ~] = sortrows(plan_2, [2, 3]);
    [plan_3, ~] = sortrows(plan_3, [2, 3]);

    comb_plans = [plan_1; plan_2; plan_3];
    comb_plans = table2struct(comb_plans);

    j = vel_list == tow_speed;
    leg_name = string(['U_\infty = ', num2str(vel_list(j)), ...
        + ' [m \cdot s^{-1}]']);

    vel = comb_plans([comb_plans.tow_speed_nom] == tow_speed);

    TSR_list = unique([vel.TSR_nom]);

    mean_CP = zeros(length(TSR_list), 1);
    mean_CT = zeros(length(TSR_list), 1);
    mean_CMx = zeros(length(TSR_list), 1);
    mean_CMy = zeros(length(TSR_list), 1);
    mean_TSR = zeros(length(TSR_list), 1); 
    mean_Re_c = zeros(length(TSR_list), 1);
    exp_unc_CP = zeros(length(TSR_list), 1);
    exp_unc_CT = zeros(length(TSR_list), 1);
    exp_unc_CMx = zeros(length(TSR_list), 1);
    exp_unc_CMy = zeros(length(TSR_list), 1);

    for t = 1 : length(TSR_list)
        tsr = vel([vel.TSR_nom] == TSR_list(t));
        mean_CP(t) = mean([tsr.mean_CP]);
        mean_CT(t) = mean([tsr.mean_CT]);
        mean_CMx(t) = mean([tsr.mean_CMx]);
        mean_CMy(t) = mean([tsr.mean_CMy]);
        mean_TSR(t) = mean([tsr.mean_TSR]);
        mean_Re_c(t) = mean([tsr.Re_c]);
        exp_unc_CP(t) = calc_multi_exp_unc([tsr.sys_unc_CP], ...
            [tsr.num_revs], [tsr.mean_CP], ...
            [tsr.std_CP_per_rev], [tsr.DOF_CP]);
        exp_unc_CT(t) = calc_multi_exp_unc([tsr.sys_unc_CT], ...
            [tsr.num_revs], [tsr.mean_CT], ...
            [tsr.std_CT_per_rev], [tsr.DOF_CT]);
        exp_unc_CMx(t) = calc_multi_exp_unc([tsr.sys_unc_CMx], ...
            [tsr.num_revs], [tsr.mean_CMx], ...
            [tsr.std_CMx_per_rev], [tsr.DOF_CMx]);
        exp_unc_CMy(t) = calc_multi_exp_unc([tsr.sys_unc_CMy], ...
            [tsr.num_revs], [tsr.mean_CMy], ...
            [tsr.std_CMy_per_rev], [tsr.DOF_CMy]);
    end
    
    % C_P vs. TSR
    cp = figure(37);
    set(cp, 'renderer', 'painters')
    shadedErrorBar(mean_TSR, mean_CP, exp_unc_CP, 'lineProps', ...
        {'Color', C(j, :), 'DisplayName', leg_name}); 
    grid on
    xlabel('\lambda')
    xlim([1 8])
    ylabel('C_P')
    legend()

    % C_T vs. TSR
    ct = figure(38);
    set(ct, 'renderer', 'painters')
    shadedErrorBar(mean_TSR, mean_CT, exp_unc_CT, 'lineProps', ...
        {'Color', C(j, :), 'DisplayName', leg_name});
    grid on
    xlabel('\lambda')
    xlim([1 8])
    ylabel('C_T')
    legend()

    % C_Mx vs. TSR
    cmx = figure(39);
    set(cmx, 'renderer', 'painters')
    shadedErrorBar(mean_TSR, mean_CMx, exp_unc_CMx, 'lineProps', ...
        {'Color', C(j, :), 'DisplayName', leg_name});
    grid on
    xlabel('\lambda')
    xlim([1 8])
    ylabel('C_{Mx}')
    legend()

    % C_My vs. TSR
    cmy = figure(40);
    set(cmy, 'renderer', 'painters')
    shadedErrorBar(mean_TSR, mean_CMy, exp_unc_CMy, 'lineProps', ...
        {'Color', C(j, :), 'DisplayName', leg_name});
    grid on
    xlabel('\lambda')
    xlim([1 8])
    ylabel('C_{My}')
    legend()
end
