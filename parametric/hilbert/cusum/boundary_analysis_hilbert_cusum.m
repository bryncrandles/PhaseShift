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
n_simulations = 1000;

% Number of bootstrap samples for estimating critical values
n_bootstrap = 1000;

% Desired false positive rate
alpha = 0.05;

% Preliminary list of boundary values to test
boundary_values = (1:40) * 10;
n_boundary_values = length(boundary_values);

% An excessively large sample for now
n_samples = 5000;

false_positives = zeros(1, n_boundary_values);

for i = 1:n_boundary_values
    disp(i)
    boundary = boundary_values(i);
    signal_length = n_samples + 2 * boundary;
    [critical_value, statistic] = parametric_cusum(signal_length, sampling_rate, SNR, frequency, bandwidth, alpha, n_bootstrap, 'hilbert', boundary);
    for k=1:n_simulations
        % Random phase values
        phi = rand() * 2 * pi;
        % Simulate signal with no shifts and estimate instantaneous phase
            signal = sim_one_shift(signal_length, sampling_rate, SNR, frequency, phi, shift_magnitude, shift_latency);
            phase = instant_phase(signal, sampling_rate, frequency, bandwidth);
            % Burn away start and end of signal
            phase = unwrap(phase((boundary + 1):(end - boundary)));
            % Test for change point and estimate tau
            if max(abs(weighted_cusum(phase))) > critical_value
                true_positives(i, j) = true_positives(i, j) + 1;
            end
        end
    end
end


save instant_burnSize true_positives n_simulations boundary_values shift_list alpha n_samples SNR bandwidth 




