function statistic = pd(phase)

statistic = [0, diff(phase)];
statistic = (statistic - mean(statistic)) ./ std(statistic);