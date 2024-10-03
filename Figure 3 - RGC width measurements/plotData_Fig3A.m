clear 

addpath("Data - combined (MATLAB)\")
load combinedData.mat

col1 = [255 70, 50]./255;
col2 = [68 187, 153]./255;
col3 = [50 150 255]./255;


combinedApical = table2array(combinedApical); %Measurements of the apical endfeet width
combinedProcesses = table2array(combinedProcesses); %Measurements of the thinnest part of the cell bodies (anywhere but the apical endfoot and nuclear bulge)
combinedCellBody = table2array(combinedCellBody);

apicalMean = mean(combinedApical);
processesMean = mean(combinedProcesses);
cellBodyMean = mean(combinedCellBody);

apicalSD = std(combinedApical);
processesSD = std(combinedProcesses);
cellBodySD = std(combinedCellBody);


figure(1)
clf
fontSize = 12;
meanLineWidth = 1.5;
subplot(131)
[combineApicalN,combinedApicalEdges] = histcounts(combinedApical);
histogram(combinedApical, 'facecolor', col1); hold on;
plot([apicalMean apicalMean], [0 combineApicalN(5)],'k--','linewidth', meanLineWidth)
xlim([0 13])
xlabel('Width (um)')
ylabel('Count')
title(sprintf('Apical endfoot mean = %.1fum', apicalMean))
axis square
set(gca, 'fontsize', fontSize)

subplot(132)
[combinedProcessesN,combinedProcessesEdges] = histcounts(combinedProcesses);
histogram(combinedProcesses, 'facecolor', col2); hold on;
plot([processesMean processesMean], [0 combinedProcessesN(4)],'k--','linewidth', meanLineWidth)
xlim([0 13])
xlabel('Width (um)')
ylabel('Count')
title(sprintf('Processes mean = %.1fum', processesMean))
axis square
set(gca, 'fontsize', fontSize)

subplot(133)
[combinedCellBodyN,combinedCellBodyEdges] = histcounts(combinedCellBody);
histogram(combinedCellBody, 'facecolor', col3); hold on
plot([cellBodyMean cellBodyMean], [0 combinedCellBodyN(4)],'k--','linewidth', meanLineWidth)
xlim([0 13])
xlabel('Width (um)')
ylabel('Count')
title(sprintf('Cell body mean = %.1fum', cellBodyMean))
axis square
set(gca, 'fontsize', fontSize)




figure(2)
clf
histogram(combinedApical, 'normalization', 'probability', FaceColor=col1); hold on;
histogram(combinedProcesses,  'normalization', 'probability', FaceColor=col2);
histogram(combinedCellBody, 'normalization', 'probability', FaceColor=col3);

ylabel('Probability')
xlabel('Width (um)')
legend('Apical endfeet', 'Process', 'Cell body')