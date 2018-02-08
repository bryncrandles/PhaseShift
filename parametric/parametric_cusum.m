function [critical_value, statistics] = parametric_cusum(n_samples, sampling_rate, SNR, frequency, bandwidth, alpha, n_bootstrap, phase_type, boundary)
% Parametric bootstrap procedure to estimating the critical value to use
% for change-point detection via CUSUM statistic.
% 
% Inputs:
%   n_samples (int): the number of observed samples in the time series
%   sampling_rate (int): the sampling rate of the observations
%   SNR (float(0, 1)): signal-to-noise ratio in the data (i.i.d gaussian noise)
%   frequency (float(0, sampling_rate/2)): frequency of the oscillator 
%   bandwidth (float): frequency band used in hilbert/fourier phase
%       calculation
%   alpha (float(0, 1)): desired false positive rate
%   n_bootstrap (int): number of bootstrap datasets used for estimation
%   phase_type ('hilbert', 'fourier'): type of instantaneous phase used
%   boundary (int): number of data points to omit from each boundary
%
% Outputs:
%   critical_value (float): the 1-alpha quantile from the bootstrap data.
%       Reject the hypothesis if observed value statistic is greater than
%       critical value.
%
%   statistics (array(float)): the value of the statistics for each
%       bootstrap sample


if phase_type == 'hilbert'
    get_phase = @hilbert_phase;
elseif phase_type == 'fourier'
    get_phase = @fourier_phase;
end

statistics = zeros(1, n_bootstrap);

for boot = 1:n_bootstrap
    phi = rand() * 2 * pi;
    bootstrap_signal = sim_one_shift(n_samples, sampling_rate, SNR, frequency, phi);
    bootstrap_phase = get_phase(bootstrap_signal, sampling_rate, frequency, bandwidth);
    bootstrap_phase = unwrap(bootstrap_phase((boundary + 1):(end-boundary)));
    statistics(boot) = max(abs(weighted_cusum(bootstrap_phase)));
end

critical_value = quantile(statistics, 1 - alpha);
