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

%preference.seperation.para.interval{1} = {{0 0.3; 0.3 1};{0 0.7; 0.7 1};{0 0.1; 0.1 0.6; 0.6 0.8; 0.8 1}};  % Erste Seperation für den ersten, zweiten und dritten Parameter
preference.seperation.para.interval{1} = {{0 0.5; 0.5 1}};     % Zweite Seperation für alle 3 Parameter gleich 
%preference.seperation.para.interval{2} = {{0 0.3; 0.3 0.5; 0.5 1}};  % dritte Seperation für alle Parameter gleich 


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
%  - eigenwert analyse
%  - CLim befehl
%  - gui
%  - test BODE, DDE, DAE, ... was matlab hergibt
%  - 3d seperation
%  - speicher von zwischenergebnissen um datenverlust bei abst�rzen vorzubeugen+
%  speichern allgemine 
%  - eigene Colormap welche konstant in abh�ngigkeit der anzahl der
%  l�sungen ist
%  - option des sichtbereiches der L�sung (dicht) eif�gen
%  - Varablen umbenennen
%  - give the hole project a better name: how about LyX, CalicoCat
%  - Seperartion absolut und in relativ
%  - wenn dichte oder solution nicht berechet werden, muss das prgramm
%  reagieren
%  - test ob inic seperation die intervalle keinen luecken haben, ggf auch
%  fuer die anderen seperation ueberpruefen
%  - Komentare und funktionsbeschreibung  



