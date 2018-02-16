function statistic = pd(phase)
% Calculate the PD statistic from a time series
% Inputs:
%   signal (array(float)) - signal of interest
%
% Outputs:
%   statistic (array(float)) - PD statistic

statistic = [0, diff(phase)];
