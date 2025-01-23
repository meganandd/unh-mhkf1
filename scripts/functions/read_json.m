function [tow_speed, tsr] = read_json(file_name)
    [json_file] = fopen(file_name);
    raw_json = fread(json_file, inf); 
    json_string = char(raw_json');
    fclose(json_file);

    meta = jsondecode(json_string);

    tow_speed = meta.TowSpeed_m_s_;
    tsr = meta.TipSpeedRatio;
    % tsr = str2double(tsr);
end