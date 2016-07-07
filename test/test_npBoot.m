% Test npBoot for correctness
% Also time several different options

nBoot = 100;
T = 8000;
P = zeros(1,T);

for i = 1:8
    P(((i-1)*1000+1):i*1000) = i;
end

block_size = 1000;

N = length(P);
n_blocks = floor(N / block_size);
pBlock = reshape(P, block_size, n_blocks);
alpha = 0.05;

x = Boot(pBlock, n_blocks);

figure()
plot(x)



tic 
for i=1:100
    [Crit, Stat] = npBoot(P, block_size, alpha, nBoot);
end
boot1time = toc;


tic 
for i=1:100
    [Crit, Stat] = npBoot_variableBlock(P, block_size, alpha, nBoot);
end
boot2time = toc;


