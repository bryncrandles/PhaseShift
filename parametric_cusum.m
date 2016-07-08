function [critical_value, statistic] = parametric_cusum(n_samples, sampling_rate, SNR, frequency, alpha, n_bootstrap)
% Parametric bootstrap of CUSUM test statistics
% NOTE: Should I be burning the boundaries away here?

statistic = zeros(1, n_bootstrap);

for boot = 1:n_bootstrap
    phi = rand() * 2 * pi;
    bootstrap_phase = sim_one_shift(n_samples, sampling_rate, SNR, frequency, phi);
    statistic(boot) = max(abs(weighted_cusum(bootstrap_phase)));
end

critical_value = quantile(statistic, 1 - alpha);
