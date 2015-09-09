%
% logger(type,text,preference)
%
% A simple logger. 
%
% Autor: Steve Merschel
% Date: 19/08/2015

function logger(type,text,preference)
switch type
    case 'info'
        write(type,text,preference.logger.stream.info)
    case 'error'
        write(type,text,preference.logger.stream.error)
    otherwise
        error(['logger: type ',type,' not known!'])
end
end

function write(type,text,stream)
c = clock;
try
    fprintf(stream,'%d-%d-%d %d:%d:%d %s: %s\n',c(1),c(2),c(3),c(4),c(5),round(c(6)),type,text);
catch e
    e
end
end