%% Combine similar granules A[i1] and A[i2]
function A = combine_granules(Ai1,Ai2)
n = size(Ai1,2);
for j=1:n
    A{1,j}(1) = min(Ai1{j}(1), Ai2{j}(1));
    A{1,j}(2) = min(Ai1{j}(2), Ai2{j}(2));
    A{1,j}(3) = max(Ai1{j}(3), Ai2{j}(3));
    A{1,j}(4) = max(Ai1{j}(4), Ai2{j}(4));
end
end