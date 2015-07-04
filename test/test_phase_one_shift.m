% Test phase estimation proceedures


% No phase shift, phi = 1

sRate = 250;
freq = 8;
T = 1000;
SNR = 1;
phi = 1;
delta_phi = 0;
t0 = 600;
width = 1;
t = 0:(T-1);

x = sim_one_shift(T, sRate, SNR, freq, phi, delta_phi, t0);
P = ones(1, T);
iP = instant_phase(x, sRate, freq, width);
fP = fourier_phase(x, sRate, freq, width);

figure()
hold on
plot(t, P, 'r', 'linewidth', 2)
plot(t, iP, 'b', 'linewidth', 2)
plot(t, fP, 'g', 'linewidth', 2)
pause()

% Phase shift from 1 to 2 at t=600

delta_phi = 1;

x = sim_one_shift(T, sRate, SNR, freq, phi, delta_phi, t0);
P = ones(1, T);
P(t0:end) = 2;
iP = instant_phase(x, sRate, freq, width);
fP = fourier_phase(x, sRate, freq, width);

figure()
hold on
plot(t, P, 'r', 'linewidth', 2)
plot(t, iP, 'b', 'linewidth', 2)
plot(t, fP, 'g', 'linewidth', 2)
pause()

% With noise

SNR = 0.25;

x = sim_one_shift(T, sRate, SNR, freq, phi, delta_phi, t0);
P = ones(1, T);
P(t0:end) = 2;
iP = instant_phase(x, sRate, freq, width);
fP = fourier_phase(x, sRate, freq, width);

figure()
hold on
plot(t, P, 'r', 'linewidth', 2)
plot(t, iP, 'b', 'linewidth', 2)
plot(t, fP, 'g', 'linewidth', 2)
