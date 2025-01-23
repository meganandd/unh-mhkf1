    function plot_multi_re_curves(data_dir, test_plan)
    % create a list of all the tow speeds tested
    vel_list = get_vel_list(data_dir, test_plan);

    C = [255 157 46
        255 222 36
        201 227 32
        110 166 15
        9 79 11
        75 191 178
        86 143 166
        23 158 212
        68 68 158
        113 68 158
        218 181 255] / 255;

    markers = ["square", "o", "diamond", ...
        "pentagram", "^", "hexagram", "square", "o", "diamond", ...
        "pentagram", "^"];

    test_name = string(test_plan);
    processed_path = fullfile(data_dir, 'Data\Processed\' + ...
        test_name + '\' + test_name + '.csv');
    processed_plan = readtable(processed_path);
    [sorted_plan, ~] = sortrows(processed_plan, [2, 3]);

    sorted_plan = table2struct(sorted_plan);

    U_inf = unique([sorted_plan.tow_speed_nom])';
    j = zeros(length(U_inf), 1);
    leg_name = cell(length(U_inf), 1);
    c = cell(length(U_inf), 1);

    for i = 1 : length(j)
        j(i) = find(vel_list == U_inf(i));
        leg_name{i} = string(['U_\infty = ', num2str(vel_list(j(i))), ...
        + ' [ms^{-1}]']);
        c{i} = C(j(i), :);
    end

    markers = markers(j);

    mean_CP = zeros(length(vel_list), 1);
    mean_CT = zeros(length(vel_list), 1);
    mean_Re_c = zeros(length(vel_list), 1);
    exp_unc_CP = zeros(length(vel_list), 1);
    exp_unc_CT = zeros(length(vel_list), 1);

    for s = 1 : length(vel_list)
        comb_speeds = sorted_plan([sorted_plan.tow_speed_nom] == ...
            vel_list(s));

        mean_CP(s) = mean([comb_speeds.mean_CP]);
        mean_CT(s) = mean([comb_speeds.mean_CT]);
        mean_Re_c(s) = mean([comb_speeds.Re_c]);
        exp_unc_CP(s) = calc_multi_exp_unc([comb_speeds.sys_unc_CP], ...
            [comb_speeds.num_revs], [comb_speeds.mean_CP], ...
            [comb_speeds.std_CP_per_rev], [comb_speeds.DOF_CP]);
        exp_unc_CT(s) = calc_multi_exp_unc([comb_speeds.sys_unc_CT], ...
            [comb_speeds.num_revs], [comb_speeds.mean_CT], ...
            [comb_speeds.std_CT_per_rev], [comb_speeds.DOF_CT]);
    end

    re_cp = figure(14);
    set(re_cp, 'renderer', 'painter');

    hold on 

    for n = 1 : length(vel_list)
        p = errorbar(mean_Re_c(n), mean_CP(n), exp_unc_CP(n), ...
            'Marker', markers(n), 'MarkerSize', 8, 'DisplayName', ...
            leg_name{n});
        set(p, 'LineStyle', 'none')

        p.Color = c{n};
        p.MarkerFaceColor = c{n};
        grid on

        hold on
    end

    hold off

    xlabel('Re_c')
    ylabel('C_P')
    [~, ~, ~, ~] = legend(legendUnq(re_cp), 'Location', 'eastoutside');

    re_ct = figure(15);
    set(re_ct, 'renderer', 'painter');

    hold on 

    for n = 1 : length(vel_list)
        p = errorbar(mean_Re_c(n), mean_CT(n), exp_unc_CT(n), ...
            'Marker', markers(n), 'MarkerSize', 8, 'DisplayName', ...
            leg_name{n});
        set(p, 'LineStyle', 'none')

        p.Color = c{n};
        p.MarkerFaceColor = c{n};
        grid on

        hold on
    end

    hold off

    xlabel('Re_c')
    ylabel('C_T')
    [~, ~, ~, ~] = legend(legendUnq(re_ct), 'Location', 'eastoutside');
end