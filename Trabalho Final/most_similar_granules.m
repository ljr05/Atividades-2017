%% Index most similar granules
function [SV, I_row, I_col] = most_similar_granules(A)
S = similarity_meas(A);
[SV, ind] = max(S(:));
[I_row, I_col] = ind2sub(size(S),ind);
end