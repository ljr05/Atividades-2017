%% Federal University of Minas Gerais
% Luiz Queiroz, Pedro Coutinho, Rodrigo Araújo
% Fuzzy Set Based Evolving Modeling (FBeM) Algorithm

%% Reading data
% close all; 
clear all; clc;
data = xlsread('Concrete_Data.xls');

% Inserting lag of output in input data
X = [data(2:end,1:8) data(1:end-1,9)];
Y = data(2:end,9);

% Discarding outliers
stand = 4;
[X, Y] = discarding_outliers(X,Y,stand);
[Y, X] = discarding_outliers(Y,X,stand);

% Normalizing data
Unc = 0.02;
X = normalize_data(X,Unc);
Y = normalize_data(Y,Unc);

n = size(X,2);                  % number of inputs
m = size(Y,2);                  % number of outputs
n_train = size(X,1);            % number of training pairs

%% Set parameters
rho = 0.9; hr = 40; etta = 2; psi = 1/40; c = 0;
c_early = 0;

%% Read (x,y)[h], h = 1
h = 1;
x = granulating(X(h,1:n), Unc);
y = granulating(Y(h,1:m), Unc);

%% Create granule Gamma{c+1}
A(c+1,:) = x(1:n);
B(c+1,:) = y(1:m);
c = c + 1;
C(h) = c;
ha(c) = h;
d_x{c} = h;
% a{c,1} = [mp(y), zeros(1,n)];                       % coefficients of c-th y_est (consequent functional)
a{c,1} = [y{1}(1), zeros(1,n)];                     % coefficients of c-th y_est (consequent functional)
p(h) = rand;

for h=2:n_train
    %% Read (x,y)[h]
    x = granulating(X(h,1:n), Unc);
    y = granulating(Y(h,1:m), Unc);
    %% Provide single-value approximation p(x[h])
    I = [];
    for i=1:c
        if in_exp_region(x,A(i,:),rho)
            I = [I,i];                              % rules that can accommodate x[h]
        end
        pi(i) = a{i,1}*[1; mp(x(1:n))'];            % estimated output of i-th rule
    end
    ux = similarity_meas_data(x, A);                % similarity measure
    if isequal(size(I,2),0)
        [~, I] = max(ux);
    end
    p(h) = sum(ux(I).*pi(I)')/(sum(ux(I)));         % global output
    PLB(h) = min(min([B{I}]));                      % granular - Lower bound
    PUB(h) = max(max([B{I}]));                      % granular - Upper bound
        
    %P must belong to [PLB PUB]
    if(p(h)<PLB(h))
        p(h) = PLB(h);
    end
    if(p(h)>PUB(h))
        p(h) = PUB(h);
    end
    %% check if x[h] and y[h] are into i-th expanded regions E
    I = [];
    for i=1:c
        if in_exp_region(x,A(i,:),rho) && in_exp_region(y,B(i,:),rho)
            I = [I,i];
        end
    end
    %% x[h] or y[h] is not into i-th granule's expanded regions E, i.e. size(I,2) = 0
    if  isequal(size(I,2),0)
        %% Create granule Gamma{c+1}
        A(c+1,:) = x(1:n);
        B(c+1,1) = y(1:m);
        c = c + 1;
        ha(c) = h;
        d_x{c} = [h];
%         a{c,1} = [mp(y), zeros(1,n)];             % coefficients of c-th y_est (consequent functional)
        a{c,1} = [y{1}(1), zeros(1,n)];             % coefficients of c-th y_est (consequent functional)
    else
        %% Adapt the most active granule Gamma{i}
        if (size(I,2) >= 2)
            iS = index_most_active(x,A);
        else iS = I;
        end
        ha(iS) = h;
        d_x{iS} = [d_x{iS} h];
        for j=1:n
            A{iS,j} = adapting(x{j},A{iS,j},rho);
            A{iS,j} = check_conctract(A{iS,j},rho);
        end
        for j=1:m
            B{iS,j} = adapting(x{j},B{iS,j},rho);
            B{iS,j} = check_conctract(B{iS,j},rho);
        end
        %% Adapt local function parameters a{i,j} using RLS
        a{iS,1} = ([ones(size(d_x{iS},2),1), X(d_x{iS},1:n)]\Y(d_x{iS},1:m))';
        if (a{iS,1}>-999999)
        else
%             a{iS,1} = [mp(y), zeros(1,n)];
            a{iS,1} = [y{1}(1), zeros(1,n)];
        end        
    end
    %% Remove inactive granules
    for i=1:c
        if (h - ha(i) > hr)
            A(i,:) = [];
            B(i,:) = [];
            a(i,:) = [];
            ha(i) = [];
            d_x(i) = [];
            c = c - 1;
            break;
        end
    end
    %% if h = alpha*hr,  alpha = 1, 2, ...
    if isequal(mod(h,hr),0)
        %% Combine granules when feasible
        if (c >= 3)
            [I_row, I_col] = most_similar_granules(A);
            New_gran = combine_granules(A(I_row,:),A(I_col,:));
            aux = 0;
            for j=1:n
                if ~((mp(New_gran(j)) - rho/2 <= New_gran{j}(1)) && (mp(New_gran(j)) + rho/2 >= New_gran{j}(4)))
                    aux = 1;
                    break;
                end
            end
            if isequal(aux,0)
                New_gran = combine_granules(B(I_row,:),B(I_col,:));
                for j=1:m
                    if ~((mp(New_gran(j)) - rho/2 <= New_gran{j}(1)) && (mp(New_gran(j)) + rho/2 >= New_gran{j}(4)))
                        aux = 1;
                        break;
                    end
                end
            end
            if isequal(aux,0)
                A(I_row,:) = combine_granules(A(I_row,:),A(I_col,:));
                A(I_col,:) = [];
                B(I_row,:) = combine_granules(B(I_row,:),B(I_col,:));
                B(I_col,:) = [];
                a{I_row,1} = 1/2 * (a{I_row,1} + a{I_col,1});
                a(I_col,:) = [];
                ha(I_row) = h;
                ha(:,I_col) = [];
                d_x{I_row} = [d_x{I_row} d_x{I_col}];
                d_x(I_col) = [];
                c = c - 1;
            end
        end
        %% Update model granularity rho
        r = c - c_early;
        if r > etta
            rho = (1 + r/hr)*rho;
        else
            rho = (1 - (etta+r)/hr)*rho;
        end
%         for i=1:c
%             for j=1:n
%                 A{i,j} = check_conctract(A{i,j},rho);
%             end
%         end
        %% Remove inactive granules
%         for i = 1:c
%             Theta(i,1) = 2^(-psi*(h-ha{i}));
%         end
%             remov = find(Theta<=1/psi,1);
%         Theta(remov) = [];
%         ha = ha + 1;
%         for i=1:c
%             if (h - ha(i) >= hr)
%                 A(i,:) = [];
%                 B(i,:) = [];
%                 a(i,:) = [];
%                 ha(i) = [];
%                 d_x(i) = [];
%                 c = c - 1;
%                 break;
%             end
%         end
        c_early = c;
    end
    for i=1:c
        for j=1:n
            A{i,j} = check_conctract(A{i,j},rho);
        end
    end
    C(h) = c;
end
disp(mean(C));
disp(rho);
plot(p)
hold on
plot(Y)
figure
plot(C)