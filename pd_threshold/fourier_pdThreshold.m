

% Explore ISI for simple oscillator with single phase shift and 
% iid noise.

% Frequency band is (7, 9)

T = 5000;

sRate = 250;
SNR = 0.25;
freq = 8;
width = 0.5;
phi = 0;

nSim = 500;
alpha = 0.05;

list_M = (1:100) * 5;
nM = length(list_M);

count = zeros(1, nM);
tau = zeros(1, nM * nSim);

for i = 1:nM
    disp(i)
    M = list_M(i);
    for j=1:nSim
        % Simulate signal with one shift and estimate instantaneous phase
        x = sim_one_shift(T, sRate, SNR, freq, phi);
        P = fourier_phase(x, sRate, freq, width);
        Window = round(sRate/(2*width));
        if mod(Window, 2) == 0
            Burn = Window / 2;
        else
            Burn = (Window - 1) / 2;
        end
        P = P((Burn + 1):(end - Burn));
        [ind, h] = pd_test(P, M, alpha);
        count(i) = count(i) + h;
        tau((i - 1) * nSim + j) = estimate_tau(P);
    end
end

figure()

L0 = 2 * length(P) / mean(tau);

plot(list_M, count / nSim, 'b', 'linewidth', 2)
hold on
plot([0, max(list_M)], [0.05, 0.05], 'k--')
plot([L0, L0], [0, 1], 'r', 'linewidth', 2)

% Tried a number of different scenarios, all result in 
% FP rates averaging 10% rather than 5%

% Have increased nSim and list_L
% Increased T to 20+ seconds
% Tried permutation and resampling 
%     - reampling does better but not sufficient
% Tried 500 and 1000 point burn
% Tried making L = 2*tau for every signals estimated tau
% Decreasing noise

% To still try:
% make Width smaller
% Different initial phi
% Different frequency?
% Different alpha

    
