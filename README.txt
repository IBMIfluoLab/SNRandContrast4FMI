About this repository

The script "FMI_SNR_and_Contrast_Estimation.m" reads the provided data, displays the different region of interest, estimates SNR and contrast metrics for various formulas and background ROIs, and plots the metric maps and bars for comparison. The script has been desinged tailored to [1] and reproduces the figures of the manuscript. The functions SNRformulas.m and contrastFormulas.m contain all equations as described in Table 2 of [1] and can be used with any fluorescence standard to estimate SNR and contrast. All the other functions included are for data handling and visualization. They can also be adapted according to the individual applications.

Data
The dataset used in the paper is available in the folder "./Recorded data from the systems". 

Created by the Fluorescence Imaging Group at the Institute of Biological and Medical Imaging of Helmholtz Munich (contact dimitrios.gkorpas@helmholtz-munich.de).

MIT License
Copyright (c) 2024 Dimitris Gorpas

Citation
Please cite [1] if you use this code and/or any of the provided binary files.

References
[1] XXX
