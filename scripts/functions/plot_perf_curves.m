function plot_perf_curves(data_dir, test_plan)
    % create a list of all the tow speeds tested
    vel_list = get_vel_list(data_dir, test_plan);

    C = [181 12 0
        250 111 90
        201 102 40
        255 157 46
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

    markers = ['pentagram', "^", "hexagram", "square", "o", "diamond", ...
        "pentagram", "^", "hexagram", "square", "o", "diamond", ...
        "pentagram", "^"];

    test_name = string(test_plan);
    processed_path = fullfile(data_dir, 'Data\Processed\' + ...
        test_name + '\' + test_name + '.csv');
    processed_plan = readtable(processed_path);
    [sorted_plan, ~] = sortrows(processed_plan, [2, 3]);

    sorted_plan = table2struct(sorted_plan);

    U_inf = unique([sorted_plan.tow_speed_nom]);
    j = zeros(length(U_inf), 1);
    leg_name = cell(length(U_inf), 1);

    for i = 1 : length(j)
        j(i) = find(vel_list == U_inf(i));
        leg_name{i} = string(['U_\infty = ', num2str(vel_list(j(i))), ...
        + ' [ms^{-1}]']);
    end

    markers = markers(j);

    TSR = struct();
    Re_c = struct();
    C_P = struct();
    C_T = struct();
    C_Q = struct();
    C_Mx = struct();
    C_My = struct();

     for s = 1 : length(vel_list)
        vel = sorted_plan([sorted_plan.tow_speed_nom] == ...
                vel_list(s));

        TSR.("vel_" + string(s)) = [vel.mean_TSR];
        Re_c.("vel_" + string(s)) = [vel.Re_c];
        C_P.("vel_" + string(s)) = [vel.mean_CP];
        C_T.("vel_" + string(s)) = [vel.mean_CT];
        C_Q.("vel_" + string(s)) = [vel.mean_CQ];
        C_Mx.("vel_" + string(s)) = [vel.mean_CMx];
        C_My.("vel_" + string(s)) = [vel.mean_CMy];
     end

    cp = figure(6);
    set(cp, 'renderer', 'painters')
    hold on 

    for n = 1 : length(vel_list)
        p = plot(TSR.("vel_" + string(n)), ...
            C_P.("vel_" + string(n)), '-');

        p.Marker = markers(n);
        p.MarkerSize = 8;
        p.DisplayName = leg_name{n};
        p.Color = C(n, :);
        p.MarkerFaceColor = C(n, :);
        grid on
    end

    xlabel('\lambda')
    ylabel('C_P')
    [~, ~, ~, ~] = legend(legendUnq(cp), 'Location', 'eastoutside');

    ct = figure(7);
    set(ct, 'renderer', 'painters')
    hold on 

    for n = 1 : length(vel_list)
        p = plot(TSR.("vel_" + string(n)), ...
            C_T.("vel_" + string(n)), '-');

        p.Marker = markers(n);
        p.MarkerSize = 8;
        p.DisplayName = leg_name{n};
        p.Color = C(n, :);
        p.MarkerFaceColor = C(n, :);
        grid on
    end

    hold off

    xlabel('\lambda')
    ylabel('C_T')
    [~, ~, ~, ~] = legend(legendUnq(ct), 'Location', 'eastoutside');

    cq = figure(8);
    set(cq, 'renderer', 'painters')
    hold on 

    for n = 1 : length(vel_list)
        p = plot(TSR.("vel_" + string(n)), ...
            C_Q.("vel_" + string(n)), '-');

         p.Marker = markers(n);
        p.MarkerSize = 8;
        p.DisplayName = leg_name{n};
        p.Color = C(n, :);
        p.MarkerFaceColor = C(n, :);
        grid on
    end

    hold off

    xlabel('\lambda')
    ylabel('C_Q')
    [~, ~, ~, ~] = legend(legendUnq(cq), 'Location', 'eastoutside');

    cmx = figure(9);
    set(cmx, 'renderer', 'painters')
    hold on 

    for n = 1 : length(vel_list)
        p = plot(TSR.("vel_" + string(n)), ...
            C_Mx.("vel_" + string(n)), '-');

        p.Marker = markers(n);
        p.MarkerSize = 8;
        p.DisplayName = leg_name{n};
        p.Color = C(n, :);
        p.MarkerFaceColor = C(n, :);
        grid on
    end

    hold off

    xlabel('\lambda')
    ylabel('C_{Mx}')
    [~, ~, ~, ~] = legend(legendUnq(cmx), 'Location', 'eastoutside');

    cmy = figure(10);
    set(cmy, 'renderer', 'painters')
    hold on 

    for n = 1 : length(vel_list)
        p = plot(TSR.("vel_" + string(n)), ...
            C_My.("vel_" + string(n)), '-');

        p.Marker = markers(n);
        p.MarkerSize = 8;
        p.DisplayName = leg_name{n};
        p.Color = C(n, :);
        p.MarkerFaceColor = C(n, :);
        grid on
    end

    hold off

    xlabel('\lambda')
    ylabel('C_{My}')
    [~, ~, ~, ~] = legend(legendUnq(cmy), 'Location', 'eastoutside');

    rec = figure(11);
    set(rec, 'renderer', 'painters')
    hold on

    for n = 2 : length(vel_list)
        p = plot(TSR.("vel_" + string(n)), ...
            Re_c.("vel_" + string(n)), '-');

        p.Marker = markers(n);
        p.MarkerSize = 8;
        p.DisplayName = leg_name{n};
        p.Color = C(n, :);
        p.MarkerFaceColor = C(n, :);
        grid on

        hold on
    end

    y1 = yline(2*10^5, 'Label', 'Re_c = 200,000', 'LineWidth', 2.0, "DisplayName", ...
        "IEC Lower Critical Re_c", "LabelHorizontalAlignment", "right", ...
        "LabelVerticalAlignment", "bottom");
    y1.Color = 'k';
    y1.LineStyle = '--';

    y2 = yline(5*10^5, 'Label', 'Re_c = 500,000', 'LineWidth', 2.0, "DisplayName", ...
        "IEC Upper Critical Re_c", "LabelHorizontalAlignment", "left", ...
        "LabelVerticalAlignment", "bottom");
    y2.Color = 'r';
    y2.LineStyle = '--';

    xlim([1 8])

    hold off

    xlabel('\lambda')
    ylabel('Re_c')
    legend('Location', 'eastoutside')
end
