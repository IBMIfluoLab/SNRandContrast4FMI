function metricBars(module, depth, num, str, strUnits, metric_1, metric_2, metric_3, metric_4, metric_5, metric_6, metric_7)
% Plots the metric bar plot for all 6 systems and for all metric values
%
% Inputs: 
% module -   The systems for which the metric maps are constructed;
% depth -    The depth of the wells (specific to the data presented in [1];
% num -      The specific depth for which the bar plot is constructed;
% str -      The metric for which the bar plot is constructed (i.e., SNR
%            or contrast);
% strUnits - The units of the metric (i.e. dB for SNR and a.u. for
%            contrast);
% metric_N - The metric values to be used for the bar plots (i.e., N=1:7
%            for SNR and N=1:4 for contrast.
%
% 2024.06 / Created by the Fluorescence Imaging Group at the Institute of
% Biological and Medical Imaging of Helmholtz Munich (contact
% dimitrios.gkorpas@helmholtz-munich.de).
%
% MIT License
% Copyright (c) 2024 Dimitris Gorpas

% If there are 12 inputs then the bars are constructed for all SNR values
if eq(nargin, 12)
    
    metric_BARs = [metric_1(num, :)' metric_2(num, :)' metric_3(num, :)' metric_4(num, :)',...
        metric_5(num, :)' metric_6(num, :)' metric_7(num, :)'];

    strX = [string([str '_1']), string([str '_2^b^1']), string([str '_2^b^2']), string([str '_3^b^1']),...
    string([str '_3^b^2']), string([str '_4^b^1']), string([str '_4^b^2'])];

% If there are 9 inputs then the bars are constructed for all Contrast values
elseif eq(nargin, 9)

    metric_BARs = [metric_1(num, :)' metric_2(num, :)' metric_3(num, :)' metric_4(num, :)'];

    strX = [string([str '_M^b^1']), string([str '_M^b^2']), string([str '_W^b^1']), string([str '_W^b^2'])];

end

% Construct the bar plots and set the plot properties for visualization
x = 1:size(metric_BARs, 2);

figure;
bar(x, metric_BARs);
set(gca, 'XtickLabel', [], 'box', 'off')

ax = gca;
ylim([0 ceil(max(metric_BARs(:)))])
yticks([0 (ceil(max(metric_BARs(:))) / 2) ceil(max(metric_BARs(:)))])
ylabel([str strUnits])
xticklabels(ax, strX);
xlabel([str ' formula and background at ' num2str(depth) ' mm'])
legend([string(module{1}), string(module{2}), string(module{3}),...
    string(module{4}), string(module{5}), string(module{6})], 'Location',...
    'northoutside', 'Orientation', 'horizontal');
set(gcf, 'Position',  [400, 100, 1000, 250])