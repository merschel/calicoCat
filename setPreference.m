%
% preference = setPreference(odeHandle,newPreference)
%
% Set the preference of the program. If the user do not set any options the
% function set the default parameter.
%
% Autor: Steve Merschel
% Date: 30/05/2014
%
% TODO: + Check the user settings
%       + more preference

function preference = setPreference(newPreference)
%% logger
if isfield(newPreference,'logger') && isfield(newPreference.logger,'stream') && isfield(newPreference.logger.stream,'info')
    try
        preference.logger.stream.info = fopen(newPreference.logger.stream.info,'a');
        if preference.logger.stream.info == -1
            preference.logger.stream.info = 1;  % if it goes wrong to open or create the file
        end
    catch e
        preference.logger.stream.info = 1; % if it goes wrong in the try catch
    end
else
    preference.logger.stream.info = 1; %<-- default (console)
end

if isfield(newPreference,'logger') && isfield(newPreference.logger,'stream') && isfield(newPreference.logger.stream,'error')
    try
        preference.logger.stream.error = fopen(newPreference.logger.stream.error,'a');
        if preference.logger.stream.error == -1
            preference.logger.stream.error = 1; % if it goes wrong to open or create the file
        end
    catch e
        preference.logger.stream.error = 1; % if it goes wrong in the try catch
    end
else
    preference.logger.stream.error = 1; %<-- default (console)
end

%% console
if isfield(newPreference,'console') && isfield(newPreference,'clc')
    if newPrefernce.console.clc
        clc;
    end
else
    clc; %<-- default
end

if isfield(newPreference,'console') && isfield(newPreference,'closeAll')
    if newPrefernce.console.clc
        close all;
    end
else
    close all; %<-- default
end

logger('info','+++++++++++++++++++++++++++++++++++++',preference)
logger('info','Strart program and set the preference',preference)
logger('info',['Version ',versionCC()],preference)
%% ODE
logger('info','Set ode.solver',preference)
if isfield(newPreference,'ode') && isfield(newPreference.ode,'solver')
    preference.ode.solver = newPreference.ode.solver;
else
    preference.ode.solver = @ode15s; %<-- default
end

logger('info','Set ode.options',preference)
if isfield(newPreference,'ode') && isfield(newPreference.ode,'options')
    preference.ode.options = newPreference.ode.options;
else
    preference.ode.options = []; %<-- default
end

logger('info','Set ode.f',preference)
if isfield(newPreference,'ode') && isfield(newPreference.ode,'f')
    preference.ode.f = newPreference.ode.f;
else
    preference.ode.f = @f; % <-- default
end


logger('info','Analyze the ODE',preference)
[numberOfEquations, numberOfParameter] = odeAnalyzer(preference.ode.f);
if numberOfEquations == -1 || numberOfParameter == -1
    preference = -1;
    logger('error','The Comments "%numberOfEquations" or "%numberOfParameter" could not be found!!!',preference)
    return
end

preference.ode.numberOfEquations = numberOfEquations;
preference.ode.numberOfParameter = numberOfParameter;

logger('info',['Set numberOfEquations to ',num2str(numberOfEquations)],preference)
logger('info',['Set numberOfParameter to ',num2str(numberOfParameter)],preference)

%% Compute
logger('info','Set compute.solution',preference)
if isfield(newPreference,'compute') && isfield(newPreference.compute,'solution')
    preference.compute.solution = newPreference.compute.solution;
else
    preference.compute.solution = 1; %<-- default
end

logger('info','Set compute.density',preference)
if isfield(newPreference,'compute') && isfield(newPreference.compute,'density')
    preference.compute.density = newPreference.compute.density;
else
    preference.compute.density = 1; %<-- default
end

%% main settings
logger('info','Set numberOfSimulations',preference)
if isfield(newPreference,'numberOfSimulations')
    preference.numberOfSimulations = newPreference.numberOfSimulations;
else
    preference.numberOfSimulations = 100; %<-- default
end

logger('info','Set simulationTime',preference)
if isfield(newPreference,'simulationTime')
    preference.simulationTime = newPreference.simulationTime;
else
    preference.simulationTime = [0 1]; %<-- default
end

logger('info','Set deltaT',preference)
if isfield(newPreference,'deltaT')
    preference.deltaT = newPreference.deltaT;
else
    preference.deltaT = 0.1; %<-- default
end

logger('info','Set deltaX',preference)
if isfield(newPreference,'deltaX')
    preference.deltaX = newPreference.deltaX;
else
    preference.deltaX = 0.1; %<-- default
end

logger('info','Set parallel',preference)
if isfield(newPreference,'parallel')
    preference.parallel = newPreference.parallel;
else
    preference.parallel = 0; %<-- default
end

%% Initial conditons
logger('info','Set inic.interval',preference)
if isfield(newPreference,'inic') && isfield(newPreference.inic,'interval')
    if numberOfEquations > 1 && length(newPreference.inic.interval) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.inic.interval{1};
        end
        preference.inic.interval = h;
    else
        preference.inic.interval = newPreference.inic.interval;
    end
else
    h = cell(numberOfEquations,1);
    for i = 1:numberOfEquations
        h{i} = {0 1}; %<-- default
    end
    preference.inic.interval = h;
end

