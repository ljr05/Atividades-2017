%% Check if x belongs to expanded region of A[i]
function S = in_exp_region(x,A,rho)
mdp = mp(A)';
E = [mdp-rho/2 mdp+rho/2];
aux = 0;
n = size(x,2);
for j=1:n
    if ((x{j}(1) >= E(j,1)) && (x{j}(4) <= E(j,2)))
        aux = aux + 1;
    else
        break;
    end
end
if isequal(aux,n)
    S = true;
else
    S = false;
end
end