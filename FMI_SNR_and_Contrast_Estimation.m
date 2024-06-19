function FMI_SNR_and_Contrast_Estimation
% Reads the provided data, displays the different region of interest,
% estimates SNR and contrast metrics for various formulas and background
% ROIs, and plots the metric maps and bars for comparison. The script has
% been desinged tailored to [1] and reproduces the figures of the
% manuscript. The functions SNRformulas.m and contrastFormulas.m contain
% all equations as described in Table 2 of [1] and can be used with any
% fluorescence standard to estimate SNR and contrast. All the other
% functions included are for data handling and visualization. They can also
% be adapted according to the individual applications.
%
% 2024.06 / Created by the Fluorescence Imaging Group at the Institute of
% Biological and Medical Imaging of Helmholtz Munich (contact
% dimitrios.gkorpas@helmholtz-munich.de).
%
% MIT License
% Copyright (c) 2024 Dimitris Gorpas

% Add Kernels into path
p = path;
path('./Kernels', p);

% Set the field names for the exemplary data
S.Mob = "Mob";
S.NIRFI = "NIRFI";
S.NIRFII = "NIRFII";
S.RawFl = "RawFl";
S.Solaris = "Solaris";
S.Hybrid = "Hybrid";

module = fieldnames(S);

% The depth of the wells (specific to this example and the data presented
% in [1]) in mm
depth = [0.2000; 0.4000; 0.6000; 0.8000; 1; 1.3300; 1.6600; 2; 3];

% Select the path of the exemplary data
folder_path = uigetdir('Please select the path with the data');

if ischar(folder_path)

    for i = 1:length(module) % For all the systems

        if le(i, 3) % Load and analyze the data from the first 3 modules, where imaging is per well

            [centers, radii, pars, center_roibackaway,...
                radii_back, Radii, croppedImages, IMG_BKG_away] = loadData(folder_path, module{i}, 1); % Load the data

            [stats, statsback, statsbackaway] = regionStats(depth, module{i}, croppedImages, centers, radii,...
                radii_back, IMG_BKG_away, center_roibackaway, Radii, 1); % Estimate the well and background propertis

        else % Load the data from the last 3 modules where all 9 wells were imaged at once

            [centers, radii, pars, center_roibackaway,...
                radii_back, Radii, croppedImages, IMG_BKG_away] = loadData(folder_path, module{i}, 0); % Load the data

            [stats, statsback, statsbackaway] = regionStats(depth, module{i}, croppedImages, centers, radii,...
                radii_back, IMG_BKG_away, center_roibackaway, Radii, 0); % Estimate the well and background propertis

        end

        % Estimate the 4 SNR values as described in Table 2 of [1] for both
        % background ROIs
        [SNR_1, SNR_2_back_1, SNR_2_back_2away, SNR_3_back1,...
            SNR_3_back2away, SNR_4_back1, SNR_4_back2away] = SNRformulas(stats, statsback, statsbackaway);

        % Estimate the 2 contrast values as described in Table 2 of [1] for both
        % background ROIs
        [C_Mich_1, C_Mich_2away, C_Weber_1,...
            C_Weber_2away] = contrastFormulas(stats, statsback, statsbackaway, pars);

        % Generate two structures for SNR and contrast per system.
        [SNR.(module{i}), Contrast.(module{i})] = metricStruct(SNR_1, SNR_2_back_1, SNR_2_back_2away,...
            SNR_3_back1, SNR_3_back2away, SNR_4_back1, SNR_4_back2away, C_Mich_1,...
            C_Mich_2away, C_Weber_1, C_Weber_2away);

    end

    % Plot SNR maps
    SNR1 = metricMaps(module, depth, SNR, 'SNR_1', "f1"); % SNR_1 for all 6 systems and 9 wells
    SNR2b1 = metricMaps(module, depth, SNR, 'SNR_2^b^1', "f2", "b1"); % SNR_2 with background ROI surrounding the wells for all 6 systems and 9 wells
    SNR2b2 = metricMaps(module, depth, SNR, 'SNR_2^b^2', "f2", "b2"); % SNR_2 with background ROI far away from the wells for all 6 systems and 9 wells
    SNR3b1 = metricMaps(module, depth, SNR, 'SNR_3^b^1', "f3", "b1"); % SNR_3 with background ROI surrounding the wells for all 6 systems and 9 wells
    SNR3b2 = metricMaps(module, depth, SNR, 'SNR_3^b^2', "f3", "b2"); % SNR_3 with background ROI far away from the wells for all 6 systems and 9 wells
    SNR4b1 = metricMaps(module, depth, SNR, 'SNR_4^b^1', "f4", "b1"); % SNR_4 with background ROI surrounding the wells for all 6 systems and 9 wells
    SNR4b2 = metricMaps(module, depth, SNR, 'SNR_4^b^2', "f4", "b2"); % SNR_4 with background ROI far away from the wells for all 6 systems and 9 wells

    % Plot Contrast maps
    CMb1 = metricMaps(module, depth, Contrast, 'C_M^b^2', "Mich", "b1"); % Michelson Contrast with background ROI surrounding the wells for all 6 systems and 9 wells
    CMb2 = metricMaps(module, depth, Contrast, 'C_M^b^2', "Mich", "b2"); % Michelson Contrast with background ROI surrounding the wells for all 6 systems and 9 wells
    CWb1 = metricMaps(module, depth, Contrast, 'C_W^b^1', "Web", "b1"); % Weber Contrast with background ROI surrounding the wells for all 6 systems and 9 wells
    CWb2 = metricMaps(module, depth, Contrast, 'C_W^b^2', "Web", "b2"); % Weber Contrast with background ROI surrounding the wells for all 6 systems and 9 wells

    % Make the bar plots for all metrics, systems, and wells of the
    % specific examples included
    for i = 1:length(depth)

        % SNR bar plots
        metricBars(module, depth(i), i, 'SNR', ' (dB)', SNR1, SNR2b1, SNR2b2, SNR3b1, SNR3b2, SNR4b1, SNR4b2);
        
        % Contrast bar plots
        metricBars(module, depth(i), i, 'C', ' (a.u.)', CMb1, CMb2, CWb1, CWb2);

    end

end

% Restore original path
path(p);