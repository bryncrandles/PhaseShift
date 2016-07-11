function [ind, h] = pd_test(phase, n_replications, alpha)

% P is the time series to be tested

phase = unwrap(phase);

critical_value = norminv((1 - alpha / 2) ^ (1 / n_replications));

phase_derivative = pd(phase);

if max(abs(phase_derivative)) > critical_value
    ind = find(abs(phase_derivative)==max(abs(phase_derivative)));
    h = 1;
else
    ind = 0;
    h = 0;   
end
