%% Create granulated data
function x_granulated = granulating(x)
perc = 0.02;
for i=1:size(x,2)
    l = (1-perc)*x(i);
    lambda = x(i);
    Lambda = x(i);
    L = (1+perc)*x(i);
    x_granulated{1,i} = [l lambda Lambda L];
end
end