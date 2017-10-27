clear ux
for k=1:size(data,1)
    x = granulating(data(i,:));
    for i=1:c
        for j=1:n
            if in_exp_region(x(j),A(i,j),rho)
                ux(i,j) = similarity_meas_data(x(j), A(i,j));
            else ux(i,j) = 0;
            end
        end
    end
    w = min(ux);
    y(k) = 0;
    for i=1:c
        y(k) = y(k) + w(i)*a{i,1}'*[1 mp(x(1:8))]';
    end
    y(k) = y(k)/sum(w);
end