logger('info','Set inic.distribution',preference)
if isfield(newPreference,'inic') && isfield(newPreference.inic,'distribution')
    if numberOfEquations > 1 && length(newPreference.inic.distribution) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.inic.distribution{1};
        end
        preference.inic.distribution = h;
    else
        preference.inic.distribution = newPreference.inic.distribution;
    end
else
    h = cell(numberOfEquations,1);
    for i = 1:numberOfEquations
        h{i} = 'uniformly';  %<-- default
    end
    preference.inic.distribution = h;
end

%% Parameter
logger('info','Set para.interval',preference)
if isfield(newPreference,'para') && isfield(newPreference.para,'interval')
    if numberOfParameter > 1 && length(newPreference.para.interval) == 1
        h = cell(numberOfParameter,1);
        for i = 1:numberOfParameter
            h{i} = newPreference.para.interval{1};
        end
        preference.para.interval = h;
    else
        preference.para.interval = newPreference.para.interval;
    end
else
    h = cell(numberOfParameter,1);
    for i =1:numberOfParameter
        h{i} = {0 1}; %<-- default
    end
    preference.para.interval = h;
end

logger('info','Set para.distribution',preference)
if isfield(newPreference,'para') && isfield(newPreference.para,'distribution')
    if numberOfParameter > 1 && length(newPreference.para.distribution) == 1
        h = cell(numberOfParameter,1);
        for i = 1:numberOfParameter
            h{i} = newPreference.para.distribution{1};
        end
        preference.para.distribution = h;
    else
        preference.para.distribution = newPreference.para.distribution;
    end
else
    h = cell(numberOfParameter,1);
    for i = 1:numberOfParameter
        h{i} = 'uniformly'; %<-- default
    end
    preference.para.distribution = h;
end

%% Seperation
logger('info','Set seperation.value.interval',preference)
if isfield(newPreference,'seperation') && isfield(newPreference.seperation,'value') && isfield(newPreference.seperation.value,'interval')
    n = length(newPreference.seperation.value.interval);
    for k = 1:n
        if numberOfEquations > 1 && length(newPreference.seperation.value.interval{k}) == 1
            h = cell(numberOfEquations,1);
            for i = 1:numberOfEquations
                h{i} = newPreference.seperation.value.interval{k}{1};
            end
            preference.seperation.value.interval{k} = h;
        else
            preference.seperation.value.interval{k} = newPreference.seperation.value.interval{k};
        end
    end
else
    h = cell(numberOfEquations,1);
    for i = 1:numberOfEquations
        h{i} = {preference.inic.interval{i}{1} preference.inic.interval{i}{2}};  %<-- default
    end
    preference.seperation.value.interval{1} = h;
end

logger('info','Set seperation.value.time',preference)
if isfield(newPreference,'seperation') && isfield(newPreference.seperation,'value') && isfield(newPreference.seperation.value,'time')
    n = length(newPreference.seperation.value.time);
    for k = 1:n
        if numberOfEquations > 1 && length(newPreference.seperation.value.time{k}) == 1
            h = cell(numberOfEquations,1);
            for i = 1:numberOfEquations
                h{i} = newPreference.seperation.value.time{k}{1};
            end
            preference.seperation.value.time{k} = h;
        else
            preference.seperation.value.time{k} = newPreference.seperation.value.time{k};
        end
    end
else
    n = length(preference.seperation.value.interval);
    for k = 1:n
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = preference.simulationTime(1);  %<-- default
        end
        preference.seperation.value.time{k} = h;
    end
end

logger('info','Set seperation.para.interval',preference)
if isfield(newPreference,'seperation') && isfield(newPreference.seperation,'para') && isfield(newPreference.seperation.para,'interval')
    n = length(newPreference.seperation.para.interval);
    for k = 1:n
        if numberOfParameter > 1 && length(newPreference.seperation.para.interval{k}) == 1
            h = cell(numberOfParameter,1);
            for i = 1:numberOfParameter
                h{i} = newPreference.seperation.para.interval{k}{1};
            end
            preference.seperation.para.interval{k} = h;
        else
            preference.seperation.para.interval{k} = newPreference.seperation.para.interval{k};
        end
    end
else
    h = cell(numberOfParameter,1);
    for i = 1:numberOfParameter
        h{i} = {preference.para.interval{i}{1} preference.para.interval{i}{2}};  %<-- default
    end
    preference.seperation.para.interval{1} = h;
end

%% Viewer
logger('info','Set viewer.density3d.show',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'density3d') && isfield(newPreference.viewer.density3d,'show')
    if numberOfEquations > 1 && length(newPreference.viewer.density3d.show) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.viewer.density3d.show{1};
        end
        preference.viewer.density3d.show = h;
    else
        preference.viewer.density3d.show = newPreference.viewer.density3d.show;
    end
else
    h = cell(numberOfEquations,1);
    for i = 1:numberOfEquations
        h{i} = 0; %<-- default
    end
    preference.viewer.density3d.show = h;
end

logger('info','Set viewer.density3d.color',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'density3d') && isfield(newPreference.viewer.density3d,'color')
    if numberOfEquations > 1 && length(newPreference.viewer.density3d.color) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.viewer.density3d.color{1};
        end
        preference.viewer.density3d.color = h;
    else
        preference.viewer.density3d.color = newPreference.viewer.density3d.color;
    end
else
    h = cell(numberOfEquations,1);
    for i=1:numberOfEquations
        h{i} = 'jet'; %<-- default
    end
    preference.viewer.density3d.color = h;
