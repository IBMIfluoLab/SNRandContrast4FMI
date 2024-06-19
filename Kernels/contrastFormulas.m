function [C_Mich_1, C_Mich_2away, C_Weber_1, C_Weber_2away] = contrastFormulas(stats, statsback, statsbackaway, pars)
% Estimation of the contrast values according to the formulas presented in
% [1].
%
% Inputs: 
% stats -         The properties of the wells (min, max, mean, and per 
%                 pixels intensities);
% statsback -     The properties of the background ROIs surrounding the 
%                 wells (min, max, mean, and per pixels intensities);
% statsbackaway - The properties of the ROI far away from the wells (min,
%                 max, mean, and per pixels intensities);
% pars -          The number of pixels to quantify the maximum of signal 
%                 and the minimum of the background 1 and background 2.
%
% Outputs: 
% The two contrast values as described in the manuscript [1] and
% for the two background ROIs.
%
% 2024.06 / Created by the Fluorescence Imaging Group at the Institute of
% Biological and Medical Imaging of Helmholtz Munich (contact
% dimitrios.gkorpas@helmholtz-munich.de).
%
% MIT License
% Copyright (c) 2024 Dimitris Gorpas

% Contrast vector initialization (all zeros)
C_Mich_1 = zeros(9, 1);
C_Mich_2away = zeros(9, 1);
C_Weber_1 = zeros(9, 1);
C_Weber_2away = zeros(9, 1);

for i = 1:9

    % Sort pixel values to extraxt max from wells and min from background
    % ROIs
    sorted_pixval_max = sort((stats{1,i}.PixelValues),'descend'); 
    sorted_pixval_min = sort((statsback{1,i}.PixelValues));
    sorted_pixval_minaway = sort((statsbackaway.PixelValues));

    % Get the max from the wells and min from the background ROIs as the
    % mean value of the window specified in pars
    I_max = mean(double(sorted_pixval_max(1:pars(1,1),1))); % Maximum Intensity
    I_min_1 = mean(double(sorted_pixval_min(1:pars(2,1),1))); % Minimum Intensity of background ROIs surrounding the wells
    I_min_2away =  mean(double(sorted_pixval_minaway(1:pars(end,1),1))); % Minimum Intensity of the background ROI far from the wells

    % Michelson formula. C_M =(I_max-I_min)/(I_max+I_min). I_max,I_min   maximum pixel intensity and minimum background pixel intensity intensity respectively.
    C_Mich_1(i) = (I_max - I_min_1) / (I_max + I_min_1);
    C_Mich_2away(i) = (I_max - I_min_2away) / (I_max + I_min_2away);

    % Weber fraction. C_W=  (I_s-I_b)/I_b. I_s,I_b  maximum foreground and minimum background light intensity respectively. 
    C_Weber_1(i) = (I_max - I_min_1 ) / I_min_1 ;
    C_Weber_2away(i) = (I_max - I_min_2away) / I_min_2away;

end