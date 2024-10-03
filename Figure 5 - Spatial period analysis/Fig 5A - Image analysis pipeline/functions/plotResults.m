function [spatialPeriodsInd, spatialPeriodsComb, interpFrequency, powerAvg, pk2pk_combined, detrendedSDcomb, coherence] = plotResults(allResults, condName, plotGraphs)

    %% Plot colours
    col1 = [0.4660 0.6740 0.1880];
    col2 = [0.8500 0.3250 0.0980];
    plotColours = [col1; col2];
    plotColoursExps = [ col1; col2; col1; col2; col1; col2; col1; col2; col1; col2; col1; col2];

    %% Define number of experiments and number of conditions (Conditions = DMSO/ML141)
    numExp = size(allResults, 1); %Number of experiments
    numConditions = length(condName);

    for nExp = 1:numExp
        numROI(nExp)     = allResults(nExp).totalROI;
        expNameInd{nExp} = allResults(nExp).name;
        pk2pkElems(nExp) = length(allResults(nExp).allPeak2PeakBootstrap); 
    end

    maxROIelems   = max(numROI);
    maxPk2PkElems = max(pk2pkElems);
    
    spatialPeriodsInd.FFT            = NaN(maxROIelems, numExp);
    spatialPeriodsInd.Fisher         = NaN(maxROIelems, numExp);
    spatialPeriodsInd.Bootstrap      = NaN(maxROIelems, numExp);
    spatialPeriodsInd.pk2pkBootstrap = NaN(maxPk2PkElems, numExp);
