% Test cusum hypothesis test on instant and fourier phase


% Phase shift from 1 to 2 at t=600

sRate = 250;
freq = 8;
T = 2000;
SNR = 1;
phi = 1;
t0 = 1100;
width = 1;
t = 0:(T-1);
delta_phi = 1;

x = sim_one_shift(T, sRate, SNR, freq, phi, delta_phi, t0);
P = ones(1, T);
P(t0:end) = 2;
iP = instant_phase(x, sRate, freq, width);
fP = fourier_phase(x, sRate, freq, width);

% Burn away the initial and ending condition
P = P(500:1499);
iP = iP(500:1499);
fP = fP(500:1499);

% Calculate CUSUM statistics
CUSUM = weighted_cusum(P);
iCUSUM = weighted_cusum(iP);
fCUSUM = weighted_cusum(fP);

% Plot the results
figure()
subplot(2, 1, 1)
plot(P, 'r', 'linewidth', 2)
hold on
plot(iP, 'b', 'linewidth', 2)
plot(fP, 'g', 'linewidth', 2)

subplot(2, 1, 2)
hold on
plot(CUSUM, 'r', 'linewidth', 2)
plot(iCUSUM, 'b', 'linewidth', 2)
plot(fCUSUM, 'g', 'linewidth', 2)

[~, m] = max(abs(CUSUM))
[~, im] = max(abs(iCUSUM))
[~, fm] = max(abs(fCUSUM))

pause()

% With noise

SNR = 0.5;

x = sim_one_shift(T, sRate, SNR, freq, phi, delta_phi, t0);
P = ones(1, T);
P(t0:end) = 2;
iP = instant_phase(x, sRate, freq, width);
fP = fourier_phase(x, sRate, freq, width);

% Burn away the initial and ending condition
P = P(500:1499);
iP = iP(500:1499);
fP = fP(500:1499);

% Calculate CUSUM statistics
CUSUM = weighted_cusum(P);
iCUSUM = weighted_cusum(iP);
fCUSUM = weighted_cusum(fP);

% Plot the results
figure()
subplot(2, 1, 1)
plot(P, 'r', 'linewidth', 2)
hold on
plot(iP, 'b', 'linewidth', 2)
plot(fP, 'g', 'linewidth', 2)

subplot(2, 1, 2)
hold on
plot(CUSUM, 'r', 'linewidth', 2)
plot(iCUSUM, 'b', 'linewidth', 2)
plot(fCUSUM, 'g', 'linewidth', 2)

[~, m] = max(abs(CUSUM))
[~, im] = max(abs(iCUSUM))
[~, fm] = max(abs(fCUSUM))

pause()


% With more noise

SNR = 0.25;

x = sim_one_shift(T, sRate, SNR, freq, phi, delta_phi, t0);
P = ones(1, T);
P(t0:end) = 2;
iP = instant_phase(x, sRate, freq, width);
fP = fourier_phase(x, sRate, freq, width);

% Burn away the initial and ending condition
P = P(500:1499);
iP = iP(500:1499);
fP = fP(500:1499);

% Calculate CUSUM statistics
CUSUM = weighted_cusum(P);
iCUSUM = weighted_cusum(iP);
fCUSUM = weighted_cusum(fP);

% Plot the results
figure()
subplot(2, 1, 1)
plot(P, 'r', 'linewidth', 2)
hold on
plot(iP, 'b', 'linewidth', 2)
plot(fP, 'g', 'linewidth', 2)

subplot(2, 1, 2)
hold on
plot(CUSUM, 'r', 'linewidth', 2)
plot(iCUSUM, 'b', 'linewidth', 2)
plot(fCUSUM, 'g', 'linewidth', 2)

[~, m] = max(abs(CUSUM))
[~, im] = max(abs(iCUSUM))
[~, fm] = max(abs(fCUSUM))
