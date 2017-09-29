close all; clear all; clc
% data = load('fcmdata.dat');
figure
img = imread('img01.jpg');
imshow(img);
data = normalize(reshape(img,[],3));
e = 1e-4;               % maximum error
for c = 2:6
%     c = 5;              % number of clusters
    m = 2;              % power of the membership
%     [center, U, obj_fun{c-1}] = fcm(data, c);
    [center,U,obj_fun{c-1}] = cmeans(data, c, m, e);
    for j=1:size(data,1)
        [x i] = max(U(:,j));
        new_data(j,:) = center(i,:);
    end
    new_img = reshape(uint8(new_data*255),[size(img,1),size(img,2),size(img,3)]);
    figure
    imshow(new_img);
end
figure
hold on
for i=1:c-1
    plot(obj_fun{i},':x')
end
xlabel('Number of iteration');
ylabel('Value of the objective function');
legend('c=2','c=3','c=4','c=5','c=6');
axis([1 60 0 4000]);    % image 1
% axis([1 90 0 4000]);   % image 2
% axis([1 50 0 1000]);   % image 3

% plot(data(:,1),data(:,2),'o');
% xlabel('$x_1$','Interpreter','latex');
% ylabel('$x_2~~~~$','Interpreter','latex','rotation',0);
% hold on
% plot(center(:,1),center(:,2),'*k');