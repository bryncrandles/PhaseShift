function [Crit, Stat] = npBoot(P, K, alpha, nBoot, method)

if nargin < 4
    print('error: Incorrect number of arguements')
    return 
end

if nargin < 5
    method = 'permute';
end

if ~(strcmp(method, 'resample') || strcmp(method, 'permute')):
    print('error: Method must be reample or permute')
    return
end

Stat = zeros(1,nBoot);

K = floor(K);

N = L*K;
P = P(1:N);
index = 1:(N-1);

pBlock = reshape(P, K, L);

for b = 1:nBoot
    if strcmp(method, 'resample')
        Pi = floor(rand([1,L])*L)+1;
    elseif strcmp(method, 'permute')
        Pi = randperm(L);
    end
    pData = reshape(pBlock(:, Pi), [1,N]);
    C = sqrt(N./index./(N-index));
    Stat(b) = max(abs(C.*cumsum(pData(1:(N-1))-mean(pData))));
    
end

Crit = quantile(Stat, 1-alpha);