end

logger('info','Set viewer.density3d.xlabel',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'density3d') && isfield(newPreference.viewer.density3d,'xlabel')
    if numberOfEquations > 1 && length(newPreference.viewer.density3d.xlabel) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.viewer.density3d.xlabel{1};
        end
        preference.viewer.density3d.xlabel = h;
    else
        preference.viewer.density3d.xlabel = newPreference.viewer.density3d.xlabel;
    end
else
    h = cell(numberOfEquations,1);
    for i=1:numberOfEquations
        h{i} = 't'; %<-- default
    end
    preference.viewer.density3d.xlabel = h;
end

logger('info','Set viewer.density3d.ylabel',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'density3d') && isfield(newPreference.viewer.density3d,'ylabel')
    if numberOfEquations > 1 && length(newPreference.viewer.density3d.ylabel) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.viewer.density3d.ylabel{1};
        end
        preference.viewer.density3d.ylabel = h;
    else
        preference.viewer.density3d.ylabel = newPreference.viewer.density3d.ylabel;
    end
else
    h = cell(numberOfEquations,1);
    for i=1:numberOfEquations
        h{i} = 'x'; %<-- default
    end
    preference.viewer.density3d.ylabel = h;
end

logger('info','Set viewer.density3d.zlabel',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'density3d') && isfield(newPreference.viewer.density3d,'zlabel')
    if numberOfEquations > 1 && length(newPreference.viewer.density3d.zlabel) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.viewer.density3d.zlabel{1};
        end
        preference.viewer.density3d.zlabel = h;
    else
        preference.viewer.density3d.zlabel = newPreference.viewer.density3d.zlabel;
    end
else
    h = cell(numberOfEquations,1);
    for i=1:numberOfEquations
        h{i} = 'p'; %<-- default
    end
    preference.viewer.density3d.zlabel = h;
end

logger('info','Set viewer.density3d.title',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'density3d') && isfield(newPreference.viewer.density3d,'title')
    if numberOfEquations > 1 && length(newPreference.viewer.density3d.title) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.viewer.density3d.title{1};
        end
        preference.viewer.density3d.title = h;
    else
        preference.viewer.density3d.title = newPreference.viewer.density3d.title;
    end
else
    h = cell(numberOfEquations,1);
    for i=1:numberOfEquations
        h{i} = sprintf('Density for equation %d',i); %<-- default
    end
    preference.viewer.density3d.title = h;
end

logger('info','Set viewer.density3d.relative',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'density3d') && isfield(newPreference.viewer.density3d,'relativ')
    if numberOfEquations > 1 && length(newPreference.viewer.density3d.relativ) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.viewer.density3d.relativ{1};
        end
        preference.viewer.density3d.relativ = h;
    else
        preference.viewer.density3d.relativ = newPreference.viewer.density3d.relativ;
    end
else
    h = cell(numberOfEquations,1);
    for i =1:numberOfEquations
        h{i} = 1; %<-- default
    end
    preference.viewer.density3d.relativ = h;
end

logger('info','Set viewer.density3d.zoom',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'density3d') && isfield(newPreference.viewer.density3d,'zoom')
    if numberOfEquations > 1 && length(newPreference.viewer.density3d.zoom) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.viewer.density3d.zoom{1};
        end
        preference.viewer.density3d.zoom = h;
    else
        preference.viewer.density3d.zoom = newPreference.viewer.density3d.zoom;
    end
else
    h = cell(numberOfEquations,1);
    for i=1:numberOfEquations
        h{i} = []; %<-- default
    end
    preference.viewer.density3d.zoom = h;
end

logger('info','Set viewer.density.show',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'density') && isfield(newPreference.viewer.density,'show')
    if numberOfEquations > 1 && length(newPreference.viewer.density.show) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.viewer.density.show{1};
        end
        preference.viewer.density.show = h;
    else
        preference.viewer.density.show = newPreference.viewer.density.show;
    end
else
    h = cell(numberOfEquations,1);
    for i = 1:numberOfEquations
        h{i} = 1; %<-- default
    end
    preference.viewer.density.show = h;
end

logger('info','Set viewer.density.color',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'density') && isfield(newPreference.viewer.density,'color')
    if numberOfEquations > 1 && length(newPreference.viewer.density.color) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.viewer.density.color{1};
        end
        preference.viewer.density.color = h;
    else
        preference.viewer.density.color = newPreference.viewer.density.color;
    end
else
    h = cell(numberOfEquations,1);
    for i = 1:numberOfEquations
        h{i} = 'jet'; %<-- default
    end
    preference.viewer.density.color = h;
end

logger('info','Set viewer.density.xlabel',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'density') && isfield(newPreference.viewer.density,'xlabel')
    if numberOfEquations > 1 && length(newPreference.viewer.density.xlabel) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.viewer.density.xlabel{1};
        end
        preference.viewer.density.xlabel = h;
    else
        preference.viewer.density.xlabel = newPreference.viewer.density.xlabel;
    end
else
    h = cell(numberOfEquations,1);
    for i=1:numberOfEquations
        h{i} = 't'; %<-- default
    end
    preference.viewer.density.xlabel = h;
end

logger('info','Set viewer.density.ylabel',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'density') && isfield(newPreference.viewer.density,'ylabel')
    if numberOfEquations > 1 && length(newPreference.viewer.density.ylabel) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.viewer.density.ylabel{1};
        end
        preference.viewer.density.ylabel = h;
    else
        preference.viewer.density.ylabel = newPreference.viewer.density.ylabel;
    end
