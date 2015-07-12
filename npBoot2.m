function [Crit, Stat] = npBoot2(P, block_size, alpha, nBoot)


Stat = zeros(1, nBoot);

N = length(P);

n_blocks = floor(N / block_size);

N = block_size * n_blocks;
P = P(1:N);

for b = 1:nBoot
    pData = Boot2(P, block_size, n_blocks);
    C = weighted_cusum(pData);
    [~, ind] = max(abs(C)); 
    Stat(b) = abs(C(ind));
end

Crit = quantile(Stat, 1 - alpha);