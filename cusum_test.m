function [ind, h]=cusum_test(P, L, alpha, nBoot)



% P is the time series to be tested

P = unwrap(P);

Crit = npBoot(P, L, alpha, nBoot);

CUSUM = weighted_cusum(P);

if max(abs(CUSUM)) > Crit
    ind = find(abs(CUSUM)==max(abs(CUSUM)));
    h = 1;
else
    ind = 0;
    h = 0;   
end
