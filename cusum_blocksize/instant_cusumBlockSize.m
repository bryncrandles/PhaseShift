

% Explore ISI for simple oscillator with single phase shift and 
% iid noise.

% Frequency band is (7, 9)

% T = 8500, but burn away the first 4 seconds for a signal size of 7500
T = 8500;
sRate = 250;

freq = 8;

% Test out several SNR and width parameters
SNR = 0.5;
width = 1;

phi = 0;
method = 'resample';

nSim = 250;
nBoot = 1500;
alpha = 0.05;

list_L = (1:150) * 5;
nL = length(list_L);

count = zeros(1, nL);
tau = zeros(1, nL * nSim);

for i = 25:125
    disp(i)
    L = list_L(i);
    for j=1:nSim
        % Simulate signal with one shift and estimate instantaneous phase
        x = sim_one_shift(T, sRate, SNR, freq, phi);
        P = instant_phase(x, sRate, freq, width);
        % Burn away first 4 seconds
        P = P((4 * sRate):end);
        [ind, h] = cusum_test(P, L, alpha, nBoot, method);
        count(i) = count(i) + h;
        tau((i - 1) * nSim + j) = estimate_tau(P);
    end
end

%{

figure()
L1 = mean(tau);
L2 = mean(tau) * 2;

plot(list_L, count / nSim, 'b', 'linewidth', 2)
hold on
plot([0, max(list_L)], [alpha, alpha], 'k--')
plot([L1, L1], [0, 1], 'g', 'linewidth', 2)
plot([L2, L2], [0, 1], 'r', 'linewidth', 2)

%}

save instant_cusum2_blockSize_unweighted tau count nSim list_L alpha T SNR width 

disp('Standard with Boot2')

% Tried a number of different scenarios, all result in 
% FP rates averaging 10% rather than 5%

% Have increased nSim and list_L
% Increased T to 20+ seconds
% Tried permutation and resampling 
%     - reampling does better but not sufficient
% Tried 500 and 1000 point burn
% Tried making L = 2*tau for every signals estimated tau
% Decreasing noise
% Decreasing alpha to 0.025 got the desired 0.05 error rate
%   - Many different values of alpha all give 2(alpha)
%   - Updating to use alpha / 2 for cusum test
% making width smaller made things worse: possibly need to extend boundary?
%   - extending boundary didn't work. Maybe need to have larger L values
%   - Larger L values didn't converge down, does eventually show cyclic behaviour 
%     with a period near the block size
% Tried with random initial phi, didn't change anything
% Different frequency didn't change anything

% Conclusions:
% Frequency and initial phase do not change anything. 
% The burn can be too small, and the block_size can be too big if there are not enough points in the signal


    
