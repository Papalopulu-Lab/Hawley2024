function [bootstrapPeak2Peak, bootstrapPeriod, ACF, smoothedACF, bootstrapUpper, bootstrapLower, lags, locsSignificant, pksSignificant] = bootstrapACF(signal, dx)
    
    %% Caluclate the autocorrelation function (ACF) of the input signal
    x = (1:length(signal))*dx;
    [wholeACF, lags] = xcorr(signal);
    lags = lags*dx;                                                        %Lags is the vector which indicates how much the input signal 
    %% Cut the negative half of the ACF out (as this is symmetric to the positive part)
    zeroElem = find(lags==0);
    lags = lags(zeroElem:end);
    ACF = wholeACF(zeroElem:end);

    %% Randomly shuffle signal and generate bootstrap ACF data 
    bootstrapReps = 1000;
    parfor n = 1:bootstrapReps
    
     shuffledSignal = signal(randperm(length(signal)));                    %Generate random permutation of the signal
     wholeBootstrapACF = xcorr(shuffledSignal);                            %Perform autocorrelation on the randomly permuted signal
     bootstrapACF(n, :) = wholeBootstrapACF(zeroElem:end);
    end

    %% Calculate confidence bounds of the bootstrap data
    SD = std(bootstrapACF);                                                %Upper confidence interval
    bootstrapUpper = 2*SD;
    bootstrapLower = -2*SD;
 
    %% Smooth ACF
    windowSize = 20/dx;                                                    %Window size in um
    if mod(ceil(windowSize), 2) == 0
        windowSize = floor(windowSize);
    else
        windowSize = ceil(windowSize);
    end
        % smoothedACF = smoothdata(ACF, 'gaussian', windowSize);                 %Using gaussian smoothin over sgolay as only one parameter needed to specify gaussian.
    
        
        % smoothedACF = polyval(polyfit(...             %Polynomial fit line
        %             x, ACF,...
        %             polyNum), data.xMicrons{s,z,r})';
    % smoothedACF = sgolayfilt(ACF, 2, windowSize);
    smoothedACF = ACF;
    %% Find peaks
    [pks,locs] = findpeaks(smoothedACF);

    %% Remove peak that are within the bootstrap confidence interval
    signficantPks = find(pks - bootstrapUpper(locs) > 0);
    pksSignificant = pks(signficantPks); 
    locsSignificant  = locs(signficantPks);
    
    locsSignificant = (locsSignificant-1)*dx;

    %% Add in the ACF at zero as a peak value
    pksSignificant = [smoothedACF(1), pksSignificant];
    locsSignificant = [0, locsSignificant];
    
    %% Calculate distance between significant peaks
    bootstrapPeak2Peak = locsSignificant(2:end) - locsSignificant(1:end-1);
    bootstrapPeriod= mean(bootstrapPeak2Peak);
end

