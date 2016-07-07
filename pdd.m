function P = pdd(x)

P = [0, diff(x)];
P = (P - mean(P)) ./ std(P);