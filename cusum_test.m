function [ind, h]=cusum_test(P, L, alpha, nBoot, method)

if nargin < 5
    method = 'resample';
end

% P is the time series to be tested

P = unwrap(P);

Crit = npBoot(P, L, (alpha / 2), nBoot, method);

CUSUM = weighted_cusum(P);

if max(abs(CUSUM)) > Crit
    ind = find(abs(CUSUM)==max(abs(CUSUM)));
    h = 1;
else
    ind = 0;
    h = 0;   
end
