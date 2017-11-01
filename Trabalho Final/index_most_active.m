%% Index of most active granule
function iS = index_most_active(x,A)
S = similarity_meas_data(x,A);
[~, iS] = max(S);
end