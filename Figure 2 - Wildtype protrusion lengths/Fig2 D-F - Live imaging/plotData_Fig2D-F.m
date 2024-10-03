clear;clc;

addpath("Combined data/")
load combinedData.mat

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

protrusionLength{4} = data3(2:end,1);
protrusionTime{4} = data3(2:end,2);
protrusionTrackID{4} = data3(2:end,3);
protrusionID{4} = data3(2:end,4);

dt = 2; % Each frame is 2 minutes

protrusionTrackID{1} = protrusionTrackID{1} - 1e9 - 1e8;
protrusionTrackID{2} = protrusionTrackID{2} - 1e9 - 1e8;
protrusionTrackID{3} = protrusionTrackID{3} - 1e9 - 1e8;
protrusionTrackID{4} = protrusionTrackID{4} - 1e9 - 1e8;
%%

cells = 4;
for cell = 1:cells
    protrusionLifetime = [];
    maxFilamentLength = [];

    i = 1;
    for trackID = min(protrusionTrackID{cell}):max(protrusionTrackID{cell})

        idx = find(protrusionTrackID{cell} == trackID); %For each track ID find other filaments in same track

        if ~isempty(idx)
            TRACK_ID{cell}(i) = trackID;
            maxFilamentLength(i) = max(protrusionLength{cell}(idx));
            protrusionLifetime(i) = length(idx)*dt;
            i = i+1;
        end
    
    
        
        %Find corresponding filament lengths
        
    end

    maxFilamentLength = [maxFilamentLength, protrusionLength{cell}(isnan(protrusionTrackID{cell}))'];
    protrusionLifetime = [protrusionLifetime, dt*ones(1, length(find(isnan(protrusionTrackID{cell}))))];
    protrusionLifetimeAll{cell} = protrusionLifetime;
    maxFilamentLengthAll{cell} = maxFilamentLength; 

end

protrusionLifetime = [];
maxFilamentLength = [];
for cell = 1:cells
    protrusionLifetime = [protrusionLifetime, protrusionLifetimeAll{cell}];
    maxFilamentLength = [maxFilamentLength, maxFilamentLengthAll{cell}];
end






%% Filter by protrusion lifetime
protrusionLifetimePlot = protrusionLifetime(protrusionLifetime<100);
maxFilamentLengthPlot = maxFilamentLength(protrusionLifetime<100);
%% Plots
figure(1)
subplot(131)
histogram(maxFilamentLength, 15, 'FaceColor',[0 0 0], 'EdgeColor', 'w', 'FaceAlpha', 0.9)
xlabel('Protrusion length (um)')
ylabel('count')
xlim([0 25])
set(gca, 'FontSize', 15)
axis square

% protrusionLifetimePlot = protrusionLifetime(protrusionLifetime<100);
subplot(132)
histogram(protrusionLifetimePlot, 10,  'FaceColor',[0 0 0], 'EdgeColor', 'w', 'FaceAlpha', 0.9)
xlabel('Protrusion lifetime (min)')
ylabel('count')
set(gca, 'FontSize', 15)
axis square

subplot(133)
scatter(maxFilamentLengthPlot, protrusionLifetimePlot, 50, 'k', 'filled', 'MarkerFaceAlpha',0.5)
set(gca, 'FontSize', 15)
xlabel('Max protrusion length (um)')
ylabel('Protrusion lifetime (min)')
axis square

percent = 100*numel(find(maxFilamentLength>5.2))/numel(maxFilamentLength)



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

