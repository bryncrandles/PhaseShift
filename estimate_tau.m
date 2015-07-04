function tau = estimate_tau(x, N)

if nargin < 2
    N = 1;
end

tau=zeros(N, 1);
T = length(x);

WindowSize = floor(T/N);

for i = 1:N
    y = x((1 + (WindowSize * (i-1))):(WindowSize * i));
    a = acf(y, WindowSize - 1);
    if min(a) < 0
        tau(i) = find(a < 0, 1) - 1;
    else
        tau(k,Ch) = 0;
    end
end

tau = tau(tau ~= 0);
tau = mean(tau);

    