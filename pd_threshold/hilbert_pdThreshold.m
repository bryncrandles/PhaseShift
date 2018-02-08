% Sensitivity analysis for threshold for PD estimator
% Explore simple oscillator no phase shift events and i.i.d noise 
% iid noise.

% Frequency band is (7, 9)

signal_length = 3000;
n_burn = 190;

n_samples = signal_length + 2 * n_burn;

sampling_rate = 250;
SNR = 0.5;
frequency = 8;
bandwidth = 1;

n_simulations = 200;
alpha = 0.05;

list_M = (1:100) * 10;
nM = length(list_M);

false_positives = zeros(1, nM);
tau = zeros(nM, n_simulations);

for i = 1:nM
    disp(i)
    M = list_M(i);
    for j=1:n_simulations
        phi = rand() * 2 * pi;
        % Simulate signal with one shift and estimate instantaneous phase
        signal = sim_one_shift(n_samples, sampling_rate, SNR, frequency, phi);
        phase = instant_phase(signal, sampling_rate, frequency, bandwidth);
        % Burn away first 4 seconds
        phase = phase((n_burn + 1):(end - n_burn));
        [ind, h] = pd_test(phase, M, alpha);
        false_positives(i) = false_positives(i) + h;
        tau(i, j) = estimate_tau(phase);
    end
end

%{
figure()

M0 = 2 * length(phase) / mean(mean(tau));

plot(list_M, false_positives / n_simulations, 'b', 'linewidth', 2)
hold on
plot([0, max(list_M)], [0.05, 0.05], 'k--')
plot([M0, M0], [0, 1], 'r', 'linewidth', 2)

%}

% The false positive rate seems to plateau around 0.1 instead of 0.05.

% Questions:
% Need to find a better estimate of M - try signals that give different tau
% If I change alpha does the plateau change? Or do 5-10% always trigger
