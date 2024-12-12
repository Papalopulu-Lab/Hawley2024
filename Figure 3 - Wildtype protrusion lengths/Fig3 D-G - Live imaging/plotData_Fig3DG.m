clear;clc;
addpath('functions\');
addpath('Combined data (MATLAB)\');

load data.mat %Originally imported dat that contains tracked protrusion lengths data
load ABaxisData.mat %Additional angles data relative to the AB axis orientation


%Then correct angle order and calibrate angles to AB

%Convert tables to arrays
Cell1_ProtLength_array=table2array(Cell1_ProtLength);
Cell1_ABangle_array = table2array(Cell1_ABangle);
Cell1_ProtAngles_array = table2array(Cell1_ProtAngles); 

Cell2_ProtLength_array=table2array(Cell2_ProtLength);
Cell2_ABangle_array = table2array(Cell2_ABangle);
Cell2_ProtAngles_array = table2array(Cell2_ProtAngles); 

Cell3_ProtLength_array=table2array(Cell3_ProtLength);
Cell3_ABangle_array = table2array(Cell3_ABangle);
Cell3_ProtAngles_array = table2array(Cell3_ProtAngles); 

Cell4_ProtLength_array=table2array(Cell4_ProtLength);
Cell4_ABangle_array = table2array(Cell4_ABangle);
Cell4_ProtAngles_array = table2array(Cell4_ProtAngles); 

%Extract data
protLength{1} = Cell1_ProtLength_array(:, 1);
protrusionAngle{1} = Cell1_ProtAngles_array(:, 1);
ABangle{1} = Cell1_ABangle_array(:, 1); 

protLength{2} = Cell2_ProtLength_array(:, 1);
protrusionAngle{2} = Cell2_ProtAngles_array(:, 1);
ABangle{2} = Cell2_ABangle_array(:, 1); 

protLength{3} = Cell3_ProtLength_array(:, 1);
protrusionAngle{3} = Cell3_ProtAngles_array(:, 1);
ABangle{3} = Cell3_ABangle_array(:, 1); 

protLength{4} = Cell4_ProtLength_array(:, 1);
protrusionAngle{4} = Cell4_ProtAngles_array(:, 1);
ABangle{4} = Cell4_ABangle_array(:, 1); 

%Original data
protrusionLength{1} = data1(2:end,1);
protrusionTime{1} = data1(2:end,2);
protrusionTrackID{1} = data1(2:end,3);
protrusionID{1} = data1(2:end,4);

protrusionLength{2} = data2(2:end,1);
protrusionTime{2} = data2(2:end,2);
protrusionTrackID{2} = data2(2:end,3);
protrusionID{2} = data2(2:end,4);

protrusionLength{3} = data3(2:end,1);
protrusionTime{3} = data3(2:end,2);
protrusionTrackID{3} = data3(2:end,3);
protrusionID{3} = data3(2:end,4);

protrusionLength{4} = data4(2:end,1);
protrusionTime{4} = data4(2:end,2);
protrusionTrackID{4} = data4(2:end,3);
protrusionID{4} = data4(2:end,4);

dt = 2; % Each frame is 2 minutes

protrusionTrackID{1} = protrusionTrackID{1} - 1e9 - 1e8;
protrusionTrackID{2} = protrusionTrackID{2} - 1e9 - 1e8 + 1000;
protrusionTrackID{3} = protrusionTrackID{3} - 1e9 - 1e8 + 2000;
protrusionTrackID{4} = protrusionTrackID{4} - 1e9 - 1e8 + 3000;




%%



cells = 4;
%Correct the order of angles to match the previously imported data
for cell = 1:cells

    [~,I] = ismember(protrusionLength{cell}, protLength{cell});
    protLength{cell} = protLength{cell}(I);
    protrusionAngle{cell} = protrusionAngle{cell}(I);

    %Correct angles so that basal pointing is 0deg
    protrusionAngle{cell} = protrusionAngle{cell} - ABangle{cell};
    %Correct shifted angles outside of 180deg (if adding new data, need to
    %add code to potentially deal with angles shifted to less than -180)
    protrusionAngle{cell}(protrusionAngle{cell}>180) = protrusionAngle{cell}(protrusionAngle{cell}>180) - 360;
    %Make -ve angles positive (angles now span 0 -> 180, where 0 is basal
    %pointing and 180 is apical pointing)
    protrusionAngle{cell} = abs(protrusionAngle{cell}); 

    % difference = sum(protrusionLength{cell}-protLength{cell});
end

protrusionAngleAll = [];
protrusionLengthAll = [];
protrusionTrackIDAll = []; 

figure(10)
clf
for cell = 1:cells
    protrusionLifetime = [];
    maxFilamentLength = [];

    protrusionAngleAll = [protrusionAngleAll; protrusionAngle{cell}];
    protrusionLengthAll = [protrusionLengthAll; protrusionLength{cell}];
    protrusionTrackIDAll = [protrusionTrackIDAll; protrusionTrackID{cell}];

    i = 1;
    for trackID = min(protrusionTrackID{cell}):max(protrusionTrackID{cell})

        idx = find(protrusionTrackID{cell} == trackID); %For each track ID find other filaments in same track

        if ~isempty(idx)
            TRACK_ID{cell}(i) = trackID;
            
            lengths = protrusionLength{cell}(idx);
            [maxFilamentLength(i), idxMaxLength] = max(lengths);
            
            protrusionLifetime(i) = length(idx)*dt;

            angles = protrusionAngle{cell}(idx);
            angles_adjusted = angles - 90; %This changes the range from 0->180 to -90->90

            [~, maxAngleIdx] = max(abs(angles_adjusted));
            maxAngle(i) = angles(maxAngleIdx);
            maxLengthAngle(i) = angles(idxMaxLength);

            i = i+1;
            
            if length(lengths)<50

                plot(lengths, 'color', [0 0 0 0.5]);hold on
                % xlabel('Time')
            end
        end
    
    
        
        %Find corresponding filament lengths
        
    end
     
    maxFilamentLength = [maxFilamentLength, protrusionLength{cell}(isnan(protrusionTrackID{cell}))'];
    protrusionLifetime = [protrusionLifetime, dt*ones(1, length(find(isnan(protrusionTrackID{cell}))))];
    protrusionLifetimeAll{cell} = protrusionLifetime;
    maxFilamentLengthAll{cell} = maxFilamentLength; 
    maxAngleAll{cell} = maxAngle;
    maxLengthAngleAll{cell} =  maxLengthAngle;

end

protrusionLifetime = [];
maxFilamentLength = [];
maxAngle=[];
maxLengthAngle = [];

for cell = 1:cells
    protrusionLifetime = [protrusionLifetime, protrusionLifetimeAll{cell}];
    maxFilamentLength = [maxFilamentLength, maxFilamentLengthAll{cell}];
    maxAngle = [maxAngle, maxAngleAll{cell}];
    maxLengthAngle = [maxLengthAngle,  maxLengthAngleAll{cell}];
end






%% Filter by protrusion lifetime
protrusionLifetimePlot = protrusionLifetime(protrusionLifetime<100);
maxFilamentLengthPlot = maxFilamentLength(protrusionLifetime<100);
%% Plots
figure(1)
subplot(151)
histogram(maxFilamentLength, 15, 'FaceColor',[0 0 0], 'EdgeColor', 'w', 'FaceAlpha', 0.9)
xlabel('Protrusion length (um)')
ylabel('count')
xlim([0 25])
set(gca, 'FontSize', 15)
axis square

% protrusionLifetimePlot = protrusionLifetime(protrusionLifetime<100);
subplot(152)
histogram(protrusionLifetimePlot, 10,  'FaceColor',[0 0 0], 'EdgeColor', 'w', 'FaceAlpha', 0.9)
xlabel('Protrusion lifetime (min)')
ylabel('count')
set(gca, 'FontSize', 15)
axis square

subplot(153)
scatter(maxFilamentLengthPlot, protrusionLifetimePlot, 50,  'k', 'filled', 'MarkerFaceAlpha',0.5)
set(gca, 'FontSize', 15)
xlabel('Max protrusion length (um)')
ylabel('Protrusion lifetime (min)')
axis square





cutoffLow = 0;
cutoffHigh = 40;
% protrusionAngleAll_plot = protrusionAngleAll(protrusionLengthAll>cutoff);
% protrusionLengthAll_plot = protrusionLengthAll(protrusionLengthAll>cutoff);
protrusionAngleAll_plot = protrusionAngleAll(protrusionLengthAll>cutoffLow & protrusionLengthAll<cutoffHigh & protrusionTrackIDAll ~= 28);
protrusionLengthAll_plot = protrusionLengthAll(protrusionLengthAll>cutoffLow & protrusionLengthAll<cutoffHigh & protrusionTrackIDAll ~= 28);


figure(2)
subplot(221)
% polarscatter(deg2rad(protrusionAngleAll_plot), protrusionLengthAll_plot)

h=polarscatter(deg2rad(protrusionAngleAll_plot), protrusionLengthAll_plot, 8, [0 0 0], 'o', 'filled');
% title('+90 is basal-directed, -90 is apical-directed protrusion')
set(gca, 'FontSize', 12)
ax = ancestor(h, 'polaraxes');
ax.ThetaLim = [0 180];
ax.ThetaTick = [0 30 60 90 120 150 180];
A1 = append("90",char(176));
A2 = append("60",char(176));
A3 = append("30",char(176));
A4 = append("0",char(176));
A5 = append("-30",char(176));
A6 = append("-60",char(176));
A7 = append("-90",char(176));
ax.ThetaTickLabel = {A1, A2, A3, A4, A5, A6, A7};
% ax.RLim = [0 max(protrusionLengths(smallLengths))];
% colormap(magma(100))
ax.RAxis.Label.String = 'Protrusion length (μm)';




title('All time points from live imaging')

subplot(222)
% histogram(protrusionAngleAll)
% xlim([-180, 180])

hAxes = histogram(protrusionAngleAll_plot - 90);
% hAxes = histogram(protrusionAngleAll);

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
% xlim([-90 90]);
% title(sprintf('<%.fum', length1))
% set(gca,"FontSize", fontSize)
ylabel('Count')
xlabel('Protrusion angle')
title('All time points from live imaging')
axis square



maxAnglePlot = maxAngle(protrusionLifetime<100);
protrusionLifetimePlot = protrusionLifetime(protrusionLifetime<100);

subplot(223)
h=polarscatter(deg2rad(maxAnglePlot), protrusionLifetimePlot, 8, [0 0 0], 'o', 'filled');
title('Max angle vs lifetime')
set(gca, 'FontSize', 12)
ax = ancestor(h, 'polaraxes');
ax.ThetaLim = [0 180];
ax.ThetaTick = [0 30 60 90 120 150 180];
A1 = append("90",char(176));
A2 = append("60",char(176));
A3 = append("30",char(176));
A4 = append("0",char(176));
A5 = append("-30",char(176));
A6 = append("-60",char(176));
A7 = append("-90",char(176));
ax.ThetaTickLabel = {A1, A2, A3, A4, A5, A6, A7};
% ax.RLim = [0 max(protrusionLengths(smallLengths))];
% colormap(magma(100))
ax.RAxis.Label.String = 'Lifetime (min)';

maxLengthAnglePlot = maxLengthAngle(protrusionLifetime<100);
subplot(224)
h=polarscatter(deg2rad(maxLengthAnglePlot), protrusionLifetimePlot, 8, [0 0 0], 'o', 'filled');
title('Angle at max length vs lifetime')
set(gca, 'FontSize', 12)
ax = ancestor(h, 'polaraxes');
ax.ThetaLim = [0 180];
ax.ThetaTick = [0 30 60 90 120 150 180];
A1 = append("90",char(176));
A2 = append("60",char(176));
A3 = append("30",char(176));
A4 = append("0",char(176));
A5 = append("-30",char(176));
A6 = append("-60",char(176));
A7 = append("-90",char(176));
ax.ThetaTickLabel = {A1, A2, A3, A4, A5, A6, A7};
% ax.RLim = [0 max(protrusionLengths(smallLengths))];
% colormap(magma(100))
ax.RAxis.Label.String = 'Lifetime (min)';





figure(1)
subplot(154)
hAxes=scatter([-maxAnglePlot+90]', protrusionLifetimePlot', 50, 'k', 'filled', 'MarkerFaceAlpha',0.5);
set(gca, 'FontSize', 12)
colormap('parula')
xlabel('Maximum angle')
ylabel('Protrusion lifetime (min)')
xlim([-90 90])
A1 = ['-90' char(176)];
A2 = ['-45' char(176)];
A3 = ['0' char(176)];
A4 = ['45' char(176)];
A5 = ['90' char(176)];
% Set XTick and XTickLabel
hAxes.Parent.XTick = [-90 -45 0 45 90];
hAxes.Parent.XTickLabel = {A1, A2, A3, A4, A5}; % Use cell array for XTickLabel
set(gca, 'FontSize', 15)
axis square

% [hAxes, F, col]=dscatter([-maxAnglePlot+90]', protrusionLifetimePlot');
% colormap('turbo')
% xlim([-90 90])
% A1 = append("-90",char(176));
% A2 = append("-45",char(176));
% A3 = append("0",char(176));
% A4 = append("45",char(176));
% A5 = append("90",char(176));
% hAxes.XTick = [-90 -45 0 45 90];
% hAxes.XTickLabel = [A1, A2, A3, A4, A5];
% % ylim([0 max(protrusionLengths(smallLengths))]);
% set(gca,'FontSize',18)
% colormap(magma(100))
% axis square

subplot(155)
hAxes=scatter([-maxLengthAnglePlot+90]', protrusionLifetimePlot', 50, 'k', 'filled', 'MarkerFaceAlpha',0.5);
set(gca, 'FontSize', 12)
xlabel('Angle at max protrusion length')
ylabel('Protrusion lifetime (min)')
xlim([-90 90])
A1 = ['-90' char(176)];
A2 = ['-45' char(176)];
A3 = ['0' char(176)];
A4 = ['45' char(176)];
A5 = ['90' char(176)];
% Set XTick and XTickLabel
hAxes.Parent.XTick = [-90 -45 0 45 90];
hAxes.Parent.XTickLabel = {A1, A2, A3, A4, A5}; % Use cell array for XTickLabel
set(gca, 'FontSize', 15)
axis square


figure(11)
% hAxes=scatter([-maxLengthAnglePlot+90]', protrusionLifetimePlot', 50, maxFilamentLengthPlot, 'filled');
% c=colorbar;
% c.Label.String = 'Max protrusion length (um)';
% set(gca, 'FontSize', 12)
% xlabel('Angle at max protrusion length')
% ylabel('Protrusion lifetime (min)')
% xlim([-90 90])
% A1 = ['-90' char(176)];
% A2 = ['-45' char(176)];
% A3 = ['0' char(176)];
% A4 = ['45' char(176)];
% A5 = ['90' char(176)];
% % Set XTick and XTickLabel
% hAxes.Parent.XTick = [-90 -45 0 45 90];
% hAxes.Parent.XTickLabel = {A1, A2, A3, A4, A5}; % Use cell array for XTickLabel
% set(gca, 'FontSize', 15)
% axis square
% colormap(magma)
[hAxes, F, col]=dscatter([-maxLengthAnglePlot+90]', protrusionLifetimePlot');
set(gca, 'FontSize', 12)
colormap(magma)
xlabel('Angle')
ylabel('Protrusion length μm')
axis square
% colormap('turbo')
xlim([-90 90])
A1 = append("-90",char(176));
A2 = append("-45",char(176));
A3 = append("0",char(176));
A4 = append("45",char(176));
A5 = append("90",char(176));
hAxes.XTick = [-90 -45 0 45 90];
hAxes.XTickLabel = [A1, A2, A3, A4, A5];
% ylim([0 max(protrusionLengths(smallLengths))]);
set(gca,'FontSize',15)
scatterHandle = hAxes.Children  % Access the child object of hAxes (scatter plot)
set(scatterHandle, 'SizeData', 40);





binVals = [3, 10];
nBins = 5
figure(12)

subplot(313)
histPlot = [-maxLengthAnglePlot+90]';
hAxes = histogram(histPlot(protrusionLifetimePlot<binVals(1)), nBins);
% Create strings with degree symbols
A1 = ['-90' char(176)];
A2 = ['-45' char(176)];
A3 = ['0' char(176)];
A4 = ['45' char(176)];
A5 = ['90' char(176)];
% Set XTick and XTickLabel
hAxes.Parent.XTick = [-90 -45 0 45 90];
hAxes.Parent.XTickLabel = {A1, A2, A3, A4, A5}; % Use cell array for XTickLabel
xlim([-90 90])
title(sprintf('Lifetime <%.f', binVals(1)))

subplot(312)
histPlot = [-maxLengthAnglePlot+90]';
hAxes = histogram(histPlot(protrusionLifetimePlot>binVals(1) & protrusionLifetimePlot<binVals(2)), nBins);
% Create strings with degree symbols
A1 = ['-90' char(176)];
A2 = ['-45' char(176)];
A3 = ['0' char(176)];
A4 = ['45' char(176)];
A5 = ['90' char(176)];
% Set XTick and XTickLabel
hAxes.Parent.XTick = [-90 -45 0 45 90];
hAxes.Parent.XTickLabel = {A1, A2, A3, A4, A5}; % Use cell array for XTickLabel
xlim([-90 90])
title(sprintf('Lifetime >%.f & <%.f', binVals(1), binVals(2)))

subplot(311)
histPlot = [-maxLengthAnglePlot+90]';
hAxes = histogram(histPlot(protrusionLifetimePlot>binVals(2)), nBins);
% Create strings with degree symbols
A1 = ['-90' char(176)];
A2 = ['-45' char(176)];
A3 = ['0' char(176)];
A4 = ['45' char(176)];
A5 = ['90' char(176)];
% Set XTick and XTickLabel
hAxes.Parent.XTick = [-90 -45 0 45 90];
hAxes.Parent.XTickLabel = {A1, A2, A3, A4, A5}; % Use cell array for XTickLabel
xlim([-90 90])
title(sprintf('Lifetime >%.f', binVals(2)))
% [hAxes, F, col]=dscatter([-maxLengthAnglePlot+90]', protrusionLifetimePlot');
% colormap('turbo')
% xlim([-90 90])
% A1 = append("-90",char(176));
% A2 = append("-45",char(176));
% A3 = append("0",char(176));
% A4 = append("45",char(176));
% A5 = append("90",char(176));
% hAxes.XTick = [-90 -45 0 45 90];
% hAxes.XTickLabel = [A1, A2, A3, A4, A5];
% % ylim([0 max(protrusionLengths(smallLengths))]);
% set(gca,'FontSize',18)
% colormap(magma(100))
% axis square




%% Summary statistics

percent = 100*numel(find(maxFilamentLength>7.7))/numel(maxFilamentLength)

mean_length = mean(maxFilamentLength);
SD_length = std(maxFilamentLength);
median_length = median(maxFilamentLength);
IQR_length = iqr(maxFilamentLength);

protLifetime_noOutliers = protrusionLifetime(protrusionLifetime<100);
mean_lifetime = mean(protLifetime_noOutliers);
SD_lifetime = std(protLifetime_noOutliers);
median_lifetime = median(protLifetime_noOutliers);
IQR_lifetime = iqr(protLifetime_noOutliers);

Measurement = ["Mean (length)"; "SD (length)"; "Median (length)"; "IQR (length)"; "Mean (lifetime)"; "SD (lifetime)"; "Median (lifetime)"; "IQR (lifetime)"];
Value = [mean_length; SD_length; median_length; IQR_length; mean_lifetime; SD_lifetime; median_lifetime; IQR_lifetime];

SummaryStats = table(Measurement, Value)

