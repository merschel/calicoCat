clear;

%% ode
preference.ode.solver = @ode45;
preference.ode.f = @f;

preference.numberOfSimulations = 200; %wenn 1 ist die density nicht richtig
preference.simulationTime = [0 30];
preference.deltaT = .01;
preference.deltaX = .01;

preference.parallel = 1; 

preference.inic.interval = {{-2 2}};             % {{* *}} or {{* *};{* *};...}
%preference.inic.interval = {{1 2 3};{4 3 2}};
preference.inic.distribution = {'integer'}; % 'normally', 'uniformly', 'integer' or 'list'

preference.para.interval = {{0 2}};              % {{* *}} or {{* *};{* *};...}
preference.para.distribution = {'uniformly'}; % 'normally', 'uniformly' or 'integer' or 'list'

preference.seperation.value.time{1} = {0};   % erste Separartion von gleichung 1 zum zeitpunkt 0 und gelichung 2 zum zeitpunkt 0
preference.seperation.value.time{2} = {11.5};   
%preference.seperation.value.time{3} = {30};
preference.seperation.value.interval{1} = {{0 0.5; 0.5 0.7; 0.7 1}}; % erste Separation von gleichung 1 und 2 zu obigen Zeitpunkten beide in hier angebenen Intervallen
preference.seperation.value.interval{2} = {{-2 0; 0 0.5;0.5 2};{0 0.2; 0.2 1}}; % zweite Seperation von gleichung 1 im ersten intervalen und gleichung 2 im zweiten intervalen 
%preference.seperation.value.interval{3} = {{0 0.5; 0.5 0.65; 0.65 1};{0 0.2; 0.2 1}};

%preference.seperation.para.interval{1} = {{0 0.3; 0.3 1};{0 0.7; 0.7 1};{0 0.1; 0.1 0.6; 0.6 0.8; 0.8 1}};  % Erste Seperation fÃ¼r den ersten, zweiten und dritten Parameter
preference.seperation.para.interval{1} = {{0 0.5; 0.5 1}};     % Zweite Seperation fÃ¼r alle 3 Parameter gleich 
%preference.seperation.para.interval{2} = {{0 0.3; 0.3 0.5; 0.5 1}};  % dritte Seperation fÃ¼r alle Parameter gleich 


preference.viewer.density.show = {0};
preference.viewer.density3d.show = {0};

preference.viewer.sepValue.show{1} = {0};
preference.viewer.sepValue.show{2} = {0;0};
%preference.viewer.sepValue.show{3} = {0};

preference.viewer.sepPara.show{1} = {1 1 1;1 0 1};
%preference.viewer.sepPara.show{2} = {1};
%preference.viewer.sepPara.show{3} = {0};

%preference.logger.stream.info = 'output.info';

output = monte(preference);

% TODO: 

% Version 0.5
%  - Varablen umbenennen
%  - ploten von zustandsgrößen gegeneinander
%  - legende
%  - konfidenzintervalle x über t
%  - option des sichtbereiches der Lï¿½sung (dicht) eifï¿½gen
%  - Komentare und funktionsbeschreibung  
%  - anleitung schreiben 

% Version 0.6
%  - 3d seperation
%  - test ob inic seperation die intervalle keinen luecken haben, ggf auch
%  fuer die anderen seperation ueberpruefen
%  - speicher von zwischenergebnissen um datenverlust bei abstï¿½rzen vorzubeugen+
%  - speichern allgemine 
%  - option was gespeichert werden soll
%  - wenn dichte oder solution nicht berechet werden, muss das prgramm
%  reagieren
%  - eigenwert analyse
%  - phasenraum dichte

% Version 0.7
%  - eigene Colormap welche konstant in abhï¿½ngigkeit der anzahl der
%  lï¿½sungen ist 
% http://cresspahl.blogspot.de/2012/03/expanded-control-of-octaves-colormap.html
% - eigenwerte konfidenzintervalle
% - eigenwerte dichte


% Version 1.0
%  - give the hole project a better name: how about LyX, CalicoCat
%  - cluster den Zeitverlauf um unterschiedliche parameter konstelation als
%  gleichwertig zu betrachten 
%  - Abstandsmass für die sesibilität von einen Parameter

% Version > 1.0
%  - gui
%  - test BODE, DDE, DAE, ... was matlab hergibt

% ???
%  - Seperartion absolut und in relativ
%  - CLim befehl
