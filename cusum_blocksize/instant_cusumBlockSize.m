

% Explore ISI for simple oscillator with single phase shift and 
% iid noise.

% Frequency band is (7, 9)

T = 3000;
sRate = 250;
SNR = 0.5;
freq = 8;
width = 1;
phi = 0;
method = 'resample';

nSim = 250;
nBoot = 700;
alpha = 0.05;

list_L = (1:100) * 5;
nL = length(list_L);

count = zeros(1, nL);
tau = zeros(1, nL * nSim);

for i = 1:nL
    disp(i)
    L = list_L(i);
    for j=1:nSim
        % Simulate signal with one shift and estimate instantaneous phase
        x = sim_one_shift(T, sRate, SNR, freq, phi);
        P = instant_phase(x, sRate, freq, width);
        % Burn away first 4 seconds
        P = P((2 * sRate):end);
        [ind, h] = cusum_test(P, L, alpha, nBoot, method);
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

% Tried a number of different scenarios, all result in 
% FP rates averaging 10% rather than 5%

% Have increased nSim and list_L
% Increased T to 20+ seconds
% Tried permutation and resampling 
%     - reampling does better but not sufficient
% Tried 500 and 1000 point burn
% Tried making L = 2*tau for every signals estimated tau

% To still try:
% make Width smaller
% Decrease noise
% Different initial phi
% Different frequency?
% Different alpha

    
