function [x, phi, tk] = sim_many_shifts(sRate, SNR, freq, nShifts, ISImin, ISIavg, minShift, maxShift, sign)

% Simulate an oscillator with many phase shift events

% In the easy version:
% All shifts are in the same direction 
% sign = 1 
% ISImin = 750 
% ISIavg = 2250
% minShift = pi / 8
% maxShift = pi

% In the hard version:
% Shifts are in different directions 
% sign = -1 
% ISImin = 250 
% ISIavg = 1750
% minShift = pi / 10
% maxShift = pi

% Parameters 

theSign = sign .^ floor(rand(1, nShifts) * 10);
ISI = floor(ISImin + exprnd((ISIavg-ISImin), 1, nShifts+1));
T = sum(ISI);

t = 0:(T - 1);
tMat = repmat(t, nShifts, 1);

tk = cumsum(ISI(1:nShifts))';
tkMat = repmat(tk, 1, T);

shift = (minShift + rand(1, nShifts) * (maxShift - minShift)) .* theSign;
shiftMat = repmat(shift', 1, T);

phi = sum((heaviside(tMat - tkMat) > 0) .* shiftMat, 1);

x = sin(2 * pi * freq * t / sRate + phi);

epsilon = randn(1, T); % normal noise
%epsilon = rand(1, T); % uniform noise

x = x ./ norm(x);
epsilon = epsilon ./ norm(epsilon);

x = SNR .* x + (1 - SNR) .* epsilon;

