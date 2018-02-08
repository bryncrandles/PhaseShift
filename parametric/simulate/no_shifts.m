function signal = no_shifts(n_samples, sampling_rate, SNR, frequency, phase)
% Parametric simulation of an oscillator with no phase shifts.
% Inputs:
%   n_samples (int): Length of time series
%   sampling_rate (int): Samples per second
%   SNR (float(0,1)): Signal-to-noise ratio (i.i.d Gaussian noise)
%   frequency (float(0, sampling_rate/2)): Frequency of oscillator
%   phase (float(0, 2pi)): Constant phase of the oscillator
%
% Outputs:
%   signal (array): simulated observed time series

% Pure oscillator
t = 0:(n_samples - 1);
signal = sin(frequency *2 * pi * t / sampling_rate + phase);

% Gaussian noise
epsilon = randn(1, n_samples); 

% Normalize signals to set SNR
signal = signal ./ norm(signal);
epsilon = epsilon ./ norm(epsilon);

signal = SNR * signal + (1 - SNR) * epsilon;
