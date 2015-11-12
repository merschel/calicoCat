function dxdt = f_temp(~,x,k)
% numberOfEquations = 2
% numberOfParameter = 6

% Zustaende
T1 = x(1);
T2 = x(2);

% Parameter
m1 = k(1);
m2 = k(2);
c1 = k(3);
c2 = k(4);
alpha = k(5);
A = k(6);

% Zwischenfunktionen 


% DGLs
dxdt(1,1) = alpha*A / (1000*m1*c1) * (T2 - T1);
dxdt(2,1) = alpha*A / (1000*m2*c2) * (T1 - T2);

end