%
% dxdt = f(t,x,k)
%
% The ode. 
%

function [dxdt J] = f_pandel(t,x,k)
% numberOfEquations = 2
% numberOfParameter = 2

dxdt = [x(2);
        -k(1)*x(2)-k(2)*sin(x(1))];

if nargout == 2
    J = [0 1; -k(2)*cos(x(1)) -k(1)];
end

end