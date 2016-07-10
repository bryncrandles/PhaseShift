function [ind, h]=pd_test(P, M, alpha)

% P is the time series to be tested

P = unwrap(P);

Crit = norminv((1 - alpha / 2) ^ (1 / M));

PD = pd(P);

if max(abs(PD)) > Crit
    ind = find(abs(PD)==max(abs(PD)));
    h = 1;
else
    ind = 0;
    h = 0;   
end
