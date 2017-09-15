function [type] = validation(species, var_n, memb_n, tnorm, CF, classe)
u_j = membership(species,var_n,memb_n,tnorm);
[C,index] = max(u_j.*CF{memb_n-1},[],2);
for i=1:size(index,1)
    type(i) = classe(index(i));
end