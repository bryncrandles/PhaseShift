function [phase, magnitude] = instant_phase(signal, sampling_rate, frequency, delta)
% Estimate the instantaneous phase and magnitude of a time series using
% complex demodulation algorithm.
% Inputs:
%       signal (vector(float)): observed time series
%       sampling_rate (int): Temporal scale of time series in
%           samples-per-second
%       frequency (float): Frequency of the oscillator of interest
%       delta (float): Cutoff of lowpass filter
%
% Outputs:
%       phase (vector(float)): time series of instantaneous phase values
%       magnitude (vector(float)): time series of instantaneous magnitude
%           values

% Note: instantaneous phase is not unwrapped, and no initial period is
% "burned" away. 

% Note: Filter is implemented as a fourth order butterworth filter.

n_samples = length(signal);
t = 0:(n_samples - 1);

[b, a] = butter(4, 2 * delta / sampling_rate, 'low');

inphase = signal .* sin(2 * pi * frequency / sampling_rate * t);
quadrature = signal .* cos(2 * pi * frequency / sampling_rate * t);

inphase = filtfilt(b, a, inphase);        
quadrature = filtfilt(b, a, quadrature);    

phase = atan2(quadrature, inphase);
magnitude = sqrt(inphase .^ 2 + quadrature .^ 2);

