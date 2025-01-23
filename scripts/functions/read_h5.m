% read *.h5 files and save as a struct
% file_name - full file path to the *.h5 data
% save - use "1" to save *.mat file with data in specified filepath
function [info, data] = read_h5(file_name)

info = h5info(file_name);

% reads data and saves in a structure
for i = 1 : length(info.Groups.Datasets)
    group_name = info.Groups.Name;
    dataset_name = info.Groups.Datasets(i, 1).Name;
    data.(dataset_name) = h5read(file_name, [group_name,'/',dataset_name]);
end

end