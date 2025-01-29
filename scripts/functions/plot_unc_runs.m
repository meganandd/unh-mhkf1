function plot_unc_runs(data_dir)
    C = [34 148 156
        188 196 37
        150 53 84
        235 204 80] / 255;

    markers = ['o', 'square', "diamond", "pentagram"];

    processed_path = fullfile(data_dir, ['processed\' ...
        'uncertainty_runs\uncertainty_runs.csv']);
    processed_plan = readtable(processed_path);
    [sorted_plan, ~] = sortrows(processed_plan, [2, 3]);

    sorted_plan = table2struct(sorted_plan);

    TSR_1 = sorted_plan([sorted_plan.TSR_nom] == 1);
    TSR_4 = sorted_plan([sorted_plan.TSR_nom] == 4);
    TSR_8 = sorted_plan([sorted_plan.TSR_nom] == 8);
    
    U95_CP_1 = zeros(1, 10);
    U95_CT_1 = zeros(1, 10);
    U95_CQ_1 = zeros(1, 10);
    U95_CMx_1 = zeros(1, 10);
    U95_CMy_1 = zeros(1, 10);
    
    U95_CP_4 = zeros(1, 10);
    U95_CT_4 = zeros(1, 10);
    U95_CQ_4 = zeros(1, 10);
    U95_CMx_4 = zeros(1, 10);
    U95_CMy_4 = zeros(1, 10);
    
    U95_CP_8 = zeros(1, 10);
    U95_CT_8 = zeros(1, 10);
    U95_CQ_8 = zeros(1, 10);
    U95_CMx_8 = zeros(1, 10);
    U95_CMy_8 = zeros(1, 10);
     
    for k = 1 : length(TSR_1) 
        U95_CP_1(k) = calc_multi_exp_unc([TSR_1(1 : k).sys_unc_CP], ...
            [TSR_1(1 : k).num_revs], [TSR_1(1 : k).mean_CP], ...
            [TSR_1(1 : k).std_CP_per_rev], [TSR_1(1 : k).DOF_CP]);

        U95_CT_1(k) = calc_multi_exp_unc([TSR_1(1 : k).sys_unc_CT], ...
            [TSR_1(1 : k).num_revs], [TSR_1(1 : k).mean_CT], ...
            [TSR_1(1 : k).std_CT_per_rev], [TSR_1(1 : k).DOF_CT]);
    
        U95_CQ_1(k) = calc_multi_exp_unc([TSR_1(1 : k).sys_unc_CQ], ...
            [TSR_1(1 : k).num_revs], [TSR_1(1 : k).mean_CQ], ...
            [TSR_1(1 : k).std_CQ_per_rev], [TSR_1(1 : k).DOF_CQ]);
    
        U95_CMx_1(k) = calc_multi_exp_unc([TSR_1(1 : k).sys_unc_CMx], ...
            [TSR_1(1 : k).num_revs], [TSR_1(1 : k).mean_CMx], ...
            [TSR_1(1 : k).std_CMx_per_rev], [TSR_1(1 : k).DOF_CMx]);
    
        U95_CMy_1(k) = calc_multi_exp_unc([TSR_1(1 : k).sys_unc_CMy], ...
            [TSR_1(1 : k).num_revs], [TSR_1(1 : k).mean_CMy], ...
            [TSR_1(1 : k).std_CMy_per_rev], [TSR_1(1 : k).DOF_CMy]);
    end

    % min(U95_CP_1)
    % min(U95_CT_1)
    % min(U95_CQ_1)
    % min(U95_CMx_1)
    % min(U95_CMy_1)

    for k = 1 : length(TSR_4)
        U95_CP_4(k) = calc_multi_exp_unc([TSR_4(1 : k).sys_unc_CP], ...
            [TSR_4(1 : k).num_revs], [TSR_4(1 : k).mean_CP], ...
            [TSR_4(1 : k).std_CP_per_rev], [TSR_4(1 : k).DOF_CP]);

        U95_CT_4(k) = calc_multi_exp_unc([TSR_4(1 : k).sys_unc_CT], ...
            [TSR_4(1 : k).num_revs], [TSR_4(1 : k).mean_CT], ...
            [TSR_4(1 : k).std_CT_per_rev], [TSR_4(1 : k).DOF_CT]);
    
        U95_CQ_4(k) = calc_multi_exp_unc([TSR_4(1 : k).sys_unc_CQ], ...
            [TSR_4(1 : k).num_revs], [TSR_4(1 : k).mean_CQ], ...
            [TSR_4(1 : k).std_CQ_per_rev], [TSR_4(1 : k).DOF_CQ]);
    
        U95_CMx_4(k) = calc_multi_exp_unc([TSR_4(1 : k).sys_unc_CMx], ...
            [TSR_4(1 : k).num_revs], [TSR_4(1 : k).mean_CMx], ...
            [TSR_4(1 : k).std_CMx_per_rev], [TSR_4(1 : k).DOF_CMx]);
    
        U95_CMy_4(k) = calc_multi_exp_unc([TSR_4(1 : k).sys_unc_CMy], ...
            [TSR_4(1 : k).num_revs], [TSR_4(1 : k).mean_CMy], ...
            [TSR_4(1 : k).std_CMy_per_rev], [TSR_4(1 : k).DOF_CMy]);  
    end

    % min(U95_CP_4)
    % min(U95_CT_4)
    % min(U95_CQ_4)
    % min(U95_CMx_4)
    % min(U95_CMy_4)

    for k = 1 : length(TSR_8)
        U95_CP_8(k) = calc_multi_exp_unc([TSR_8(1 : k).sys_unc_CP], ...
            [TSR_8(1 : k).num_revs], [TSR_8(1 : k).mean_CP], ...
            [TSR_8(1 : k).std_CP_per_rev], [TSR_8(1 : k).DOF_CP]);

        U95_CT_8(k) = calc_multi_exp_unc([TSR_8(1 : k).sys_unc_CT], ...
            [TSR_8(1 : k).num_revs], [TSR_8(1 : k).mean_CT], ...
            [TSR_8(1 : k).std_CT_per_rev], [TSR_8(1 : k).DOF_CT]);
    
        U95_CQ_8(k) = calc_multi_exp_unc([TSR_8(1 : k).sys_unc_CQ], ...
            [TSR_8(1 : k).num_revs], [TSR_8(1 : k).mean_CQ], ...
            [TSR_8(1 : k).std_CQ_per_rev], [TSR_8(1 : k).DOF_CQ]);
    
        U95_CMx_8(k) = calc_multi_exp_unc([TSR_8(1 : k).sys_unc_CMx], ...
            [TSR_8(1 : k).num_revs], [TSR_8(1 : k).mean_CMx], ...
            [TSR_8(1 : k).std_CMx_per_rev], [TSR_8(1 : k).DOF_CMx]);
    
        U95_CMy_8(k) = calc_multi_exp_unc([TSR_8(1 : k).sys_unc_CMy], ...
            [TSR_8(1 : k).num_revs], [TSR_8(1 : k).mean_CMy], ...
            [TSR_8(1 : k).std_CMy_per_rev], [TSR_8(1 : k).DOF_CMy]);  
    end

    % min(U95_CP_8)
    % min(U95_CT_8)
    % min(U95_CQ_8)
    % min(U95_CMx_8)
    % min(U95_CMy_8)

    f = figure(36);
    set(f, 'renderer', 'painter');

    t = tiledlayout(1, 3);

    ax1 = nexttile;
    plot(1 : 10, (U95_CP_1 ./ [TSR_1.mean_CP]) * 100, 'DisplayName', ...
        'C_P', 'Marker', markers(1), 'MarkerSize', 8, 'MarkerFaceColor', ...
        C(1, :), 'MarkerEdgeColor', C(1, :), 'Color', C(1, :));
    hold on 

    plot(1 : 10, (U95_CT_1 ./ [TSR_1.mean_CT]) * 100, 'DisplayName', ...
        'C_T', 'Marker', markers(2), 'MarkerSize', 8, 'MarkerFaceColor', ...
        C(2, :), 'MarkerEdgeColor', C(2, :), 'Color', C(2, :))
    hold on

    plot(1 : 10, (U95_CMx_1 ./ [TSR_1.mean_CMx]) * 100, 'DisplayName', ...
        'C_{Mx}', 'Marker', markers(3), 'MarkerSize', 8, 'MarkerFaceColor', ...
        C(3, :), 'MarkerEdgeColor', C(3, :), 'Color', C(3, :))
    hold on
    
    plot(1 : 10, (U95_CMy_1 ./ [TSR_1.mean_CMy]) * 100, 'DisplayName', ...
        'C_{My}', 'Marker', markers(4), 'MarkerSize', 8, 'MarkerFaceColor', ...
        C(4, :), 'MarkerEdgeColor', C(4, :), 'Color', C(4, :))
    grid on
    hold off
    
    % xlim([1 10])
    % xlabel('Number of Trials')
    % ylabel("Percent Uncertainty [%]")
    % title(["Percent expanded uncertainty of mean performance coefficients", ...
    %     "for increasing trials"]) 
    title('\lambda = 1')
    % legend('Location','eastoutside')
    
    ax2 = nexttile;
    plot(1 : 10, (U95_CP_4 ./ [TSR_4.mean_CP]) * 100, 'DisplayName', ...
        'C_P', 'Marker', markers(1), 'MarkerSize', 8, 'MarkerFaceColor', ...
        C(1, :), 'MarkerEdgeColor', C(1, :), 'Color', C(1, :))
    hold on 
    plot(1 : 10, (U95_CT_4 ./ [TSR_4.mean_CT]) * 100, 'DisplayName', ...
        'C_T', 'Marker', markers(2), 'MarkerSize', 8, 'MarkerFaceColor', ...
        C(2, :), 'MarkerEdgeColor', C(2, :), 'Color', C(2, :))
    hold on
    plot(1 : 10, (U95_CMx_4 ./ [TSR_4.mean_CMx]) * 100, 'DisplayName', ...
        'C_{Mx}', 'Marker', markers(3), 'MarkerSize', 8, 'MarkerFaceColor', ...
        C(3, :), 'MarkerEdgeColor', C(3, :), 'Color', C(3, :))
    hold on
    plot(1 : 10, (U95_CMy_4 ./ [TSR_4.mean_CMy]) * 100, 'DisplayName', ...
        'C_{My}', 'Marker', markers(4), 'MarkerSize', 8, 'MarkerFaceColor', ...
        C(4, :), 'MarkerEdgeColor', C(4, :), 'Color', C(4, :))
    grid on
    hold off
    
    % xlim([1 10])
    % xlabel('Number of Trials')
    % ylabel("Percent Uncertainty [%]")
    % title(["Percent expanded uncertainty of mean performance coefficients", ...
    %     "for increasing trials"]) 
    title('\lambda = 4')
    % legend('Location','eastoutside')
    
    ax3 = nexttile;
    plot(1 : 10, (U95_CP_8 ./ [TSR_8.mean_CP]) * 100, 'DisplayName', ...
        'C_P', 'Marker', markers(1), 'MarkerSize', 8, 'MarkerFaceColor', ...
        C(1, :), 'MarkerEdgeColor', C(1, :), 'Color', C(1, :))
    hold on 
    plot(1 : 10, (U95_CT_8 ./ [TSR_8.mean_CT]) * 100, 'DisplayName', ...
        'C_T', 'Marker', markers(2), 'MarkerSize', 8, 'MarkerFaceColor', ...
        C(2, :), 'MarkerEdgeColor', C(2, :), 'Color', C(2, :))
    hold on
    plot(1 : 10, (U95_CMx_8 ./ [TSR_8.mean_CMx]) * 100, 'DisplayName', ...
        'C_{Mx}', 'Marker', markers(3), 'MarkerSize', 8, 'MarkerFaceColor', ...
        C(3, :), 'MarkerEdgeColor', C(3, :), 'Color', C(3, :))
    hold on
    plot(1 : 10, (U95_CMy_8 ./ [TSR_8.mean_CMy]) * 100, 'DisplayName', ...
        'C_{My}', 'Marker', markers(4), 'MarkerSize', 8, 'MarkerFaceColor', ...
        C(4, :), 'MarkerEdgeColor', C(4, :), 'Color', C(4, :))
    grid on
    hold off
    
    % xlim([1 10])
    % xlabel('Number of Trials')
    % ylabel("Percent Uncertainty [%]")
    % title(["Percent expanded uncertainty of mean performance coefficients", ...
    %     "for increasing trials"]) 
    title('\lambda = 8')
    % legend('Location','eastoutside')

    linkaxes([ax1 ax2 ax3],'xy')
    ax1.XLim = [1 10];
    ax1.YLim = [0 13];
    
    xlabel(t,'Number of Trials')
    ylabel(t,'Percent Uncertainty [%]')
    legend('Location','eastoutside')

    t.TileSpacing = 'compact';
    t.Padding = 'compact';

    saveas(f, "./../figures/uncertainty_vs_trials.png")
end