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
lim_meas = [4.3 2 1 0.1; 7.9 4.4 6.9 2.5];  % measures limits for each attributes

% gscatter(iris(:,1), iris(:,2), iris(:,5),'rgb','osd');
% grid
% xlabel('x_1'); ylabel('x_2');
% axis([4 8 2 4.5]);
% legend('setosa','versicolor','virginica');
%% Data input
var_n = 4;                  % number of variables
for tnorm=0:1               % 0: t-norm product; 1: t-norm minimum
    p = 0.7;                % percentage for training
    N = 25;                 % repetition number of executions
    n_max = 15;             % maximum number of membership function
    for iter_n=1:N
        aux = randperm(50);
        for memb_n=2:n_max                      % number of membership function
%             plot_membership(var_n,memb_n);    % Plot of the membership function
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
            for k=1:3
                for i=1:50*p
                    spe_rand(i,:) = species{k}(aux(i),1:var_n);
                end
                [type_t{k,memb_n-1}(:,iter_n)] = validation(spe_rand, var_n, memb_n, tnorm, CF, classe);
                S = 0;
                for i=1:50*p
                    if type_t{k,memb_n-1}(i,iter_n) == k
                        S = S + 1;
                    end
                end
                erro_t{k,memb_n-1}(iter_n) = (1 - S/((50-50*(1-p))))*100;
            end
            %% Validation using evaluation data
            clear spe_rand
            for k=1:3
                for i=1:50*(1-p)
                    spe_rand(i,:) = species{k}(aux(i+50*p),:);
                end
                [type_e{k,memb_n-1}(:,iter_n)] = validation(spe_rand, var_n, memb_n, tnorm, CF, classe);
                S = 0;
                for i=1:50*(1-p)
                    if type_e{k,memb_n-1}(i,iter_n) == k
                        S = S + 1;
                    end
                end
                erro_e{k,memb_n-1}(iter_n) = (1 - S/((50-50*p)))*100;
            end
        end
    end
    %% Figures
    S_t = zeros(3,n_max-1); S_e = zeros(3,n_max-1);
    for i=2:n_max
        for k=1:3
            S_t(k,i-1) = S_t(k,i-1) + mean(erro_t{k,i-1});
            S_e(k,i-1) = S_e(k,i-1) + mean(erro_e{k,i-1});
        end
    end
    err_t_mean(:,tnorm+1) = mean(S_t(:,:));
    err_e_mean(:,tnorm+1) = mean(S_e(:,:));
    i = 2:1:n_max;
%     subplot(1,2,tnorm+1);
    figure
    plot(i,err_t_mean(:,tnorm+1),':ok');
    hold on
    plot(i,err_e_mean(:,tnorm+1),':or');
    xlabel('Número de funções de pertinência');
    ylabel('Taxa do erro de classificação (%)');
    axis([2 n_max 0 40]);
    legend('Training Data','Evaluation Data');
    grid
end