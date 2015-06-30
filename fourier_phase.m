function P = fourier_phase(x, sRate, freq, width)
% Fourier_Moving: Calculate a time series of amplitude and phase value
%   Each value is calculated from a moving window of size Window centred at
%   t. 
%   I am specifically interested in a band centred at w, of width 2*dw

T = length(x);

Window = round(sRate/(2*width));
%if mod(Window,2)==0
%    Window=Window+1;
%end

if mod(Window, 2) == 0
    Burn = Window / 2;
else
    Burn = (Window - 1) / 2;
end

t0 = Burn+1;
t1 = T - Burn;

% H = hamming(Window)';

P = zeros(1, T);

% Need to adjust this to be the correct band
m = 0:((Window - 1) / 2);
ind = max(m(abs(2*width*m-freq)==min(abs(2*width*m-freq)))) + 1;

for t=t0:t1
    %y = x((t-Burn):(t+Burn)).*H;
    y = x((t - Burn):(t + Burn));
    Y = fft(y);
    P(t) = angle(Y(ind));
end

t = 0:(T-1);

P = unwrap(P);
P = mod(P - 2 * pi * 8 * (t-Burn) / sRate + pi / 2, 2 * pi);
P(1:Burn) = 0;
P((end-Burn):end) = 0;


