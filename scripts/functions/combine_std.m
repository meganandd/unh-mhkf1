function tot_std = combine_std(n, mean, std)
    tot_mean = sum(n .* mean) / sum(n);
    tot_var = sum(n .* (std.^2 + mean.^2)) / sum(n) - tot_mean^2;

    tot_std = sqrt(tot_var);
end