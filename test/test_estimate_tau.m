% Test the acf function and the estimate tau function


% For a constant signal, the ACF should be all ones
% The value of tau should be 0 since the ACF
% never crosses 0.

T = 100;
x = ones(1,T);
a = acf(x, 5);

if all(a == 1)
    'Pass';
else
    error('Fail 1')
end

tau = estimate_tau(x);

if isnan(tau)
    'Pass';
else
    error('Fail 2')
end

% Creating an alternating series
% ACF should alternatve between +/- 1
% tau should be 0 since it crosses at lag 1

x(2:2:end) = -1;
a = acf(x, 20);

if all(a(1:2:end) > 0) && all(a(2:2:end) < 0)
    'Pass';
else
    error('Fail 3')
end

tau = estimate_tau(x);

if tau == 0
    'Pass';
else
    error('Fail 4')
end


t = 0:(T - 1);
x = sin(2 * pi * t / T);
a = acf(x, T - 1);
tau = estimate_tau(x);

figure()

plot(t/T, a, 'linewidth', 2)
title('ACF of 1Hz sine wave')
hold on
plot([tau / T, tau / T], [-1, 1], 'r', 'linewidth', 2)
plot([0, 1], [0, 0], 'k--')
hold off
pause()

x = randn(1, T);
a = acf(x, length(x) - 1);
tau = estimate_tau(x);

plot(t/T, a, 'linewidth', 2)
title('ACF of G(0, 1) noise')
hold on
plot([tau / T, tau / T], [-1, 1], 'r', 'linewidth', 2)
plot([0, 1], [0, 0], 'k--')
hold off



x1 = sin(2 * pi * 3* t / T);
x2 = sin(2 * pi * 5 * t / T);
x3 = sin(2 * pi * 7 * t / T);
x = [x1, x2, x3];

tau1 = estimate_tau(x1);
tau2 = estimate_tau(x2);
tau3 = estimate_tau(x3);
tau = mean([tau1, tau2, tau3]);

if tau == estimate_tau(x)
    error('Fail 5')
else
    'Pass';
end

if tau == estimate_tau(x, 3)
    'Pass';
else
    error('Fail 6')
end

if tau == estimate_tau(x, 6)
    'Pass';
else
    error('Fail 7')
end

if tau == estimate_tau(x, 9)
    error('Fail 8')
else
    disp('Pass')
end


