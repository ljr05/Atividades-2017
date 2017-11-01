%% Adapt the most active granule Gamma{i}
function A = adapting(x,A,rho)
mdp = mp({A});
%% 1
if ((x(1) > mdp - rho/2) && (x(1) < A(1)))
    A(1) = x(1);
end
%% 2
if ((x(2) > mdp - rho/2) && (x(2) < A(2)))
    A(2) = x(2);
end
%% 3
if ((x(2) > A(2)) && (x(2) < mdp))
    A(2) = x(2);
end
%% 4
if ((x(2) > mdp) && (x(2) < mdp + rho/2))
    A(2) = mdp;
end
%% 5
if ((x(3) > mdp - rho/2) && (x(3) < mdp))
    A(3) = mdp;
end
%% 6
if ((x(3) > mdp) && (x(3) < A(3)))
    A(3) = x(3);
end
%% 7
if ((x(3) > A(3)) && (x(3) < mdp + rho/2))
    A(3) = x(3);
end
%% 8
if ((x(4) > A(4)) && (x(4) < mdp + rho/2))
    A(4) = x(4);
end
end