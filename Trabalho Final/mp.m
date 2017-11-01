%% Midpoint of trapezoids granules
function M = mp(x)
for i=1:size(x,2)
    M(i) = (x{i}(2) + x{i}(3))/2;
end
end