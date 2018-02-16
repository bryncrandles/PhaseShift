function signal = sim_one_shift(n_samples, sampling_rate, SNR, frequency, phase, shift_magnitude, shift_latency)
% Simulate observations from a noisy oscillator with phase shift event.
% Noise is i.i.d normally distributed. 
% Inputs:
%   n_samples (int) - The number of samples in the signal
%   sampling_rate (int) - Sampling rate of the observations
%   SNR (float) - Signal-to-noise ratio
%   frequency (float) - Frequency of the oscillator
%   phase (float) - Initial phase of the oscillator
%   shift_magnitude (float) - Change in phase due to phase shift 
%   shift_latency (int) - Sample index at which the shift occurs
%
% Outputs:
%   signal (array(float)) - The simulated time series


% If no shift information is provided, then defaults to no shifts. 
if nargin < 5
    error('Not enough parameters')
elseif nargin < 7
    shift_magnitude = 0;
    shift_latency = 0;
end

% Simulate oscillator with constant phase
t = 0:(n_samples - 1);
signal = sin(frequency * 2 * pi * t / sampling_rate + phase);

% Apply phase shift
if shift_latency > 0
    signal(shift_latency:end) = sin(frequency * 2 * pi * t(shift_latency:end) / sampling_rate + (phase + shift_magnitude));
end

% Random Gaussian noise
epsilon = randn(1,n_samples);

% Normalize signal and noise
signal = signal ./ norm(signal);
epsilon = epsilon ./ norm(epsilon);

% Combine signal and noise at the desired ratio
signal = SNR .* signal + (1 - SNR) .* epsilon;
