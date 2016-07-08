% Test nonparametric_cusum for correctness
% Also time several different options

n_bootstrap = 100;
n_samples = 8000;
phase = zeros(1, n_samples);

for i = 1:8
    phase(((i-1)*1000+1):i*1000) = i;
end

blocksize = 1000;

n_samples = length(phase);
n_blocks = floor(n_samples / block_size);
phase_block = reshape(phase, block_size, n_blocks);
alpha = 0.05;

bootstrap_phase = Boot(phase_block, n_blocks);

figure()
plot(bootstrap_phase)



tic 
for i=1:100
    [critical_value, statistic] = nonparametric_cusum(phase, blocksize, alpha, n_bootstrap);
end
boot1time = toc;



