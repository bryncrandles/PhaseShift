% Sensitivity analysis of BlockSize for nonparametric CUSUM estimator on on
% fourier moving window phase 

% Frequency band is (7, 9)
frequency = 8;
bandwidth = 1;

% Sampling rate is 250 samples per second
sampling_rate = 250;

% Signal length is T = 7000, but burn away the first and last 4 seconds 
% for a signal size of 5000 
signal_length = 7000;
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
        signal = sim_one_shift(signal_length, sampling_rate, SNR, frequency, phi);
        phase = fourier_phase(signal, sampling_rate, frequency, bandwidth);
        phase = phase((burn_length + 1):(end - burn_length));
        [ind, h] = cusum_test(phase, blocksize, alpha, n_bootstrap);
        false_positives(i) = false_positives(i) + h;
        tau(i, j) = estimate_tau(phase);
    end
end

save fourier_cusum_blocksize tau false_positives n_simulations blocksize_list n_samples bandwidth SNR alpha


%{

figure()

L0 = mean(tau) * 2;

plot(list_L, count / nSim, 'b', 'linewidth', 2)
hold on
plot([0, max(list_L)], [0.05, 0.05], 'k--')
plot([L0, L0], [0, 1], 'r', 'linewidth', 2)

%}

% Similar results to the instant version. 
% The Tau values are typically smaller due to the high frequency components in
% the signal.




    
