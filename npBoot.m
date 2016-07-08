function [Crit, Stat] = npBoot(P, block_size, alpha, nBoot)


Stat = zeros(1, nBoot);

N = length(P);

n_blocks = floor(N / block_size);

N = block_size * n_blocks;
P = P(1:N);

pBlock = reshape(P, block_size, n_blocks);

for b = 1:nBoot
    pData = Boot(pBlock, n_blocks);
    C = weighted_cusum(pData);
    Stat(b) = max(abs(C));
end

Crit = quantile(Stat, 1 - alpha);
