%% Midpoint of trapezoids
function M = mp(x)
for i=1:size(x,2)
    a = x{i}(3) - x{i}(2);
    b = x{i}(4) - x{i}(1);
    c = x{i}(2) - x{i}(1);
    if ~(a + b == 0)
        M(i) = (2*a*c + a^2 + c*b + a*b + b^2)/(3*(a+b)) + x{i}(1);
    else
        M(i) = x{i}(1);
    end
end
end