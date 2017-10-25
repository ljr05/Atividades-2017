% Test of the algorithm c_Means
close all; clear all; clc
data = load('fcmdata.dat');
alg = 1;            % 0: matlab function;   1: implemented function
c = 4;              % number of clusters
m = 2;              % power of the membership
if alg == 0
    [center, U, obj_fun] = fcm(data, c);                % matlab function
else
    e = 1e-3;       % maximum error
    [center, U, obj_fun] = cmeans(data, c, m, e);       % implemented function
end

figure
plot(data(:,1),data(:,2),'o');
hold on
plot(center(:,1),center(:,2),'*k');
xlabel('$x_1$','Interpreter','latex');
ylabel('$x_2~~~~$','Interpreter','latex','rotation',0);
legend('Data','Cluster centers');