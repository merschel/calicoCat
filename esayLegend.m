%
% function esayLegend(text,color)
%
% make it possible to control the line color in a legend;
% 
% - text: is a cell array with the strings for the legend
% - colorMap: is the color map for the legend. For each 
%             text entry one need a row in the color map. 
%
% Autor: Steve Merschel
% Date : 2015/09/20

function esayLegend(text,colorMap)
hLeg = legend(text);
hLegC = get(hLeg,'Children');
hLegCL = hLegC(strcmp(get(hLegC,'Type'),'line'));
colorMap = flipud(colorMap);
for i = 1:size(colorMap,1)
    set(hLegCL(2*i),'Color',colorMap(i,:))
end
