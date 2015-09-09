%
% v = versionMonte() 
%
% Print the version of the programm.
%
% Autor: Steve Merschel
% Date: 30/05/2014

function [v] = versionMonte()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
projectNumber = 0;            
versionNumber = 1;            
text = '\n   Monte %s\n\n';     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
%%%%%%%%%%% chain vector %%%%%%%%%%%%%    
numberOfPrimes = 8;
m = 2;
n = 0;
while(n<numberOfPrimes)
    p = primes(m);
    n = length(p);
    m = m + 1;
end
x = [projectNumber p];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y = chainfrac(x);
v=y-mod(y*10^versionNumber,1)/(10^versionNumber);
if nargout == 1
    return;
else
    fprintf(text,num2str(v))
end
end

function y=chainfrac(x)
n = length(x);
y = x(n);    
for i = n:-1:1
    y = x(i)+1/y;
end
end