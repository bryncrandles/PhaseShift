% Search for the minimum value of n_samples such that the desired 
% false positive rate can be achieved. at which the power to identify shifts
% plateaus. 

% Frequency band is (7, 9)
frequency = 8;
bandwidth = 1;

% Sampling rate is 250 samples per second
sampling_rate = 250;

% Default SNR is 0.5, but test other values 
SNR = 0.5;

% Number of simulations for each blocksize
n_simulations = 1000;

% Number of bootstrap samples for estimating critical values
n_bootstrap = 5000;

% Desired power
power = 0.9;
alpha = 0.05;

% Optimial burn value from burn_analysis_instant.m
n_burn = 150;

% For the default parameters - SNR = 0.5, width = 1

sample_list = (1:50)*50;
n_sample_parameters = length(sample_list);

false_positives = zeros(1, n_sample_parameters);

for i = 1:n_sample_parameters
    disp(i)
    n_samples = sample_list(i);
    signal_length = n_samples + 2 * n_burn;
    [critical_value] = parametric_cusum_instant(signal_length, sampling_rate, SNR, frequency, bandwidth, alpha, n_bootstrap, n_burn);    
    for j=1:n_simulations
        % Random phase values
        phi = rand() * 2 * pi;
        % Simulate signal with no shifts and estimate instantaneous phase
        signal = sim_one_shift(signal_length, sampling_rate, SNR, frequency, phi);
        phase = instant_phase(signal, sampling_rate, frequency, bandwidth);
        % Burn away start and end of signal
        phase = unwrap(phase((n_burn + 1):(end - n_burn)));
        % Test for change point and estimate tau
        if max(abs(weighted_cusum(phase))) > critical_value
            false_positives(i) = false_positives(i) + 1;
        end
    end
end



save instant_minSize false_positives n_simulations sample_list alpha n_burn SNR frequency bandwidth 

% There doesn't appear to be any minimum over and above the burn