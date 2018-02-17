function signal = sim_two_shifts(n_samples, sampling_rate, SNR, frequency, phi, shift_magnitude, shift_latency)
% Simulate observations from a noisy oscillator with two phase shift
% events. Noise is i.i.d normally distributed. 
% Inputs:
%   n_samples (int) - The number of samples in the signal
%   sampling_rate (int) - Sampling rate of the observations
%   SNR (float) - Signal-to-noise ratio
%   frequency (float) - Frequency of the oscillator
%   phase (float) - Initial phase of the oscillator
%   shift_magnitude (array(float)) - Two element vector of shift magnitudes 
%   shift_latency (array(int)) - Two element vector of shift latencies. 
%           The latencies should correspond to the magnitudes. E.g.,
%           shift_magnitude(1) is the magnitude of the shift at 
%           shift_latency(1). 
%
% Outputs:
%   signal (array(float)) - The simulated time series

% Ensure that the shift events appear in order. 
[~, index] = sort(shift_latency);
shift_latency = shift_latency(index);
shift_magnitude = shift_magnitude(index);

t = 0:(n_samples - 1);

signal = sin(frequency * 2 * pi * t / sampling_rate + phi);
signal(shift_latency(1):end) = sin(frequency * 2 * pi * t(shift_latency(1):end) / sampling_rate + (phi + shift_magnitude(1)));
signal(shift_latency(2):end) = sin(frequency * 2 * pi * t(shift_latency(2):end) / sampling_rate + (phi + shift_magnitude(1) + shift_magnitude(2)));
signal = signal ./ norm(signal);

epsilon = randn(1, n_samples); 
epsilon = epsilon ./ norm(epsilon);

signal = SNR .* signal + (1 - SNR) .* epsilon;
