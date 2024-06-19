function [stats, statsback, statsbackaway] = regionStats(depth, module, croppedImages, centers, radii, radii_back, IMG_BKG_away, center_roibackaway, Radii, cropped)
% Estimate the properties of the wells and background ROIs
%
% Inputs:
% depth -              The depth of the well considered;
% module -             The system considered;
% croppedImages -      The images of the wells;
% centers -            The centers of the wells;
% radii -              The radius of each well;
% radii_back -         The radius of the background ROIs surrounding the 
%                      wells;
% IMG_BKG_away -       The background image far away from the wells;
% center_roibackaway - The center of the background ROI far away from the 
%                      wells;
% Radii -              The radius of the background ROI far away from the 
%                      wells;
% cropped -            1 if the fluorescence standard was imaged per well 
%                      and 0 if all 9 wells were imaged together.
%
% Outputs:
% stats -         Max, mean, min, and per pixel intensity values of the 
%                 wells;
% statsback -     Max, mean, min, and per pixel intensity values of the
%                 background ROIs surrounding the wells;
% statsbackaway - Max, mean, min, and per pixel intensity values of the
%                 background ROIs far away from the wells.
%
% 2024.06 / Created by the Fluorescence Imaging Group at the Institute of
% Biological and Medical Imaging of Helmholtz Munich (contact
% dimitrios.gkorpas@helmholtz-munich.de).
%
% MIT License
% Copyright (c) 2024 Dimitris Gorpas

stats = cell(1, length(depth));
statsback = cell(1, length(depth));

for i = 1:length(depth) % For all the wells

    if eq(cropped, 1)

        maxI = max(croppedImages(i).sample,[],'all'); % Maximum intensity within the well
        ImgOrig = croppedImages(i).sample; % Original image of the well

        % Show the well and the surrounding background ROI
        figure;
        imshow(ImgOrig, [0 maxI]);
        title([module ' at ' num2str(depth(i)) ' mm']);
        set(gcf, 'Position',  [70*i, 300, 250, 250])

        roi = drawcircle('Center', centers{i}, 'Radius', radii{i}, 'StripeColor', 'black'); % Draw the boundary of the well
        hold on
        mask = createMask(roi); % Create the mask of the well

        stats{1, i} = regionprops(mask, ImgOrig, 'MaxIntensity', 'MeanIntensity',...
            'MinIntensity','PixelValues'); % Estimate the well properties

        roiback = drawcircle('Center', centers{i}, 'Radius', radii_back{i}); % Draw the background ROI
        hold on

        maskback = createMask(roiback); % Create the mask of the background ROI
        maskback = maskback - mask; % Remove the well from the mask
        statsback{i} = regionprops(maskback, ImgOrig, 'MaxIntensity', 'MeanIntensity',...
            'MinIntensity', 'PixelValues'); % Estimate the background ROI properties
                
    else

        maxI = max(croppedImages,[],'all'); % Maximum intensity from all wells

        % Show the wells and the surrounding background ROIs
        figure;
        imshow(croppedImages,[0 maxI]);
        title([module ' at ' num2str(depth(i)) ' mm']);
        set(gcf, 'Position',  [70*i, 300, 250, 250]) 

        roi_1 = drawcircle('Center', centers(i, :), 'Radius', radii); % Draw the boundary of each well
        mask = createMask(roi_1); % Create the mask of the well
        stats{1, i} = regionprops(mask, croppedImages, 'MaxIntensity', 'MeanIntensity',...
            'MinIntensity', 'PixelValues'); % Estimate the well properties

        roiback = drawcircle('Center', centers(i, :), 'Radius', radii_back); % Draw the background ROI

        maskback = createMask(roiback); % Create the mask of the background ROI
        maskback = maskback - mask; % Remove the well from the mask
        statsback{i} = regionprops(maskback, croppedImages, 'MaxIntensity', 'MeanIntensity',...
            'MinIntensity', 'PixelValues'); % Estimate the background ROI properties
       
    end

    hold off

    pause(0.2)

end

% Obtain values for the backround away from the wells
max_IMG_BKG_away = max(IMG_BKG_away, [], 'all'); % Maximum intensity from the background ROI far from the wells

% Show the background ROI far from the wells
figure;
imshow(IMG_BKG_away, [0 max_IMG_BKG_away]);
title([module ' background far']);
set(gcf, 'Position',  [700, 100, 250, 300])

roibackaway = drawcircle('Center', center_roibackaway, 'Radius', Radii, 'StripeColor', 'black'); % Draw the boundary of the background ROI
maskbackaway = createMask(roibackaway); % Create the mask of the background ROI
statsbackaway = regionprops(maskbackaway, IMG_BKG_away, 'MaxIntensity', 'MeanIntensity',...
    'MinIntensity', 'PixelValues'); % Estimate the background ROI properties

pause(0.2)