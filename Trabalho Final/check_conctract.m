%% Checking if support conctraction of granule Gamma{i} is necessary
function A = check_conctract(A,rho)
mdp = mp({A});
if (mdp - rho/2 > A(1))
    A(1) = mdp - rho/2;
    if (mdp - rho/2 > A(2))
        A(2) = mdp - rho/2;
    end
end
if (mdp + rho/2 < A(4))
    A(4) = mdp + rho/2;
    if (mdp + rho/2 < A(3))
        A(3) = mdp + rho/2;
    end
end
end