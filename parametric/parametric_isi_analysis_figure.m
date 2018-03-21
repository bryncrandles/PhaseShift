% Script for generating figure S2 for the parametric power analyses. The
% figure should display the statistical power of the methods as a function
% of shift-magnitude and boudary. 

% Clear the workspace
clear

% Set working directory (hilbert, fourier, wavelet)
cd 'C:\Users\slipperyhank\Documents\MATLAB\PhaseShift\parametric\hilbert'
% cd 'C:\Users\slipperyhank\Documents\MATLAB\PhaseShift\parametric\fourier'
% cd 'C:\Users\slipperyhank\Documents\MATLAB\PhaseShift\parametric\wavelet'

% Load CUSUM or PD results
% load isi_analysis_cusum
load isi_analysis_pd

% SNR value is fixed at 0.5

% Normalize to get statistical power
power = true_positives / n_simulations;

% Flip power so low ISI values are on the bottom of the plot
% power = flipud(power);

% False positive rate for column 0 (no shift)
% power(:, 1) = 1 - power(:, 1);

h = heatmap(power);
h.XLabel = 'Phase Shift Magnitude';
h.YLabel = 'ISI Value';
h.CellLabelColor = 'none';
%h.XDisplayLabels = {'0', '', '', '', '', '', '', '', '', '', '\pi/2', '', '', '', '', '', '', '', '', '', '\pi'};
%h.XDisplayLabels = {'0', '', '', '', '', '0.5 s', '', '', '', '', '1 s'};
h.Title = 'Statistical Power of PD Estimator (2 events)';
h.FontSize = 16;