else
    h = cell(numberOfEquations,1);
    for i=1:numberOfEquations
        h{i} = 'x'; %<-- default
    end
    preference.viewer.density.ylabel = h;
end

logger('info','Set viewer.density.title',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'density') && isfield(newPreference.viewer.density,'title')
    if numberOfEquations > 1 && length(newPreference.viewer.density.title) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.viewer.density.title{1};
        end
        preference.viewer.density.title = h;
    else
        preference.viewer.density.title = newPreference.viewer.density.title;
    end
else
    h = cell(numberOfEquations,1);
    for i=1:numberOfEquations
        h{i} = sprintf('Density for equation %d',i); %<-- default
    end
    preference.viewer.density.title = h;
end

logger('info','Set viewer.density.zoom',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'density') && isfield(newPreference.viewer.density,'zoom')
    if numberOfEquations > 1 && length(newPreference.viewer.density.zoom) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.viewer.density.zoom{1};
        end
        preference.viewer.density.zoom = h;
    else
        preference.viewer.density.zoom = newPreference.viewer.density.zoom;
    end
else
    h = cell(numberOfEquations,1);
    for i=1:numberOfEquations
        h{i} = []; %<-- default
    end
    preference.viewer.density.zoom = h;
end

logger('info','Set viewer.solPlot.show',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'solPlot') && isfield(newPreference.viewer.solPlot,'show')
    if numberOfEquations > 1 && length(newPreference.viewer.solPlot.show) == 1
        n = numberOfEquations*(numberOfEquations+1)*(numberOfEquations+2)/6;
        h = cell(n,1);
        count1 = 0;
        count2 = numberOfEquations;
        count3 = (numberOfEquations^2+numberOfEquations)/2;
        count4 = numberOfEquations^2;
        for i = 1:numberOfEquations
            count1 = count1 + 1;
            h{count1} = {0,i};
            for j = i+1:numberOfEquations
                count2 = count2 + 1;
                h{count2} = {i,j};
                count3 = count3 + 1;
                h{count3} = {0,i,j};
                for k = j+1:numberOfEquations
                    count4 = count4 + 1;
                    h{count4} = {i,j,k};
                end
            end
        end
        preference.viewer.solPlot.show = h;
    else
        preference.viewer.solPlot.show = newPreference.viewer.solPlot.show;
    end
else
    n = (numberOfEquations^2+numberOfEquations)/2;
    h = cell(n,1);
    count = numberOfEquations;
    for i = 1:numberOfEquations
        h{i} = {0, i};
        for j = i+1:numberOfEquations
            count = count + 1;
            h{count} = {i,j};  %<-- default
        end
    end
    preference.viewer.solPlot.show = h;   
end

logger('info','Set viewer.solPlot.color',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'solPlot') && isfield(newPreference.viewer.solPlot,'color')
    if numberOfEquations > 1 && length(newPreference.viewer.solPlot.color) == 1
        n = length(preference.viewer.solPlot.show);
        h = cell(n,1);
        for i = 1:n
            h{i} = newPreference.viewer.solPlot.color;
        end
        preference.viewer.solPlot.color = h;
    else
        preference.viewer.solPlot.color = newPreference.viewer.solPlot.color;
    end
else
    n = length(preference.viewer.solPlot.show);
    h = cell(n,1);
    for i = 1:n
        h{i} = 'blue'; %<-- default
    end
    preference.viewer.solPlot.color = h;   
end

logger('info','Set viewer.solPlot.xlabel',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'solPlot') && isfield(newPreference.viewer.solPlot,'xlabel')
    if numberOfEquations > 1 && length(newPreference.viewer.solPlot.xlabel) == 1
        n = length(preference.viewer.solPlot.show);
        h = cell(n,1);
        for i = 1:n
            h{i} = newPreference.viewer.solPlot.xlabel;
        end
        preference.viewer.solPlot.xlabel = h;
    else
        preference.viewer.solPlot.xlabel = newPreference.viewer.solPlot.xlabel;
    end
else
    n = length(preference.viewer.solPlot.show);
    h = cell(n,1);
    for i = 1:n
        switch preference.viewer.solPlot.show{i}{1}
            case 0
                h{i} = 't'; %<-- default
            case 1
                h{i} = 'x_1'; %<-- default
            case 2
                h{i} = 'x_2'; %<-- default
            case 3
                h{i} = 'x_3'; %<-- default
        end
    end
    preference.viewer.solPlot.xlabel = h;
end

logger('info','Set viewer.solPlot.ylabel',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'solPlot') && isfield(newPreference.viewer.solPlot,'ylabel')
    if numberOfEquations > 1 && length(newPreference.viewer.solPlot.ylabel) == 1
        n = length(preference.viewer.solPlot.show);
        h = cell(n,1);
        for i = 1:n
            h{i} = newPreference.viewer.solPlot.ylabel;
        end
        preference.viewer.solPlot.ylabel = h;
    else
        preference.viewer.solPlot.ylabel = newPreference.viewer.solPlot.ylabel;
    end
