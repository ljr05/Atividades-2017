function u_j = membership(species, var_n, memb_n, tnorm)
global n lim_meas
L = 1/(memb_n-1);                   % interval between each membership function
m = size(species,1);
for i=1:var_n
    x_norm(1:m,i) = (species(1:m,i) - lim_meas(1,i)) / (lim_meas(2,i) - lim_meas(1,i));
    for j=1:memb_n
        u{1,i}(:,j) = trimf(x_norm(1:m,i), [(j-1)*L-L (j-1)*L (j-1)*L+L]);
    end
end
u_j = ones(m,size(n,1));

if tnorm == 0
    for j=1:size(n,1)
        for i=1:var_n
            u_j(:,j) = u_j(:,j) .* u{1,i}(:,n(j,i));
        end
    end
else
    for j=1:size(n,1)
        for i=1:var_n
            u_j(:,j) = min(u_j(:,j),u{1,i}(:,n(j,i)));
        end
    end
end
end