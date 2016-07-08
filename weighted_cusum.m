function S=weighted_cusum(x)

N = length(x);
index = 1:(N-1);

w = sqrt(N ./ index ./ (N - index));
% w = 1 / sqrt(N);

S = [w .* cumsum(x(1:(N-1)) - mean(x)), 0];
