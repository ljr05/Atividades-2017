clear all; close all; clc
global n lim_meas
load iris.dat
% attributes column [min - max]
% #1: sepal length  [4.3 - 7.9]
% #2: sepal width   [2.0 - 4.4]
% #3: petal length  [1.0 - 6.9]
% #4: petal width   [0.1 - 2.5]
% #5: species
species{1} = iris((iris(:,5)==1),:);        % data for setosa
species{2} = iris((iris(:,5)==2),:);        % data for versicolor
species{3} = iris((iris(:,5)==3),:);        % data for virginica
obsv_n = size(iris, 1);                     % total number of observations
lim_meas = [4.3 2; 7.9 4.4];                % measures limits for each attributes

% gscatter(iris(:,1), iris(:,2), iris(:,5), 'rgb', 'osd');
% grid
% xlabel('$x_1$ (sepal length)','Interpreter','latex');
% ylabel('$x_2$ (sepal width)','Interpreter','latex');
% axis([4.2 8 1.9 4.5]);
% legend('setosa','versicolor','virginica');
%% Data input
var_n = 2;                  % number of variables
for tnorm=0:1               % 0: t-norm product; 1: t-norm minimum
    p = 1;                  % percentage for training
    N = 1;                  % repetition number of executions
    memb_n = 8;             % maximum number of membership function
    for iter_n=1:N
        aux = randperm(50);
        %         plot_membership(var_n,memb_n);    % Plot of the membership function
        %% Classes training
        clear u_j sum_u_j spe_rand
        n = permn([1:memb_n],var_n);
        for k=1:3
            for i=1:50*p
                spe_rand(i,:) = species{k}(aux(i),1:var_n);
            end
            u_j{k,1} = membership(spe_rand,var_n,memb_n,tnorm);
            sum_u_j(k,:) = sum(u_j{k,1},1);
        end
        [C,classe] = max(sum_u_j,[],1);
        % certainty grade
        beta = sum(sum_u_j,1);
        for i=1:size(n,1)
            CF{memb_n-1}(i) = ( sum_u_j(classe(i),i) - (beta(i)-sum_u_j(classe(i),i))/(k-1) ) / beta(i);
        end
        %% Validation using training data
        clear spe_rand
        x = 0;
        for i=lim_meas(1,1):.01:lim_meas(2,1)
            for j=lim_meas(1,2):.01:lim_meas(2,2)
                x = x + 1;
                spe_rand(x,:) = [i j];
            end
        end
        [type_t{1,memb_n-1}(:,iter_n)] = validation(spe_rand, var_n, memb_n, tnorm, CF, classe);
        %% Figures
        figure
        decisionmap = reshape(type_t{1,memb_n-1}(:,iter_n), [241 361]); % [25 37]
        imagesc([4.3 7.9],[2 4.4],decisionmap);
        set(gca,'ydir','normal');
        cmap = [1 0.7 0.7; 0.4 0.8 0.2; 0.7 0.7 1];
        colormap(cmap);
        hold on
        plot(iris(1:50,1),iris(1:50,2),'ro','LineWidth',2);
        plot(iris(51:100,1),iris(51:100,2),'gs','LineWidth',2);
        plot(iris(101:150,1),iris(101:150,2),'bd','LineWidth',2);
        xlabel('$x_1$ (sepal length)','Interpreter','latex');
        ylabel('$x_2$ (sepal width)','Interpreter','latex'); %,'Rotation',0);
        axis([4.3 7.9 2 4.4]);
        legend('setosa','versicolor','virginica','Location','NorthOutside','Orientation','horizontal');
    end
end