%% Federal University of Minas Gerais
% Luiz Queiroz, Pedro Coutinho, Rodrigo Araújo
% Fuzzy Set Based Evolving Modeling (FBeM) Algorithm

%% Reading data
close all; clear all; clc;
data = normalize_data(xlsread('Concrete_Data.xls'));

%% Parameters initialization
rho = 0.45;
hr = 40;
etta = 2;
psi = 1/40;
c = 0;
c_early = 0;

%% Read (x,y)[h], h = 1
h = 1;
x = granulating(data(h,:));

%% Create granule Gamma{c+1}
A(c+1,:) = x(1:8);
B(c+1,1) = x(9);
c = c + 1;
ha{c} = h;
P{1,1} = 10e3*eye(size(x,2));
a{1,1} = zeros(size(x,2),1);

for h=2:size(data,1)
    %% Read (x,y)[h]
    x = granulating(data(h,:));
    %% Provide single-value approximation p(x[h])
    for i=1:c
        for j=1:8
            ux(i,j) = trapmf(mp(x(j)),[A{i,j}]);
        end
        [a{i} P{i}] = RLS(a{i},P{i},x(1:8),x(9));
        pi(i) = a{i}'*[1; mp(x(1:8))'];
    end
    p = sum(min(ux').*pi)/(sum(min(ux')));
    %% Provide granular approximation B{i*} - convex hull
    convex = [];
    for i=1:c
        uy(i) = trapmf(mp(x(9)),[B{i}]);
        if uy(i)~=0
            convex = [convex; B{i}];
        end
    end
    if ~isempty(convex)
        ch_B = [min(convex(:,1)) min(convex(:,2)) max(convex(:,3)) max(convex(:,4))];
    end
    %% Calculate output error eps[h] = mp(y[h]) - p(x[h])
    eps = mp(x(9)) - p;
    %% check expanded regions E{i}
    aux = 0;
    for i=1:c
        % x[h]
        for j=1:8
            E{i,j} = exp_region(A(i,j),rho);
            if ~((mp(x(j)) >= E{i,j}(1)) && (mp(x(j)) <= E{i,j}(2)))
                aux = 1;
                break;
            end
        end
        % y[h]
        j = j + 1;
        E{i,j} = exp_region(B(i),rho);
        if ~((mp(x(j)) >= E{i,j}(1)) && (mp(x(j)) <= E{i,j}(2)))
            aux = 1;
        end
        if  isequal(aux,1) break;
        end
    end
    %% x[h] or y[h] is not into granules' expanded regions E{i} for all i
    % i.e. aux = 1
    if  isequal(aux,1)
        % Create granule Gamma{c+1}
        A(c+1,:) = x(1:8);
        B(c+1,1) = x(9);
        c = c + 1;
        ha{c} = h;
        P{c,1} = 10e3*eye(size(x,2));
        a{c,1} = zeros(size(x,2),1);
    else
        iS = index_most_active(x,A);
        ha{iS} = h;
        for j=1:8
            A = updating(x{j},A(is,j),rho);
        end
        B = updating(x{j},B(is,1),rho);
        
        for i=1:c
            for j=1:8
                ux(i,j) = trapmf(mp(x(j)),[A{i,j}]);
            end
            [a{i} P{i}] = RLS(a{i},P{i},x(1:8),x(9));
            pi(i) = a{i}'*[1; mp(x(1:8))'];
        end
        p = sum(min(ux').*pi)/(sum(min(ux')));
    end
    if isequal(mod(h,hr),0)
        %% Combine granules when feasible
        S = similarity_meas(A);
        for i=1:size(A,1)
            for j=1:size(A,1)
                if (j > i) && (S(i,j) > rho)
                    A(i,:) = update;
                    A(j,:) = [];
                    B(j,1) = [];
                    ha{j} = [];
                    c = c - 1;
                end
            end
        end
        %% Update model granularity, rho
        r = c - c_early;
        if r > etta
            rho = (1 + r/hr)*rho;
        else
            rho = (1 + (etta-r)/hr)*rho;
        end
        c_early = c;
        %% Remove inactive granules
        for i = 1:c
            Theta(i,1) = 2^(-psi*(h-ha{i}));
        end
        remov = find(Theta<=psi);
        Theta(remov) = [];
        A(remov,:) = [];
        B(remov,1) = [];
        c = c - size(remov,1);
    end
end