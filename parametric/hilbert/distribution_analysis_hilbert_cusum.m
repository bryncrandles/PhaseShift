% Simulation analysis of the distribution of the PD statistic under the
% null hypthesis of no phase shift event using parametric bootstrapping.

% As the estimator is a maximum over several values, it should correspond
% to a GEV distribution. Make signal sufficiently long, with amply boundary
% to avoid any finite issues.  




% latency tolerance - how close does the estimated latency need to be to
% the true latency in order to consider the phase shift correctly
% identified?

% Frequency band is (7, 9)
frequency = 8;
bandwidth = 1;
phi = 0;

% Sampling rate is 250 samples per second
sampling_rate = 250;

% Number of samples
n_samples = 34 * sampling_rate;
boundary = 2 * sampling_rate;

% Number of bootstrap samples for estimating distribution
n_bootstrap = 10000;

% Significance level
alpha = 0.05;

% Three different noise levels to be considered
SNR = 0.5;

% Get random sample of observations
[critical_value, observations] = parametric_cusum(n_samples, sampling_rate, SNR, frequency, bandwidth, alpha, n_bootstrap, 'hilbert', boundary);


save distribution_analysis_cusum frequency bandwidth SNR n_bootstrap observations
