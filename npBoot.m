function [Crit, Stat] = npBoot(P, block_size, alpha, nBoot, method)

if nargin < 4
    print('error: Incorrect number of arguements')
    return 
end

if nargin < 5
    method = 'resample';
end

if ~(strcmp(method, 'resample') || strcmp(method, 'permutation'))
    print('error: Method must be reample or permute')
    return
end

Stat = zeros(1, nBoot);

N = length(P);

n_blocks = floor(N / block_size);

N = block_size * n_blocks;
P = P(1:N);

pBlock = reshape(P, block_size, n_blocks);

for b = 1:nBoot
    if strcmp(method, 'resample')
        Pi = floor(rand([1, n_blocks]) * n_blocks) + 1;
    elseif strcmp(method, 'permutation')
        Pi = randperm(n_blocks);
    end
    pData = reshape(pBlock(:, Pi), [1, N]);
    C = weighted_cusum(pData);
    [~, ind] = max(abs(C));
    Stat(b) = abs(C(ind));
end

Crit = quantile(Stat, 1 - alpha);