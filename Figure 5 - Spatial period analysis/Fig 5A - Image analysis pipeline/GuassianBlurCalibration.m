clear, clc; close all;

%% Load experiment data
addpath('functions')

roiWidthInMicrons = 15;                                                     %Define the width of the regions of interest (roi) measured in um

plotImages = 0; % 1=yes, 0=no. Plot individual images, ROIs, spatial period analyses (takes much longer)
plotGraphs = 0; % Keep this set to zero otherwise graphs will be plotted on every loop

I = 20;
I_arr = linspace(0.001, 8, I);
%% Get experiment data
[DMSO, ML141_75uM] = experimentData(roiWidthInMicrons);

%% Run multiple analysis on code using a range of Guassian blur widths 
for i =1:I

blurMicronsSD = I_arr(i);

%% Plot images, regions of interest, and store cropped roi data

% %DMSO
figNum = 1;

figNum = figNum + 10;
[DMSO.Exp2] = analyseData(DMSO.Exp2, figNum, plotImages, blurMicronsSD);

figNum = figNum + 10;
[DMSO.Exp3] = analyseData(DMSO.Exp3, figNum, plotImages, blurMicronsSD);
% 
figNum = figNum + 10;
[DMSO.Exp4] = analyseData(DMSO.Exp4, figNum, plotImages, blurMicronsSD);

figNum = figNum + 10;
[DMSO.Exp5] = analyseData(DMSO.Exp5, figNum, plotImages, blurMicronsSD);

figNum = figNum + 10;
[DMSO.Exp6] = analyseData(DMSO.Exp6, figNum, plotImages, blurMicronsSD);

figNum = figNum + 10;
[DMSO.Exp7] = analyseData(DMSO.Exp7, figNum, plotImages, blurMicronsSD);


% ML141 75uM
figNum = figNum + 10;
[ML141_75uM.Exp2] = analyseData(ML141_75uM.Exp2, figNum, plotImages, blurMicronsSD);

figNum = figNum + 10;
[ML141_75uM.Exp3] = analyseData(ML141_75uM.Exp3, figNum, plotImages, blurMicronsSD);

figNum = figNum + 10;
[ML141_75uM.Exp4] = analyseData(ML141_75uM.Exp4, figNum, plotImages, blurMicronsSD);

figNum = figNum + 10;
[ML141_75uM.Exp5] = analyseData(ML141_75uM.Exp5, figNum, plotImages, blurMicronsSD);

figNum = figNum + 10;
[ML141_75uM.Exp6] = analyseData(ML141_75uM.Exp6, figNum, plotImages, blurMicronsSD);

figNum = figNum + 10;
[ML141_75uM.Exp7] = analyseData(ML141_75uM.Exp7, figNum, plotImages, blurMicronsSD);



%% Plot spatial periods

allResults = [ DMSO.Exp2; ML141_75uM.Exp2; DMSO.Exp3; ML141_75uM.Exp3; DMSO.Exp4; ML141_75uM.Exp4; DMSO.Exp5; ML141_75uM.Exp5; DMSO.Exp6; ML141_75uM.Exp6; DMSO.Exp7; ML141_75uM.Exp7];

condName = {'DMSO', 'ML141 75uM'};

[spatialPeriodsInd, spatialPeriodsComb, interpFrequency, powerAvg, pk2pk_combined] = plotResults(allResults, condName, plotGraphs);

percent = 100*i/I;
clc;
fprintf('Progress: %.f%%', percent)

below10um = numel(find(pk2pk_combined<10));
percentBelow10um(i) = 100*below10um/numel(pk2pk_combined);

[~,idx_10um] = min(abs(1./interpFrequency-10));
powerAt10um(i) = (powerAvg(1, idx_10um));

end
%%
figure(2)
clf

yyaxis left
plot(I_arr, powerAt10um, 'LineWidth',2)
title('Fourier power at 10um')
xlabel('Guassian blur SD width')
ylabel('Average power from DMSO spectra')

yyaxis right
plot(I_arr, percentBelow10um, '-.','LineWidth',2)
ylabel('Percent of pk2pk distances below 10um')
xlabel('Guassian blur SD width')
title('% below 10um in pk2pk ACF')