else
    n = length(preference.viewer.solPlot.show);
    h = cell(n,1);
    for i = 1:n
        switch preference.viewer.solPlot.show{i}{2}
            case 0
                h{i} = 't'; %<-- default
            case 1
                h{i} = 'x_1'; %<-- default
            case 2
                h{i} = 'x_2'; %<-- default
            case 3
                h{i} = 'x_3'; %<-- default
        end
    end
    preference.viewer.solPlot.ylabel = h;
end

logger('info','Set viewer.solPlot.zlabel',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'solPlot') && isfield(newPreference.viewer.solPlot,'zlabel')
    if numberOfEquations > 1 && length(newPreference.viewer.solPlot.zlabel) == 1
        n = length(preference.viewer.solPlot.show);
        h = cell(n,1);
        for i = 1:n
            h{i} = newPreference.viewer.solPlot.zlabel;
        end
        preference.viewer.solPlot.zlabel = h;
    else
        preference.viewer.solPlot.zlabel = newPreference.viewer.solPlot.zlabel;
    end
else
    n = length(preference.viewer.solPlot.show);
    h = cell(n,1);
    for i = 1:n
        if length(preference.viewer.solPlot.show{i}) == 3
            switch preference.viewer.solPlot.show{i}{3}
                case 0
                    h{i} = 't'; %<-- default
                case 1
                    h{i} = 'x_1'; %<-- default
                case 2
                    h{i} = 'x_2'; %<-- default
                case 3
                    h{i} = 'x_3'; %<-- default
            end
        end
    end
    preference.viewer.solPlot.zlabel = h;
end

% logger('info','Set viewer.solPlot.title',preference)
% if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'solPlot') && isfield(newPreference.viewer.solPlot,'title')
%     if numberOfEquations > 1 && length(newPreference.viewer.solPlot.title) == 1
%         n = length(preference.viewer.solPlot.show);
%         h = cell(n,1);
%         for i = 1:n
%             h{i} = newPreference.viewer.solPlot.title;
%         end
%         preference.viewer.solPlot.zlabel = h;
%     else
%         preference.viewer.solPlot.title = newPreference.viewer.solPlot.title;
%     end
% else
%     n = length(preference.viewer.solPlot.show);
%     h = cell(n,1);
%     for i = 1:n
%         for j = 1:length(preference.viewer.solPlot.show{i})
%             switch preference.viewer.solPlot.show{i}{j}
%                 case 0
%                     h{i} = 't'; %<-- default
%                 case 1
%                     h{i} = 'x_1'; %<-- default
%                 case 2
%                     h{i} = 'x_2'; %<-- default
%                 case 3
%                     h{i} = 'x_3'; %<-- default
%             end
%         end
%     end
%     preference.viewer.solPlot.title = h;
% end

logger('info','Set viewer.sepValue.show',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'sepValue') && isfield(newPreference.viewer.sepValue,'show')
    n = length(newPreference.viewer.sepValue.show);
    for k = 1:n
        if numberOfEquations > 1 && length(newPreference.viewer.sepValue.show{k}) == 1
            h = cell(numberOfEquations,1);
            for i = 1:numberOfEquations
                h{i} = newPreference.viewer.sepValue.show{k}{1};
            end
            preference.viewer.sepValue.show{k} = h;
        else
            preference.viewer.sepValue.show{k} = newPreference.viewer.sepValue.show{k};
        end
    end
else
    n = length(preference.seperation.value.interval);
    for k = 1:n
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = 1;  %<-- default
        end
        preference.viewer.sepValue.show{k} = h;
    end
end

logger('info','Set viewer.sepValue.color',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'sepValue') && isfield(newPreference.viewer.sepValue,'color')
    n = length(newPreference.viewer.sepValue.color);
    for k = 1:n
        if numberOfEquations > 1 && length(newPreference.viewer.sepValue.color{k}) == 1
            h = cell(numberOfEquations,1);
            for i = 1:numberOfEquations
                h{i} = newPreference.viewer.sepValue.color{k}{1};
            end
            preference.viewer.sepValue.color{k} = h;
        else
            preference.viewer.sepValue.color{k} = newPreference.viewer.sepValue.color{k};
        end
    end
else
    n = length(preference.seperation.value.interval);
    for k = 1:n
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = @lines;  %<-- default
        end
        preference.viewer.sepValue.color{k} = h;
    end
end

logger('info','Set viewer.sepValue.xlabel',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'sepValue') && isfield(newPreference.viewer.sepValue,'xlabel')
    n = length(newPreference.viewer.sepValue.xlabel);
    for k = 1:n
        if numberOfEquations > 1 && length(newPreference.viewer.sepValue.xlabel{k}) == 1
            h = cell(numberOfEquations,1);
            for i = 1:numberOfEquations
                h{i} = newPreference.viewer.sepValue.xlabel{k}{1};
            end
            preference.viewer.sepValue.xlabel{k} = h;
        else
            preference.viewer.sepValue.xlabel{k} = newPreference.viewer.sepValue.xlabel{k};
        end
    end
else
    n = length(preference.seperation.value.interval);
    for k = 1:n
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = 't';  %<-- default
        end
        preference.viewer.sepValue.xlabel{k} = h;
    end
end

