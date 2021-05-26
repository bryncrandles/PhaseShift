% Adapted from isi_analysis_hilbert_cusum

% add path to files
addpath(genpath('/home/bc11xx/projects/def-wjmarsha/bc11xx/phase-shift-stuff/PhaseShift/'))

% set directory
cd '/home/bc11xx/projects/def-wjmarsha/bc11xx/phase-shift-stuff/'

% Frequency band is (7, 9)
frequency = 8;
bandwidth = 1;

% Sampling rate is 250 samples per second
sampling_rate = 250;

% Number of samples
n_samples = 1000;
boundary = 250; % one second boundary for the whole signal

% First shift 
shift_latency1 = 400;
% Second shift 
shift_latency2 = 500;
% hard code number of boundary points for removal for second shift
upper_boundary = 10 ;% (1:10) * 10;
%n_isi_levels = length(isi_levels);

% latency tolerance
latency_tolerance = 50;

% magnitudes of shifts
shift_levels = (0:20) ./ 20 .* pi;
n_shift_levels = length(shift_levels);

% different noise levels to be considered
dB = (-1:1) / 2;
SNR_levels = 10.^(dB) ./ (1+10.^(dB));
n_SNR_levels = length(SNR_levels);

% Number of bootstrap samples for estimating critical values
n_bootstrap = 5000;

% Significance level
alpha = 0.05;

% number of simulations
n_simulations = 1000;

% initialize results
true_positives = zeros(n_SNR_levels, n_shift_levels);
stage1_fails = zeros(n_SNR_levels, n_shift_levels);
stage2_fails_A = zeros(n_SNR_levels, n_shift_levels);
stage2_fails_B = zeros(n_SNR_levels, n_shift_levels);

%% loop to calculate true positives (power) for each shift magnitude
for i = 1:n_SNR_levels
    SNR = SNR_levels(i);
    % get critical value for the whole signal 
    [critical_value, ~] = parametric_pd(n_samples, sampling_rate, SNR, frequency, bandwidth, alpha, n_bootstrap, 'hilbert', boundary);
    [critical_value_upper, ~] = parametric_pd3(n_samples, sampling_rate, SNR, frequency, bandwidth, alpha, n_bootstrap, 'hilbert', boundary, shift_magnitude, shift_latency1, upper_boundary, latency_tolerance);
    for j = 1:n_shift_levels
        shift_magnitude = shift_levels(j);
        for k = 1:n_simulations
            % simulate signal with two shifts 
            phi = rand() * 2 * pi;
            signal = sim_two_shifts(n_samples, sampling_rate, SNR, frequency, phi, [shift_magnitude, shift_magnitude], [shift_latency1, shift_latency2]);
            % Estimate phase (hilbert)
            phase = hilbert_phase(signal, sampling_rate, frequency, bandwidth);
            phase = unwrap(phase);
            phase = phase((1 + boundary):(end - boundary));
            % Enforce that the target shift is the first one identified
            pd_statistic = abs(pd(phase));
            % takes care of latency tolerance
            pd_statistic(1:((shift_latency1 - boundary) - latency_tolerance)) = 0;
            pd_statistic(((shift_latency1 - boundary) + latency_tolerance):end) = 0;
            [max_value, estimated_latency] = max(pd_statistic);
            if max_value > critical_value
               upper_phase = phase((estimated_latency + upper_boundary + 1):end);
               [max_value_upper, estimated_latency_upper] = max(abs(pd(upper_phase)));
               if max_value_upper > critical_value_upper 
                  if abs(boundary + estimated_latency + upper_boundary + estimated_latency_upper - shift_latency2) < latency_tolerance         
                     true_positives(i, j) = true_positives(i, j) + 1;
                  else
                    stage2_fails_B(i, j) = stage2_fails_B(i, j) + 1;
                  end
               else
                    stage2_fails_A(i, j) = stage2_fails_A(i, j) + 1;
               end
            else
                stage1_fails(i, j) = stage1_fails(i, j) + 1;
            end
        end
    end
end


%%
savename = ['ISI_analysis_pd_boundary_10_' date '.mat'];
save(savename, 'latency_tolerance', 'frequency', 'bandwidth', 'alpha', 'sampling_rate', 'shift_latency1', 'shift_latency2', 'boundary', 'upper_boundary', 'shift_levels', 'SNR_levels', 'n_bootstrap', 'n_simulations', 'SNR', 'true_positives', 'stage1_fails', 'stage2_fails_A', 'stage2_fails_B')

exit
