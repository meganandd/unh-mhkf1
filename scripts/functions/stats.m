% -------------------------------------------------------------------------
% Computes mean, variance, and standard deviation for a given time series. 
% 
% Input(s):
%   y = time series 
% 
% Output(s):
%   mean = mean of time series, y
%   var = variance of time series, y
%   stdev = standard deviation of time series, y
% -------------------------------------------------------------------------

function [mean, var, stdev] = stats(y)
    % total number of data points
    N = length(y);
    % sum for mean
    sum = 0;
    % sum squared for variance 
    sum_sq = 0;
    % not NaNs, number 'good'
    n_g = 0;

    for n = 1 : N
        if isnan(y(n)) == false
            sum = sum + y(n);
            sum_sq = sum_sq + y(n)^2;
            n_g = n_g + 1;
        end
    end

    mean = sum / n_g;
    var = sum_sq / n_g - mean^2;
    stdev = sqrt(var);
end