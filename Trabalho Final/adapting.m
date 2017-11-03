%% Adapt the most active granule Gamma{i}
function A = adapting(x,A,rho)
%% 1
if ((x(1) > mp({A}) - rho/2) && (x(1) < A(1)))
    A(1) = x(1);
end
%% 2
if ((x(2) > mp({A}) - rho/2) && (x(2) < A(2)))
    A(2) = x(2);
end
%% 3
if ((x(2) > A(2)) && (x(2) < mp({A})))
    A(2) = x(2);
end
%% 4
if ((x(2) > mp({A})) && (x(2) < mp({A}) + rho/2))
    A(2) = mp({A});
end
%% 5
if ((x(3) > mp({A}) - rho/2) && (x(3) < mp({A})))
    A(3) = mp({A});
end
%% 6
if ((x(3) > mp({A})) && (x(3) < A(3)))
    A(3) = x(3);
end
%% 7
if ((x(3) > A(3)) && (x(3) < mp({A}) + rho/2))
    A(3) = x(3);
end
%% 8
if ((x(4) > A(4)) && (x(4) < mp({A}) + rho/2))
    A(4) = x(4);
end
end