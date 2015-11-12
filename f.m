%
% dxdt = f(t,x,k)
%
% The ode. 
%

function [dxdt J] = f(t,x,k)
% numberOfEquations = 2
% numberOfParameter = 3

%dxdt = [k(1)*x(1)];


%dxdt = [k(1)*sin(t)-k(2)*sin(x(1))];

%dxdt = [k(1)*sin(t)-sin(x(1))];

dxdt = [x(1)*sin(t*x(1)+k(1)*x(2))+k(3)*cos(t)
        x(2)*cos(t*x(2)+k(2)*x(1))+k(3)*sin(t)];

if nargout == 2
    J = [sin(t*x(1)+k(1)*x(2)) + x(1)*t*cos(t*x(1)+k(1)*x(2)),  x(1)*k(1)*cos(t*x(1)+k(1)*x(2));
         -x(2)*k(2)*sin(t*x(2)+k(2)*x(1)), cos(t*x(2)+k(2)*x(1)) - x(2)*t*sin(t*x(2)+k(2)*x(1))];
end

 %dxdt = [x(1)*(k(1)-x(1));
 %           x(2)*(k(2)*k(1)-x(1))
 %           x(3)*x(2)-x(1)*x(4)
 %           x(1)-x(4)+sin(x(2))];
end