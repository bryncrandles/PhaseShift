

% Explore block size for simple oscillator with no phase shifts and 
% iid noise.

% Frequency band is (7, 9)

T = 2000;
sRate = 250;
SNR = 0.5;
freq = 8;
width = 1;
phi = 0;
delta_phi = pi / 2;
t0 = 3000;

nSim = 100;
nBoot = 1000;
alpha = 0.05;

nK = sRate / 5;
count = zeros(1, nK);

% I need to finish exploring the value for K before this simulation 
% can be completed.

for i = 1:nK
    ISI = 5 * i;
    for j=1:nSim
        % Simulate signal with one shift and estimate instantaneous phase
        x = sim_one_shift(T, sRate, SNR, freq, phi, delta_phi, t0);
        P = instant_phase(x, sRate, freq, width);
        % Burn away first 4 seconds
        P = P(1001:end);
        [ind, h] = cusum_test(P, K, alpha, nBoot);
        if h == 1
            count(i) = count(i) + 1;
            [ind_lower, h_lower] = cusum_test(P(1:(ind - K)), K, alpha, 
            
    
    