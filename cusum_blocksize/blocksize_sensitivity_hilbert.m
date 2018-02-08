% Sensitivity analysis of BlockSize for nonparametric CUSUM estimator on on
% instantaneous phase 

% Frequency band is (7, 9)
frequency = 8;
bandwidth = 1;

% Sampling rate is 250 samples per second
sampling_rate = 250;

% Signal length is T = 7000, but burn away the first and last 4 seconds 
% for a signal size of 5000 
n_samples = 7000;
burn_length = 4 * sampling_rate;

% Default SNR is 0.5, but test other values 
SNR = 0.5;

% Number of simulations for each blocksize
n_simulations = 500;

% Number of bootstrap samples for estimating critical values
n_bootstrap = 1000;

% Desired false positive rate
alpha = 0.05;

% For the default parameters - SNR = 0.5, width = 1
% The estimated block size is approximately 350 sample
% Test block sizes in this range - 250 to 450
blocksize_list = (50:90) * 5;
n_blocksizes = length(blocksize_list);

% Initialize false positives and change point locations 
false_positives = zeros(1, n_blocksizes);
estimated_shift = zeros(n_blocksizes, n_simulations);

% Initialize tau estimates
tau = zeros(n_blocksizes, n_simulations);

for i = 1:n_blocksizes
    disp(i)
    blocksize = blocksize_list(i);
    for j=1:n_simulations
        % Random phase values
        phi = rand() * 2 * pi;
        % Simulate signal with no shifts and estimate instantaneous phase
        signal = sim_one_shift(n_samples, sampling_rate, SNR, frequency, phi);
        phase = instant_phase(signal, sampling_rate, frequency, bandwidth);
        % Burn away start and end of signal
        phase = phase((burn_length + 1):(end - burn_length));
        % Test for change point and estimate tau
        [ind, h] = cusum_test(phase, blocksize, alpha, n_bootstrap);
        estimated_shift(i, j) = ind;
        false_positives(i) = false_positives(i) + h;
        tau(i, j) = estimate_tau(phase);
    end
end

save instant_blockSize tau false_positives n_simulations blocksize_list alpha n_samples SNR bandwidth burn_length estimated_shift

%{

figure()
L0 = mean(mean(tau)) * 2;

plot(blocksize_list, false_positives / n_simulations, 'b', 'linewidth', 2)
hold on
plot([0, max(blocksize_list)], [alpha, alpha], 'k--')
plot([L0, L0], [0, 1], 'r', 'linewidth', 2)


%}




% Tried a number of different scenarios, all result in 
% FP rates averaging 10% rather than 5%

% Have increased nSim and blocksize_list
% Increased T to 20+ seconds
% Tried permutation and resampling 
%     - reampling does better but not sufficient
% Tried 500 and 1000 point burn
% Tried making L = 2*tau for every signals estimated tau
% Decreasing noise
% Decreasing alpha to 0.025 got the desired 0.05 error rate
%   - Many different values of alpha all give 2(alpha)
% Making width smaller made things worse: possibly need to extend boundary?
%   - extending boundary didn't work. Maybe need to have larger L values
%   - Larger L values didn't converge down, does eventually show cyclic behaviour 
%     with a period near the block size
% Tried with random initial phi, didn't change anything
% Different frequency didn't change anything
% Added a 'back burn' to remove the end of signal boundary effect, reduced
% the FPs slightly. Now results of alpha 0.05 close 7.5%

% Conclusions:
% Frequency and initial phase do not change anything. 
% The burn can be too small, and the block_size can be too big if there are not enough points in the signal
% Need to consider the boundary at the end

    
