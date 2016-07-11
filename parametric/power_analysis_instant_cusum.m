% Theoreitical analysis of the power of shift identification methods 
% Use many different SNRs and Shift magnitude values


% Frequency band is (7, 9)
frequency = 8;
bandwidth = 1;

% Sampling rate is 250 samples per second
sampling_rate = 250;

% Number of samples
signal_length = 3000;
n_burn = 150;
n_samples = signal_length + 2 * n_burn;
shift_latency = n_burn + signal_length / 2;

% Number of simulations for each blocksize
n_simulations = 10;

% Number of bootstrap samples for estimating critical values
n_bootstrap = 5000;

% Significance level
alpha = 0.05;

% List of noise levels to be considered
dB = (-10:10)/2;
SNR_list = 10.^(dB./10) ./ (1+10.^(dB./10));
n_SNR = length(SNR_list);

% List of shift magnitudes to be considered
shift_list = (1:21) ./ 21 .* pi;
n_shift = length(shift_list);

% Initialize results
true_positive = zeros(n_SNR, n_shift, n_bootstrap);
estimated_latency = zeros(n_SNR, n_shift, n_bootstrap);

for i = 1:n_SNR
    SNR = SNR_list(i)
    critical_value = parametric_cusum_instant(n_samples, sampling_rate, SNR, frequency, bandwidth, alpha, n_bootstrap, n_burn);
    for j = 1:n_shift
        shift_magnitude = shift_list(j);
        for k = 1:n_simulations
            phi = rand() * 2 * pi;
            % Simulate signal with single phase shift event 
            signal = sim_one_shift(signal_length, sampling_rate, SNR, frequency, phi, shift_magnitude, shift_latency);
            % Estimate fourier phase
            phase = instant_phase(signal, sampling_rate, frequency, bandwidth);
            phase = phase((1+n_burn):(end - n_burn));
            [max_value, index] = max(abs(weighted_cusum(phase)));
            if max_value > critical_value
                true_positive(i, j, k) = 1;
                estimated_latency(i, j, k) = index;
            end
        end
    end   
end

save power_anlaysis_instant_cusum frequency bandwidth SNR_list shift_list true_positive estimated_latency n_simulations
