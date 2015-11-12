%
% monteViewer(sol,den,preference,mode,varargin)
%
% Present the datas.
%   * ODE solution:

function viewer(sol,den,eva,preference,mode,varargin)

switch mode
    case 'showSolPlot'
        try
            showSolPlot(sol,preference)
        catch e
            logger('error',['Something goes wrong in solPlot: ',...
                e.identifier, ' -> ', e.message],preference)
        end
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
    case 'showConfidenceInterval'
        try 
            showConfidenceInterval(sol,preference)
        catch e
            logger('error',['Something goes wrong in showConfidenceInterval: ',...
                e.identifier, ' -> ', e.message],preference)
        end
    case 'showEigenValue'
        try
            showEigenValue(sol,eva,preference)
        catch e
            logger('error',['Something goes wrong in showEigenValue: ',...
                e.identifier, ' -> ', e.message],preference)
        end
    otherwise
        error(['viewer: ', mode,' not known']);
end

end

% Show an 3d figure of the density.
function showDensity3d(sol,den,preference)
logger('info','showDensity3d',preference)
for i = 1:preference.ode.numberOfEquations
    if preference.viewer.density3d.show{i}
        logger('info',['Plot equation number ',num2str(i)],preference)
        
        if isempty(preference.viewer.density3d.zoom{i})
            T = sol.deval.t;
            X = den.spacedX{i};
            D = den.density{i};
        else
            [~, idxT1] = min(abs(sol.deval.t-preference.viewer.density3d.zoom{i}(1,1)));
            [~, idxT2] = min(abs(sol.deval.t-preference.viewer.density3d.zoom{i}(1,2)));
            T = sol.deval.t(idxT1:idxT2);
            
            [~, idxX1] = min(abs(den.spacedX{i}-preference.viewer.density3d.zoom{i}(2,1)));
            [~, idxX2] = min(abs(den.spacedX{i}-preference.viewer.density3d.zoom{i}(2,2)));
                        
            X = den.spacedX{i}(idxX1:idxX2);
            
            D = den.density{i}(idxX1:idxX2,idxT1:idxT2);
        end
        
        if preference.viewer.density3d.relativ{i}
            n = preference.numberOfSimulations;
        else
            n = 1;
        end
        figure
        surface(T,X,D/n,'LineStyle','none')
        xlim([T(1) T(end)]);
        ylim([X(1) X(end)]);
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
        
        if isempty(preference.viewer.density.zoom{i})
            T = sol.deval.t;
            X = den.spacedX{i};
            D = den.density{i};
        else
            [~, idxT1] = min(abs(sol.deval.t-preference.viewer.density.zoom{i}(1,1)));
            [~, idxT2] = min(abs(sol.deval.t-preference.viewer.density.zoom{i}(1,2)));
            T = sol.deval.t(idxT1:idxT2);
            
            [~, idxX1] = min(abs(den.spacedX{i}-preference.viewer.density.zoom{i}(2,1)));
            [~, idxX2] = min(abs(den.spacedX{i}-preference.viewer.density.zoom{i}(2,2)));
                        
            X = den.spacedX{i}(idxX1:idxX2);
            
            D = den.density{i}(idxX1:idxX2,idxT1:idxT2);
        end
        
        figure
        image(T,X,64*D/max(max(D)));
        set(gca,'ydir','normal');
        xlim([T(1) T(end)]);
        ylim([X(1) X(end)]);
        xlabel(preference.viewer.density.xlabel{i})
        ylabel(preference.viewer.density.ylabel{i})
        title(preference.viewer.density.title{i})
        colormap(preference.viewer.density.color{i});
        colorbar
    end
end
logger('info','done showDensity',preference)
end

