%% Similarity measure between granules
function S = similarity_meas(A)
S = zeros(size(A,1),size(A,1));
n = size(A,2);
for i1=1:size(A,1)
    for i2=1:size(A,1)
        if (i2 > i1)
            aux = 0;
            for j=1:n
                for k=1:4
                    aux = aux + abs(A{i1,j}(k) - A{i2,j}(k));
                end
            end
            % Similarity measure
            S(i1,i2) = 1 - (1/(4*n))*aux;
        end
    end
end
end