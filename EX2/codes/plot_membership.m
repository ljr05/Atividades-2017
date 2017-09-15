function plot_membership(var_n,memb_n)
figure
L = 1/(memb_n-1);                   % interval between each membership function
for i=1:var_n
    x{i} = (0:1/1000:1)';
    for j=1:memb_n
        u{i}(:,j) = trimf(x{i}, [(j-1)*L-L (j-1)*L (j-1)*L+L]);
        subplot(var_n/2,2,i)
        hold on
        plot(x{i}, u{i}(:,j));
    end
    axis([0 1 0 1]);
    xlabel(['$x_',num2str(i),'$'],'Interpreter','latex');
    ylabel(['$\mu_k(x_',num2str(i),')$'],'Interpreter','latex');
end
end