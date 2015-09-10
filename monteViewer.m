%
% monteViewer(sol,den,preference,mode,varargin)
%
% Present the datas.
%   * ODE solution:

function monteViewer(sol,den,preference,mode,varargin)

switch mode
    case 'showDensity3d'
        try
            showDensity3d(sol,den,preference)
        catch e
            logger('error',['Something goes wrong in showDensity3d: ',...
                e.identifier, ' -> ', e.message],preference)
        end
    case 'showDensity'
        try
            showDensity(sol,den,preference);
        catch e
            logger('error',['Something goes wrong in showDensity: ',...
                e.identifier, ' -> ', e.message],preference)
        end
    case 'showSeperationValue'
        try
            showSeperationValue(sol,preference);
        catch e
            logger('error',['Something goes wrong in showSeperationValue: ',...
                e.identifier, ' -> ', e.message],preference)
        end
    case 'showSeperationPara'
        try
            showSeperationPara(sol,preference);
        catch e
            logger('error',['Something goes wrong in showSeperationPara: ',...
                e.identifier, ' -> ', e.message],preference)
        end
    otherwise
        error(['viewer: ', mode,' not known']);
end

end

% Show an 3d figure of the density.
% Calculate all nessesary parameter
function showDensity3d(sol,den,preference)
logger('info','showDensity3d',preference)
for i = 1:preference.ode.numberOfEquations
    if preference.viewer.density3d.show{i}
        logger('info',['Plot equation number ',num2str(i)],preference)
        if preference.viewer.density3d.relativ{i}
            n = preference.numberOfSimulations;
        else
            n = 1;
        end
        figure
        surface(sol.deval.t,den.spacedX{i},den.density{i}/n,'LineStyle','none')
        xlim([sol.deval.t(1) sol.deval.t(end)]);
        ylim([den.minX{i} den.maxX{i}]);
        xlabel(preference.viewer.density3d.xlabel{i})
        ylabel(preference.viewer.density3d.ylabel{i})
        zlabel(preference.viewer.density3d.zlabel{i})
        title(preference.viewer.density3d.title{i})
        colormap(preference.viewer.density3d.color{i});
        colorbar
        view([45 45]);
    end
end
logger('info','done showDensity3d',preference)
end

% Show an image of the density. Use this because is faster
% and more stable then surface.
function showDensity(sol,den,preference)
logger('info','showDensity',preference)
for i = 1:preference.ode.numberOfEquations
    if preference.viewer.density.show{i}
        logger('info',['Plot equation number ',num2str(i)],preference)
        figure
        image(sol.deval.t, den.spacedX{i},64*den.density{i}/max(max(den.density{i})));
        set(gca,'ydir','normal');
        xlim([sol.deval.t(1) sol.deval.t(end)]);
        ylim([den.minX{i} den.maxX{i}]);
        xlabel(preference.viewer.density.xlabel{i})
        ylabel(preference.viewer.density.ylabel{i})
        title(preference.viewer.density.title{i})
        colormap(preference.viewer.density.color{i});
        colorbar
    end
end
logger('info','done showDensity',preference)
end

% Show the function plot, with the color seperation.
function showSeperationPara(sol,preference)
logger('info','showSeperationPara',preference)
for k = 1:length(preference.seperation.para.interval)
    for i = 1:preference.ode.numberOfEquations
        for j = 1:preference.ode.numberOfParameter
            if preference.viewer.sepPara.show{k}{i,j}
                logger('info',['Plot equation number ',num2str(i),'; Parameter number ',num2str(j)],preference)
                CM = colormapCreator(preference.viewer.sepPara.color{k}{i,j},size(preference.seperation.para.interval{k}{j},1));
                legName = cell(size(preference.seperation.para.interval{k}{j},1),1);
                legPlot = zeros(size(preference.seperation.para.interval{k}{j},1),1);
                legCount = 1;
                figure
                hold on
                for l = 1:preference.numberOfSimulations
                    colorNumber = findIntervall(cell2mat(preference.seperation.para.interval{k}{j}),sol.rPara(j,l));
                    ph = plot(sol.deval.t,sol.deval.x{l}(i,:),'color',CM(colorNumber,:));
                    
                    % the following if-statment is for the legend
                    if colorNumber == legCount
                        legName{legCount} = [num2str(preference.seperation.para.interval{k}{j}{legCount,1}),...
                            ' - ',num2str(preference.seperation.para.interval{k}{j}{legCount,2})];
                        legPlot(legCount) = ph;
                        legCount = legCount + 1;
                    end
                end
                xlabel(preference.viewer.sepPara.xlabel{k}{i,j})
                ylabel(preference.viewer.sepPara.ylabel{k}{i,j})
                title(preference.viewer.sepPara.title{k}{i,j})
                legend(legPlot,legName)
            end
        end
    end
end
logger('info','done showSeperationPara',preference)
end

function showSeperationValue(sol,preference)
logger('info','showSeperationValue',preference)
for k = 1:length(preference.seperation.value.interval)
    for i = 1:preference.ode.numberOfEquations
        if preference.viewer.sepValue.show{k}{i}
            logger('info',['Plot equation number ',num2str(i)],preference)
            CM = colormapCreator(preference.viewer.sepValue.color{k}{i},size(preference.seperation.value.interval{k}{i},1));
            legName = cell(size(preference.seperation.value.interval{k}{i},1),1);
            legPlot = zeros(size(preference.seperation.value.interval{k}{i},1),1);
            legCount = 1;
            figure
            hold on
            for j = 1:preference.numberOfSimulations
                sepValue=deval(sol.solver{j},preference.seperation.value.time{k}{i},i);
                colorNumber = findIntervall(cell2mat(preference.seperation.value.interval{k}{i}),sepValue);
                ph = plot(sol.deval.t,sol.deval.x{j}(i,:),'color',CM(colorNumber,:));
                
                % the following if-statment is for the legend
                if colorNumber == legCount
                    legName{legCount} = [num2str(preference.seperation.value.interval{k}{i}{legCount,1}),...
                        ' - ',num2str(preference.seperation.value.interval{k}{i}{legCount,2})];
                    legPlot(legCount) = ph;
                    legCount = legCount + 1;
                end
                
            end
            xlabel(preference.viewer.sepValue.xlabel{k}{i})
            ylabel(preference.viewer.sepValue.ylabel{k}{i})
            title(preference.viewer.sepValue.title{k}{i})
            legend(legPlot,legName)
        end
    end
end
logger('info','done showSeperationValue',preference)
end
