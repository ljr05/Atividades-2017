% algorithm c_Means
function [center,U,obj_fun] = cmeans(data,c,m,e)
n = size(data,1);               % number of data
center = rand(c,size(data,2));  % centers
k = 1;
while (1)
    % Updating the membership matrix
    U = zeros(c,n);
    for j=1:n
        for i=1:c
            dist = norm(center(i,:) - data(j,:));
            if dist == 0
                U(i,j) = 1;
                break;
            else
                s_d = 0;
                for l=1:c
                    s_d = s_d + (dist / norm(center(l,:) - data(j,:)))^(2/(m-1));
                end
                U(i,j) = 1 / s_d;
            end
        end
    end
    % Calculation of new cluster centers
    for i=1:c
        s_ux = 0;
        s_u = 0;
        for j=1:n
            s_ux = s_ux + (U(i,j)^m).*data(j,:);
            s_u = s_u + U(i,j)^m;
        end
        C(i,:) = s_ux./s_u;
    end
    % Calculation of error 
    aux = 0;
    for i=1:c
        if (norm(C(i,:) - center(i,:)) > e)
            aux = 1;
            break;
        end
    end
    % Updating the cluster centers
    center(1:c,:) = C(1:c,:);
    % Results of the objective function at k-th iteration
    obj_fun(k) = fun(center,U.^m,data);
    disp(['Iteration count = ',num2str(k),', obj.fcn = ',num2str(obj_fun(k))]);
    if (aux == 0)   break;
    else k = k + 1;
    end
end
end