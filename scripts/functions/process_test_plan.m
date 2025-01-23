% Processes data from test plan(s) from AFT Test Bed. 
% 
% Input(s):
%   data_dir = location of 'MHKF1-1m' folder
%   test_plan = test plan name (found in 'Raw' folder)
%
% Output(s):
%   Saves a .csv file to the corresponsing 'Processed' folder with all 
%   parameters of interest for each run in the test plan
% -------------------------------------------------------------------------

function process_test_plan(data_dir, test_plan)
    
    % check if data_dir exists and prompts for a new path if not 
    if ~isfolder(data_dir)
        error_message = sprintf(['Error: The following folder does not ' ...
            'exist:\n%s\nPlease specify a new folder.'], data_dir);
        uiwait(warndlg(error_message)); 
        data_dir = uigetdir();

        if data_dir == 0
            fprintf('Folder selection cancelled. \n')
            return
        end
    end

    % process data for each test plan given as an input
    for n = 1 : length(test_plan)
        test_name = string(test_plan(n));

        fprintf('Processing ' + test_name + '. \n')

        % number of runs in current test plan
        n_runs = length(dir(fullfile(data_dir, '\Data\Raw\' + ...
            test_name))) - 2;
    
        % initialize data structures for raw data from ACS and NI
        % acs_raw = struct();
        % ni_raw = struct();

        % allocate variables to save later in table 
        run = zeros(length(n_runs), 1);
        tow_speed_nom = zeros(length(n_runs), 1);
        TSR_nom = zeros(length(n_runs), 1);
        num_revs = zeros(length(n_runs), 1);
        water_dens = zeros(length(n_runs), 1);
        
        Re_c = zeros(length(n_runs), 1);
        lead_lag = zeros(length(n_runs), 1);
        flapwise = zeros(length(n_runs), 1);
        thrust = zeros(length(n_runs), 1);
        torque = zeros(length(n_runs), 1);
        
        mean_tow_speed = zeros(length(n_runs), 1);
        std_tow_speed = zeros(length(n_runs), 1);
        
        mean_TSR = zeros(length(n_runs), 1);
        std_TSR_per_rev = zeros(length(n_runs), 1);
        
        mean_CP = zeros(length(n_runs), 1);
        std_CP_per_rev = zeros(length(n_runs), 1);
        
        mean_CT = zeros(length(n_runs), 1);
        std_CT_per_rev = zeros(length(n_runs), 1);
        
        mean_CQ = zeros(length(n_runs), 1);
        std_CQ_per_rev = zeros(length(n_runs), 1);
        
        mean_CMx = zeros(length(n_runs), 1);
        std_CMx_per_rev = zeros(length(n_runs), 1);
        
        mean_CMy = zeros(length(n_runs), 1);
        std_CMy_per_rev = zeros(length(n_runs), 1);
        
        std_omega_per_rev = zeros(length(n_runs), 1);
        
        TSR_p = zeros(length(n_runs), 1);
        CP_p = zeros(length(n_runs), 1);
        CT_p = zeros(length(n_runs), 1);
        U_inf_p = zeros(length(n_runs), 1);
        Re_c_p = zeros(length(n_runs), 1);
        
        sys_unc_CP = zeros(length(n_runs), 1);
        unc_CP = zeros(length(n_runs), 1);
        exp_unc_CP = zeros(length(n_runs), 1);
        
        sys_unc_CT = zeros(length(n_runs), 1);
        unc_CT = zeros(length(n_runs), 1);
        exp_unc_CT = zeros(length(n_runs), 1);
        
        sys_unc_CQ = zeros(length(n_runs), 1);
        unc_CQ = zeros(length(n_runs), 1);
        exp_unc_CQ = zeros(length(n_runs), 1);
        
        sys_unc_CMx = zeros(length(n_runs), 1);
        unc_CMx = zeros(length(n_runs), 1);
        exp_unc_CMx = zeros(length(n_runs), 1);
        
        sys_unc_CMy = zeros(length(n_runs), 1);
        unc_CMy = zeros(length(n_runs), 1);
        exp_unc_CMy = zeros(length(n_runs), 1);
        
        DOF_TSR = zeros(length(n_runs), 1);
        DOF_CP = zeros(length(n_runs), 1);
        DOF_CT = zeros(length(n_runs), 1);
        DOF_CQ = zeros(length(n_runs), 1);
        DOF_CMx = zeros(length(n_runs), 1);
        DOF_CMy = zeros(length(n_runs), 1);
        
        for i = 0 : n_runs - 1
            j = i + 1;
            % read acsdata.h5 into struct()
            [acs_info, acs_data] = read_h5([fullfile(data_dir, ...
            '\Data\Raw\' + test_name + '\' + string(i) + '\acsdata.h5')]);
            % read nidata.h5 into struct()
            [ni_info, ni_data] = read_h5([fullfile(data_dir, ...
            '\Data\Raw\' + test_name + '\' + string(i) + '\nidata.h5')]);
    
            % % save raw data into struct()
            % acs_raw.('run_' + string(i)) = acs_data;
            % ni_raw.('run_' + string(i)) = ni_data;
            
            meta_path = [fullfile(data_dir, ...
            '\Data\Raw\' + test_name + '\' + string(i) + '\metadata.json')];
            
            [inst_perf, n_revs, ~, rho, nu] = ...
                get_inst_perf(acs_info, acs_data, ni_info, ni_data, ...
                meta_path, data_dir);
    
            rev_mean = get_rev_mean(rho, nu, n_revs, inst_perf);

            perf_unc = calc_perf_uncertainty(rev_mean);
            
            processed_path = fullfile(data_dir, ...
                '\Data\Processed\' + test_name);
            
            if ~isfolder((fullfile(processed_path)))
                mkdir(fullfile(processed_path))
            end

            run(j, 1) = i;
            tow_speed_nom(j, 1) = round(rev_mean.m_U_inf, 1);
            TSR_nom(j, 1) = round(rev_mean.m_TSR, 1);
            num_revs(j, 1) = n_revs;
            water_dens(j, 1) = rho;

            Re_c(j, 1) = rev_mean.m_Re_c;
            lead_lag(j, 1) = rev_mean.m_edgewise;
            flapwise(j, 1) = rev_mean.m_flapwise;
            thrust(j, 1) = rev_mean.m_thrust;
            torque(j, 1) = rev_mean.m_torque;

            mean_tow_speed(j, 1) = rev_mean.m_U_inf;
            std_tow_speed(j, 1) = rev_mean.stddev_U_inf;

            mean_TSR(j, 1) = rev_mean.m_TSR;
            std_TSR_per_rev (j, 1)= rev_mean.stddev_TSR;

            mean_CP(j, 1) = rev_mean.m_C_P;
            std_CP_per_rev(j, 1) = rev_mean.stddev_C_P;

            mean_CT(j, 1) = rev_mean.m_C_T;
            std_CT_per_rev(j, 1) = rev_mean.stddev_C_T;

            mean_CQ(j, 1) = rev_mean.m_C_Q;
            std_CQ_per_rev(j, 1) = rev_mean.stddev_C_Q;

            mean_CMx(j, 1) = rev_mean.m_C_Mx;
            std_CMx_per_rev(j, 1) = rev_mean.stddev_C_Mx;

            mean_CMy(j, 1) = rev_mean.m_C_My;
            std_CMy_per_rev(j, 1) = rev_mean.stddev_C_My;

            std_omega_per_rev(j, 1) = rev_mean.stddev_omega;

            TSR_p(j, 1) = rev_mean.m_TSR_p;
            CP_p(j, 1) = rev_mean.m_C_P_p;
            CT_p(j, 1) = rev_mean.m_C_T_p;
            U_inf_p(j, 1) = rev_mean.m_U_inf_p;
            Re_c_p(j, 1) = rev_mean.m_Re_c_p;
        
            sys_unc_CP(j, 1) = perf_unc.b_C_P;
            unc_CP(j, 1) = perf_unc.unc_C_P;
            exp_unc_CP(j, 1) = perf_unc.U95_C_P;
        
            sys_unc_CT(j, 1) = perf_unc.b_C_T;
            unc_CT(j, 1) = perf_unc.unc_C_T;
            exp_unc_CT(j, 1) = perf_unc.U95_C_T;
        
            sys_unc_CQ(j, 1) = perf_unc.b_C_Q;
            unc_CQ(j, 1) = perf_unc.unc_C_Q;
            exp_unc_CQ(j, 1) = perf_unc.U95_C_Q;
        
            sys_unc_CMx(j, 1) = perf_unc.b_C_Mx;
            unc_CMx(j, 1) = perf_unc.unc_C_Mx;
            exp_unc_CMx(j, 1) = perf_unc.U95_C_Mx;
        
            sys_unc_CMy(j, 1) = perf_unc.b_C_My;
            unc_CMy(j, 1) = perf_unc.unc_C_My;
            exp_unc_CMy(j, 1) = perf_unc.U95_C_My;
        
            DOF_TSR(j, 1) = perf_unc.DOF_TSR;
            DOF_CP(j, 1) = perf_unc.DOF_C_P;
            DOF_CT(j, 1) = perf_unc.DOF_C_T;
            DOF_CQ(j, 1) = perf_unc.DOF_C_Q;
            DOF_CMx(j, 1) = perf_unc.DOF_C_Mx;
            DOF_CMy(j, 1) = perf_unc.DOF_C_My;

            fprintf('Processed data for run ' + string(i) + ' saved. \n')
        end

        T = table(run, tow_speed_nom, TSR_nom, ...
            num_revs, water_dens, Re_c, lead_lag, flapwise, thrust, ...
            torque, mean_tow_speed, std_tow_speed, mean_TSR, ...
            std_TSR_per_rev, mean_CP, std_CP_per_rev, mean_CT, ...
            std_CT_per_rev, mean_CQ, std_CQ_per_rev, mean_CMx, ...
            std_CMx_per_rev, mean_CMy, std_CMy_per_rev, std_omega_per_rev, ...
            TSR_p, CP_p, CT_p, U_inf_p, Re_c_p, sys_unc_CP, unc_CP, ...
            exp_unc_CP, sys_unc_CT, unc_CT, exp_unc_CT, sys_unc_CQ, ...
            unc_CQ, exp_unc_CQ, sys_unc_CMx, unc_CMx, exp_unc_CMx, ...
            sys_unc_CMy, unc_CMy, exp_unc_CMy, DOF_TSR, DOF_CP, DOF_CT, ...
            DOF_CQ, DOF_CMx, DOF_CMy);

        writetable(T, fullfile(processed_path, '/' + test_name + '.csv'));

        fprintf('Finished processing ' + test_name + '. \n')
    end
end

   
    