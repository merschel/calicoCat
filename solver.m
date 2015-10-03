%
% sol = solver(odeSolverHandle,odeHandle,simulationTime,inic,solverOpt,para)
%
% Anonymos function of the Matlab ODE solver.
%
% Autor: Steve Merschel
% Date : 29/05/2014

function sol = solver(odeSolverHandle,odeHandle,simulationTime,inic,solverOpt,para)
sol = odeSolverHandle(odeHandle,simulationTime,inic,solverOpt,para);