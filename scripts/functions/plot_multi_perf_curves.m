function plot_multi_perf_curves(data_dir)
    % Fontaine et al. (2020) data --> taken from ARL spreadsheet
    % 3 [m/s]
    lambda_3 = [4.789214738, 3.869633427, 4.296063353, ...
        3.378475762, 2.895311562];
    CT_3 = [0.79936292, 0.757268038, 0.779393451, 0.71893131, ...
        0.640312458];
    CQ_3 = [0.097522223, 0.120900464, 0.109756539, 0.133918229, ... 
        0.135646428];
    CP_3 = [0.438568589, 0.448279072, 0.446065499, 0.440415166, ...
        0.396574772];
    
    % 4 [m/s]
    lambda_4 = [4.733903625, 3.328929811, 4.21847731, 3.750303605, ...
        2.859254586];
    CT_4 = [0.792681743, 0.706376339, 0.772234708, 0.747490174, ...
        0.634028432];
    CQ_4 = [0.104271773, 0.139226323, 0.117716917, 0.130774176, ...
        0.14315103];
    CP_4 = [0.444417777, 0.434216758, 0.451125811, 0.450154347, ...
        0.394670567];
    
    % 5 [m/s]
    lambda_5 = [4.742489314, 4.261222359, 3.358427985, 3.787169476, ...
        2.855286392];
    CT_5 = [0.796391834, 0.774851481, 0.712290159, 0.748596388, ...
        0.636196429];
    CQ_5 = [0.107188933, 0.1186809, 0.142534476, 0.131648611, ...
        0.147038839];
    CP_5 = [0.448430929, 0.451120528,0.438760602, 0.449227699, ...
        0.3951402];

    % OpenFAST data --> I digitized this data from Sandia design report, 
    % did not have access to spreadsheet/data table
    lambda = [2.2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5];

    CP_openfast = [0.28, 0.35, 0.4, 0.425, 0.43, 0.42, 0.415, 0.4, ...
        0.375, 0.34];
    CT_openfast = [0.46, 0.55, 0.62, 0.695, 0.72, 0.74, 0.75, 0.745, ...
        0.74, 0.73];

    % Create a list of all the tow speeds tested
    test_plan = '1.6-2.0_perf';
    vel_list = get_vel_list(data_dir, test_plan);
    
    % Colors corresponding to different tow speeds 
    C = [86 143 166
        23 158 212
        68 68 158
        113 68 158
        218 181 255] / 255;

    markers = ["square", "o", "diamond", "pentagram", "^"];
    
    processed_path = fullfile(data_dir, 'processed\');
    % Create a table for each test plan to be averaged together
    plan_1 = readtable(fullfile(processed_path, ...
        '0.4-2.0_perf\0.4-2.0_perf.csv'));
    plan_2 = readtable(fullfile(processed_path, ...
        '1.6-2.0_perf\1.6-2.0_perf.csv'));
    plan_3 = readtable(fullfile(processed_path, ...
        '1.6-2.0_perf_2\1.6-2.0_perf_2.csv'));

    [plan_1, ~] = sortrows(plan_1, [2, 3]);
    [plan_2, ~] = sortrows(plan_2, [2, 3]);
    [plan_3, ~] = sortrows(plan_3, [2, 3]);

    TSR_list = unique([plan_2.TSR_nom])';

    comb_plans = [plan_1; plan_2; plan_3];

    comb_plans = table2struct(comb_plans);

    U_inf = unique([plan_2.tow_speed_nom]);
    leg_name = cell(length(U_inf), 1);

    for i = 1 : length(U_inf)
        j = vel_list == U_inf(i);
        leg_name{i} = string(['U_\infty = ', num2str(vel_list(j)), ...
        + ' [ms^{-1}]']);
    end

    mean_CP = zeros(length(TSR_list), 1);
    mean_CP_p = zeros(length(TSR_list), 1);
    mean_CT = zeros(length(TSR_list), 1);
    mean_CT_p = zeros(length(TSR_list), 1);
    mean_CQ = zeros(length(TSR_list), 1);
    mean_CMx = zeros(length(TSR_list), 1);
    mean_CMy = zeros(length(TSR_list), 1);
    mean_TSR = zeros(length(TSR_list), 1); 
    mean_TSR_p = zeros(length(TSR_list), 1);
    mean_Re_c = zeros(length(TSR_list), 1);
    exp_unc_CP = zeros(length(TSR_list), 1);
    exp_unc_CT = zeros(length(TSR_list), 1);
    exp_unc_CMx = zeros(length(TSR_list), 1);
    exp_unc_CMy = zeros(length(TSR_list), 1);
    
    for s = 1 : length(vel_list)
        vel = comb_plans([comb_plans.tow_speed_nom] == ...
                vel_list(s));
        for t = 1 : length(TSR_list)
            tsr = vel([vel.TSR_nom] == TSR_list(t));
            mean_CP(t) = mean([tsr.mean_CP]);
            mean_CP_p(t) = mean([tsr.CP_p]);
            mean_CT(t) = mean([tsr.mean_CT]);
            mean_CT_p(t) = mean([tsr.CT_p]);
            mean_CQ(t) = mean([tsr.mean_CQ]);
            mean_CMx(t) = mean([tsr.mean_CMx]);
            mean_CMy(t) = mean([tsr.mean_CMy]);
            mean_TSR(t) = mean([tsr.mean_TSR]);
            mean_TSR_p(t) = mean([tsr.TSR_p]);
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
        
        % CP vs. TSR
        f16 = figure(16);
        p16 = plot(mean_TSR, mean_CP);
        set(f16, 'renderer', 'painters')
        
        p16.Marker = markers(s);
        p16.MarkerSize = 8;
        p16.DisplayName = leg_name{s};
        p16.Color = C(s, :);
        p16.MarkerFaceColor = C(s, :);
        grid on
        
        xlim([0 8])
        xlabel('\lambda')
        ylabel('C_{P}')
        [~, ~, ~, ~] = legend(legendUnq(f16), 'Location', 'eastoutside');
        hold on

        % Detail view of CP vs. TSR
        f17 = figure(17);
        p17 = plot(mean_TSR, mean_CP);
        set(f17, 'renderer', 'painters')
        
        p17.Marker = markers(s);
        p17.MarkerSize = 8;
        p17.DisplayName = leg_name{s};
        p17.Color = C(s, :);
        p17.MarkerFaceColor = C(s, :);
        grid on
        
        xlim([2.5 5])
        xlabel('\lambda')
        ylabel('C_{P}')
        hold on

        % CT vs. TSR
        f18 = figure(18);
        p18 = plot(mean_TSR, mean_CT);
        set(f18, 'renderer', 'painters')
        
        p18.Marker = markers(s);
        p18.MarkerSize = 8;
        p18.DisplayName = leg_name{s};
        p18.Color = C(s, :);
        p18.MarkerFaceColor = C(s, :);
        grid on
        
        xlabel('\lambda')
        ylabel('C_{T}')
        [~, ~, ~, ~] = legend(legendUnq(f18), 'Location', 'eastoutside');
        hold on

        % Detail view of CT vs. TSR
        f19 = figure(19);
        p19 = plot(mean_TSR, mean_CT);
        set(f19, 'renderer', 'painters')
        
        p19.Marker = markers(s);
        p19.MarkerSize = 8;
        p19.DisplayName = leg_name{s};
        p19.Color = C(s, :);
        p19.MarkerFaceColor = C(s, :);
        grid on
        
        xlim([2.5 5])
        xlabel('\lambda')
        ylabel('C_{T}')
        hold on

        % CQ vs. TSR
        f20 = figure(20);
        p20 = plot(mean_TSR, mean_CQ);
        set(f20, 'renderer', 'painters')
        
        p20.Marker = markers(s);
        p20.MarkerSize = 8;
        p20.DisplayName = leg_name{s};
        p20.Color = C(s, :);
        p20.MarkerFaceColor = C(s, :);
        grid on
        
        xlim([0 8])
        xlabel('\lambda')
        ylabel('C_{Q}')
        [~, ~, ~, ~] = legend(legendUnq(f20), 'Location', 'eastoutside');
        hold on

        % Detail view of CQ vs. TSR
        f21 = figure(21);
        p21 = plot(mean_TSR, mean_CQ);
        set(f21, 'renderer', 'painters')
        
        p21.Marker = markers(s);
        p21.MarkerSize = 8;
        p21.DisplayName = leg_name{s};
        p21.Color = C(s, :);
        p21.MarkerFaceColor = C(s, :);
        grid on
        
        xlim([2.5 5])
        xlabel('\lambda')
        ylabel('C_{Q}')
        hold on

        % C_Mx vs. TSR
        f22 = figure(22);
        p22 = plot(mean_TSR, mean_CMx);
        set(f22, 'renderer', 'painters')
        
        p22.Marker = markers(s);
        p22.MarkerSize = 8;
        p22.DisplayName = leg_name{s};
        p22.Color = C(s, :);
        p22.MarkerFaceColor = C(s, :);
        grid on
        
        xlim([0 8])
        xlabel('\lambda')
        ylabel('C_{Mx}')
        [~, ~, ~, ~] = legend(legendUnq(f22), 'Location', 'eastoutside');
        hold on

        % Detail view of C_Mx vs. TSR
        f23 = figure(23);
        p23 = plot(mean_TSR, mean_CMx);
        set(f23, 'renderer', 'painters')
        
        p23.Marker = markers(s);
        p23.MarkerSize = 8;
        p23.DisplayName = leg_name{s};
        p23.Color = C(s, :);
        p23.MarkerFaceColor = C(s, :);
        grid on
        
        xlim([2.5 5])
        xlabel('\lambda')
        ylabel('C_{Mx}')
        hold on

        % C_My vs. TSR
        f24 = figure(24);
        p24 = plot(mean_TSR, mean_CMy);
        set(f24, 'renderer', 'painters')
        
        p24.Marker = markers(s);
        p24.MarkerSize = 8;
        p24.DisplayName = leg_name{s};
        p24.Color = C(s, :);
        p24.MarkerFaceColor = C(s, :);
        grid on
        
        xlim([0 8])
        xlabel('\lambda')
        ylabel('C_{My}')
        [~, ~, ~, ~] = legend(legendUnq(f24), 'Location', 'eastoutside');
        hold on

        % Detail view of C_My vs. TSR
        f25 = figure(25);
        p25 = plot(mean_TSR, mean_CMy);
        set(f25, 'renderer', 'painters')
        
        p25.Marker = markers(s);
        p25.MarkerSize = 8;
        p25.DisplayName = leg_name{s};
        p25.Color = C(s, :);
        p25.MarkerFaceColor = C(s, :);
        grid on
        
        xlim([2.5 5])
        xlabel('\lambda')
        ylabel('C_{My}')
        hold on

        % CP' vs. TSR'
        f26 = figure(26);
        p26 = plot(mean_TSR_p, mean_CP_p);
        set(f26, 'renderer', 'painters')
        
        p26.Marker = markers(s);
        p26.MarkerSize = 8;
        p26.DisplayName = leg_name{s};
        p26.Color = C(s, :);
        p26.MarkerFaceColor = C(s, :);
        grid on
        
        xlim([0 8])
        xlabel('\lambda''')
        ylabel('C_{P}''')
        [~, ~, ~, ~] = legend(legendUnq(f26), 'Location', 'eastoutside');
        hold on

        % CT' vs. TSR'
        f27 = figure(27);
        p27 = plot(mean_TSR_p, mean_CT_p);
        set(f27, 'renderer', 'painters')
        
        p27.Marker = markers(s);
        p27.MarkerSize = 8;
        p27.DisplayName = leg_name{s};
        p27.Color = C(s, :);
        p27.MarkerFaceColor = C(s, :);
        grid on
        
        xlim([0 8])
        xlabel('\lambda''')
        ylabel('C_{T}''')
        [~, ~, ~, ~] = legend(legendUnq(f27), 'Location', 'eastoutside');
        hold on

        % CP' vs. TSR' with GTWT data from Fontaine et al. (2020)
        f28 = figure(28);
        p28 = plot(mean_TSR_p, mean_CP_p);
        set(f28, 'renderer', 'painters')
        
        p28.Marker = markers(s);
        p28.MarkerSize = 8;
        p28.DisplayName = leg_name{s};
        p28.Color = C(s, :);
        p28.MarkerFaceColor = C(s, :);
        grid on
        
        xlim([0 8])
        xlabel('\lambda''')
        ylabel('C_{P}''')
        hold on

        % CT' vs. TSR' with GTWT data from Fontaine et al. (2020)
        f29 = figure(29);
        p29 = plot(mean_TSR_p, mean_CT_p);
        set(f29, 'renderer', 'painters')
        
        p29.Marker = markers(s);
        p29.MarkerSize = 8;
        p29.DisplayName = leg_name{s};
        p29.Color = C(s, :);
        p29.MarkerFaceColor = C(s, :);
        grid on
        
        xlim([0 8])
        xlabel('\lambda''')
        ylabel('C_{T}''')
        hold on

        % CP' vs. TSR' with modified MHKF1 OpenFAST model data
        f30 = figure(30);
        p30 = plot(mean_TSR_p, mean_CP_p);
        set(f30, 'renderer', 'painters')
        
        p30.Marker = markers(s);
        p30.MarkerSize = 8;
        p30.DisplayName = leg_name{s};
        p30.Color = C(s, :);
        p30.MarkerFaceColor = C(s, :);
        grid on
        
        xlim([0 8])
        xlabel('\lambda''')
        ylabel('C_{P}''')
        hold on

        % CT' vs. TSR' with modified MHKF1 OpenFAST model data
        f31 = figure(31);
        p31 = plot(mean_TSR_p, mean_CT_p);
        set(f31, 'renderer', 'painters')
        
        p31.Marker = markers(s);
        p31.MarkerSize = 8;
        p31.DisplayName = leg_name{s};
        p31.Color = C(s, :);
        p31.MarkerFaceColor = C(s, :);
        grid on
        
        xlim([0 8])
        xlabel('\lambda''')
        ylabel('C_{T}''')
        hold on

        % Percent uncertainty of CP vs. TSR
        f32 = figure(32);
        p32 = plot(mean_TSR, (exp_unc_CP ./ mean_CP) .* 100);
        set(p32, 'LineStyle', 'None')
        set(f32, 'renderer', 'painters')
        
        p32.Marker = markers(s);
        p32.MarkerSize = 8;
        p32.DisplayName = leg_name{s};
        p32.Color = C(s, :);
        p32.MarkerFaceColor = C(s, :);
        grid on
        
        xlim([0 8])
        xlabel('\lambda')
        ylabel('Percent Uncertainty of C_{P} [%]')
        [~, ~, ~, ~] = legend(legendUnq(f32), 'Location', 'eastoutside');
        hold on

        % Percent uncertainty of CT vs. TSR
        f33 = figure(33);
        p33 = plot(mean_TSR, (exp_unc_CT ./ mean_CT) .* 100);
        set(p33, 'LineStyle', 'None')
        set(f33, 'renderer', 'painters')
        
        p33.Marker = markers(s);
        p33.MarkerSize = 8;
        p33.DisplayName = leg_name{s};
        p33.Color = C(s, :);
        p33.MarkerFaceColor = C(s, :);
        grid on
        
        xlim([0 8])
        xlabel('\lambda')
        ylabel('Percent Uncertainty of C_{T} [%]')
        [~, ~, ~, ~] = legend(legendUnq(f33), 'Location', 'eastoutside');
        hold on

        % Percent uncertainty of C_Mx vs. TSR
        f34 = figure(34);
        p34 = plot(mean_TSR, (exp_unc_CMx ./ mean_CMx) .* 100);
        set(p34, 'LineStyle', 'None')
        set(f34, 'renderer', 'painters')
        
        p34.Marker = markers(s);
        p34.MarkerSize = 8;
        p34.DisplayName = leg_name{s};
        p34.Color = C(s, :);
        p34.MarkerFaceColor = C(s, :);
        grid on
        
        xlim([0 8])
        xlabel('\lambda')
        ylabel('Percent Uncertainty of C_{Mx} [%]')
        [~, ~, ~, ~] = legend(legendUnq(f34), 'Location', 'eastoutside');
        hold on

        % Percent uncertainty of C_My vs. TSR
        f35 = figure(35);
        p35 = plot(mean_TSR, (exp_unc_CMy ./ mean_CMy) .* 100);
        set(p35, 'LineStyle', 'None')
        set(f35, 'renderer', 'painters')
        
        p35.Marker = markers(s);
        p35.MarkerSize = 8;
        p35.DisplayName = leg_name{s};
        p35.Color = C(s, :);
        p35.MarkerFaceColor = C(s, :);
        grid on
        
        xlim([0 8])
        xlabel('\lambda')
        ylabel('Percent Uncertainty of C_{My} [%]')
        [~, ~, ~, ~] = legend(legendUnq(f35), 'Location', 'eastoutside');
        hold on
    end
    
    hold on 
    
    % Add GTWT data to f28
    figure(28)
    plot(lambda_3, CP_3, 'Color', 'k', 'Marker', "hexagram", 'MarkerSize', 8, ...
         'DisplayName', 'U_\infty = 3 [ms^{-1}] (GTWT)', 'LineStyle', 'none')
    plot(lambda_4, CP_4, 'Color', 'k', 'Marker', ".", 'MarkerSize', 8, ...
        'DisplayName', 'U_\infty = 4 [ms^{-1}] (GTWT)', 'LineStyle', 'none')
    plot(lambda_5, CP_5, 'Color', 'k', 'Marker', "*", 'MarkerSize', 8, ...
        'DisplayName', 'U_\infty = 5 [ms^{-1}] (GTWT)', 'LineStyle', 'none')
    [~, ~, ~, ~] = legend(legendUnq(f28), 'Location', 'eastoutside');

    % Add GTWT data to f29
    figure(29)
    plot(lambda_3, CT_3, 'Color', 'k', 'Marker', "hexagram", 'MarkerSize', 8, ...
         'DisplayName', 'U_\infty = 3 [ms^{-1}] (GTWT)', 'LineStyle', 'none')
    plot(lambda_4, CT_4, 'Color', 'k', 'Marker', ".", 'MarkerSize', 8, ...
        'DisplayName', 'U_\infty = 4 [ms^{-1}] (GTWT)', 'LineStyle', 'none')
    plot(lambda_5, CT_5, 'Color', 'k', 'Marker', "*", 'MarkerSize', 8, ...
        'DisplayName', 'U_\infty = 5 [ms^{-1}] (GTWT)', 'LineStyle', 'none')
    [~, ~, ~, ~] = legend(legendUnq(f29), 'Location', 'eastoutside');

    % Add OpenFAST data to f30
    figure(30)
    plot(lambda, CP_openfast, 'Color', 'b', 'Marker', ...
        "hexagram", 'MarkerSize', 8, 'MarkerFaceColor', 'b', ...
        'DisplayName', 'Modified MHKF1 Rotor')
    [~, ~, ~, ~] = legend(legendUnq(f30), 'Location', 'eastoutside');

    % Add OpenFAST data to f31
    figure(31)
    plot(lambda, CT_openfast, 'Color', 'b', 'Marker', ...
        "hexagram", 'MarkerSize', 8, 'MarkerFaceColor', 'b', ...
        'DisplayName', 'Modified MHKF1 Rotor')
    [~, ~, ~, ~] = legend(legendUnq(f31), 'Location', 'eastoutside');

    saveas(f16, "./../figures/1.6-2.0_CP.png")
    saveas(f17, "./../figures/1.6-2.0_CP_detail.png")
    saveas(f18, "./../figures/1.6-2.0_CT.png")
    saveas(f19, "./../figures/1.6-2.0_CT_detail.png")
    saveas(f20, "./../figures/1.6-2.0_CQ.png")
    saveas(f21, "./../figures/1.6-2.0_CQ_detail.png")
    saveas(f22, "./../figures/1.6-2.0_CMx.png")
    saveas(f23, "./../figures/1.6-2.0_CMx_detail.png")
    saveas(f24, "./../figures/1.6-2.0_CMy.png")
    saveas(f25, "./../figures/1.6-2.0_CMy_detail.png")
    saveas(f26, "./../figures/blockage_1.6-2.0_CP.png")
    saveas(f27, "./../figures/blockage_1.6-2.0_CT.png")
    saveas(f28, "./../figures/1.6-2.0_CP_fontaine.png")
    saveas(f29, "./../figures/1.6-2.0_CT_fontaine.png")
    saveas(f30, "./../figures/openfast_CP.png")
    saveas(f31, "./../figures/openfast_CT.png")
    saveas(f32, "./../figures/perc_unc_CP.png")
    saveas(f33, "./../figures/perc_unc_CT.png")
    saveas(f34, "./../figures/perc_unc_CMx.png")
    saveas(f35, "./../figures/perc_unc_CMy.png")
end
