%% Index most similar granules
function [I_row, I_col] = most_similar_granules(A)
S = similarity_meas(A);
[~, ind] = max(S(:));
[I_row, I_col] = ind2sub(size(S),ind);
end