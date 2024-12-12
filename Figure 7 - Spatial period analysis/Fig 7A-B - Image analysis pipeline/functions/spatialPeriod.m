%spatialPeriod.m Analyses an already detrended signal via two methods:
%1) Fast Fourier Transform with a Fisher-G test of significance in the
%power of the peak period.
%2) Autocorrelation function with bootstrapping to test each peak for
%significance.

function [f, P1, peakPeriod, peakPeriodFisher, pvalFisher, bootstrapPeak2Peak, bootstrapPeriod, ACF, smoothedACF, bootstrapUpper, bootstrapLower, lags, locsSignificant, pksSignificant]=spatialPeriod(signal, dx)

    %% Fast Fourier transform of the detrended signal
    signal = signal';
    Y=fft(signal);
    L=length(Y);
    Fs=1/dx;
    f = Fs*(0:(L/2))/L;
    P2 = abs(Y/L).^2;

    P1 = P2(:, 1:floor(L/2)+1);
    P1(:,2:end-1) = 2*P1(:,2:end-1);

    f = f';
    P1 = P1';
    
    [~,i]=max(P1);
    peakPeriod=1./f(i);                                                     %Individual cell fourier dominant periods
      
    [peakPeriodFisher, ~, pvalFisher] = Fisher(P1, f);

    %% Bootstrap ACF of the detrended signal
    [bootstrapPeak2Peak, bootstrapPeriod, ACF, smoothedACF, bootstrapUpper, bootstrapLower, lags, locsSignificant, pksSignificant] = bootstrapACF(signal, dx);

end


function [FisherPer,Occurrence, pval]=Fisher(P1,f)

II=size(P1,2);


    PXX2=P1(2:end,:);
    F2=f(2:end);
    %Preallocation for storing stats
    fisherG=zeros(II,1);
    pval=zeros(II,1);
    peakLoc=zeros(II,1);
    peakHeight=zeros(II,1);
    FisherPer=zeros(II,1);

    for ii=1:II

        pxx=PXX2(:,ii); % periodogram
        
        [fisherG(ii),pval(ii),idx]=GetFisherG(pxx); % Find the peak and collect Fisher G-statistic
        peakLoc(ii)=idx;
        peakHeight(ii)=pxx(idx);
        
        if pval(ii)<0.05
            FisherPer(ii)=1/F2(idx);
        else
            FisherPer(ii)=nan;
        end

    end
    
    Occurrence=1-sum(isnan(FisherPer))/II;
    
end

%GetFisherG is based on the matlab page and refs found here: 
%https://www.mathworks.com/help/signal/ug/significance-testing-for-periodic-component.html
function [fisher_g,pval,idx]=GetFisherG(Pxx)
    idx=find(Pxx==max(Pxx),1,'first');
    fisher_g=Pxx(idx)/sum(Pxx);

    N = length(Pxx);
    nn = 1:floor(1/fisher_g);

    I = (-1).^(nn-1).*exp(gammaln(N+1)-gammaln(nn+1)-gammaln(N-nn+1)).*(1-nn*fisher_g).^(N-1);
    
    pval = sum(I);
end