function [critical_value, statistic] = parametric_cusum(n_samples, sampling_rate, SNR, frequency, bandwidth, alpha, n_bootstrap, phase_type, n_burn)
% Parametric bootstrap of CUSUM test statistics
% Optional n_burn parameter

if nargin < 8
    n_burn = 0;
end

if phase_type == 'hilbert'
    get_phase = @hilbert_phase;
elseif phase_type == 'fourier'
    get_phase = @fourier_phase;
end



n_samples = n_samples + n_burn;

statistic = zeros(1, n_bootstrap);

for boot = 1:n_bootstrap
    phi = rand() * 2 * pi;
    bootstrap_signal = sim_one_shift(n_samples, sampling_rate, SNR, frequency, phi);
    bootstrap_phase = get_phase(bootstrap_signal, sampling_rate, frequency, bandwidth);
    bootstrap_phase = unwrap(bootstrap_phase((n_burn + 1):(end-n_burn)));
    statistic(boot) = max(abs(weighted_cusum(bootstrap_phase)));
end

critical_value = quantile(statistic, 1 - alpha);
