% -------------------------------------------------------------------------
% Calculates the mean and variance of a time series within n standard
% deviations n amount of times 
%
% Input(s): 
%   ts = time series
%   n_stdev = number of standard deviations from the mean
%   n_times = number of times to filter data 
%
% Output(s): 
%   ts_new = filtered time series (includes NaNs)
%   mean = filtered mean
%   var = filtered variance 
%   n_good = number of 'good' points (not NaNs)
% -------------------------------------------------------------------------

function [ts, mean, var, n_good] = stdev_n(ts, n_stdev, n_times)
    N = length(ts);
    sum = 0;
    sum_sq = 0;
    n_good = 0;
    
    % calculate inital mean, var, and stdev ignoring NaNs in the data
    for n = 1 : N
        if isnan(ts(n)) == false
            sum = sum + ts(n);
            sum_sq = sum_sq + ts(n)^2;
            n_good = n_good + 1;
        end
    end
    % initial stats for use in the filtering loop below
    mean = sum / n_good;
    var = sum_sq / n_good - mean^2;
    stdev = sqrt(var);
    
    % loop to filter dataset n times 
    for k = 1 : n_times
        sum = 0;
        sum_sq = 0;
        n_good = 0;

        for n = 1 : N
            % if time series value - mean > n times the standard deviation,
            % replace that value with NaNs
            if abs(ts(n) - mean) > n_stdev*stdev
                ts(n) = NaN;
            elseif isnan(ts(n)) == false
                % recalulating values to compute stats excluding NaNs
                sum = sum + ts(n);
                sum_sq = sum_sq + ts(n)^2;
                n_good = n_good + 1;
            end
        end

        % new stats post-filtering 
        mean = sum / n_good;
        var = sum_sq / n_good - mean^2;
        stdev = sqrt(var);
    end
end