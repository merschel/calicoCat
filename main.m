clear;
%profile on
%% ode
preference.ode.solver = @ode45;
preference.ode.f = @f;

preference.numberOfSimulations = 1; %wenn 1 ist die density nicht richtig
preference.simulationTime = [0 30];
preference.deltaT = .01;
preference.deltaX = .01;

preference.parallel = 1; 

preference.inic.interval = {{-10 10}};             % {{* *}} or {{* *};{* *};...}
%preference.inic.interval = {{1 2 3};{4 3 2}};
preference.inic.distribution = {'uniformly'}; % 'normally', 'uniformly', 'integer' or 'list'

preference.para.interval = {{-10 10}};              % {{* *}} or {{* *};{* *};...}
preference.para.distribution = {'uniformly'}; % 'normally', 'uniformly' or 'integer' or 'list'

preference.seperation.value.time{1} = {0};   % erste Separartion von gleichung 1 zum zeitpunkt 0 und gelichung 2 zum zeitpunkt 0
%preference.seperation.value.time{2} = {11.5};   
%preference.seperation.value.time{3} = {30};

%preference.seperation.value.interval{1} = {{0 0.5; 0.5 1; 1 1.5; 1 2}}; % erste Separation von gleichung 1 und 2 zu obigen Zeitpunkten beide in hier angebenen Intervallen
%preference.seperation.value.interval{2} = {{-2 0; 0 0.5;0.5 2};{0 0.2; 0.2 1}}; % zweite Seperation von gleichung 1 im ersten intervalen und gleichung 2 im zweiten intervalen 
%preference.seperation.value.interval{3} = {{0 0.5; 0.5 0.65; 0.65 1};{0 0.2; 0.2 1}};

%preference.seperation.para.interval{1} = {{0 0.3; 0.3 1};{0 0.7; 0.7 1};{0 0.1; 0.1 0.6; 0.6 0.8; 0.8 1}};  % Erste Seperation für den ersten, zweiten und dritten Parameter
%preference.seperation.para.interval{1} = {{0 0.5; 0.5 1}};     % Zweite Seperation für alle 3 Parameter gleich 
%preference.seperation.para.interval{2} = {{0 0.3; 0.3 0.5; 0.5 1}};  % dritte Seperation für alle Parameter gleich 

%preference.viewer.solPlot.show = {{0 1}; {0 2}; {1 2}};
preference.viewer.solPlot.show = {1};
%preference.viewer.solPlot.color = {@lines};

preference.viewer.density.show = {1};
% preference.viewer.density.zoom{1} = [];
% preference.viewer.density.zoom{2} = [2 3 ; 3 4];
preference.viewer.density.color = {'viridis'};
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


preference.viewer.eigenValue.show = {1};


output = calicoCat(preference);
%profile off
%profile viewer


% TODO:
% Version 0.5
%  - anleitung schreiben

% Version 0.6
%  - separation rechtschreibfehler entfernen 
%  - 3d seperation
%  - test ob inic seperation die intervalle keinen luecken haben, ggf auch
%  fuer die anderen seperation ueberpruefen
%  - speicher von zwischenergebnissen um datenverlust bei abst�rzen vorzubeugen+
%  - speichern allgemine
%  - option was gespeichert werden soll
%  - wenn dichte oder solution nicht berechet werden, muss das prgramm
%  reagieren
%  - eigenwert analyse
%  - phasenraum dichte

% Version 0.7
%  - eigene Colormap welche konstant in abh�ngigkeit der anzahl der
%  l�sungen ist 
% http://cresspahl.blogspot.de/2012/03/expanded-control-of-octaves-colormap.html
% - eigenwerte konfidenzintervalle
% - eigenwerte dichte
% - logger bei einfachen zahlen mit 0 auffühlen 
% - lhs zus�tzlich als zufallsgenaerator

% - Version 0.8 
% - Hauptkomponentenanalyse
% - 

% Version 1.0
%  - cluster den Zeitverlauf um unterschiedliche parameter konstelation als
%  gleichwertig zu betrachten 
%  - Abstandsmass f�r die sesibilit�t von einen Parameter

% Version > 1.0
%  - gui
%  - test BODE, DDE, DAE, ... was matlab hergibt

% ???
%  - Seperartion absolut und in relativ
%  - CLim befehl
