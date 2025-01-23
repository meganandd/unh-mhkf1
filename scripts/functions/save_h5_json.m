% read *.json and *.h5 files and save as *.mat files
% data_dir - full file path to the folder of interest in the 'Raw' folder
% saved - use "1" to save files with data in specified path

function [acs_data, ni_data] = save_h5_json(data_dir, test_plan, saved)
raw_data_dir = fullfile(data_dir, '\Data\Raw\' + string(test_plan) + '\');

if ~isfolder(data_dir)
    error_message = sprintf(['Error: The following folder does not ' ...
        'exist:\n%s\nPlease specify a new folder.'], data_dir);
    uiwait(warndlg(error_message)); 
    data_dir = uigetdir();save
    
    if data_dir == 0
        fprintf('Folder selection cancelled. \n')
        return
    end
end

n_runs = length(dir(raw_data_dir)) - 3;

for i = 0 : n_runs
    % h5 files
    path_acs_h5 = fullfile(raw_data_dir, string(i) + '\acsdata.h5');
    acs_file = dir(path_acs_h5);
    
    % make path 'char' type, necessary for saving files to correct folder
    full_path_acs = fullfile(acs_file.folder, acs_file.name);

    path_ni_h5 = fullfile(raw_data_dir, string(i) + '\nidata.h5');
    ni_file = dir(path_ni_h5);

    full_path_ni = fullfile(ni_file.folder, ni_file.name);

    % read/extract information from h5 files
    acs_info = h5info(path_acs_h5);
    ni_info = h5info(path_ni_h5);

    for k = 1 : length(acs_info.Groups.Datasets)
        group_name = acs_info.Groups.Name;
        dataset_name = acs_info.Groups.Datasets(k, 1).Name;
        acs_data.(dataset_name) = h5read(path_acs_h5, ...
            [group_name, '/', dataset_name]);
    end

    for k = 1 : length(ni_info.Groups.Datasets)
        group_name = ni_info.Groups.Name;
        dataset_name = ni_info.Groups.Datasets(k, 1).Name;
        ni_data.(dataset_name) = h5read(path_ni_h5, ...
            [group_name, '/', dataset_name]);
    end

    % JSON files
    run_path_json = fullfile(raw_data_dir, string(i) + '\metadata.json');
    run_file_json = dir(run_path_json);

    % read/extract metadata from JSON file
    file_name_json = run_file_json.name;
    full_path_json = fullfile(run_file_json.folder, file_name_json); 

    % fprintf(1, 'Now reading %s\n', run_path_json);

    [json_file] = fopen(full_path_json);
    raw_json = fread(json_file, inf); 
    json_string = char(raw_json');
    fclose(json_file);

    metadata = jsondecode(json_string);

    % saves *.json and *.mat files if specified
    if saved == 1
        if ~isfile(fullfile(raw_data_dir, string(i) + '\*.mat'))
            save([full_path_acs(1 : end - 3), '.mat'], 'acs_data')
            save([full_path_ni(1 : end - 3), '.mat'], 'ni_data')
            save([full_path_json(1 : end - 5),'.mat'], 'metadata')
            fprintf('*.json and *.mat files from run ' + string(i) + ...
                ' saved. \n')
        end
    else
        fprintf('No files saved. \n')
    end
end
end