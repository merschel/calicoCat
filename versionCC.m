%
% v = versionCC() 
%
% Print the version of the programm.
%
% Autor: Steve Merschel
% Date: 30/05/2014

function [v] = versionCC()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
versionNumber = 0;
projectNumber = 4;            
bugFixNumber  = 0;

text = '\n   CalicoCat %s\n\n';  

v = [num2str(versionNumber),'.',num2str(projectNumber),'.',num2str(bugFixNumber)];

if nargout == 1
    return
else
    fprintf(text,v)
end