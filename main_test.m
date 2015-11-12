clear;
%profile on
%% ode
%preference.ode.solver = @ode45;
preference.ode.f = @f_test;
preference.ode.options = odeset('MaxStep',0.01);

preference.numberOfSimulations = 1; %wenn 1 ist die density nicht richtig
preference.simulationTime = [0 100];
preference.deltaT = .001;
preference.deltaX = .01;

preference.parallel = 0; 

preference.inic.interval = {{20 20};{0.0001 0.0001};{0.0001 0.0001}};             % {{* *}} or {{* *};{* *};...}
%preference.inic.interval = {{1 2 3};{4 3 2}};
preference.inic.distribution = {'uniformly'}; % 'normally', 'uniformly', 'integer' or 'list'

preference.para.interval = {{0.1 0.1};{2 2};{1 1};{1 1};{0.001 0.001}; {365 365}; {30 30}; {100 100}; {0.0001 0.0001}; {0.008 0.008}};              % {{* *}} or {{* *};{* *};...}
preference.para.distribution = {'uniformly'}; % 'normally', 'uniformly' or 'integer' or 'list'

%preference.seperation.value.time{1} = {0};   % erste Separartion von gleichung 1 zum zeitpunkt 0 und gelichung 2 zum zeitpunkt 0
%preference.seperation.value.time{2} = {11.5};   
%preference.seperation.value.time{3} = {30};

%preference.seperation.value.interval{1} = {{0 0.5; 0.5 1; 1 1.5; 1 2}}; % erste Separation von gleichung 1 und 2 zu obigen Zeitpunkten beide in hier angebenen Intervallen
%preference.seperation.value.interval{2} = {{-2 0; 0 0.5;0.5 2};{0 0.2; 0.2 1}}; % zweite Seperation von gleichung 1 im ersten intervalen und gleichung 2 im zweiten intervalen 
%preference.seperation.value.interval{3} = {{0 0.5; 0.5 0.65; 0.65 1};{0 0.2; 0.2 1}};

%preference.seperation.para.interval{1} = {{0 0.3; 0.3 1};{0 0.7; 0.7 1};{0 0.1; 0.1 0.6; 0.6 0.8; 0.8 1}};  % Erste Seperation für den ersten, zweiten und dritten Parameter
%preference.seperation.para.interval{1} = {{0 0.5; 0.5 1}};     % Zweite Seperation für alle 3 Parameter gleich 
%preference.seperation.para.interval{2} = {{0 0.3; 0.3 0.5; 0.5 1}};  % dritte Seperation für alle Parameter gleich 

%preference.viewer.solPlot.show = {{0 1}; {0 2}; {1 2}};
%preference.viewer.solPlot.show = {1};
%preference.viewer.solPlot.color = {@lines};

preference.viewer.density.show = {0};
% preference.viewer.density.zoom{1} = [];
% preference.viewer.density.zoom{2} = [2 3 ; 3 4];

preference.viewer.density3d.show = {0};

%preference.viewer.density3d.zoom{1} = [10 20;1 2];
%preference.viewer.density3d.zoom{2} = [];

preference.viewer.sepValue.show{1} = {0};
%preference.viewer.sepValue.show{2} = {0;0};
%preference.viewer.sepValue.show{3} = {0};

preference.viewer.sepPara.show{1} = {0};
%preference.viewer.sepPara.show{1} = {1 1 1;1 0 1};
%preference.viewer.sepPara.show{2} = {1};
%preference.viewer.sepPara.show{3} = {0};

%preference.viewer.confidence.intervals = {[0.1 0.2 0.4 0.3 0.5 0.9 0.7 0.8 1]};
preference.viewer.confidence.show = {0};

%preference.logger.stream.info = 'output.info';

output = calicoCat(preference);
