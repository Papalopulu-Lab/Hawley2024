clear; clc;

addpath("Data (MATLAB)\")
addpath('functions')
load('dataExp1.mat')
load('dataExp2.mat')


plotColours = [0.7493    0.7209    0.6570;
    0.8500 0.3250 0.0980
    0.4660 0.6740 0.1880;
    0.4660 0.6740 0.1880;];


%Data stored as condition.measurement{experiment#, slice#}

%% DMSO data
%Experiment 1 (2-Feb-2024) (1h in each condition)
DMSO.cellLengths{1, 1} = table2array(DMSO_S1_2024_02_02_CellLengths);
DMSO.protLengths{1, 1} = table2array(DMSO_S1_2024_02_02_ProtLengths);

DMSO.cellLengths{1, 2} = table2array(DMSO_S2_2024_02_02_CellLengths);
DMSO.protLengths{1, 2} = table2array(DMSO_S2_2024_02_02_ProtLengths);

DMSO = processData(DMSO);



%% LatA 100nM data
%Experiment 1 (2-Feb-2024) (1h in each condition)
LatA_100nM.cellLengths{1, 1} = table2array(LatA100nM_S1_2024_02_02_CellLengths);
LatA_100nM.protLengths{1, 1} = table2array(LatA100nM_S1_2024_02_02_ProtLengths);

LatA_100nM.cellLengths{1, 2} = table2array(LatA100nM_S2_2024_02_02_CellLengths);
LatA_100nM.protLengths{1, 2} = table2array(LatA100nM_S2_2024_02_02_ProtLengths);

LatA_100nM = processData(LatA_100nM);

%% ML141 75uM data
% Experiment 1 (2-Feb-2024) (1h in each condition)
ML141_75uM.cellLengths{1, 1} = table2array(ML141_75uM_S1_2024_02_02_CellLengths);
ML141_75uM.protLengths{1, 1} = table2array(ML141_75uM_S1_2024_02_02_ProtLengths);

ML141_75uM.cellLengths{1, 2} = table2array(ML141_75uM_S2_2024_02_02_CellLengths);
ML141_75uM.protLengths{1, 2} = table2array(ML141_75uM_S2_2024_02_02_ProtLengths);

ML141_75uM = processData(ML141_75uM);

%% ML141 150uM data

ML141_150uM.cellLengths{1, 1} = table2array(ML141_150uM_S3_2024_03_05_CellLengths);
ML141_150uM.protLengths{1, 1} = table2array(ML141_150uM_S3_2024_03_05_ProtLengths);

ML141_150uM.cellLengths{1, 2} = table2array(ML141_150uM_S4_2024_03_05_CellLengths);
ML141_150uM.protLengths{1, 2} = table2array(ML141_150uM_S4_2024_03_05_ProtLengths);

ML141_150uM = processData(ML141_150uM);


%%

clearvars -except DMSO LatA_100nM ML141_75uM ML141_150uM plotColours

maxNumProt = max([DMSO.numProt, LatA_100nM.numProt, ML141_75uM.numProt, ML141_150uM.numProt]);
protLength_plot = NaN(maxNumProt,4);
protLength_plot(1:DMSO.numProt, 1) = DMSO.allProtLengths;
protLength_plot(1:LatA_100nM.numProt, 2) = LatA_100nM.allProtLengths;
protLength_plot(1:ML141_75uM.numProt, 3) = ML141_75uM.allProtLengths;
protLength_plot(1:ML141_150uM.numProt, 4) = ML141_150uM.allProtLengths;
 

fontSize = 15;

figure(1)
clf
subplot(121)
violinplot(protLength_plot, {'DMSO', 'LatA 100nM', 'ML141 75μM', 'ML141 150μM'}, 'QuartileStyle','shadow', 'ShowMean', true, 'ViolinColor', plotColours);
ylabel('Protrusion length (μm)')
title('Protrusion length')

set(gca,'FontSize', fontSize)

figure(10)
histogram(protLength_plot(:,1))
title('Vibratome slicing')
xlabel('Protrusion length (μm)')
ylabel('count')
xlim([0 25])




%% Protrusion density distributions


 
% DMSO_numCells = length(DMSO_density);
% LatA_100nM_numCells = length(LatA_100nM_density);
% ML141_75uM_numCells = length(ML141_75uM_density);
 
maxNumCells = max([DMSO.numCells, LatA_100nM.numCells, ML141_75uM.numCells, ML141_150uM.numCells]);

protDensity_plot = NaN(maxNumCells, 4);

protDensity_plot(1:DMSO.numCells, 1) = DMSO.allProtDensity;
protDensity_plot(1:LatA_100nM.numCells, 2) = LatA_100nM.allProtDensity;
protDensity_plot(1:ML141_75uM.numCells, 3) = ML141_75uM.allProtDensity;
protDensity_plot(1:ML141_150uM.numCells, 4) = ML141_150uM.allProtDensity;

figure(1)
subplot(122)
violinplot(protDensity_plot, {'DMSO', 'LatA 100nM', 'ML141 75μM', 'ML141 150μM'}, 'QuartileStyle','shadow', 'ShowMean', true, 'ViolinColor', plotColours);
ylabel('Protrusions/μm')
title('Protrusion density')
set(gca,'FontSize', fontSize)

 
% % maxNumCells = max([DMSO.numCells, ML141_75uM.numCells, ML141_150uM.numCells]);
% % 
% % protDensity_plot = NaN(maxNumCells, 3);
% % 
% % protDensity_plot(1:DMSO.numCells, 1) = DMSO.allProtDensity;
% % protDensity_plot(1:ML141_75uM.numCells, 2) = ML141_75uM.allProtDensity;
% % protDensity_plot(1:ML141_150uM.numCells, 3) = ML141_150uM.allProtDensity;
% % 
% % figure(2)
% % clf
% % violinplot(protDensity_plot, {'DMSO', 'ML141 75uM', 'ML141 150uM'}, 'QuartileStyle','shadow', 'ShowMean', true);
% % ylabel('Protrusion density (protrusions/um)')
% % set(gca, 'FontSize', 13)
% % axis square

%% Statistical tests
pval_LatA_100nM_length  = kruskalwallis(protLength_plot(:, 1:2), [], 'off');
pval_ML141_75uM_length  = kruskalwallis(protLength_plot(:, 1:2:3), [], 'off');
pval_ML141_150uM_length = kruskalwallis(protLength_plot(:, 1:3:4), [], 'off');

pval_LatA_100nM_density = kruskalwallis(protDensity_plot(:, 1:2), [], 'off');
pval_ML141_75uM_density = kruskalwallis(protDensity_plot(:, 1:2:3), [], 'off');
pval_ML141_150uM_density = kruskalwallis(protDensity_plot(:, 1:3:4), [], 'off');

Measurement   = ["Protrusion length"; "Protrusion density"];
DMSO_vs_LatA_100nM  = [pval_LatA_100nM_length; pval_LatA_100nM_density];
DMSO_vs_ML141_75uM = [pval_ML141_75uM_length; pval_ML141_75uM_density];
DMSO_vs_ML141_150uM = [pval_ML141_150uM_length; pval_ML141_150uM_density];


One_way_ANOVA_pvals = table(Measurement, DMSO_vs_LatA_100nM, DMSO_vs_ML141_75uM, DMSO_vs_ML141_150uM)

Measurement = ["Number of cells tracked"; "Number of protrusions tracked"];
DMSO_ = [DMSO.numCells; DMSO.numProt];
LatA_100nM_ = [LatA_100nM.numCells; LatA_100nM.numProt];
ML141_75uM_ = [ML141_75uM.numCells; ML141_75uM.numProt];
ML141_150uM_ = [ML141_150uM.numCells; ML141_150uM.numProt];
Total = [DMSO.numCells + LatA_100nM.numCells + ML141_75uM.numCells + ML141_150uM.numCells; DMSO.numProt + LatA_100nM.numProt + ML141_75uM.numProt + ML141_150uM.numProt];
n_number = table(Measurement, DMSO_, LatA_100nM_, ML141_75uM_, ML141_150uM_, Total)