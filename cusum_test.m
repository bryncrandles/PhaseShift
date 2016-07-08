function [ind, h]=cusum_test(phase, blocksize, alpha, n_bootstrap)



% P is the time series to be tested

phase = unwrap(phase);

critical_value = nonparametric_cusum(phase, blocksize, alpha, n_bootstrap);

statistic = weighted_cusum(phase);

if max(abs(statistic)) > critical_value
    [~, ind] = max(abs(statistic));
    h = 1;
else
    ind = 0;
    h = 0;   
end
