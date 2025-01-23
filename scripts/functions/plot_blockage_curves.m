function plot_blockage_curves(data_dir, test_plan)
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
    C_P = struct();
    C_T = struct();
    Re_c_4 = zeros(length(U_inf), 1);
    CP_4 = zeros(length(U_inf), 1);
    CT_4 = zeros(length(U_inf), 1);

     for s = 1 : length(vel_list)
        vel = sorted_plan([sorted_plan.tow_speed_nom] == ...
                vel_list(s));

        TSR.("vel_" + string(s)) = [vel.TSR_p];
        C_P.("vel_" + string(s)) = [vel.CP_p];
        C_T.("vel_" + string(s)) = [vel.CT_p];

        tsr = vel([vel.TSR_nom] == 4);
        
        Re_c_4(s) = [tsr.Re_c_p];
        CP_4(s) = [tsr.CP_p];
        CT_4(s) = [tsr.CT_p];
     end

    cp = figure(12);
    set(cp, 'renderer', 'painter');
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

    xlabel('\lambda''')
    ylabel('C_P''')
    [~, ~, ~, ~] = legend(legendUnq(cp), 'Location', 'eastoutside');

    ct = figure(13);
    set(ct, 'renderer', 'painter');
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

    xlabel('\lambda''')
    ylabel('C_T''')
    [~, ~, ~, ~] = legend(legendUnq(ct), 'Location', 'eastoutside');
end

