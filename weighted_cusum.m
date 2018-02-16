function wCUSUM = weighted_cusum(signal)
% Calculate the weighted-CUSUM statistic
%
% Inputs:
%   signal (array(float)) - observed time series
%
% Outputs:
%   wCUSUM (float) - weighted CUSUM value

% Calcuate weights
N = length(signal);
index = 1:(N-1);
weights = sqrt(N ./ index ./ (N - index));

% Calculate weighted cusum
wCUSUM = [weights .* cumsum(signal(1:(N-1)) - mean(signal)), 0];
