%
% [sol den]=monte(odeHandle,newPreference)
%
% The main programm.
% 
% Autor: Steve Merschel
% Date: 01/06/2014

function output = monte(newPreference)
preference = setPreference(newPreference);

if ~isstruct(preference)
    return
end

if  preference.compute.solution % TODO: Wenn nicht berechnet werden soll muss etwas �bergeben werde
    sol = solution(preference);
end

if preference.compute.density        % TODO: Wenn nicht berechnet werden soll muss etwas �bergeben werden
    den = density(sol,preference);
end

monteViewer(sol,den,preference,'showDensity3d')
monteViewer(sol,den,preference,'showDensity')
monteViewer(sol,[],preference,'showSeperationValue')
monteViewer(sol,[],preference,'showSeperationPara')
monteViewer(sol,[],preference,'showConfidenceInterval')
monteViewer(sol,[],preference,'showSolPlot')

output.sol = sol;
output.den = den;
output.preference = preference;

%% close all open files
logger('info','Close all open streams and the program is finish',preference)
fids = fopen('all');
for i = fids
    fclose(i);
end
end

function sol = solution(preference)
logger('info','Begin to solve the equations',preference)

%% generate the random numbers
% for initial conditions
logger('info','Generate the random numbers for the inital conditions',preference)
sol.rInic = zeros(preference.ode.numberOfEquations,preference.numberOfSimulations);
for i = 1:preference.ode.numberOfEquations
    switch preference.inic.distribution{i}
        case 'uniformly'
            sol.rInic(i,:) = preference.inic.interval{i}{1} + (preference.inic.interval{i}{2}-preference.inic.interval{i}{1}).*rand(preference.numberOfSimulations,1);
        case 'normally'
            sol.rInic(i,:) = preference.inic.interval{i}{1} + preference.inic.interval{i}{2}.*randn(preference.numberOfSimulations,1);
        case 'integer'
            sol.rInic(i,:) = randi([preference.inic.interval{i}{1} preference.inic.interval{i}{2}],preference.numberOfSimulations,1);
        case 'list'
            sol.rInic(i,:) = cell2mat(preference.inic.interval{i});
        otherwise
            fprintf(['Error in opt.inic.distribution: ',preference.inic.distribution{i}, ' not known!'])
            return
    end
end

% for the ode parameter
logger('info','Generate the random numbers for the parameters',preference)
sol.rPara = zeros(preference.ode.numberOfParameter,preference.numberOfSimulations);
for i = 1:preference.ode.numberOfParameter
    switch preference.para.distribution{i}
        case 'uniformly'
            sol.rPara(i,:) = preference.para.interval{i}{1} + (preference.para.interval{i}{2} - preference.para.interval{i}{1}) .* rand(preference.numberOfSimulations,1);
        case 'normally'
            sol.rPara(i,:) = preference.para.interval{i}{1} + preference.para.interval{i}{2} .* rand(preference.numberOfSimulations,1);
        case 'integer'
            sol.rPara(i,:) = randi([preference.para.interval{i}{1} preference.para.interval{i}{2}],preference.numberOfSimulations,1);
        case 'list'
            sol.rPara(i,:) = cell2mat(preference.para.interval{i});
        otherwise
            fprintf(['Error in opt.para.distribution: ',preference.para.distribution{i}, ' not known!'])
            return
    end
end
    
numTimePoints = round((preference.simulationTime(2)-preference.simulationTime(1))/preference.deltaT)+1;
solDeval.t = linspace(preference.simulationTime(1),preference.simulationTime(2),numTimePoints);

solSolver = cell(preference.numberOfSimulations,1);
x = cell(preference.numberOfSimulations,1);
X = cell(preference.ode.numberOfEquations,1);
if preference.parallel
    parfor i = 1:preference.numberOfSimulations
        [solSolver{i}, x{i}] = solve(i,sol,solDeval,preference);
    end
else
    solDeval.x = cell(preference.numberOfSimulations,1);
    for i = 1:preference.numberOfSimulations
        [solSolver{i}, x{i}] = solve(i,sol,solDeval,preference);
    end
end

x = cell2mat(x);

for j = 1:preference.ode.numberOfEquations
    X{j} = x(j:preference.ode.numberOfEquations:end,:);
end

solDeval.x = X;

sol.solver = solSolver;
sol.deval = solDeval;

logger('info','Done to solve the equations',preference)
end

function [s, d] = solve(i,sol,solDeval,preference)
    logger('info',['Solve simulation number ',num2str(i)],preference)
    s = solver(preference.ode.solver,preference.ode.f,preference.simulationTime,sol.rInic(:,i),preference.ode.options,sol.rPara(:,i));
    d = deval(s,solDeval.t);
end

function den = density(sol,preference)
logger('info','Begin to compute the density',preference)

minX = cell(preference.ode.numberOfEquations,1);
maxX = cell(preference.ode.numberOfEquations,1);

for k = 1:preference.ode.numberOfEquations
    minX{k} = min(min(sol.deval.x{k}));
    maxX{k} = max(max(sol.deval.x{k}));
end

density = cell(preference.ode.numberOfEquations,1);
spacedX = cell(preference.ode.numberOfEquations,1);

for k = 1:preference.ode.numberOfEquations
    logger('info',['Determine density for eqation number ',num2str(k)],preference)
    numberAreaPoints = round((maxX{k}-minX{k})/preference.deltaX)+1;
    spacedX{k} = linspace(minX{k},maxX{k},numberAreaPoints);
    try
        density{k} = hist(sol.deval.x{k},spacedX{k});  %TODO: sometimes memory problems: fix this!!!!
    catch exeption
        fprintf('Equation %d cause an error\n',k)
        fprintf(exeption)
    end
end

den.minX = minX;
den.maxX = maxX;
den.spacedX = spacedX;
den.density = density;

logger('info','Done to compute the density',preference)
end
