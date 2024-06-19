function [centers, radii, pars, center_roibackaway, radii_back, Radii, croppedImages, IMG_BKG_away] = loadData(folder_path, module, cropped)
% Loads all the required data from the experiments described in [1] for
% estimating the SNR and contrast values from 6 systems. 
%
% Inputs:
% folder_path - The parent path where the folders with data from each
%               system exist;
% module -      The system name (see Table 1 in [1]);
% cropped -     1 if the fluorescence standard was imaged per well and 0 if
%               all 9 wells were imaged together.
%
% Outpus:
% All outputs are described bellow and they all are related to the
% location and size of the wells and the background regions of interest.
%
% 2024.06 / Created by the Fluorescence Imaging Group at the Institute of
% Biological and Medical Imaging of Helmholtz Munich (contact
% dimitrios.gkorpas@helmholtz-munich.de).
%
% MIT License
% Copyright (c) 2024 Elena Krukova and Dimitris Gorpas

% Load the centers of the wells
lcenters = load(fullfile(folder_path, module, ['centers_' module '.mat']));
centers = lcenters.centers;

% Load the radius of the wells
lradii = load(fullfile(folder_path, module, ['radii_' module '.mat']));
radii = lradii.radii;

% Load the number of pixels to quantify the maximum of signal and the
% minimum of the background 1 and background 2
lpars = load(fullfile(folder_path, module, ['pars_' module '.mat']));
pars = lpars.pars;

% Load the center of the background ROI far away from the wells
lcenter_roibackaway = load(fullfile(folder_path, module, ['center_roibackaway_' module '.mat']));
center_roibackaway = lcenter_roibackaway.center_roibackaway;

% Load the radius of the background ROIs surrounding each well
lradii_back = load(fullfile(folder_path, module, ['radii_back_' module '.mat']));
radii_back = lradii_back.radii_back;

% Load the mean radius of the wells
meanR = load(fullfile(folder_path, module, ['R_' module '.mat']));
Radii = meanR.Radii;

% Load the cropped images of the fluorescence standard
if eq(cropped, 1)

    lcroppedImages = load(fullfile(folder_path, module, ['cropped_images_' module '.mat']));
    croppedImages = lcroppedImages.croppedImages;

else

    lcroppedImages = load(fullfile(folder_path, module, ['Image_' module '.mat']));
    croppedImages = lcroppedImages.Img;

end

% Load the background image away from the wells
lIMG_BKG_away = load(fullfile(folder_path, module, ['IMG_BKG_away_' module '.mat']));
IMG_BKG_away = lIMG_BKG_away.IMG_BKG_away;
