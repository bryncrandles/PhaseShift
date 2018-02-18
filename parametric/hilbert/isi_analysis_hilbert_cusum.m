% Simulation analysis of the statistical power of CUSUM statistics for
% identifying closely spaced phase shift events using parametric
% boostrapping. 

% latency tolerance - how close does the estimated latency need to be to
% the true latency in order to consider the phase shift correctly
% identified?

% There is quite a bit of variability in estimated latency. Will take +/-
% 50 as a threshold and can estimate latency error seperately if needed.
latency_tolerance = 75;

% Frequency band is (7, 9)
frequency = 8;
bandwidth = 1;

% Sampling rate is 250 samples per second
sampling_rate = 250;

% Number of samples
n_samples = 1000;
boundary = 125;

% Shift occurs in the middle of the signal, with variable magnitude
shift_latency1 = n_samples / 2;
isi_levels = boundary + (1:10) * 10;
n_isi_levels = length(isi_levels);


shift_magnitude1 = pi/2;
shift_levels = (0:20) ./ 20 .* pi;
n_shift_levels = length(shift_levels);

% Number of bootstrap samples for estimating critical values
n_bootstrap = 5000;

% Significance level
alpha = 0.05;


% Number of simulations for each blocksize
n_simulations = 1000;
SNR = 0.5;


% Initialize results
true_positives = zeros(n_isi_levels, n_shift_levels);
stage1_fails_A = zeros(n_isi_levels, n_shift_levels);
stage1_fails_B = zeros(n_isi_levels, n_shift_levels);
stage2_fails_A = zeros(n_isi_levels, n_shift_levels);
stage2_fails_B = zeros(n_isi_levels, n_shift_levels);

[critical_value, ~, critical_value_upper] = parametric_cusum2(n_samples, sampling_rate, SNR, frequency, bandwidth, alpha, n_bootstrap, 'hilbert', boundary, shift_magnitude1, shift_latency1, latency_tolerance);
for i = 1:n_isi_levels
    shift_latency2 = shift_latency1 + isi_levels(i)
    for j = 1:n_shift_levels
        shift_magnitude2 = shift_levels(j)
        [~, critical_value_lower, ~] = parametric_cusum2(n_samples, sampling_rate, SNR, frequency, bandwidth, alpha, n_bootstrap, 'hilbert', boundary, shift_magnitude2, shift_latency2, latency_tolerance);
        for l = 1:n_simulations
            phi = rand() * 2 * pi;
            % Simulate signal with single phase shift event 
            signal = sim_two_shifts(n_samples, sampling_rate, SNR, frequency, phi, [shift_magnitude1, shift_magnitude2], [shift_latency1, shift_latency2]);
            % Estimate phase (hilbert)
            phase = hilbert_phase(signal, sampling_rate, frequency, bandwidth);
            phase = unwrap(phase);
            phase = phase((1 + boundary):(end - boundary));
            [max_value, estimated_latency] = max(abs(weighted_cusum(phase)));
            if max_value > critical_value 
                if abs(boundary + estimated_latency - shift_latency1) < latency_tolerance
                    upper_phase = phase(estimated_latency + boundary + 1:end);
                    [max_value_upper, estimated_latency_upper] = max(abs(weighted_cusum(upper_phase)));
                    if max_value_upper > critical_value_upper 
                        if abs(boundary + estimated_latency + estimated_latency_upper - shift_latency2) < latency_tolerance
                            true_positives(i, j) = true_positives(i, j) + 1;
                        else
                            stage2_fails_B(i, j) = stage2_fails_B(i, j) + 1;
                        end
                    else
                        stage2_fails_A(i, j) = stage2_fails_A(i, j) + 1;
                    end
                elseif abs(boundary + estimated_latency - shift_latency2) < latency_tolerance
                    lower_phase = phase(1:estimated_latency - boundary);
                    [max_value_lower, estimated_latency_lower] = max(abs(weighted_cusum(lower_phase)));
                    if max_value_lower > critical_value_lower 
                        if abs(boundary + estimated_latency_lower - shift_latency1) < latency_tolerance
                            true_positives(i, j) = true_positives(i, j) + 1;
                        else
                            stage2_fails_B(i, j) = stage2_fails_B(i, j) + 1;
                        end
                    else
                        stage2_fails_A(i, j) = stage2_fails_A(i, j) + 1;
                    end
                else
                    stage1_fails_B(i, j) = stage1_fails_B(i, j) + 1;
                end
            else
                stage1_fails_A(i, j) = stage1_fails_A(i, j) + 1;
            end
        end
    end
end

save isi_analysis_cusum frequency bandwidth SNR shift_levels isi_levels n_simulations true_positives stage1_fails_A stage1_fails_B stage2_fails_A stage2_fails_B
