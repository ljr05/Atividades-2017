%% Federal University of Minas Gerais
% Luiz Queiroz, Pedro Coutinho, Rodrigo Araújo
% Fuzzy Set Based Evolving Modeling (FBeM) Algorithm
%% Reading data
close all; clear all; clc;
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
c = c+1;

for h=2:size(data,1)
    x = data(h,:);
    for i=1:c
        for j=1:8
            u(i,j) = trapmf(x(j),[A{i,j}]);
        end
        pi(i) = funtional(x);
    end
    p = sum(min(u)'.*pi)/(sum(min(u)));
    
end

%% Create membership A and B
function memb_input = create_memb(x)
perc = 0.02;
l = (1-perc)*x;
lambda = x;
Lambda = x;
L = (1+perc)*x;
memb_input = [l lambda Lambda L];
end
%% Fazer
function pi = funtional(x)
pi = x(1);
end