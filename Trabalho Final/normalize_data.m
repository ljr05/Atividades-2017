function Xnorm = normalize_data(X)
Xnorm = zeros(size(X,1), size(X,2));
for i = 1:size(X,2)
    Xnorm(:,i) = (X(:,i)-min(X(:,i)))/(max(X(:,i))-min(X(:,i)));
end
end