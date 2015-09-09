%
% row = findIntervall(A,value)
% 
% Find the intervall which the value 'value' contains. 
% 'A' is a matrix which contains a some intervalls.
%
%     | 1 2 |   (in this example 'A' have 3 intervalls
% A = | 2 5 |    first from 1 to 2, second from 2 to 5  
%     | 5 8 |    and third from 5 to 8)
%
% The first value of an intervall is inclusiv and the 
% second value is exclusiv. For example is 'value' = 2 
% then return the function 2 for the second intervall.
% If the value smaller then the first value of the first 
% intervall then the function will return 1 for the first
% intervall. If the value bigger then the second value of 
% the last intervall then the function will return n for 
% the last intervall. With n = number of intervalls.
% If the function can't find a intervall it will return -1. 
%
% Autor: Steve Merschel
% Date : 29/05/2014

function row = findIntervall(A,value)
n = size(A,1);
% if 'value' smaller then the first value of the first intervall
if(value<=A(1,1)) 
    row = 1;
    return
end

% if 'value' bigger then the second value of the last intervall
if(value>=A(n,2))
    row=n;
    return
end

% search the intervall 
row = -1;
for i = 1:n
    if(value>=A(i,1) && value<A(i,2))
        row = i;
        break;
    end
end
end