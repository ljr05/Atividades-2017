%% Recursive Least Squared Method
function [Omega,P] = RLS(Omega,P,x,y)
X = [1, mp(x(1:8))]';
Y = mp(y);
I = eye(size(X,1));
P = P*(I-(X*X'*P)/(1+X'*P*X));
Omega = Omega + P*X*(Y-X'*Omega);
end