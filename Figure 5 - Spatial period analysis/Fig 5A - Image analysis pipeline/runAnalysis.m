clear, clc; close all;

%% Load experiment data
addpath('functions')
% addpath('functions\boundedline\')
% addpath('functions\catuneven\')
% addpath('functions\Inpaint_nans\')
% addpath('functions\singlepatch\')

roiWidthInMicrons = 15; %Define the width of the regions of interest (roi) measured in um
blurMicronsSD = 3; %Gaussian blur standard deviation in um (3um is used in the paper)

plotImages = 1; % 1=yes, 0=no. Plot individual images, ROIs, spatial period analyses (takes much longer)
plotGraphs = 1;


%% Get experiment data
[DMSO, ML141_75uM] = experimentData(roiWidthInMicrons);


%% Plot images, regions of interest, and store cropped roi data

%DMSO
figNum = 1;

figNum = figNum + 10;
[DMSO.Exp2] = analyseData(DMSO.Exp2, figNum, plotImages, blurMicronsSD);

figNum = figNum + 10;
[DMSO.Exp3] = analyseData(DMSO.Exp3, figNum, plotImages, blurMicronsSD);

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

% [spatialPeriodsInd, spatialPeriodsComb] = plotResults(allResults, condName);
[spatialPeriodsInd, spatialPeriodsComb, interpFrequency, powerAvg, pk2pk_combined, detrendedSDcomb, coherence] = plotResults(allResults, condName, plotGraphs);


%% Things to add to analysis:

%Mann-Whitney U test
pval_Fisher         = ranksum(spatialPeriodsComb.Fisher(:,1), spatialPeriodsComb.Fisher(:,2));
pval_Bootstrap      = ranksum(spatialPeriodsComb.Bootstrap(:,1), spatialPeriodsComb.Bootstrap(:,2));
pval_pk2pkBootstrap = ranksum(spatialPeriodsComb.pk2pkBootstrap(:,1), spatialPeriodsComb.pk2pkBootstrap(:,2)); 

Measurement = ["Combined exp: FFT p-val"; "Combined exp: ACF p-val"; "Combined exp: ACF pk2pk p-val"; "Power spectrum coherence: DMSO"; "Powe spectrum coherence: ML141"];
Value = [pval_Fisher; pval_Bootstrap; pval_pk2pkBootstrap; coherence.DMSO; coherence.ML141];

One_way_ANOVA_pvals = table(Measurement, Value)


% [~, ks_pval]=kstest2(powerAvg(1,1:500), powerAvg(2,1:500))