logger('info','Set viewer.sepValue.ylabel',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'sepValue') && isfield(newPreference.viewer.sepValue,'ylabel')
    n = length(newPreference.viewer.sepValue.ylabel);
    for k = 1:n
        if numberOfEquations > 1 && length(newPreference.viewer.sepValue.ylabel{k}) == 1
            h = cell(numberOfEquations,1);
            for i = 1:numberOfEquations
                h{i} = newPreference.viewer.sepValue.ylabel{k}{1};
            end
            preference.viewer.sepValue.ylabel{k} = h;
        else
            preference.viewer.sepValue.ylabel{k} = newPreference.viewer.sepValue.ylabel{k};
        end
    end
else
    n = length(preference.seperation.value.interval);
    for k = 1:n
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = 'x';  %<-- default
        end
        preference.viewer.sepValue.ylabel{k} = h;
    end
end

logger('info','Set viewer.sepValue.title',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'sepValue') && isfield(newPreference.viewer.sepValue,'title')
    n = length(newPreference.viewer.sepValue.title);
    for k = 1:n
        if numberOfEquations > 1 && length(newPreference.viewer.sepValue.title{k}) == 1
            h = cell(numberOfEquations,1);
            for i = 1:numberOfEquations
                h{i} = newPreference.viewer.sepValue.title{k}{1};
            end
            preference.viewer.sepValue.title{k} = h;
        else
            preference.viewer.sepValue.title{k} = newPreference.viewer.sepValue.title{k};
        end
    end
else
    n = length(preference.seperation.value.interval);
    for k = 1:n
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = sprintf('Seperation %d at time %f; eqatuion %d',k,preference.seperation.value.time{k}{i},i);  %<-- default
        end
        preference.viewer.sepValue.title{k} = h;
    end
end

logger('info','Set viewer.sepValue.legend',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'sepValue') && isfield(newPreference.viewer.sepValue,'legend')
    n = length(newPreference.viewer.sepValue.legend);
    for k = 1:n
        if numberOfEquations > 1 && length(newPreference.viewer.sepValue.legend{k}) == 1
            h = cell(numberOfEquations,1);
            for i = 1:numberOfEquations
                h{i} = newPreference.viewer.sepValue.legend{k}{1};
            end
            preference.viewer.sepValue.legend{k} = h;
        else
            preference.viewer.sepValue.legend{k} = newPreference.viewer.sepValue.legend{k};
        end
    end
else
    n = length(preference.seperation.value.interval);
    for k = 1:n
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h1 = cell(size(preference.seperation.value.interval{k}{i},1),1);
            for j = 1:size(preference.seperation.value.interval{k}{i},1)
                h1{j} = [num2str(preference.seperation.value.interval{k}{i}{j,1}),' - ',...
                    num2str(preference.seperation.value.interval{k}{i}{j,2})];  %<-- default
            end
            h{i} = h1;
        end
        preference.viewer.sepValue.legend{k} = h;
    end
end

logger('info','Set viewer.sepPara.show',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'sepPara') && isfield(newPreference.viewer.sepPara,'show')
    n = length(newPreference.viewer.sepPara.show);
    for k = 1:n
        if numberOfEquations > 1 && length(newPreference.viewer.sepPara.show{k}) == 1
            h = cell(numberOfEquations,numberOfParameter);
            for i = 1:numberOfEquations
                for j = 1:numberOfParameter
                    h{i,j} = newPreference.viewer.sepPara.show{k}{1};
                end
            end
            preference.viewer.sepPara.show{k} = h;
        else
            h = cell(numberOfEquations,numberOfParameter);
            for i = 1:numberOfEquations
                for j = 1:numberOfParameter
                    h{i,j} = newPreference.viewer.sepPara.show{k}{i,j};
                end
            end
            preference.viewer.sepPara.show{k} = h;
        end
    end
else
    n = length(preference.seperation.para.interval);
    for k = 1:n
        h = cell(numberOfEquations,numberOfParameter);
        for i = 1:numberOfEquations
            for j = 1:numberOfParameter
                h{i,j} = 1;  %<-- default
            end
        end
        preference.viewer.sepPara.show{k} = h;
    end
end

logger('info','Set viewer.sepPara.color',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'sepPara') && isfield(newPreference.viewer.sepPara,'color')
    n = length(newPreference.viewer.sepPara.color);
    for k = 1:n
        if numberOfEquations > 1 && length(newPreference.viewer.sepPara.color{k}) == 1
            h = cell(numberOfEquations,numberOfParameter);
            for i = 1:numberOfEquations
                for j = 1:numberOfParameter
                    h{i,j} = newPreference.viewer.sepPara.color{k}{1};
                end
            end
            preference.viewer.sepPara.color{k} = h;
        else
            h = cell(numberOfEquations,numberOfParameter);
            for i = 1:numberOfEquations
                for j = 1:numberOfParameter
                    h{i,j} = newPreference.viewer.sepPara.color{k}{i,j};
                end
            end
            preference.viewer.sepPara.color{k} = h;
        end
    end
else
    n = length(preference.seperation.para.interval);
    for k = 1:n
        h = cell(numberOfEquations,numberOfParameter);
        for i = 1:numberOfEquations
            for j = 1:numberOfParameter
                h{i,j} = @lines;  %<-- default
            end
        end
        preference.viewer.sepPara.color{k} = h;
    end
end

