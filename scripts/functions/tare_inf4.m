% -------------------------------------------------------------------------
% Saves tare values for each AFT load cell channel based on values recorded
% while the system is stationary. 
% 
% Input(s):
%   acs_data = un-trimmed and unprocessed struct() of data from ACS
%
% Output(s):
%   tare_vals = struct() of tare values for each load cell channel based on
%   values recorded at rest before the towing run begins 
% -------------------------------------------------------------------------

function tare_vals = tare_inf4(acs_data)
    % use first 2 seconds of pre-trimmed data from the INF4 to tare 
    % load cell channels
    tare_vals = struct();

    % delta_acs = round(1 / (acs_data.time(2) - acs_data.time(1)));
    
    % start tare index
    start_tare = 1;
    stop_tare = find(round(acs_data.time, 3) == 2, 1, 'first');

    if isempty(stop_tare)
        [~, stop_tare] = min(abs(round(acs_data.time, 3) - 2));
    end

    % look at first 2 seconds of data, take mean of each dataset
    ch1_tare = acs_data.load_cell_ch1(start_tare : stop_tare);
    [ch1_tare, ~, ~] = stats(ch1_tare);

    ch2_tare = acs_data.load_cell_ch2(start_tare : stop_tare);
    [ch2_tare, ~, ~] = stats(ch2_tare);

    ch3_tare = acs_data.load_cell_ch3(start_tare : stop_tare);
    [ch3_tare, ~, ~] = stats(ch3_tare);

    ch4_tare = acs_data.load_cell_ch4(start_tare : stop_tare);
    [ch4_tare, ~, ~] = stats(ch4_tare);
    
    % subtract mean from original time series
    tare_vals.ch1 = ch1_tare;
    tare_vals.ch2 = ch2_tare;
    tare_vals.ch3 = ch3_tare;
    tare_vals.ch4 = ch4_tare;
end