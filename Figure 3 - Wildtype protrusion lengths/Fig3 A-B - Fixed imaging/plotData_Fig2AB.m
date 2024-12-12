clear;clc;

addpath('functions')
addpath("Data - combined (MATLAB)\")

load protrusionLengths.mat
load orientationAnglesCorrected.mat
load positions.mat positions         %Column 1 = x-positions, column 2 = y-positions, column 3 = z-positions


leftOfVentricle=find(positions(:,1)<0);
orientationAnglesCorrected(leftOfVentricle)
[flippedAnglesHorz] = flipAnglesHorizontally(orientationAnglesCorrected(leftOfVentricle));

orientationAnglesCorrected(leftOfVentricle) = flippedAnglesHorz;
orientationAnglesCorrected(orientationAnglesCorrected<0) = -orientationAnglesCorrected(orientationAnglesCorrected<0);

smallLengths = find(protrusionLengths<100);

meanProtrusionLength = mean(protrusionLengths);
SDProtrusionLength = std(protrusionLengths);

medianProtrusionLength = median(protrusionLengths);
IQRprotrusionLength = iqr(protrusionLengths);


aboveProcessWidth = find(protrusionLengths>3.2);
percentAboveProcessWidth = 100 * length(protrusionLengths(aboveProcessWidth)) / length(protrusionLengths);
aboveApicalWidth = find(protrusionLengths>5.2);
percentAboveApicalWidth = 100 * length(protrusionLengths(aboveApicalWidth)) / length(protrusionLengths);
aboveCellBodyWidth = find(protrusionLengths>7.7);
percentAboveCellBodyWidth = 100 * length(protrusionLengths(aboveCellBodyWidth)) / length(protrusionLengths);


figure(1)
clf
fig=gcf;
fig.InvertHardcopy = 'off';
histogram(protrusionLengths, 40,'FaceColor',[0 0 0],'FaceAlpha',0.5)
ylabel('Counts')
xlabel('Length (\mum)')
set(gca, 'FontSize', 12)
title('Distribution of protrusion length (n=364)')
set(gca, 'FontSize', 18)

figure(2)
clf
subplot(212)
[hAxes, F, col]=dscatter(orientationAnglesCorrected(smallLengths)-90, protrusionLengths(smallLengths));
set(gca, 'FontSize', 12)
colormap('parula')
xlabel('Angle')
ylabel('Protrusion length μm')
axis square
colormap('turbo')
xlim([-90 90])
A1 = append("-90",char(176));
A2 = append("-45",char(176));
A3 = append("0",char(176));
A4 = append("45",char(176));
A5 = append("90",char(176));
hAxes.XTick = [-90 -45 0 45 90];
hAxes.XTickLabel = [A1, A2, A3, A4, A5];
ylim([0 max(protrusionLengths(smallLengths))]);
set(gca,'FontSize',18)

subplot(211)
h=polarscatter(deg2rad(orientationAnglesCorrected(smallLengths)),protrusionLengths(smallLengths), 8, col, 'o', 'filled')
title('+90 is basal-directed, -90 is apical-directed protrusion')
set(gca, 'FontSize', 12)
ax = ancestor(h, 'polaraxes')
ax.ThetaLim = [0 180]
ax.ThetaTick = [0 30 60 90 120 150 180];
A1 = append("90",char(176));
A2 = append("60",char(176));
A3 = append("30",char(176));
A4 = append("0",char(176));
A5 = append("-30",char(176));
A6 = append("-60",char(176));
A7 = append("-90",char(176));
ax.ThetaTickLabel = {A1, A2, A3, A4, A5, A6, A7};
ax.RLim = [0 max(protrusionLengths(smallLengths))];
colormap(magma(100))
ax.RAxis.Label.String = 'Protrusion length (μm)';
set(gca,'FontSize',14)

length1 = 5;
length2 = 10;
length3 = 25;


shortProtsIdx = find(protrusionLengths<length1);
mediumProtsIdx = find(protrusionLengths<length2 & protrusionLengths>length1);
longProtsIdx = find(protrusionLengths<length3 & protrusionLengths>length2);
%%
colMap = flipud(brewermap(3, 'Greens'));
fontSize = 14;

figure(5)
clf
subplot(311)
hAxes = histogram(orientationAnglesCorrected(shortProtsIdx) - 90, 6,'FaceColor',colMap(1,:));

% Create strings with degree symbols
A1 = ['-90' char(176)];
A2 = ['-45' char(176)];
A3 = ['0' char(176)];
A4 = ['45' char(176)];
A5 = ['90' char(176)];

% Set XTick and XTickLabel
hAxes.Parent.XTick = [-90 -45 0 45 90];
hAxes.Parent.XTickLabel = {A1, A2, A3, A4, A5}; % Use cell array for XTickLabel

% Set x-axis limits
xlim([-90 90]);
title(sprintf('<%.fum', length1))
set(gca,"FontSize", fontSize)
ylabel('Count')
xlabel('Protrusion angle')

subplot(312)
hAxes = histogram(orientationAnglesCorrected(mediumProtsIdx) - 90, 6,'FaceColor',colMap(2,:));

% Create strings with degree symbols
A1 = ['-90' char(176)];
A2 = ['-45' char(176)];
A3 = ['0' char(176)];
A4 = ['45' char(176)];
A5 = ['90' char(176)];

% Set XTick and XTickLabel
hAxes.Parent.XTick = [-90 -45 0 45 90];
hAxes.Parent.XTickLabel = {A1, A2, A3, A4, A5}; % Use cell array for XTickLabel

% Set x-axis limits
xlim([-90 90]);
title(sprintf('%.fμm → %.fμm', length1, length2))
set(gca,"FontSize", fontSize)
ylabel('Count')
xlabel('Protrusion angle')



subplot(313)
hAxes = histogram(orientationAnglesCorrected(longProtsIdx) - 90, 6,'FaceColor',colMap(3,:));

% Create strings with degree symbols
A1 = ['-90' char(176)];
A2 = ['-45' char(176)];
A3 = ['0' char(176)];
A4 = ['45' char(176)];
A5 = ['90' char(176)];

% Set XTick and XTickLabel
hAxes.Parent.XTick = [-90 -45 0 45 90];
hAxes.Parent.XTickLabel = {A1, A2, A3, A4, A5}; % Use cell array for XTickLabel

% Set x-axis limits
xlim([-90 90]);

title(sprintf('>%.fμm', length2))
set(gca,"FontSize", fontSize)
ylabel('Count')
xlabel('Protrusion angle')

[H, pval, W] = swtest(protrusionLengths)
Measurement = ["Mean (length)"; "SD (length)"; "Median (length)"; "IQR (length)"];
Value = [meanProtrusionLength; SDProtrusionLength; medianProtrusionLength; IQRprotrusionLength];

SummaryStats = table(Measurement, Value)
