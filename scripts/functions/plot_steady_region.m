function plot_steady_region(data_dir)
    % Sample steady region plot has U_inf = 1.6 [m/s] and TSR = 4.7 -->
    % this corresponds to run '100' in '1.6-2.0_perf'
    test_name = "1.6-2.0_perf";
    test_num = 100; % run number corresponding to test conditions in figure 

    % read acsdata.h5 into struct()
    [~, acs_data] = read_h5([fullfile(data_dir, ...
    '\raw\' + test_name + '\' + string(test_num) + '\acsdata.h5')]);
    % read nidata.h5 into struct()
    [~, ni_data] = read_h5([fullfile(data_dir, ...
    '\raw\' + test_name + '\' + string(test_num) + '\nidata.h5')]);

    % Calculate carriage velocity from NI linear encoder data & resample to
    % match length of ACS datasets, overwrites carriage_vel in acs_data
    acs_data.carriage_vel = calc_tow_speed(ni_data.time, ...
        ni_data.carriage_pos, acs_data.time);

    f = figure(2);
    set(f, 'renderer', 'painter');
    yyaxis left
    plot(acs_data.time, acs_data.carriage_vel, 'DisplayName', 'U_\infty [m/s]')
    ylabel('U_\infty [m/s]')
    
    yyaxis right
    plot(acs_data.time, acs_data.turbine_rpm, 'DisplayName', ...
        'Rotor Speed [rpm]')
    ylabel('Rotor Speed [rpm]')

    hold on
    xline(11.5, '--', 'LineWidth', 2)
    xline(22, '--', 'LineWidth', 2)
    xlim([0 32])
    xlabel('Time [s]')

    saveas(f, "./../figures/steady_region.png")
end