% spatialPeriodsInd.pk2pkBootstrap
    for nCon = 1:numConditions

        spatialPeriodsCombined.FFT{1,nCon}            = [];
        spatialPeriodsCombined.Fisher{1,nCon}         = [];
        spatialPeriodsCombined.Bootstrap{1,nCon}      = [];
        spatialPeriodsCombined.pk2pkBootstrap{1,nCon} = [];
        detrendedSDcombined{1,nCon} = [];
       
    end

    for nExp = 1:numExp

        %Individual experiments   
        spatialPeriodsInd.FFT(1:numROI(nExp), nExp)                = allResults(nExp).periodsFFT;
        spatialPeriodsInd.Fisher(1:numROI(nExp), nExp)             = allResults(nExp).periodsFisher;
        spatialPeriodsInd.Bootstrap(1:numROI(nExp), nExp)          = allResults(nExp).periodsBootstrap;
        spatialPeriodsInd.pk2pkBootstrap(1:pk2pkElems(nExp), nExp) = allResults(nExp).allPeak2PeakBootstrap;
 
        %Combined experiments
        for nCon = 1:numConditions

            if contains(allResults(nExp).name, condName(nCon))
                spatialPeriodsCombined.FFT{1, nCon}            = [spatialPeriodsCombined.FFT{nCon}; allResults(nExp).periodsFFT];
                spatialPeriodsCombined.Fisher{1, nCon}         = [spatialPeriodsCombined.Fisher{nCon}; allResults(nExp).periodsFisher];
                spatialPeriodsCombined.Bootstrap{1, nCon}      = [spatialPeriodsCombined.Bootstrap{nCon}; allResults(nExp).periodsBootstrap];
                spatialPeriodsCombined.pk2pkBootstrap{1, nCon} = [spatialPeriodsCombined.pk2pkBootstrap{nCon}; allResults(nExp).allPeak2PeakBootstrap];
                detrendedSDcombined{1, nCon} = [detrendedSDcombined{nCon}; allResults(nExp).detrendedSD]; 
            end
        end
    end
    
    for nCon = 1:numConditions
        condElems(nCon) = size(spatialPeriodsCombined.FFT{nCon},1);
        condElemsPk2PkBootstrap(nCon) = size(spatialPeriodsCombined.pk2pkBootstrap{nCon},1);
    end
    
    maxCondElems = max(condElems);
    spatialPeriodsComb.FFT       = NaN(maxCondElems, numConditions);
    spatialPeriodsComb.Fisher    = NaN(maxCondElems, numConditions);
    spatialPeriodsComb.Bootstrap = NaN(maxCondElems, numConditions);
    detrendedSDcomb = NaN(maxCondElems, numConditions);

    maxCondElemsPk2PkBootstrap = max(condElemsPk2PkBootstrap);
    spatialPeriodsComb.pk2pkBootstrap = NaN(maxCondElemsPk2PkBootstrap, numConditions);

    

    %% Convert combined spatial periods structure into an array where missing elements are NaN 
    for nCon = 1:numConditions

        spatialPeriodsComb.FFT(1:condElems(nCon), nCon) = spatialPeriodsCombined.FFT{nCon};
        spatialPeriodsComb.Fisher(1:condElems(nCon), nCon) = spatialPeriodsCombined.Fisher{nCon};
        spatialPeriodsComb.Bootstrap(1:condElems(nCon), nCon) = spatialPeriodsCombined.Bootstrap{nCon};
        detrendedSDcomb(1:condElems(nCon), nCon) = detrendedSDcombined{nCon};

        spatialPeriodsComb.pk2pkBootstrap(1:condElemsPk2PkBootstrap(nCon), nCon) = spatialPeriodsCombined.pk2pkBootstrap{nCon};
    
    end


 
    if plotGraphs == 1
        %% Plots spatial period distributions
        figure(100)
        clf
        fontSize = 12;
        
        %Fourier with Fisher-G testing
        subplot(2,3,1)
        violinplot(spatialPeriodsInd.Fisher, expNameInd, 'QuartileStyle','shadow', 'ShowMean', true, 'ViolinColor', plotColoursExps);
        ylabel('Spatial period (\mum)')
        set(gca, 'FontSize', fontSize)
        title('Fourier with Fisher-G')
        axis square
        subplot(2,3,4)
        violinplot(spatialPeriodsComb.Fisher, condName, 'QuartileStyle','shadow', 'ShowMean', true, 'ViolinColor', plotColours);
        ylabel('Spatial period (\mum)')
        set(gca, 'FontSize', fontSize)
        axis square
        
        %ACF bootstrapping - mean peak to peak distances
        subplot(2,3,2)
        violinplot(spatialPeriodsInd.Bootstrap, expNameInd, 'QuartileStyle','shadow', 'ShowMean', true, 'ViolinColor', plotColoursExps);
        ylabel('Spatial period (\mum)')
        set(gca, 'FontSize', fontSize)
        title('ACF bootstrapping')
        axis square
        subplot(2,3,5)
        violinplot(spatialPeriodsComb.Bootstrap, condName, 'QuartileStyle','shadow', 'ShowMean', true, 'ViolinColor', plotColours);
        ylabel('Spatial period (\mum)')
        set(gca, 'FontSize', fontSize)
        axis square
        
        %ACF bootstrapping - all peak to peak distancs
        subplot(2,3,3)
        violinplot(spatialPeriodsInd.pk2pkBootstrap, expNameInd, 'QuartileStyle','shadow', 'ShowMean', true, 'ViolinColor', plotColoursExps);
        ylabel('Spatial period (\mum)')
        set(gca, 'FontSize', fontSize)
        title('ACF individual pk2pk')
        axis square
        subplot(2,3,6)
        violinplot(spatialPeriodsComb.pk2pkBootstrap, condName, 'QuartileStyle','shadow', 'ShowMean', true, 'ViolinColor', plotColours);
        % histogram(spatialPeriodsComb.pk2pkBootstrap(:,1)); hold on;
        % histogram(spatialPeriodsComb.pk2pkBootstrap(:,2))
        ylabel('Spatial period (\mum)')
        set(gca, 'FontSize', fontSize)
        axis square

        %% Plot standard deviation
        figure(101)
        clf
       
        pval_detrendedSD = ranksum(detrendedSDcomb(:,1), detrendedSDcomb(:,2));
        violinplot(detrendedSDcomb, condName, 'QuartileStyle','shadow', 'ShowMean', true, 'ViolinColor', plotColours);
        title(sprintf('p-value = %.3f', pval_detrendedSD))
        ylabel('Standard deviation of detrended signals')
    end

    %% Plot all power spectra
    
    
    numInterpPoints = 4000;
    interpFrequency = linspace(0, 2, numInterpPoints);

    powerSum = zeros(numConditions, numInterpPoints);
    % N = 0;
    nConCount = zeros(numConditions,1);
    
    for nExp = 1:numExp    
        for nCon = 1:numConditions

            if contains(allResults(nExp).name, condName(nCon))
              
                power = allResults(nExp).power(:);
                frequency = allResults(nExp).frequency(:);
                numPower = numel(power);
                
                for nPS = 1:numPower
                    
                    if ~isempty(power{nPS})
                        
                        if plotGraphs == 1
                            figure(200)
                            subplot(1, numConditions+1, nCon)
                            plot(1./frequency{nPS}, power{nPS}, 'color', [plotColours(nCon, :).*0.6 0.1]); hold on
                            xlim([0 200])
                        end
                        
                        interpPower = interp1(frequency{nPS}, power{nPS}, interpFrequency);
                        powerSum(nCon, :) = powerSum(nCon, :) + interpPower;

                        nConCount(nCon) = nConCount(nCon) + 1;
                        allPowerSpectra{nCon}(nConCount(nCon), :) = interpPower;

                    end
                end
            end
        end
    end

    powerSD(1,:) = nanstd(allPowerSpectra{1}, [], 1);
    powerSD(2,:) = nanstd(allPowerSpectra{2}, [], 1);
    powerIQR(1,:) = iqr(allPowerSpectra{1}, 1);
    powerIQR(2,:) = iqr(allPowerSpectra{2}, 1);

