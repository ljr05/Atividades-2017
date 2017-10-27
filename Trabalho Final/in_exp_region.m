%% Check if x belongs to expanded region of A[i]
function S = in_exp_region(x,A,rho)
E = exp_region(A,rho);
aux = 0;
n = size(A,2);
for j=1:n
    if ((x{j}(1) >= E(j,1)) && (x{j}(4) <= E(j,2)))
        aux = aux + 1;
        break;
    end
end
if isequal(aux,n)
    S = true;
else S = false;
end
% for j=1:size(A,2)
%     uE(j,1) = trapmf(x{j}(1),[E(j,1) E(j,1) E(j,2) E(j,2)]);
%     uE(j,2) = trapmf(x{j}(4),[E(j,1) E(j,1) E(j,2) E(j,2)]);
% end
% if isequal(min(sum(uE')),0)
%     S = false;
% else S = true;
% end
end