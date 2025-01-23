% -------------------------------------------------------------------------
% Computes UNH tow carriage velocity using carriage position and time data
% sampled from National Instruments software/chassis. 
% 
% Input(s):
%   ni_time = time data sampled with National Instruments program/chassis
%   (triggered to begin sampling with ACS)
%   ni_pos = carriage position data from linear encoder (sampled through 
%   National Instruments)
%   acs_time = time data collected from ACS motion controller 
%
% Output(s):
%   U_inf = array of carriage velocity data calculated from the change in 
%   carriage position and time during a towing run; interpolated to have 
%   the same number of data points as the signals sampled through ACS (NI
%   samples at 100 Hz, ACS samples at 1000 Hz)
% -------------------------------------------------------------------------

function U_inf = calc_tow_speed(ni_time, ni_pos, acs_time)
    % calculate carriage velocity using carriage position and time from NI
    U_inf = diff(ni_pos) ./ diff(ni_time);

    % remove last point of time data to match size of velocity data (N - 1)
    ni_time = ni_time(1 : end - 1);
    
    % interpolate tow speed to match length of datasets from ACS NTM
    U_inf = interp1(ni_time, U_inf, acs_time);
end


