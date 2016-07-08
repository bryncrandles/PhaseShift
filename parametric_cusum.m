function [critical_value, statistic] = parametric_cusum(n_samples, sampling_rate, SNR, frequency, alpha, n_bootstrap, n_burn)
% Parametric bootstrap of CUSUM test statistics
% Optional n_burn parameter

if nargin < 7
    n_burn = 0;
end

n_samples = n_samples + n_burn;

statistic = zeros(1, n_bootstrap);

for boot = 1:n_bootstrap
    phi = rand() * 2 * pi;
    bootstrap_phase = sim_one_shift(n_samples, sampling_rate, SNR, frequency, phi);
    bootstrap_phase = bootstrap_phase((n_burn + 1):end);
    statistic(boot) = max(abs(weighted_cusum(bootstrap_phase)));
end

critical_value = quantile(statistic, 1 - alpha);
