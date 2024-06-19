function [SNR, Contrast] = metricStruct(SNR_1, SNR_2_back_1, SNR_2_back_2away,...
    SNR_3_back1, SNR_3_back2away, SNR_4_back1, SNR_4_back2away, C_Mich_1,...
    C_Mich_2away, C_Weber_1, C_Weber_2away)
% Group all metrics into two structures, the SNR and contrast
% 
% Inputs:
% All SNR and contrast metrics
%
% Outputs:
% SNR -      All the SNR values from the formulas of Table 2 in [1];
% Contrast - All contrast metrics from the formulas of Table 2 in [1].
%
% 2024.06 / Created by the Fluorescence Imaging Group at the Institute of
% Biological and Medical Imaging of Helmholtz Munich (contact
% dimitrios.gkorpas@helmholtz-munich.de).
%
% MIT License
% Copyright (c) 2024 Dimitris Gorpas

% Group all SNR values for all formulas and all wells in one structure
SNR = struct('depth', [],'f1', [], 'f2', [], 'f3', []);
SNR.f1 = 20*log10(SNR_1);
SNR.f2.b1 = 20*log10(SNR_2_back_1);
SNR.f2.b2 = 20*log10(SNR_2_back_2away);
SNR.f3.b1 = 20*log10(SNR_3_back1);
SNR.f3.b2 = 20*log10(SNR_3_back2away);
SNR.f4.b1 = 20*log10(SNR_4_back1);
SNR.f4.b2 = 20*log10(SNR_4_back2away);

% Zero any possible negative SNR value
SNR.f1(SNR.f1 < 0) = 0;
SNR.f2.b1(SNR.f2.b1 < 0) = 0;
SNR.f2.b2(SNR.f2.b2 < 0) = 0;
SNR.f3.b1(SNR.f3.b1 < 0) = 0;
SNR.f3.b2(SNR.f3.b2 < 0) = 0;
SNR.f4.b1(SNR.f4.b1 < 0) = 0;
SNR.f4.b2(SNR.f4.b2 < 0) = 0;

% Group all Contrast values for all formulas and all wells in one structure
Contrast = struct('Mich', [], 'Web', []);
Contrast.Mich.b1 = C_Mich_1;
Contrast.Mich.b2 = C_Mich_2away;
Contrast.Web.b1 = C_Weber_1;
Contrast.Web.b2= C_Weber_2away;