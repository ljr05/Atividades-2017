function y = fun(center,U,data)
c = size(center,1);     % number of clusters
n = size(data,1);       % number of data
y = 0;
for i=1:c
    for j=1:n
        y = y + U(i,j)*norm(center(i,:) - data(j,:))^2;
    end
end