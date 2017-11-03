%% Checking if support conctraction of granule Gamma{i} is necessary
function A = check_conctract(A,rho)
if (mp({A}) - rho/2 > A(1))
    A(1) = mp({A}) - rho/2;
    if (mp({A}) - rho/2 > A(2))
        A(2) = mp({A}) - rho/2;
    end
end
if (mp({A}) + rho/2 < A(4))
    A(4) = mp({A}) + rho/2;
    if (mp({A}) + rho/2 < A(3))
        A(3) = mp({A}) + rho/2;
    end
end
end