logger('info','Set viewer.sepPara.xlabel',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'sepPara') && isfield(newPreference.viewer.sepPara,'xlabel')
    n = length(newPreference.viewer.sepPara.xlabel);
    for k = 1:n
        if numberOfEquations > 1 && length(newPreference.viewer.sepPara.xlabel{k}) == 1
            h = cell(numberOfEquations,numberOfParameter);
            for i = 1:numberOfEquations
                for j = 1:numberOfParameter
                    h{i,j} = newPreference.viewer.sepPara.xlabel{k}{1};
                end
            end
            preference.viewer.sepPara.xlabel{k} = h;
        else
            h = cell(numberOfEquations,numberOfParameter);
            for i = 1:numberOfEquations
                for j = 1:numberOfParameter
                    h{i,j} = newPreference.viewer.sepPara.xlabel{k}{i,j};
                end
            end
            preference.viewer.sepPara.xlabel{k} = h;
        end
    end
else
    n = length(preference.seperation.para.interval);
    for k = 1:n
        h = cell(numberOfEquations,numberOfParameter);
        for i = 1:numberOfEquations
            for j = 1:numberOfParameter
                h{i,j} = 't';  %<-- default
            end
        end
        preference.viewer.sepPara.xlabel{k} = h;
    end
end

logger('info','Set viewer.sepPara.ylabel',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'sepPara') && isfield(newPreference.viewer.sepPara,'ylabel')
    n = length(newPreference.viewer.sepPara.ylabel);
    for k = 1:n
        if numberOfEquations > 1 && length(newPreference.viewer.sepPara.ylabel{k}) == 1
            h = cell(numberOfEquations,numberOfParameter);
            for i = 1:numberOfEquations
                for j = 1:numberOfParameter
                    h{i} = newPreference.viewer.sepPara.ylabel{k}{1};
                end
            end
            preference.viewer.sepPara.ylabel{k} = h;
        else
            h = cell(numberOfEquations,numberOfParameter);
            for i = 1:numberOfEquations
                for j = 1:numberOfParameter
                    h{i,j} = newPreference.viewer.sepPara.ylabel{k}{i,j};
                end
            end
            preference.viewer.sepPara.ylabel{k} = h;
        end
    end
else
    n = length(preference.seperation.para.interval);
    for k = 1:n
        h = cell(numberOfEquations,numberOfParameter);
        for i = 1:numberOfEquations
            for j = 1:numberOfParameter
                h{i,j} = 'x';  %<-- default
            end
        end
        preference.viewer.sepPara.ylabel{k} = h;
    end
end

logger('info','Set viewer.sepPara.title',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'sepPara') && isfield(newPreference.viewer.sepPara,'title')
    n = length(newPreference.viewer.sepPara.title);
    for k = 1:n
        if numberOfEquations > 1 && length(newPreference.viewer.sepPara.title{k}) == 1
            h = cell(numberOfEquations,numberOfParameter);
            for i = 1:numberOfEquations
                for j = 1:numberOfParameter
                    h{i} = newPreference.viewer.sepPara.title{k}{1};
                end
            end
            preference.viewer.sepPara.title{k} = h;
        else
            h = cell(numberOfEquations,numberOfParameter);
            for i = 1:numberOfEquations
                for j = 1:numberOfParameter
                    h{i,j} = newPreference.viewer.sepPara.title{k}{i,j};
                end
            end
            preference.viewer.sepPara.title{k} = h;
        end
    end
else
    n = length(preference.seperation.para.interval);
    for k = 1:n
        h = cell(numberOfEquations,numberOfParameter);
        for i = 1:numberOfEquations
            for j = 1:numberOfParameter
                h{i,j} = sprintf('Parameter seperation %d; eqatuion %d; parameter %d',k,i,j); %<-- default
            end
        end
        preference.viewer.sepPara.title{k} = h;
    end
end

logger('info','Set viewer.sepPara.legend',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'sepPara') && isfield(newPreference.viewer.sepPara,'legend')
    n = length(newPreference.viewer.sepPara.legend);
    for k = 1:n
        if numberOfEquations > 1 && length(newPreference.viewer.sepPara.legend{k}) == 1
            h = cell(numberOfEquations,numberOfParameter);
            for i = 1:numberOfEquations
                for j = 1:numberOfParameter
                    h{i} = newPreference.viewer.sepPara.legend{k}{1};
                end
            end
            preference.viewer.sepPara.legend{k} = h;
        else
            h = cell(numberOfEquations,numberOfParameter);
            for i = 1:numberOfEquations
                for j = 1:numberOfParameter
                    h{i,j} = newPreference.viewer.sepPara.legend{k}{i,j};
                end
            end
            preference.viewer.sepPara.legend{k} = h;
        end
    end
else
    n = length(preference.seperation.para.interval);
    for k = 1:n
        h = cell(numberOfEquations,numberOfParameter);
        for i = 1:numberOfEquations
            for j = 1:numberOfParameter
                h1 = cell(size(preference.seperation.para.interval{k}{j},1),1);
                for l = 1:size(preference.seperation.para.interval{k}{j},1)
                    h1{l} =  [num2str(preference.seperation.para.interval{k}{j}{l,1}),' - ',...
                        num2str(preference.seperation.para.interval{k}{j}{l,2})]; %<-- default
                end
                h{i,j} = h1;
            end
        end
        preference.viewer.sepPara.legend{k} = h;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

logger('info','Set viewer.confidence.show',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'confidence') && isfield(newPreference.viewer.confidence,'show')
    if numberOfEquations > 1 && length(newPreference.viewer.confidence.show) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.viewer.confidence.show{1};
        end
        preference.viewer.confidence.show = h;
    else
        preference.viewer.confidence.show = newPreference.viewer.confidence.show;
    end
