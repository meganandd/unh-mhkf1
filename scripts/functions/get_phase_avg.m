function phase_avg = get_phase_avg(inst_perf)
    % Define number of bins
    bin_size = 2;
    num_bins = 360 / bin_size; 
    bin_edges = linspace(0, 360, num_bins + 1); % Bin edges

    turbine_pos = wrapTo360(inst_perf.turbine_pos * 6);

    inst_perf.datasets = {'omega', 'rpm', 'U_inf', 'TSR', 'edgewise', ...
        'flapwise', 'thrust', 'torque', 'C_P', 'C_Q', 'C_T', 'C_Mx', ...
        'C_My', 'Re_D', 'Re_c'}; % List of dataset names

    % Initialize struct to hold phase-averaged results
    phase_avg = struct();
    rev_mean = struct();
    normalized_data = struct();

    for d = 1 : length(inst_perf.datasets)
        dataset_name = inst_perf.datasets{d};
        phase_avg.(dataset_name) = zeros(num_bins, 1);
        
        % Phase averaging for each dataset
        for i = 1 : num_bins
            % Find indices of values within the current bin
            bin_indices = (turbine_pos >= bin_edges(i)) & ...
                (turbine_pos < bin_edges(i + 1));
            
            % Calculate the average for this bin
            phase_avg.(dataset_name)(i) = ...
                mean(inst_perf.(dataset_name)(bin_indices), 'omitnan');
        end
        rev_mean.(dataset_name) = mean(phase_avg.(dataset_name));
        normalized_data.(dataset_name) = phase_avg.(dataset_name) - ...
            rev_mean.(dataset_name);
    end

figure()
hold on
plot(1 : 36, phase_avg.edgewise, 'LineWidth', 2);
xlim([0 36])
xline([9, 18, 27, 36])
xlabel('Bins (10^{\circ} width)')
ylabel("Edgewise Bending Moment [N-m]")
end



