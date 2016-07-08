% Test phase estimation proceedures


% No phase shift, phi = 1

sampling_rate = 250;
frequency = 8;
n_samples = 1000;
SNR = 1;
phi = 1;
delta_phi = 0;
t0 = 600;
bandwidth = 1;
t = 0:(n_samples - 1);

signal = sim_one_shift(n_samples, sampling_rate, SNR, frequency, phi, delta_phi, t0);
phase = ones(1, n_samples);
f_phase = fourier_phase(signal, sampling_rate, frequency, bandwidth);

figure()
hold on
plot(t, phase, 'r', 'linewidth', 2)
plot(t, f_phase, 'g', 'linewidth', 2)
pause()

% Phase shift from 1 to 2 at t=600

delta_phi = 1;
frequency = 9;
bandwidth = 2;

signal = sim_one_shift(n_samples, sampling_rate, SNR, frequency, phi, delta_phi, t0);
phase = ones(1, n_samples);
phase(t0:end) = 2;
f_phase = fourier_phase(signal, sampling_rate, frequency, bandwidth);

figure()
hold on
plot(t, phase, 'r', 'linewidth', 2)
plot(t, unwrap(f_phase), 'g', 'linewidth', 2)
pause()

% With noise

SNR = 0.25;
frequency = 10;
bandwidth = 0.25;

signal = sim_one_shift(n_samples, sampling_rate, SNR, frequency, phi, delta_phi, t0);
phase = ones(1, n_samples);
phase(t0:end) = 2;
f_phase = fourier_phase(signal, sampling_rate, frequency, bandwidth);

figure()
hold on
plot(t, phase, 'r', 'linewidth', 2)
plot(t, unwrap(f_phase), 'g', 'linewidth', 2)
