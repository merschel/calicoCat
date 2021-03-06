clear;
%profile on
%% ode

preference.ode.f = @f_worldModel;

preference.numberOfSimulations = 10; %wenn 1 ist die density nicht richtig
preference.simulationTime = [0 500];
preference.deltaT = .01;
preference.deltaX = .01;

preference.parallel = 1; 

preference.inic.interval = {{0 1};{0 1};{0 1}};             % {{* *}} or {{* *};{* *};...}
preference.inic.distribution = {'uniformly'}; % 'normally', 'uniformly', 'integer' or 'list'

preference.para.interval = {{0.03 0.03}; {0.01 0.01};  {1 1};  {1 1};  {0.1 0.1};  {0.02 0.02};  {1 1};  {0.05 0.5}};              % {{* *}} or {{* *};{* *};...}
preference.para.distribution = {'uniformly'}; % 'normally', 'uniformly' or 'integer' or 'list'

preference.viewer.solPlot.xlabel = {'t';'t';'t';'Bev';'Bev';'UmB'};
preference.viewer.solPlot.ylabel = {'Bev';'UmB';'Anl';'UmB';'Anl';'Anl'};

preference.compute.density = 0;

%preference.seperation.value.time{1} = {0};   % erste Separartion von gleichung 1 zum zeitpunkt 0 und gelichung 2 zum zeitpunkt 0

%preference.seperation.value.interval{1} = {{0 0.5; 0.5 1; 1 1.5; 1 2}}; % erste Separation von gleichung 1 und 2 zu obigen Zeitpunkten beide in hier angebenen Intervallen
%preference.seperation.value.interval{2} = {{-2 0; 0 0.5;0.5 2};{0 0.2; 0.2 1}}; % zweite Seperation von gleichung 1 im ersten intervalen und gleichung 2 im zweiten intervalen 
%preference.seperation.value.interval{3} = {{0 0.5; 0.5 0.65; 0.65 1};{0 0.2; 0.2 1}};

%preference.seperation.para.interval{1} = {{0 0.3; 0.3 1};{0 0.7; 0.7 1};{0 0.1; 0.1 0.6; 0.6 0.8; 0.8 1}};  % Erste Seperation für den ersten, zweiten und dritten Parameter
%preference.seperation.para.interval{1} = {{0 0.5; 0.5 1}};     % Zweite Seperation für alle 3 Parameter gleich 
%preference.seperation.para.interval{2} = {{0 0.3; 0.3 0.5; 0.5 1}};  % dritte Seperation für alle Parameter gleich 

%preference.viewer.solPlot.show = {1};

preference.viewer.density.show = {0};

preference.viewer.density3d.show = {0};

preference.viewer.sepValue.show{1} = {0};

preference.viewer.sepPara.show{1} = {0};

preference.viewer.confidence.show = {0};

output = calicoCat(preference);

