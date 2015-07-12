function x = Boot2(P, block_size, n_blocks)

N = length(P);
Pi = floor(rand([1, n_blocks]) * (N - block_size + 1)) + 1;

x = zeros(1, N);

for i=1:n_blocks
    x(((i-1)*block_size + 1):(i*block_size)) = P(Pi(i):(Pi(i) + block_size - 1));
end