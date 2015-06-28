function [ind] = cusumID(P, alpha, nBoot, K, bound, Nmin)

% time series P should be already unwrapped if it is angular data so that
% function cn be used by ordinal data.

% need to set the 'time-scale' of CP's
% for the simulated ex
% bound = 3*sRate/2;

% for Ross the value of bound is made up
% bound = 30*sRate;

% Minimum length of signal to check for CP
% for the simulation
% Nmin = 2*sRate;
% for the Ross
% Nmin = 105*sRate;

% Parameter K
% For the simulation
% K=sRate/2;
% for the Ross
% K = 12*sRate;

N = length(P);
ind = zeros(1,N);

[m, h] = cusum_test(P, K, alpha, nBoot); 

if h == 1
    nHigh = min(m+bound, N);
    nLow = max(1, m-bound);
    ind((nLow+1):(nHigh-1)) = 1;
    if nLow > Nmin
        ind(1:(nLow-1)) = cusumID(P(1:(nLow-1)), alpha, nBoot, K, bound, Nmin);
    end
    if (N - nHigh + 1) > Nmin        
        ind((nHigh+1):end) = cusumID(P((nHigh+1):end), alpha, nBoot, K, bound, Nmin);
    end
end
















        