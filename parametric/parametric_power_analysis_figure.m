% Script for generating a figure for the parametric power analyses. The
% figure should display the statistical power of the methods as a function
% of shift-magnitude and boudary. 

% Clear the workspace
clear

% Set working directory (hilbert, fourier, wavelet)
cd 'C:\Users\slipperyhank\Documents\MATLAB\PhaseShift\parametric\hilbert'
% cd 'C:\Users\slipperyhank\Documents\MATLAB\PhaseShift\parametric\fourier'
% cd 'C:\Users\slipperyhank\Documents\MATLAB\PhaseShift\parametric\wavelet'

% Load CUSUM or PD results
% load power_analysis_cusum
load power_analysis_pd

% Select SNR value to plot
SNR_levels
true_positives = true_positives(2, :, :);

% Normalize to get statistical power
power = squeeze(true_positives / n_simulations);

% Flip power so low Boundary values are on the bottom of the plot
power = flipud(power);

h = heatmap(power);
h.XLabel = 'Phase Shift Magnitude';
h.YLabel = 'Boundary Value';
h.CellLabelColor = 'none';
%h.XDisplayLabels = {'0', '', '', '', '', '', '', '', '', '', '\pi/2', '', '', '', '', '', '', '', '', '', '\pi'};
%h.XDisplayLabels = {'0', '', '', '', '', '0.5 s', '', '', '', '', '1 s'};
h.Title = 'Statistical Power of PD Estimator';
h.FontSize = 16;