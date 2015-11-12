%
% dxdt = f(t,x,k)
%
% The ode. 
%

function [dxdt J] = f_test(t,X,k)
% numberOfEquations = 3
% numberOfParameter = 10

a = k(1);
b = k(2);
c = k(3);
d = k(4);
e = k(5);
f = k(6);
g = k(7);
Kx = k(8);
m = k(9);
n = k(10);

x = X(1);
y = X(2);
z = X(3);

Ky = m*x*(Kx-x);
Kz = n*x*y;

dxdt = [ a*x-a*x^2/Kx-f*x*y/(x+d);
         b*y-b*y^2/Ky-g*y*z/(y+e);
         c*z-c*z^2/Kz];

if nargout == 2
    df1dx = a - 2*a*x/Kx - f*y/(x+d) + f*x*y/(x+d)^2;
    df1dy = -f*x/(x+d);
    df1dz = 0;
    
    df2dx = b*y^2/(m*x^2*(Kx-x))-b*y^2/(m*x*(Kx-x)^2);
    df2dy = b - 2*b*y/(m*x*(Kx-x)) - g*z/(y+e) + g*y*z/(y+e)^2;
    df2dz = -g*y/(y+e);
    
    df3dx = c*z^2/(n*x^2*y);
    df3dy = c*z^2/(n*x*y^2);
    df3dz = c - 2*c*z/(n*x*y);
    
    J = [df1dx df1dy df1dz; df2dx df2dy df2dz; df3dx df3dy df3dz];
end

end