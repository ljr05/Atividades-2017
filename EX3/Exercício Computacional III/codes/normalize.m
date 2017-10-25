function data = normalize(x)
for j=1:size(x,2)
    for i=1:size(x,1)
        data(i,j) = double(x(i,j)) / 255;
    end
end