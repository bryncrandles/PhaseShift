function phase = fourier_phase(signal, sampling_rate, frequency, bandwidth)
% Fourier_Moving: Calculate a time series of amplitude and phase value
%   Each value is calculated from a moving window centred at t. 
%   I am specifically interested in a band centred at w, of width 2 * dw

n_samples = length(signal);

window_size = round(sampling_rate / (2 * bandwidth));

if mod(window_size, 2) == 0
    half_window_size = window_size / 2;
else
    half_window_size = (window_size - 1) / 2;
end

lower_boundary = half_window_size + 1;
upper_boundary = n_samples - half_window_size;

phase = zeros(1, n_samples);

% Need to adjust this to be the correct band
m = 0:((window_size - 1) / 2);
[~, ind] = min(abs(2 * bandwidth * m - frequency));

for t=lower_boundary:upper_boundary
    window_signal = signal((t - half_window_size):(t + half_window_size));
    window_spectrum = fft(window_signal);
    phase(t) = angle(window_spectrum(ind));
end

t = 0:(n_samples - 1);

phase = unwrap(phase);
phase = mod(phase - 2 * pi * 8 * (t-half_window_size) / sampling_rate + pi / 2, 2 * pi);
phase(1:half_window_size) = 0;
phase((end-half_window_size):end) = 0;


