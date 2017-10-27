%% Federal University of Minas Gerais
% Luiz Queiroz, Pedro Coutinho, Rodrigo Araújo
% Fuzzy Set Based Evolving Modeling (FBeM) Algorithm
% Teste
%% Reading data
close all; clear all; clc;
data = xlsread('Concrete_Data.xls');

X = [data(2:end,1:8) data(1:end-1,9)];
Y = data(2:end,9);

PD = 4;
% Discarding outliers
h = 1;                 
Mean = mean(X);
Stand = std(X);
for j=1:size(X,2)
    while h<=size(X,1)
        if (X(h,j)<Mean(j)-PD*Stand(j) || X(h,j)>Mean(j)+PD*Stand(j))
            X(h,:) = []; Y(h) = []; h=h-1; 
        end
        h=h+1;
    end
    h=1;
end
clear Mean Stand
h = 1;
Mean = mean(Y);
Stand = std(Y);
while (h<=size(X,1))
    if (Y(h)<Mean-PD*Stand || Y(h)>Mean+PD*Stand)
        X(h,:) = []; Y(h) = []; h=h-1;
    end
    h=h+1;
end

X = normalize_data(X);
Y = normalize_data(Y);

%% Set parameters
rho = 0.45; hr = 40; etta = 2; psi = 1/40; c = 0;
c_early = 0;

%% Read (x,y)[h], h = 1
h = 1;
x = granulating([data(h,1:8) 0 data(h,9)]);
%% Create granule Gamma{c+1}
n = size(x,2)-1;
A(c+1,:) = x(1:n);
B(c+1,1) = x(n+1);
c = c + 1;
C(h) = c;
ha{c} = h;
P{1,1} = 10e3*eye(size(x,2));
a{1,1} = [mp(x(n+1)); zeros(size(x,2)-1,1)];                 % coefficients of c-th y_est (consequent functional)

for h=2:size(data,1)
    %% Read (x,y)[h]
    x = granulating([data(h,1:8) y(h-1,1) data(h,9)]);
    %% Provide single-value approximation p(x[h])
    I = [];
    for i=1:c
        if in_exp_region(x(1:n),A(i,:),rho)
            I = [I,i];
        end
%         for j=1:n
%             if in_exp_region(x(j),A(i,j),rho)
%                 ux(i,j) = similarity_meas_data(x(j), A(i,j));
%             else ux(i,j) = 0;
%             end
%         end
        ux(i) = similarity_meas_data(x(1:n), A(i,:));
%         [a{i,1}, P{i}] = RLS(a{i,1},P{i},x(1:n),x(9));      % recursive Least Squared to update coefficients of y_est (consequent functional)
        pi(i) = a{i,1}'*[1; mp(x(1:n))'];                   % estimated output of i-th rule
    end
%     p = sum(min(ux,[],2).*pi)/(sum(min(ux,[],2)));          % global output
    p = sum(min(ux,[],2).*pi)/(sum(min(ux,[],2)));          % global output
    %% check expanded regions i-th E
    aux = 0;
    for i=1:c
%         if in_exp_region(x,A(i,:),rho)
        if (in_exp_region(x(1:8),A(i,:),rho) && in_exp_region(x(9),B(i,:),rho))
            aux = 1;
            break;
        end
    end
    %% x[h] or y[h] is not into i-th granule's expanded regions E, i.e. aux = 0
    if  isequal(aux,0)
        %% Create granule Gamma{c+1}
        A(c+1,:) = x(1:n);
        B(c+1,1) = x(9);
        c = c + 1;
        ha{c} = h;
        P{c,1} = 10e3*eye(n+1);
        a{c,1} = [mp(x(9)); zeros(n,1)];        % coefficients of c-th y_est (consequent functional)
    else
        %% Adapt the most active granule Gamma{i}
        iS = index_most_active(x,A);
        ha{iS} = h;
        for j=1:n
            A(iS,j) = updating(x{j},A(iS,j),rho);
        end
        B(iS,1) = updating(x{j},B(iS,1),rho);
        %% Adapt local function parameters a{i,j} using RLS
        for i=1:c
            for j=1:n
                if in_exp_region(x(j),A(i,j),rho)
                    ux(i,j) = similarity_meas_data(x(j), A(i,j));
                else ux(i,j) = 0;
                end
            end
            [a{i,1}, P{i}] = RLS(a{i,1},P{i},x(1:n),x(9));
            pi(i) = a{i,1}'*[1; mp(x(1:n))'];
        end
        p = sum(min(ux,[],2).*pi)/(sum(min(ux,[],2)));
    end
    %% if h = alpha*hr,  alpha = 1, 2, ...
    if isequal(mod(h,hr),0)
        %% Combine granules when feasible
        [SV, I_row, I_col] = most_similar_granules(A);
%         while (SV >= 0.79)
            New_gran = combine_granules(A(I_row,:),A(I_col,:));
            aux = 0;
            for j=1:n
                if (New_gran{j}(4) - New_gran{j}(1) >= rho)
                    aux = 1;
                    break;
                end
            end
            if isequal(aux,0)
                A(I_row,:) = New_gran;
                A(I_col,:) = [];
                B(I_row,:) = combine_granules(B(I_row,:),B(I_col,:));
                B(I_col,:) = [];
                a{I_row,1} = 1/2 * (a{I_row,1} + a{I_col,1});
                a(I_col,:) = [];
                ha{I_row} = h;
                ha(:,I_col) = [];
                c = c - 1;
            end
%             [SV, I_row, I_col] = most_similar_granules(A);
%         end
        %% Update model granularity rho
        r = c - c_early;
        if r > etta
            rho = (1 + r/hr)*rho;
        else
            rho = (1 - (etta+r)/hr)*rho;
%             rho = (1 - (etta-r)/hr)*rho;      % this formula is in thesis
        end
        for i=1:c
            for j=1:n
                if (mp(A(i,j)) - rho/2 > A{i,j}(1))
                    A{i,j}(1) = mp(A(i,j)) - rho/2;
                    if (mp(A(i,j)) - rho/2 > A{i,j}(2))
                        A{i,j}(2) = mp(A(i,j)) - rho/2;
                    end
                end
                if (mp(A(i,j)) + rho/2 < A{i,j}(4))
                    A{i,j}(4) = mp(A(i,j)) + rho/2;
                    if (mp(A(i,j)) + rho/2 < A{i,j}(3))
                        A{i,j}(3) = mp(A(i,j)) + rho/2;
                    end
                end
%                 if (mp(A(i,j)) - rho/2 > A{i,j}(2))
%                     A{i,j}(2) = mp(A(i,j)) - rho/2;
%                 end
%                 if (mp(A(i,j)) + rho/2 < A{i,j}(3))
%                     A{i,j}(3) = mp(A(i,j)) + rho/2;
%                 end
            end
        end
        %% Remove inactive granules
        for i = 1:c
            Theta(i,1) = 2^(-psi*(h-ha{i}));
        end
        remov = find(Theta<=1/psi);
        Theta(remov) = [];
        A(remov,:) = [];
        B(remov,:) = [];
        a(remov,:) = [];
        ha(:,remov) = [];
        c = c - size(remov,1);
        c_early = c;
    end
    C(h) = c;
end
disp(mean(C));
disp(rho);
