function [critical_value, statistic] = parametric_cusum_instant_ISI(n_samples, sampling_rate, SNR, frequency, bandwidth, alpha, n_bootstrap, n_burn, shift_magnitude, ISI)
% Parametric bootstrap of CUSUM test statistics
% Optional n_burn parameter


shift_latency = n_burn + n_samples / 2;

n_samples = n_samples + n_burn;

base_critical_value = parametric_cusum_instant(n_samples, sampling_rate, SNR, frequency, bandwidth, alpha, n_bootstrap, n_burn);

statistic = zeros(2, n_bootstrap);

for boot = 1:n_bootstrap
    phi = rand() * 2 * pi;
    bootstrap_signal = sim_one_shift(n_samples, sampling_rate, SNR, frequency, phi, shift_magnitude, shift_latency);
    bootstrap_phase = instant_phase(bootstrap_signal, sampling_rate, frequency, bandwidth);
    bootstrap_phase = unwrap(bootstrap_phase((n_burn + 1):(end-n_burn)));
    [max_value, index] = max(abs(weighted_cusum(bootstrap_phase)));
    if max_value > base_critical_value
        lower_phase = bootstrap_phase(1:(index - ISI));
        upper_phase = bootstrap_phase(1:(index + ISI));
        statistic(1, boot) = max(abs(weighted_cusum(lower_phase)));
        statistic(2, boot) = max(abs(weighted_cusum(upper_phase)));
    end
end

statistic = statistic(statistic(:) > 0);
critical_value = quantile(statistic, 1 - alpha);
