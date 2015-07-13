function [ind, h]=pdd_test(P, M, alpha)

% P is the time series to be tested

P = unwrap(P);

Crit = norminv((1 - alpha / 2) ^ (1 / M));

PDD = pdd(P);

if max(abs(PDD)) > Crit
    ind = find(abs(PDD)==max(abs(PDD)));
    h = 1;
else
    ind = 0;
    h = 0;   
end
