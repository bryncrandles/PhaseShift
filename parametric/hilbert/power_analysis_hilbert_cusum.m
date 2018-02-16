% Simulation analysis of the statistical power of CUSUM statistics for
% shift identification using parametric boostrapping. 

% The boundary effects of estimating phase (both real boundaries and
% change-points) will influence power. The boundary effect will require a
% higher threshold for an event. Thus, removing the boundary effects can
% lower the threshold and increase power. Here we study this balance. 


% latency tolerance - how close does the estimated latency need to be to
% the true latency in order to consider the phase shift correctly
% identified?

% There is quite a bit of variability in estimated latency. Will take +/-
% 50 as a threshold and can estimate latency error seperately if needed.
latency_tolerance = 50;

% Frequency band is (7, 9)
frequency = 8;
bandwidth = 1;

% Sampling rate is 250 samples per second
sampling_rate = 250;

% Number of samples
n_samples = 1000;

% Shift occurs in the middle of the signal, with variable magnitude
shift_latency = n_samples / 2;

shift_levels = (0:20) ./ 20 .* pi;
n_shift_levels = length(shift_levels);

% Number of bootstrap samples for estimating critical values
n_bootstrap = 5000;

% Significance level
alpha = 0.05;

% Three different noise levels to be considered
dB = (-1:1) / 2;
SNR_levels = 10.^(dB) ./ (1+10.^(dB));
n_SNR_levels = length(SNR_levels);

% Boundary levels from 0s to 1s in 25 point intervals
boundary_levels = (0:10) * 25;
n_boundary_levels = length(boundary_levels);

% Number of simulations for each blocksize
n_simulations = 1000;

% Initialize results
true_positives = zeros(n_SNR_levels, n_boundary_levels, n_shift_levels);

for i = 1:n_SNR_levels
    SNR = SNR_levels(i)
    for j = 1:n_boundary_levels
        boundary = boundary_levels(j)
        critical_value = parametric_cusum(n_samples, sampling_rate, SNR, frequency, bandwidth, alpha, n_bootstrap, 'hilbert', boundary);
        for k = 1:n_shift_levels
        shift_magnitude = shift_levels(k)
            for l = 1:n_simulations
                phi = rand() * 2 * pi;
                % Simulate signal with single phase shift event 
                signal = sim_one_shift(n_samples, sampling_rate, SNR, frequency, phi, shift_magnitude, shift_latency);
                % Estimate phase (hilbert)
                phase = hilbert_phase(signal, sampling_rate, frequency, bandwidth);
                phase = unwrap(phase);
                phase = phase((1 + boundary):(end - boundary));
                [max_value, index] = max(abs(weighted_cusum(phase)));
                if max_value > critical_value && abs(boundary + index - shift_latency) < latency_tolerance
                    true_positives(i, j, k) = true_positives(i, j, k) + 1;
                end
            end
        end
    end
end

save power_analysis_cusum frequency bandwidth SNR_levels shift_levels boundary_levels n_simulations true_positives
