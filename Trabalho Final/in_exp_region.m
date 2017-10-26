%% Check if x belongs to expanded region of A[i]
function S = in_exp_region(x,A,rho)
E = exp_region(A,rho);
for j=1:size(A,2)
    uE(j,1) = trapmf(x{j}(1),[E(j,1) E(j,1) E(j,2) E(j,2)]);
    uE(j,2) = trapmf(x{j}(4),[E(j,1) E(j,1) E(j,2) E(j,2)]);
end
if isequal(min(sum(uE')),0)
    S = false;
else S = true;
end
end