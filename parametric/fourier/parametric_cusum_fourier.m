function [critical_value, statistic] = parametric_cusum_fourier(n_samples, sampling_rate, SNR, frequency, bandwidth, alpha, n_bootstrap, n_burn)
% Parametric bootstrap of CUSUM test statistics
% Optional n_burn parameter

if nargin < 7
    n_burn = 0;
end

n_samples = n_samples + n_burn;

statistic = zeros(1, n_bootstrap);

for boot = 1:n_bootstrap
    phi = rand() * 2 * pi;
    bootstrap_signal = sim_one_shift(n_samples, sampling_rate, SNR, frequency, phi);
    bootstrap_phase = fourier_phase(bootstrap_signal, sampling_rate, frequency, bandwidth);
    bootstrap_phase = unwrap(bootstrap_phase((n_burn + 1):(end-n_burn)));
    statistic(boot) = max(abs(weighted_cusum(bootstrap_phase)));
end

critical_value = quantile(statistic, 1 - alpha);
