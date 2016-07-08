function [phase, magnitude] = instant_phase(signal, sampling_rate, frequency, bandwidth)

% Estimate the instantaneous phase of a time series `signal`
% in the frequency band centred at `frequency` with size 2 * bandwidth

% phase is not unwrapped, and no initial period is "burned"

n_samples = length(signal);
t = 0:(n_samples - 1);

[b, a] = butter(4, 2 * bandwidth / sampling_rate, 'low');

inphase = x .* sin(2 * pi * frequency / sampling_rate * t);
quadrature = x .* cos(2 * pi * frequency / sampling_rate * t);

inphase = filtfilt(b, a, inphase);        
quadrature = filtfilt(b, a, quadrature);    

phase = atan2(quadrature, inphase);
magnitude = sqrt(inphase .^ 2 + quadrature .^ 2);

