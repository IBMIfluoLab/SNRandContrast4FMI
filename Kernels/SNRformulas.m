function [SNR_1, SNR_2_back_1, SNR_2_back_2away, SNR_3_back1, SNR_3_back2away, SNR_4_back1, SNR_4_back2away] = SNRformulas(stats, statsback, statsbackaway)
% Estimation of the SNR values according to the formulas presented in [1].
%
% Inputs: stats - The properties of the wells (min, max, mean, and per
% pixels intensities); statsback - The properties of the background ROIs
% surrounding the wells (min, max, mean, and per pixels intensities);
% statsbackaway - The properties of the ROI far away from the wells (min,
% max, mean, and per pixels intensities)
%
% Outputs: The four SNR values as described in the manuscript [1] and for
% the two background ROIs.
%
% 2024.06 / Created by the Fluorescence Imaging Group at the Institute of
% Biological and Medical Imaging of Helmholtz Munich (contact
% dimitrios.gkorpas@helmholtz-munich.de).
%
% MIT License
% Copyright (c) 2024 Dimitris Gorpas

% SNR vector initialization (all zeros)
SNR_1 = zeros(9, 1);
SNR_2_back_1 = zeros(9, 1);
SNR_2_back_2away = zeros(9, 1);
SNR_3_back1 = zeros(9, 1);
SNR_3_back2away = zeros(9, 1);
SNR_4_back1 = zeros(9, 1);
SNR_4_back2away = zeros(9, 1);

for i = 1:9 % For all 9 wells

    % SNR_1. SNR=n/σ=sqrt(n). n - number of photons on the detector; σ -
    % the noise associated with the detector (i.e., standard deviation).
    N = stats{1, i}.MeanIntensity;
    SNR_1(i) = sqrt(N);

    % SNR_2. SNR=S/sqrt(S+N). S - mean foreground signal pixel intensity; N -
    % mean background  noise pixel intensity.
    AverageSignal = stats{1, i}.MeanIntensity;
    Noiseback_1 = statsback{1, i}.MeanIntensity;
    Noiseback_2away = statsbackaway.MeanIntensity;   
    SNR_2_back_1(i) = AverageSignal / (sqrt(AverageSignal + Noiseback_1));
    SNR_2_back_2away(i) = AverageSignal / (sqrt(AverageSignal + Noiseback_2away));

    % SNR_3. SNR=μ_(S-N)/σ_S. μ_(S-N) - mean signal after background
    % subtraction; σ_S - standard deviation of signal.
    Signal = stats{1, i}.PixelValues;
    Background_1 = mean(statsback{1, i}.PixelValues);    
    Background_2away = mean(statsbackaway.PixelValues);
    SignalSubs_1 = Signal  - Background_1;
    Signa1Subs_2away = Signal - Background_2away;
    sigma_std = std2(Signal);
    SNR_3_back1(i) = mean(SignalSubs_1)/sigma_std;
    SNR_3_back2away(i) = mean(Signa1Subs_2away / sigma_std);

    % SNR_4. NR=(S-N)/σ_N. S - mean signal pixel intensity; N - mean
    % background  noise pixel intensity, σ_N - background standard
    % deviation.
    stdBackground_1 = std2(statsback{1, i}.PixelValues);
    stdBackground_2away = std2(statsbackaway.PixelValues);
    SNR_4_back1(i) = (AverageSignal - Background_1) / stdBackground_1;
    SNR_4_back2away(i) = (AverageSignal - Background_2away) / stdBackground_2away;

end