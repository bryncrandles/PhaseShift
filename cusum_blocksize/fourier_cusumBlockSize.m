

% Explore ISI for simple oscillator with single phase shift and 
% iid noise.

% Frequency band is (7, 9)

T = 3000;
sRate = 250;
SNR = 0.5;
freq = 8;
width = 1;
phi = 0;


nSim = 250;
nBoot = 700;
alpha = 0.05;

list_L = (1:100) * 5;
nL = length(list_L);

count = zeros(1, nL);
tau = zeros(1, nL * nSim);

for i = 40:50
    disp(i)
    L = list_L(i);
    for j=1:nSim
        % Simulate signal with one shift and estimate instantaneous phase
        x = sim_one_shift(T, sRate, SNR, freq, phi);
        P = fourier_phase(x, sRate, freq, width);
        % Burn 
        Window = round(sRate/(2*width));
        if mod(Window, 2) == 0
            Burn = Window / 2;
        else
            Burn = (Window - 1) / 2;
        end
        P = P((Burn + 1):(end - Burn));
        [ind, h] = cusum_test(P, L, alpha, nBoot);
        count(i) = count(i) + h;
        tau((i - 1) * nSim + j) = estimate_tau(P);
    end
end

figure()

count = count / nSim;
L0 = mean(tau) * 2;

plot(list_L, count, 'b', 'linewidth', 2)
hold on
plot([0, max(list_L)], [0.05, 0.05], 'k--')
plot([L0, L0], [0, 1], 'r', 'linewidth', 2)


    
