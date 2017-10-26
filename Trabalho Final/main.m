%% Federal University of Minas Gerais
% Luiz Queiroz, Pedro Coutinho, Rodrigo Ara�jo
% Fuzzy Set Based Evolving Modeling (FBeM) Algorithm

%% Reading data
close all; clear all; clc;
data = normalize_data(xlsread('Concrete_Data.xls'));

%% Set parameters
rho = 0.45; hr = 40; etta = 2; psi = 1/40; c = 0;
c_early = 0;

%% Read (x,y)[h], h = 1
h = 1;
x = granulating(data(h,:));

%% Create granule Gamma{c+1}
A(c+1,:) = x(1:8);
B(c+1,1) = x(9);
c = c + 1;
C(h) = c;
ha{c} = h;
P{1,1} = 10e3*eye(size(x,2));
a{1,1} = [mp(x(9)); zeros(size(x,2)-1,1)];                  % coefficients of c-th y_est (consequent functional)

for h=2:size(data,1)
    %% Read (x,y)[h]
    x = granulating(data(h,:));
    %% Provide single-value approximation p(x[h])
    for i=1:c
        if in_exp_region(x,A(i,:),rho)
            ux(i,1) = similarity_meas_data(x(1:8), A(i,:));
        else ux(i,1) = 0;
        end
        [a{i,1} P{i}] = RLS(a{i,1},P{i},x(1:8),x(9));       % recursive Least Squared to update coefficients of y_est (consequent functional)
        pi(i) = a{i,1}'*[1; mp(x(1:8))'];                   % estimated output of i-th rule
    end
    p = sum(min(ux').*pi)/(sum(min(ux')));                  % global output
    %% Provide granular approximation B{i*} - convex hull
%     convex = [];
%     for i=1:c
%         uy(i) = trapmf(mp(x(9)),[B{i}]);  
%         if uy(i)~=0
%             convex = [convex; B{i}];
%         end
%     end
%     if ~isempty(convex)
%         ch_B = [min(convex(:,1)) min(convex(:,2)) max(convex(:,3)) max(convex(:,4))];
%     end
    %% Calculate output error eps[h] = mp(y[h]) - p(x[h])
%     eps = mp(x(9)) - p;
    %% check expanded regions i-th E
    aux = 0;
    for i=1:c
        if in_exp_region(x,A(i,:),rho)
            aux = 1;
            break;
        end
    end
    %% x[h] or y[h] is not into i-th granule's expanded regions E, i.e. aux = 0
    if  isequal(aux,0)
        %% Create granule Gamma{c+1}
        A(c+1,:) = x(1:8);
        B(c+1,1) = x(9);
        c = c + 1;
        ha{c} = h;
        P{c,1} = 10e3*eye(size(x,2));
        a{c,1} = [mp(x(9)); zeros(size(x,2)-1,1)];        % coefficients of c-th y_est (consequent functional)
%         if isequal(mod(h,hr),0)
%             disp(c);
%         end
    else
        %% Adapt the most active granule Gamma{i}
        iS = index_most_active(x,A);
        ha{iS} = h;
        for j=1:8
            A(iS,j) = updating(x{j},A(iS,j),rho);
        end
        B(iS,1) = updating(x{j},B(iS,1),rho);
        %% Adapt local function parameters a{i,j} using RLS
        for i=1:c
            if in_exp_region(x,A(i,:),rho)
                ux(i,1) = similarity_meas_data(x(1:8), A(i,:));
            else ux(i,1) = 0;
            end
            [a{i,1} P{i}] = RLS(a{i,1},P{i},x(1:8),x(9));
            pi(i) = a{i,1}'*[1; mp(x(1:8))'];
        end
        p = sum(min(ux').*pi)/(sum(min(ux')));
    end
    %% if h = alpha*hr,  alpha = 1, 2, ...
    if isequal(mod(h,hr),0)
        %% Combine granules when feasible
        [SV, I_row, I_col] = most_similar_granules(A);
        while (SV >= 0.8)
            A(I_row,:) = combine_granules(A(I_row,:),A(I_col,:));
            A(I_col,:) = [];
            B(I_row,:) = combine_granules(B(I_row,:),B(I_col,:));
            B(I_col,:) = [];
            a{I_row,1} = 1/2 * (a{I_row,1} + a{I_col,1});
            a(I_col,:) = [];
            ha{I_row} = h;
            ha(:,I_col) = [];
            c = c - 1;
            [SV, I_row, I_col] = most_similar_granules(A);
        end
        %% Update model granularity rho
        r = c - c_early;
        if r > etta
            rho = (1 + r/hr)*rho;
        else
            rho = (1 - (etta-r)/hr)*rho;
        end
        for i=1:c
            for j=1:8
                if (mp(A(i,j)) - rho/2 > A{i,j}(1))
                    A{i,j}(1) = mp(A(i,j)) - rho/2;
                end
                if (mp(A(i,j)) + rho/2 < A{i,j}(4))
                    A{i,j}(4) = mp(A(i,j)) + rho/2;
                end
                if (mp(A(i,j)) - rho/2 > A{i,j}(2))
                    A{i,j}(2) = mp(A(i,j)) - rho/2;
                end
                if (mp(A(i,j)) + rho/2 < A{i,j}(3))
                    A{i,j}(3) = mp(A(i,j)) + rho/2;
                end
            end
        end
        %% Remove inactive granules
        for i = 1:c
            Theta(i,1) = 2^(-psi*(h-ha{i}));
        end
        remov = find(Theta<=psi);
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