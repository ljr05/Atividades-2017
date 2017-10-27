%% Similarity measure between data and granule
function S = similarity_meas_data(x,A)
S = zeros(size(A,1),1);
n = size(x,2);
% if n > 1
%     n = n -1;
% end
for i=1:size(A,1)
    for j=1:n
        for k=1:4
            S(i) = S(i) + abs(x{j}(k) - A{i,j}(k));
        end
    end
    % Similarity measure
    S(i) = 1-1/(4*n)*S(i);
end
end