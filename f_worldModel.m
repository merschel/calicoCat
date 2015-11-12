function [dxdt J] = f_worldModel(~,x,k)
% numberOfEquations = 3
% numberOfParameter = 8

% Zustaende
Bevoelkerung = x(1);
Umweltbelastung = x(2);
Anlagen = x(3);

% Parameter
GEBURTENRATE      = k(1);
STERBERATE        = k(2);
GEBURTENKONTROLLE = k(3);
SCHADSCHWELLE     = k(4);
ERHOLUNGSRATE     = k(5);
BELASTUNGSRATE    = k(6);
KONSUMZIEL        = k(7);
ZUWACHSRATE       = k(8);

% Zwischenfunktionen 
KonsumNiveau = Anlagen;
UmweltQualitaet = SCHADSCHWELLE/Umweltbelastung;

% DGLs
dxdt(1,1) = GEBURTENRATE * Bevoelkerung * GEBURTENKONTROLLE * UmweltQualitaet * KonsumNiveau - STERBERATE * Bevoelkerung * Umweltbelastung;

if UmweltQualitaet > 1
    Erholung = ERHOLUNGSRATE * Umweltbelastung;
else
    Erholung = ERHOLUNGSRATE * SCHADSCHWELLE; 
end

dxdt(2,1) = BELASTUNGSRATE * KonsumNiveau * Bevoelkerung - Erholung;
dxdt(3,1) = ZUWACHSRATE * Anlagen * Umweltbelastung * ( 1 - Anlagen*Umweltbelastung/KONSUMZIEL); 

% Jakobimatrix
if nargout == 2
    df1dBevoelkerung = GEBURTENRATE*GEBURTENKONTROLLE*SCHADSCHWELLE*Anlagen/Umweltbelastung - STERBERATE*Umweltbelastung;
    df1dUmweltbelastung = - GEBURTENRATE*GEBURTENKONTROLLE*SCHADSCHWELLE*Anlagen * Bevoelkerung / Umweltbelastung^2 - STERBERATE*Umweltbelastung;
    df1dAnlagen = GEBURTENRATE*GEBURTENKONTROLLE*SCHADSCHWELLE*Bevoelkerung/Umweltbelastung;
    
    df2dBevoelkerung = BELASTUNGSRATE * Anlagen;
    if UmweltQualitaet > 1 
        df2dUmweltbelastung = - ERHOLUNGSRATE; 
    else
        df2dUmweltbelastung = 0;
    end
    df2dAnlagen = BELASTUNGSRATE * Bevoelkerung;
    
    df3dBevoelkerung = 0;
    df3dUmweltbelastung = ZUWACHSRATE * Anlagen * ( 1 - Anlagen*Umweltbelastung/KONSUMZIEL) - ZUWACHSRATE * Anlagen^2 * Umweltbelastung / KONSUMZIEL;
    df3dAnlagen = ZUWACHSRATE * Umweltbelastung * ( 1 - Anlagen*Umweltbelastung/KONSUMZIEL) - ZUWACHSRATE * Anlagen * Umweltbelastung^2 / KONSUMZIEL;
    J = [df1dBevoelkerung df1dUmweltbelastung df1dAnlagen; df2dBevoelkerung df2dUmweltbelastung df2dAnlagen; df3dBevoelkerung df3dUmweltbelastung df3dAnlagen];
end

end