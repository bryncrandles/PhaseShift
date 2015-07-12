function x = Boot(pBlock, n_blocks)

N = numel(pBlock);
Pi = floor(rand([1, n_blocks]) * n_blocks) + 1;
x = reshape(pBlock(:, Pi), [1, N]);