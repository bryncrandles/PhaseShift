function [ind, h]=cusum_test(phase, blocksize, alpha, n_bootstrap)
% Test the hypothesis of no change point using the CUSUM statistic
% and nonparametric block bootstrap sampling distribution. 
%
% Inputs:
%   phase: time series of phase values
%   blocksize: Size of blocks for bootstrap algorithm
%   alpha: significance level
%   n_boostrap: number of bootstrap samples used for test
% Outputs
%   ind: phase is the time series to be tested

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
