% Test multiple phase shift estimation


% 10 shifts, no noise, EASY

sRate = 250;
freq = 8;

SNR = 1;
nShifts = 10;
ISImin = 750;
ISIavg = 1500;
minShift = pi/8;
maxShift = pi;
sign = 1;
width = 1;


[x, phi, ~] = sim_many_shifts(sRate, SNR, freq, nShifts, ISImin, ISIavg, minShift, maxShift, sign);

T = length(x);
t = 0:(T-1);

iP = instant_phase(x, sRate, freq, width);
fP = fourier_phase(x, sRate, freq, width);

figure()
hold on
plot(t, phi, 'r', 'linewidth', 2)
plot(t, unwrap(iP), 'b', 'linewidth', 2)
plot(t, unwrap(fP), 'g', 'linewidth', 2)
pause()

% 10 shifts, no noise, HARD

sRate = 250;
freq = 8;

SNR = 1;
nShifts = 10;
ISImin = 250;
ISIavg = 1500;
minShift = pi/10;
maxShift = pi;
sign = -1;
width = 1;


[x, phi, ~] = sim_many_shifts(sRate, SNR, freq, nShifts, ISImin, ISIavg, minShift, maxShift, sign);

T = length(x);
t = 0:(T-1);

iP = instant_phase(x, sRate, freq, width);
fP = fourier_phase(x, sRate, freq, width);

figure()
hold on
plot(t, phi, 'r', 'linewidth', 2)
plot(t, unwrap(iP), 'b', 'linewidth', 2)
plot(t, unwrap(fP), 'g', 'linewidth', 2)
pause()


% 10 shifts, noise, EASY

sRate = 250;
freq = 8;
SNR = 0.5;
nShifts = 10;
ISImin = 750;
ISIavg = 1500;
minShift = pi/8;
maxShift = pi;
sign = 1;
width = 1;


[x, phi, ~] = sim_many_shifts(sRate, SNR, freq, nShifts, ISImin, ISIavg, minShift, maxShift, sign);

T = length(x);
t = 0:(T-1);

iP = instant_phase(x, sRate, freq, width);
fP = fourier_phase(x, sRate, freq, width);

figure()
hold on
plot(t, phi, 'r', 'linewidth', 2)
plot(t, unwrap(iP), 'b', 'linewidth', 2)
plot(t, unwrap(fP), 'g', 'linewidth', 2)
pause()



% 10 shifts, noise, HARD

sRate = 250;
freq = 8;

SNR = 0.5;
nShifts = 10;
ISImin = 250;
ISIavg = 1500;
minShift = pi/10;
maxShift = pi;
sign = -1;
width = 1;


[x, phi, ~] = sim_many_shifts(sRate, SNR, freq, nShifts, ISImin, ISIavg, minShift, maxShift, sign);

T = length(x);
t = 0:(T-1);

iP = instant_phase(x, sRate, freq, width);
fP = fourier_phase(x, sRate, freq, width);

figure()
hold on
plot(t, phi, 'r', 'linewidth', 2)
plot(t, unwrap(iP), 'b', 'linewidth', 2)
plot(t, unwrap(fP), 'g', 'linewidth', 2)
pause()


% 10 shifts, more noise, EASY

sRate = 250;
freq = 8;
SNR = 0.25;
nShifts = 10;
ISImin = 750;
ISIavg = 1500;
minShift = pi/8;
maxShift = pi;
sign = 1;
width = 1;


[x, phi, ~] = sim_many_shifts(sRate, SNR, freq, nShifts, ISImin, ISIavg, minShift, maxShift, sign);

T = length(x);
t = 0:(T-1);

iP = instant_phase(x, sRate, freq, width);
fP = fourier_phase(x, sRate, freq, width);

figure()
hold on
plot(t, phi, 'r', 'linewidth', 2)
plot(t, unwrap(iP), 'b', 'linewidth', 2)
plot(t, unwrap(fP), 'g', 'linewidth', 2)
pause()



% 10 shifts, more noise, HARD

sRate = 250;
freq = 8;

SNR = 0.25;
nShifts = 10;
ISImin = 250;
ISIavg = 1500;
minShift = pi/10;
maxShift = pi;
sign = -1;
width = 1;


[x, phi, ~] = sim_many_shifts(sRate, SNR, freq, nShifts, ISImin, ISIavg, minShift, maxShift, sign);

T = length(x);
t = 0:(T-1);

iP = instant_phase(x, sRate, freq, width);
fP = fourier_phase(x, sRate, freq, width);

figure()
hold on
plot(t, phi, 'r', 'linewidth', 2)
plot(t, unwrap(iP), 'b', 'linewidth', 2)
plot(t, unwrap(fP), 'g', 'linewidth', 2)
