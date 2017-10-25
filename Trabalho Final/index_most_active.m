%% Index most active granule
function iS = index_most_active(x,A)
S = zeros(size(A,1),1);
n = size(x,2)-1;
for i=1:size(A,1)
    for j=1:n
        for k=1:4
            S(i) = S(i) + abs(x{j}(k) - A{i,j}(k));
        end
    end
    % Similarity measure
    S(i) = 1-1/(4*n)*S(i);
end
[~, iS] = max(S);
end