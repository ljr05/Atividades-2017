%% Create granulated data
function x_granulated = granulating(x,perc)
for i=1:size(x,2)
    l = x(i) - perc;
    lambda = x(i);
    Lambda = x(i);
    L = x(i) + perc;
    x_granulated{1,i} = [l lambda Lambda L];
end
end