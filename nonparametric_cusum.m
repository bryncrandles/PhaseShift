function [critical_value, statistic] = nonparametric_cusum(phase, blocksize, alpha, n_bootstrap)

statistic = zeros(1, n_bootstrap);

n_samples = length(phase);

n_blocks = floor(n_samples / blocksize);

n_samples = blocksize * n_blocks;
phase = phase(1:n_samples);

phase_block = reshape(phase, blocksize, n_blocks);

for boot = 1:n_bootstrap
    bootstrap_phase = Boot(phase_block, n_blocks);
    statistic(boot) = max(abs(weighted_cusum(bootstrap_phase)));
end

critical_value = quantile(statistic, 1 - alpha);
