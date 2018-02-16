% Script for generating figure S1 for the parametric distribution analyses.
% The figure should display the distribution of the estimator under the 
% null hypothesis of no phase shift event.  

% Clear the workspace
clear

% Set working directory (hilbert, fourier, wavelet)
cd 'C:\Users\slipperyhank\Documents\MATLAB\PhaseShift\parametric\hilbert'
% cd 'C:\Users\slipperyhank\Documents\MATLAB\PhaseShift\parametric\fourier'
% cd 'C:\Users\slipperyhank\Documents\MATLAB\PhaseShift\parametric\wavelet'

% Load CUSUM or PD results
% load distribution_analysis_cusum
load distribution_analysis_pd


hist(observations, 100)

pd = fitdist(observations', 'gev');
qqplot(observations, pd)