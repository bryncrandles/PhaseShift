function [critical_value_upper, statistics_upper] = parametric_cusum3(n_samples, sampling_rate, SNR, frequency, bandwidth, alpha, n_bootstrap, phase_type, boundary, shift_magnitude, shift_latency, upper_boundary, latency_tolerance)

% Function to estimate the "upper" critical value of phase signal after a
% change point with a variable boundary using parametric bootstrapping 

% Adapted from "parametric_cusum" and "parametric_cusum2"

% INPUTS
%   n_samples (integer) : number of samples in simulated signal
%   sampling_rate (integer) : sampling rate of oscillator
%   SNR (float(0, 1)) : signal to noise ratio of simulated signal
%   frequency (float(0, sampling_rate/2)) : frequency of simulated oscillator
%   bandwidth (float): frequency band used in hilbert/fourier phase
%       calculation
%   alpha (float(0, 1)) : desired false positive rate
%   n_bootstrap (integer) : number of bootstrap datasets used for estimation
%   phase_type ('hilbert' or 'fourier') : type of instantaneous phase used
%   boundary (int) : number of data points to omit from each boundary for
%                   whole signal 
%   shift_magnitude (float(0,pi)) : difference in phase after change-point
%   shift_latency (integer) : index when the phase shift occurs 
%   upper_boundary (integer) :  number of data points to omit after the change-point 
%   latency_tolerance (integer) : tolerance of difference between true and
%                                   estimated change points

% OUTPUTS
%   critical_value_upper (float) : critical value of the upper phase signal
%                                  after the change point
%   statistics_upper (vector (float)) : statistics of the sampling
%                                       distribution of the upper phase

% FUNCTION

if phase_type == 'hilbert'
    get_phase = @hilbert_phase;
elseif phase_type == 'fourier'
    get_phase = @fourier_phase;
end

% critical value
critical_value = parametric_cusum(n_samples, sampling_rate, SNR, frequency, bandwidth, alpha, n_bootstrap, phase_type, boundary);

% initialize vector to store statistics for upper sampling distribution
statistics_upper = zeros(1, n_bootstrap);

% Simple minded approach to breaking the while loop incase of problems
count_bootstraps = 0;
count_fails = 0;
max_fails = 1000;

while count_bootstraps < n_bootstrap && count_fails < max_fails
    phi = rand() * 2 * pi;
    bootstrap_signal = sim_one_shift(n_samples, sampling_rate, SNR, frequency, phi, shift_magnitude, shift_latency);
    bootstrap_phase = get_phase(bootstrap_signal, sampling_rate, frequency, bandwidth);
    bootstrap_phase = unwrap(bootstrap_phase);
    bootstrap_phase = bootstrap_phase((boundary + 1):(end - boundary));
    [max_value, estimated_latency] = max(abs(weighted_cusum(bootstrap_phase)));
    if max_value > critical_value && abs(boundary + estimated_latency - shift_latency) < latency_tolerance
       count_bootstraps = count_bootstraps + 1;
       upper_phase = bootstrap_phase((estimated_latency + 1 + upper_boundary):end);
       statistics_upper(count_bootstraps) = max(abs(weighted_cusum(upper_phase)));
    else
       count_fails = count_fails + 1;
    end 
end

if count_fails >= max_fails
    critical_value_upper = Inf;
else
    critical_value_upper = quantile(statistics_upper, 1 - alpha);
end

end