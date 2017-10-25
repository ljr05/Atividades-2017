%% Expanded region
function E = exp_region(A,rho)
mdp = mp(A);
E = [mdp-rho/2 mdp+rho/2];
end