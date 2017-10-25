% Algorithm c_Means applied in segmentation of images
close all; clear all; clc
figure
img = imread('img01.jpg');
imshow(img);
data = normalize(reshape(img,[],3));
alg = 0;                % 0: matlab function;   1: implemented function
for c = 5:5             % number of clusters
    m = 2;              % power of the membership
    if alg == 0
        [center, U, obj_fun{c-1}] = fcm(data, c);           % matlab function
    else
        e = 1e-3;       % maximum error
        [center, U, obj_fun{c-1}] = cmeans(data, c, m, e);	% implemented function
    end
    for j=1:size(data,1)
        [x i] = max(U(:,j));
        new_data(j,:) = center(i,:);
    end
    new_img = reshape(uint8(new_data*255),[size(img,1),size(img,2),size(img,3)]);
    figure
    imshow(new_img);
end
% trajectories of the objective function for each number of clusters
figure
hold on
for i=1:c-1
    plot(obj_fun{i},':x')
end
xlabel('Number of iteration');
ylabel('Value of the objective function');
% legend('c=2','c=3','c=4','c=5','c=6');
% axis([1 60 0 4000]);   % image 1
% axis([1 80 0 4000]);   % image 2
% axis([1 55 0 1000]);    % image 3