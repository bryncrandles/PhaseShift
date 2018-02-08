% Search for minimal boundary effect to omit so the desired false positive
% rate can be achieved (no shifts).

% Experimental setup

% Frequency band is (7, 9)
frequency = 8;
bandwidth = 1;

% Sampling rate is 250 samples per second
sampling_rate = 250;

% Default SNR is 0.5, but test other values 
SNR = 0.5;

% Number of simulations for each potential boundary effect
n_simulations = 5000;

% Number of bootstrap samples for estimating critical values
n_bootstrap = 1000;

% Desired false positive rate
alpha = 0.05;

% Optimial boundary value from "boundary_analysis_hilbert_cusum.m"
boundary = 150;

% Preliminary list of signal lengths to test
signal_length_values = (1:50)*50;
n_signal_length_values = length(signal_length_values);

false_positives = zeros(1, n_signal_length_values);

for i = 1:n_signal_length_values
    disp(i)
    n_samples = signal_length_values(i) + 2 * boundary;
    [critical_value, statistic] = parametric_cusum(n_samples, sampling_rate, SNR, frequency, bandwidth, alpha, n_bootstrap, 'hilbert', boundary);
    for k=1:n_simulations
        % Random phase values
        phi = rand() * 2 * pi;
        % Simulate signal with no shifts and estimate instantaneous phase
        signal = no_shifts(n_samples, sampling_rate, SNR, frequency, phi);
        phase = hilbert_phase(signal, sampling_rate, frequency, bandwidth);
        % Unwrap phase signal
        phase = unwrap(phase);
        % Burn away boundaries
        phase = phase((boundary + 1):(end - boundary));
        % Test for change point
        if max(abs(weighted_cusum(phase))) > critical_value
            false_positives(i) = false_positives(i) + 1;
        end
    end
end

% There doesn't appear to be any minimum over and above the boundary value.