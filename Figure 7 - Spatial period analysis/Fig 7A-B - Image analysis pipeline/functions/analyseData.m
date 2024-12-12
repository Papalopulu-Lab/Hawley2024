function [data] = analyseData (data, figNum, plotImages, blurMicronsSD)
    %% Plot images, regions of interest, and store cropped roi data
    polyNum = 4;                                                            %Define detrending polynomial for mean signals with the roi

    if plotImages == 1
        figure(figNum)
        clf
        sgtitle(sprintf('%s (%s)', ...
            data.name,string(data.date)))
        figure(figNum + 1)
        clf
        sgtitle(sprintf('%s (%s)', ...
            data.name,string(data.date)))
    end

    S = size(data.image, 1);
    maxZ = size(data.image,2);

    ZinEachSlice = zeros(S,1);
    totalROI = 0;
    
    for s = 1:S
        for z = 1:maxZ
            hasAnImage = ~isempty(data.image{s,z});
            
            numROI = 1;

            if size(data.roi(s, z, :), 3) > 1 && ~isempty(data.roi{s, z, 2})
                numROI=2;
            end

            ZinEachSlice(s) = ZinEachSlice(s) + hasAnImage;
            totalROI = totalROI + hasAnImage*numROI;
        end
    end

    data.totalROI = totalROI;

    count = 0;

    %% Preallocation for storing data
    allIntensityValues = [];
    data.periodsFFT = [];
    data.periodsFisher = [];
    data.periodsBootstrap = [];
    data.allPeak2PeakBootstrap = [];
    data.detrendedSD = [];
    data.pearson = [];

    for s = 1:S  
        Z = ZinEachSlice(s);                                                %Number of z depths for the current slice
        for z = 1:Z
