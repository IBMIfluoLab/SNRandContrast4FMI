function metric_1 = metricMaps(module, depth, metric, str, metricval1, metricval2)
% Plots the metric maps for all 6 systems and for all 9 wells
%
% Inputs: 
% module -     The systems for which the metric maps are constructed;
% depth -      The depth of the wells (specific to the data presented in
%              [1];
% metric -     The metric values structure as resulted from the 
%              metricStruct function;
% str -        The title of the map as string; 
% metricval1 - The metric function to be % mapped as string (e.g. "f1" for
%              SNR_1, "f2" for SNR_2, "Mich" for Michelson contrast etc.). 
%              The description of the functions is in Table 2 of [1];
% metricval2 - The background to be used for the mapping (i.e., "b1" for 
%              background ROI surrounding the wells and "b2" for background
%              ROI far away from the wells.
%
% Output:
% metric_1 -   The values of the metric to be mapped for all systems and
%              wells.
%
% 2024.06 / Created by the Fluorescence Imaging Group at the Institute of
% Biological and Medical Imaging of Helmholtz Munich (contact
% dimitrios.gkorpas@helmholtz-munich.de).
%
% MIT License
% Copyright (c) 2024 Dimitris Gorpas

% If metricval2 is provided (i.e., 5 inputs) then the maps are constructed
% for either background ROI surrounding or far away from the wells
if eq(nargin, 6)
    
    metric_1 = [metric.(module{1}).(metricval1).(metricval2) metric.(module{2}).(metricval1).(metricval2)...
        metric.(module{3}).(metricval1).(metricval2) metric.(module{4}).(metricval1).(metricval2)...
        metric.(module{5}).(metricval1).(metricval2)  metric.(module{6}).(metricval1).(metricval2)];

% If metricval2 is not provided (i.e., 4 inputs) then the map is 
% constructed for metric_1 (as in Table 2 in [1]) where there is no 
% background
elseif eq(nargin, 5)

    metric_1 = [metric.(module{1}).(metricval1) metric.(module{2}).(metricval1) metric.(module{3}).(metricval1)...
        metric.(module{4}).(metricval1) metric.(module{5}).(metricval1)  metric.(module{6}).(metricval1)];

end

% Construct the map and set the plot properties for visualization
figure;
clims = [min(metric_1, [], 'all') max(metric_1, [], 'all')];
imagesc(metric_1, clims)
colorbar('southoutside')
colormap bone
ax=gca;
yticklabels(ax, depth);
ylabel('Depth, mm')
xticklabels(ax,[string(module{1}), string(module{2}), string(module{3}),...
    string(module{4}), string(module{5}), string(module{6})]);
ax.XAxisLocation = 'top';
title(str);
set(gcf, 'Position',  [200, 700, 350, 450]);