% Show the function plot, with the color seperation on the parameters
function showSeperationPara(sol,preference)
logger('info','showSeperationPara',preference)
for k = 1:length(preference.seperation.para.interval)
    for i = 1:preference.ode.numberOfEquations
        for j = 1:preference.ode.numberOfParameter
            if preference.viewer.sepPara.show{k}{i,j}
                logger('info',['Plot equation number ',num2str(i),'; Parameter number ',num2str(j)],preference)
                CM = colormapCreator(preference.viewer.sepPara.color{k}{i,j},size(preference.seperation.para.interval{k}{j},1));
                figure
                hold on
                for l = 1:preference.numberOfSimulations
                    colorNumber = findIntervall(cell2mat(preference.seperation.para.interval{k}{j}),sol.rPara(j,l));
                    plot(sol.deval.t,sol.deval.x{i}(l,:),'color',CM(colorNumber,:));                    
                end
                xlabel(preference.viewer.sepPara.xlabel{k}{i,j})
                ylabel(preference.viewer.sepPara.ylabel{k}{i,j})
                title(preference.viewer.sepPara.title{k}{i,j})
                esayLegend(preference.viewer.sepPara.legend{k}{i,j},CM)
            end
        end
    end
end
logger('info','done showSeperationPara',preference)
end

% Show the function plot, with the color seperation on special time values
function showSeperationValue(sol,preference)
logger('info','showSeperationValue',preference)
for k = 1:length(preference.seperation.value.interval)
    for i = 1:preference.ode.numberOfEquations
        if preference.viewer.sepValue.show{k}{i}
            logger('info',['Plot equation number ',num2str(i)],preference)
            CM = colormapCreator(preference.viewer.sepValue.color{k}{i},size(preference.seperation.value.interval{k}{i},1));
            figure
            hold on
            for j = 1:preference.numberOfSimulations
                sepValue=deval(sol.solver{j},preference.seperation.value.time{k}{i},i);
                colorNumber = findIntervall(cell2mat(preference.seperation.value.interval{k}{i}),sepValue);
                plot(sol.deval.t,sol.deval.x{i}(j,:),'color',CM(colorNumber,:));               
            end
            xlabel(preference.viewer.sepValue.xlabel{k}{i})
            ylabel(preference.viewer.sepValue.ylabel{k}{i})
            title(preference.viewer.sepValue.title{k}{i})
            esayLegend(preference.viewer.sepValue.legend{k}{i},CM)
        end
    end
end
logger('info','done showSeperationValue',preference)
end

% show the confidence intervals of the solutions
function showConfidenceInterval(sol,preference)
logger('info','showConfidenceInterval',preference)
for i = 1:preference.ode.numberOfEquations
    if preference.viewer.confidence.show{i}
        logger('info',['Plot equation number ',num2str(i)],preference)
        CM = colormapCreator(preference.viewer.confidence.color{i},length(preference.viewer.confidence.intervals{i}));
        figure
        hold on
        sortX = sort(sol.deval.x{i});
        intervals = sort(preference.viewer.confidence.intervals{i},'descend');
        for j = 1:length(intervals)
            idx1 = floor((1-intervals(j))*preference.numberOfSimulations/2);
            idx2 = preference.numberOfSimulations - idx1;
            if idx1 == 0
                idx1 = 1;
            end
            T = [sol.deval.t, fliplr(sol.deval.t)];
            X = [sortX(idx1,:), fliplr(sortX(idx2,:))];
            fill(T,X,CM(j,:));
        end
         xlabel(preference.viewer.confidence.xlabel{i})
         ylabel(preference.viewer.confidence.ylabel{i})
         title(preference.viewer.confidence.title{i})
         legend(preference.viewer.confidence.legend{i})
    end
end
end

