%% Discard outliers
function [x, y] = discarding_outliers(x,y,k)
h = 1;            
Mean = mean(x);
Stand = std(x);
while (h <= size(x,1))
    for j=1:size(x,2)
        if ((x(h,j) < Mean(j)-k*Stand(j)) || (x(h,j) > Mean(j)+k*Stand(j)))
            x(h,:) = [];
            y(h) = [];
            h = h - 1;
            break;
        end
    end
    h = h + 1;
end