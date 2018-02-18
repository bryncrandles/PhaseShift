function [critical_value, critical_value_lower, critical_value_upper] = parametric_pdd2(n_samples, sampling_rate, SNR, frequency, bandwidth, alpha, n_bootstrap, phase_type, boundary, shift_magnitude, shift_latency, latency_tolerance)
% Parametric bootstrap procedure to estimating the critical values for the
% upper and lower halves of a signal after the discovery of an initial
% phase shift event with specific magnitude and latency (i.e., recursive 
% application).
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
%   shift_magnitude (float(0,pi)): difference in phase after change-point
%   shift_latency (int): index when the phase shift occurs 
%
% Outputs:
%   critical_value (float): the 1-alpha quantile from the bootstrap data.
%       Used to identify the initial change-point.
%   critical_value_lower (float): the 1-alpha quantile from bootstrap data
%       of the lower half of the signal after initial shift is identified.
%   critical_value_upper (float): the 1-alpha quantile from bootstrap data
%       of the upper half of teh signal after initial shift is identified.

if phase_type == 'hilbert'
    get_phase = @hilbert_phase;
elseif phase_type == 'fourier'
    get_phase = @fourier_phase;
end

critical_value = parametric_pdd(n_samples, sampling_rate, SNR, frequency, bandwidth, alpha, n_bootstrap, phase_type, boundary);

statistics_lower = zeros(1, n_bootstrap);
statistics_upper = zeros(1, n_bootstrap);

count_bootstraps = 0;

% Simple minded approach to breaking the while loop incase of problems
count_fails = 0;
max_fails = 1000;

while count_bootstraps < n_bootstrap && count_fails < max_fails
    phi = rand() * 2 * pi;
    bootstrap_signal = sim_one_shift(n_samples, sampling_rate, SNR, frequency, phi, shift_magnitude, shift_latency);
    bootstrap_phase = get_phase(bootstrap_signal, sampling_rate, frequency, bandwidth);
    bootstrap_phase = unwrap(bootstrap_phase);
    bootstrap_phase = bootstrap_phase((boundary + 1):(end - boundary));
    [max_value, estimated_latency] = max(abs(pd(bootstrap_phase)));
    if max_value > critical_value && abs(boundary + estimated_latency - shift_latency) < latency_tolerance
        count_bootstraps = count_bootstraps + 1;
        lower_phase = bootstrap_phase(1:(estimated_latency - boundary));
        statistics_lower(count_bootstraps) = max(abs(pd(lower_phase)));
        upper_phase = bootstrap_phase((estimated_latency + 1 + boundary):end);
        statistics_upper(count_bootstraps) = max(abs(pd(upper_phase)));
    else
        count_fails = count_fails + 1;
    end
end

if count_fails >= max_fails
    
else
    critical_value_lower = quantile(statistics_lower, 1 - alpha);
    critical_value_upper = quantile(statistics_upper, 1 - alpha);
end
