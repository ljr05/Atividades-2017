%% Federal University of Minas Gerais
% Luiz Queiroz, Pedro Coutinho, Rodrigo Araújo
% Fuzzy Set Based Evolving Modeling (FBeM) Algorithm
%% Reading data
data = xlsread('Concrete_Data.xls');
%% Parameters initialization
rho = 0.45;
hr = 40;
etta = 2;
psi = 1/40;
c = 0;
%% Read (x,y)[h], h = 1;
h = 1;
x = data(h,:);
%% Create granule
for j=1:8
    A{c+1,j} = create_memb(x(j));
end
B{c+1} = create_memb(x(j+1));


function memb_input = create_memb(x)
perc = 0.02;
l = (1-perc)*x;
lambda = x;
Lambda = x;
L = (1+perc)*x;
memb_input = [l lambda Lambda L];
end