%% Stat test at each point in power spectra

period = 1./interpFrequency;
[~,ub]=min(abs(period-10));
[~,lb]=min(abs(period-200));


N = 2000; %To avoid NaN values towards end of power spectra data
for n = 1:N
    powerSpectraPVAL(n) = ranksum(allPowerSpectra{1}(:,n), allPowerSpectra{2}(:,n));
    normalityTest(1, n) = swtest(allPowerSpectra{1}(:,n));
    normalityTest(2, n) = swtest(allPowerSpectra{2}(:,n));
end

        for nCon = 1:numConditions
            powerAvg(nCon, :) = powerSum(nCon, :)./nConCount(nCon);
        end

        if plotGraphs == 1
            
            figure(200)
            subplot(1, numConditions+1, 3)
         
 
            plot(1./interpFrequency, powerAvg(1,:), 'LineWidth', 1.5, 'color', plotColours(1, :)); hold on
            plot(1./interpFrequency, powerAvg(2,:), 'LineWidth', 1.5, 'color', plotColours(2, :));
            legend('DMSO', 'ML141 75uM')
            xlim([0 200])
            axis square
            xlabel('Spatial period (um)')
            ylabel('Power')
            title('Mean power spectra')


    
            figure(200)
            subplot(1, numConditions+1, 1)
            plot(1./interpFrequency, powerAvg(1, :), 'LineWidth', 1.5, 'color', plotColours(1,:))
            title(sprintf('DMSO (n = %.f)', nConCount(1)))
            axis square
            xlabel('Spatial period (um)')
            ylabel('Power')
    
            subplot(1, numConditions+1, 2)
            plot(1./interpFrequency, powerAvg(2, :), 'LineWidth', 1.5, 'color', plotColours(2,:))
            title(sprintf('ML141 75uM (n = %.f)', nConCount(2)))
            axis square
            xlabel('Spatial period (um)')
            ylabel('Power')

            % interpFrequency
            % powerAvg
            coherence.DMSO = accurateCoherence(interpFrequency(1:2000), powerAvg(1,1:2000));
            coherence.ML141 = accurateCoherence(interpFrequency(1:2000), powerAvg(2,1:2000));



            %% Stats analysis of spectra
            figure(201)
            clf

            subplot(2,2,2)
            x = period(2:end);
            y1 = powerAvg(1, 2:end);
            y2 = powerAvg(2, 2:end);
            b1 = powerIQR(1, 2:end);
            b2 = powerIQR(2, 2:end);
            boundedline(x, y1, b1, x, y2, b2, 'cmap', plotColours, 'transparency', 0.2, 'alpha', 'linewidth', 1.5)
            xlim([0 200])
            ylim([0 max(powerAvg, [], 'all')*2.1])
            xlabel('Spatial period (um)')
            ylabel('Power')
            title('Mean power spectra')


            subplot(2,2,4)
            x = period(lb:ub);
            y =  powerSpectraPVAL(lb:ub);

            %Colour plot points by significance
            for n = 1:ub-lb
                if y(n)<=0.05
                    semilogy(x(n), y(n), 'o', 'MarkerFaceColor', col1, 'MarkerEdgeColor', 'none'); hold on;
                else
                    semilogy(x(n), y(n), 'o', 'MarkerFaceColor', [1 1 1]*0.8, 'MarkerEdgeColor', 'none'); hold on;
                end
            end

            semilogy(x, y, '-.k', 'LineWidth', 0.5); hold on;
            semilogy([0 200], [0.05, 0.05], '--k', 'LineWidth', 1.5)
            xlim([0 ub])
            title('Mann-Whitney U-test')
            ylabel('p-value')
            xlabel('Spatial period (um)')
            % axis square
            drawnow

            subplot(221)
            x = period(lb:ub);
            y =  normalityTest(:, lb:ub);
        
            plot(x, y(1,:), 'o', 'MarkerFaceColor', col1, 'MarkerEdgeColor', 'none')
            title('Shapiro-Wilk Normality (DMSO)')
            ylim([0 1])
            xlabel('Spatial period (um)')
            yticks([0 1])
            yticklabels({'Passes normality', 'Fails normality'})
            
            subplot(223)
            plot(x, y(2,:), 'o', 'MarkerFaceColor', col2, 'MarkerEdgeColor', 'none')
            title('Shapiro-Wilk Normality (ML141 75uM)')
            % sgtitle('Shapiro-Wilk Normality test on power spectra')
            ylim([0 1])
            xlabel('Spatial period (um)')
            yticks([0 1])
            yticklabels({'Passes normality', 'Fails normality'})

        end
        % interpFrequency
pk2pk_combined = spatialPeriodsComb.pk2pkBootstrap;
end