else
    h = cell(numberOfEquations,1);
    for i = 1:numberOfEquations
        h{i} = 1; %<-- default
    end
    preference.viewer.confidence.show = h;
end

logger('info','Set viewer.confidence.intervals',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'confidence') && isfield(newPreference.viewer.confidence,'intervals')
    if numberOfEquations > 1 && length(newPreference.viewer.confidence.intervals) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.viewer.confidence.intervals{1};
        end
        preference.viewer.confidence.intervals = h;
    else
        preference.viewer.confidence.intervals = newPreference.viewer.confidence.intervals;
    end
else
    h = cell(numberOfEquations,1);
    for i = 1:numberOfEquations
        h{i} = [0.25 0.5 0.75]; %<-- default
    end
    preference.viewer.confidence.intervals = h;
end

logger('info','Set viewer.confidence.color',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'confidence') && isfield(newPreference.viewer.confidence,'color')
    if numberOfEquations > 1 && length(newPreference.viewer.confidence.color) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.viewer.confidence.color{1};
        end
        preference.viewer.confidence.color = h;
    else
        preference.viewer.confidence.color = newPreference.viewer.confidence.color;
    end
else
    h = cell(numberOfEquations,1);
    for i = 1:numberOfEquations
        h{i} = @jet; %<-- default
    end
    preference.viewer.confidence.color = h;
end

logger('info','Set viewer.confidence.xlabel',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'confidence') && isfield(newPreference.viewer.confidence,'xlabel')
    if numberOfEquations > 1 && length(newPreference.viewer.confidence.xlabel) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.viewer.confidence.xlabel{1};
        end
        preference.viewer.confidence.xlabel = h;
    else
        preference.viewer.confidence.xlabel = newPreference.viewer.confidence.xlabel;
    end
else
    h = cell(numberOfEquations,1);
    for i=1:numberOfEquations
        h{i} = 't'; %<-- default
    end
    preference.viewer.confidence.xlabel = h;
end

logger('info','Set viewer.confidence.ylabel',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'confidence') && isfield(newPreference.viewer.confidence,'ylabel')
    if numberOfEquations > 1 && length(newPreference.viewer.confidence.ylabel) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.viewer.confidence.ylabel{1};
        end
        preference.viewer.confidence.ylabel = h;
    else
        preference.viewer.confidence.ylabel = newPreference.viewer.confidence.ylabel;
    end
else
    h = cell(numberOfEquations,1);
    for i=1:numberOfEquations
        h{i} = 'x'; %<-- default
    end
    preference.viewer.confidence.ylabel = h;
end

logger('info','Set viewer.confidence.title',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'confidence') && isfield(newPreference.viewer.confidence,'title')
    if numberOfEquations > 1 && length(newPreference.viewer.confidence.title) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.viewer.confidence.title{1};
        end
        preference.viewer.confidence.title = h;
    else
        preference.viewer.confidence.title = newPreference.viewer.confidence.title;
    end
else
    h = cell(numberOfEquations,1);
    for i=1:numberOfEquations
        h{i} = sprintf('Confidence intervall for equation %d',i); %<-- default
    end
    preference.viewer.confidence.title = h;
end

logger('info','Set viewer.confidence.legend',preference)
if isfield(newPreference,'viewer') && isfield(newPreference.viewer,'confidence') && isfield(newPreference.viewer.confidence,'legend')
    if numberOfEquations > 1 && length(newPreference.viewer.confidence.legend) == 1
        h = cell(numberOfEquations,1);
        for i = 1:numberOfEquations
            h{i} = newPreference.viewer.confidence.legend{1};
        end
        preference.viewer.confidence.legend = h;
    else
        preference.viewer.confidence.legend = newPreference.viewer.confidence.legend;
    end
else
    h = cell(numberOfEquations,1);
    for i = 1:numberOfEquations
        h1 = cell(length(preference.viewer.confidence.intervals{i}),1);
        intervals = sort(preference.viewer.confidence.intervals{i},'descend');
        for j = 1:length(intervals)
            h1{j} = sprintf('%3.1f %%',100*intervals(j)); %<-- default
        end
        h{i} = h1;
    end
    preference.viewer.confidence.legend = h;
end

end

%%
% Analyze the ODE. Read the numberOfEquations and numberOfParameter
% comments in the file which discripe the ODE. If there no comments
% in the ODE file then it return -1.
%
% TODO: modify the function in this way that the user do not need to set
%       numberOfEquations and numberOfParameter in the ODE file
function [numberOfEquations, numberOfParameter] = odeAnalyzer(odeHandle)
numberOfEquations = -1;
numberOfParameter = -1;

fun = functions(odeHandle);
fid = fopen(fun.file);
line = fgetl(fid);
flag = 0;
flagMax = 2;
while ischar(line)
    if(~isempty(line))
        if(~isempty(strfind(line,'numberOfEquations')))
            h = regexp(line,'=','split');
            numberOfEquations = str2double(h{2});
            flag = flag + 1;
        end
        if(~isempty(strfind(line,'numberOfParameter')))
            h = regexp(line,'=','split');
            numberOfParameter = str2double(h{2});
            flag = flag + 1;
        end
    end
    if flag>=flagMax % found all values
        break;
    end
    line = fgetl(fid);
end
fclose(fid);
end