% show the selutions without a separetion. One can also plot the solution
% against each other and against the time.
function showSolPlot(sol,preference)
logger('info','showSolPlot',preference)
for i = 1:size(preference.viewer.solPlot.show,1)
    if length(preference.viewer.solPlot.show{i}) == 2
        if preference.viewer.solPlot.show{i}{1} == 0
            X1 = sol.deval.t;
            X2 = sol.deval.x{preference.viewer.solPlot.show{i}{2}};
        elseif preference.viewer.solPlot.show{i}{2} == 0
            X1 = sol.deval.x{preference.viewer.solPlot.show{i}{1}};
            X2 = sol.deval.t;
        else
            X1 = sol.deval.x{preference.viewer.solPlot.show{i}{1}}';
            X2 = sol.deval.x{preference.viewer.solPlot.show{i}{2}}';
        end
        figure
        plot(X1,X2,'color',preference.viewer.solPlot.color{i});
        xlabel(preference.viewer.solPlot.xlabel{i})
        ylabel(preference.viewer.solPlot.ylabel{i})
    else
        if preference.viewer.solPlot.show{i}{1} == 0
            X1 = sol.deval.t;
            X2 = sol.deval.x{preference.viewer.solPlot.show{i}{2}};
            X3 = sol.deval.x{preference.viewer.solPlot.show{i}{3}};
        elseif preference.viewer.solPlot.show{i}{2} == 0
            X1 = sol.deval.x{preference.viewer.solPlot.show{i}{1}};
            X2 = sol.deval.t;
            X3 = sol.deval.x{preference.viewer.solPlot.show{i}{3}};
        elseif preference.viewer.solPlot.show{i}{3} == 0
            X1 = sol.deval.x{preference.viewer.solPlot.show{i}{1}};
            X2 = sol.deval.x{preference.viewer.solPlot.show{i}{2}};
            X3 = sol.deval.t;
        else
            X1 = sol.deval.x{preference.viewer.solPlot.show{i}{1}}';
            X2 = sol.deval.x{preference.viewer.solPlot.show{i}{2}}';
            X3 = sol.deval.x{preference.viewer.solPlot.show{i}{3}}';
        end
        figure
        plot3(X1,X2,X3,'color',preference.viewer.solPlot.color{i})
        xlabel(preference.viewer.solPlot.xlabel{i})
        ylabel(preference.viewer.solPlot.ylabel{i})
        zlabel(preference.viewer.solPlot.zlabel{i})
    end
end
end

function showEigenValue(sol,eva,preference)

A = zeros(size(eva.eig,2),preference.numberOfSimulations);

for i = 1:preference.ode.numberOfEquations
    A(:,:) = eva.eig(i,:,:);
    rA = real(A);
    iA = imag(A);
    
    mini = min(min(iA));
    maxi = max(max(iA));
    
    minr = min(min(rA));
    maxr = max(max(rA));
    
    figure
    subplot(3,1,1)
    hold on
    line([sol.deval.t(1) sol.deval.t(end)],[0 0],'color','black')
    
    plot(sol.deval.t,rA,'color','blue')    
    xlim([sol.deval.t(1) sol.deval.t(end)])
    ylim([minr maxr])
    xlabel('t')
    ylabel('Re')
    title(['Equation ',num2str(i)])
    
    subplot(3,1,2)
    hold on
    line([sol.deval.t(1) sol.deval.t(end)],[0 0],'color','black')
    
    plot(sol.deval.t,iA,'color','blue')
    xlim([sol.deval.t(1) sol.deval.t(end)])
    ylim([mini maxi])
    xlabel('t')
    ylabel('Im')
    
    subplot(3,1,3)
    plot(rA,iA,'bo')
    xlim([minr maxr])
    ylim([mini maxi])
    xlabel('Re')
    ylabel('Im')
    
    figure
    hold on
    plot3(sol.deval.t,rA,iA,'color','blue')
    plot3(sol.deval.t,0.*rA+maxr,iA,'color',[0.8,0.8,0.8])
    plot3(sol.deval.t,rA,0.*iA+mini,'color',[0.8,0.8,0.8])
    xlabel('t')
    ylabel('Re')
    zlabel('Im')
    view([-45 45])
end

end