%             data.name
            %% Rotate and plot raw images
            
            im=imrotate(data.image{s, z}, ...                               %Rotate image
                data.rotation(s), 'bilinear', 'crop');
            im = im2gray(im);
       
            if plotImages == 1 
                figure(figNum)
                subplot(S, Z, (s-1)*Z + z)
                
                imshow(im); hold on  
                colormap(magma(100))
                %Plot image
                title(sprintf('S%.0f, Z%.0f', s, z))
            end
            
            if size(data.roi(s, z, :), 3) > 1
                if isempty(data.roi{s, z, 2})
                    R=1;
                else
                    R=2;
                end
            else
                R=1;
            end   
            
            %% Plot regions of interest and detrend the data

            for r = 1:R
                count =  count + 1;
                
                x = data.roi{s, z, r}(1);
                y = data.roi{s, z, r}(2);
                w = data.roi{s, z, r}(3);
                h = data.roi{s, z, r}(4);
            
                if R == 1
                rectangle('Position', [x, y, w, h], 'Curvature',[0,0], ...  %Plot roi on top of the slice images
                'LineWidth',1, 'EdgeColor','w');
                          
                elseif R==2 && r==1

                    x1 = data.roi{s, z, 1}(1);
                    y1 = data.roi{s, z, 1}(2);
                    w1 = data.roi{s, z, 1}(3);
                    h1 = data.roi{s, z, 1}(4);
    
                    x2 = data.roi{s, z, 2}(1);
                    y2 = data.roi{s, z, 2}(2);
                    w2 = data.roi{s, z, 2}(3);
                    h2 = data.roi{s, z, 2}(4);

                    if plotImages == 1
                        rectangle('Position', [x1, y1, w1, h1], 'Curvature',[0,0], ...  %Plot roi on top of the slice images
                        'LineWidth',1, 'EdgeColor','w'); hold on
                        rectangle('Position', [x2, y2, w2, h2], 'Curvature',[0,0], ...  %Plot roi on top of the slice images
                        'LineWidth',1, 'EdgeColor','w')
                    end
                end
            
                %Crop roi image____________________________________________
                data.roiImage{s, z, r} = im(y : y+h, x : x+w);              %Store the raw signal within the region of interest as a cropped image 
                
                sigma = blurMicronsSD/data.dx; %Gaussian blur standard deviation in pixels
                data.roiImage{s, z, r} = imgaussfilt(data.roiImage{s, z, r}, sigma);


                data.meanSignal{s, z, r} = ...                              %Store the mean signal along the DV axis - also divided by max so that powers are comparable in power spectrum relative to max intensity
                    mean(data.roiImage{s, z, r}, 2)./max(mean(data.roiImage{s, z, r}, 2));

                data.xMicrons{s, z, r} = ...                                %DV axis in microns
                    (1:numel(data.meanSignal{s, z, r}))*data.dx;
                
                data.detrendLine{s, z, r} = polyval(polyfit(...             %Polynomial fit line
                    data.xMicrons{s, z, r}, data.meanSignal{s, z, r},...
                    polyNum), data.xMicrons{s,z,r})';
               
            
                data.detrendedSignal{s, z, r} = data.meanSignal{s, z, r}... %Detrended signal using the polynomial fit line
                    - data.detrendLine{s, z, r};

                data.detrendedSignal{s, z, r} = data.meanSignal{s, z, r} - mean(data.meanSignal{s, z, r});

                data.detrendedSD = [data.detrendedSD; std(data.detrendedSignal{s, z, r})]; %Standard deviation of detrended signal (to look at amplitude differences)
                




                % 
                % %%testing FFT filter
                % cutoff_period = 100;
                % [detrendedSignal, ~, ~, ~] = FFTfilter(data.meanSignal{s, z, r}, 1/cutoff_period, 1/data.dx);
                % data.detrendedSignal{s, z, r} = detrendedSignal';



                %Correlation between detrended and original signal
                pearson = corrcoef(data.meanSignal{s, z, r}, data.detrendedSignal{s, z, r});
                data.pearson = [data.pearson; pearson(1,2)];




                %% Spatial period of the detrended signal
                [data.frequency{s, z, r}, data.power{s, z, r}, data.periodFFT{s, z, r}, data.periodFisher{s, z, r}, data.pvalFisher{s, z, r}, data.peak2PeakBootstrap{s, z, r}, data.periodBootstrap{s, z, r}, data.ACF{s, z, r}, data.smoothedACF{s, z, r}, data.bootstrapUpper{s, z, r}, data.bootstrapLower{s, z, r}, data.lags{s, z, r}, data.locsSignificant{s, z, r}, data.pksSignificant{s, z, r}] = spatialPeriod(data.detrendedSignal{s, z, r}, data.dx);
                data.periodsFFT       = [data.periodsFFT; data.periodFFT{s, z, r}];
                data.periodsFisher    = [data.periodsFisher; data.periodFisher{s, z, r}];
                data.periodsBootstrap = [data.periodsBootstrap; data.periodBootstrap{s, z, r}];
 
                data.allPeak2PeakBootstrap = [data.allPeak2PeakBootstrap; data.peak2PeakBootstrap{s, z, r}'];

                
                
                if plotImages == 1

                    figure(figNum + 3)
                    subplot(1, totalROI, count)
                    % plot(data.xMicrons{s, z, r}, data.detrendLine{s, z, r}, '--'); hold on;
                    % plot(data.xMicrons{s, z, r}, data.meanSignal{s, z, r})
                    % plot(data.detrendLine{s, z, r}, data.xMicrons{s, z, r}, '--'); hold on;
                    plot(data.meanSignal{s, z, r}, data.xMicrons{s, z, r}); hold on
                    plot(data.detrendedSignal{s, z, r}, data.xMicrons{s, z, r})
                    ylim([0 max(data.xMicrons{s, z, r})])
                    set(gca, 'YDir','reverse')
                    grid on
                    title(sprintf('FFT per: %.0fum', data.periodFFT{s,z,r}))

                    %Plot roi images
                    figure(figNum + 1)
                    subplot(2, totalROI, count)
                    imagesc(data.roiImage{s,z,r}), axis equal, xlim([0 size(data.roiImage{s,z,r},2)]), title(sprintf('S%.0f, Z%.0f, R%.0f', s, z, r)), colormap(magma(100)), xticks([]), yticks([])
    
                    %Plot power spectra from spatial period analysis
                    figure(figNum + 2)
                    subplot(2, totalROI, count)

%                     1/data.periodFFT{s, z, r}
%                     data.frequency{s, z, r}
%                     idx = find(data.frequency{s, z, r} == 1/data.periodFFT{s, z, r})

                    [~,idx] = min( abs(data.frequency{s, z, r} - 1/data.periodFFT{s, z, r}) )

                    size(data.frequency{s, z, r})
                    size(data.power{s, z, r})
                    plot(1./data.frequency{s, z, r}, data.power{s, z, r}), title(sprintf('S%.0f, Z%.0f, R%.0f, %.0f', s, z, r, data.periodFFT{s,z,r})); hold on
                    plot(data.periodFFT{s, z, r}, data.power{s, z, r}(idx), 'x','Color','r')
                    xlim([0 100])
                    xlabel('μm')
                    % set(gca, 'FontSize', 6)
                    axis square
                    
                    %Plot autocorrelation

                    figure(figNum + 2)
                    subplot(2, totalROI, count+totalROI)
                    plot(data.lags{s, z, r}, data.ACF{s, z, r}, 'color', [1 0 0]); hold on
                    plot(data.lags{s, z, r}, data.smoothedACF{s, z, r}, 'color', [0 0 1]); hold on
                    % area(data.lags{s, z, r}, data.bootstrapUpper{s, z, r}, 'FaceColor', [0 0 0 ], 'FaceAlpha', 0.2)
                    area(data.lags{s, z, r}, data.bootstrapUpper{s, z, r}, 'FaceColor', [0 0 0], 'FaceAlpha', 0.2, 'EdgeColor', 'none')

                    area(data.lags{s, z, r}, data.bootstrapLower{s, z, r}, 'FaceColor', [0 0 0 ], 'FaceAlpha', 0.2, 'EdgeColor', 'none')
                    plot(data.locsSignificant{s, z, r}, data.pksSignificant{s, z, r}, 'x','color','k')
                    title(sprintf('%.0f', data.periodBootstrap{s,z,r}))
                    axis square
                    xlabel('μm')
                end
                
                allIntensityValues = [allIntensityValues; data.detrendedSignal{s, z, r}];
            end

            %% Plot detrended data all with same intensity axis range
            if plotImages == 1
                minIntensity = min(allIntensityValues);
                maxIntensity = max(allIntensityValues);
                count = count - R;
    
                for r = 1:R
                    count = count + 1;
                    
                    %Plot 
                    figure(figNum + 1)
                    subplot(2, totalROI, count + totalROI)
                    plot(data.detrendedSignal{s, z, r}, data.xMicrons{s, z, r}), ylim([0, data.xMicrons{s, z, r}(end)]), xlim([minIntensity, maxIntensity]), set(gca, 'YDir','reverse')
    
                end
            end
        end
    end
end

