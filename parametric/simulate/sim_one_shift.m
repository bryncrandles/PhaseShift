function x = sim_one_shift(T, sRate, SNR, freq, phi, delta_phi, t0)

if nargin < 5
    error('Not enough parameters')
elseif nargin < 7
    delta_phi = 0;
    t0 = 0;
end

% PARAMETERS

% T: The number of samples in the signal

% sRate: sampling rate, typically 250 samples per second

% freq: frequency of the ocsillator
 
% SNR: singal-to-noise ratio: 1 for no noise

% phi: the initial phase of the oscillator
% delta_phi: the change in phase of the oscillator

% t0: the temporal index of the change point

t=0:(T-1);

x=sin(freq*2*pi*t/sRate+phi);

if t0 > 0
    x(t0:end) = sin(freq*2*pi*t(t0:end)/sRate+(phi + delta_phi));
end
       
epsilon = randn(1,T); % normal noise
%epsilon = rand(1,T); % uniform noise

x = x ./ norm(x);
epsilon = epsilon ./ norm(epsilon);

x = SNR .* x + (1 - SNR) .* epsilon;
