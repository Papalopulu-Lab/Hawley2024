function [coherence]=accurateCoherence(f,p)
%Coherence is calculated as: 
% coherence = Ap/A
%where Ap is the area under the power spectrum within 10% left and right of
%the peak power frequency, and A is the area under the whole power
%spectrum.

if size(f, 1) > size(f, 2)
    f=f';
end
if size(p, 1) > size(p, 2)
    p=p';
end


    %% Find peak in Power
    [~, peakPowerIdx] = max(p); %Peak value index of the average FT (largest frequency contribution to signal)
    
    %% Determine 10% of the peak power frequency
    df       = f(2)-f(1); %frequency step size
    tenP     = 0.1*f(peakPowerIdx); %Ten percent the value of the peak value
    tenP_idx = 0.1*f(peakPowerIdx)/df; %Ten percent as an index value
    
    %% Calculate the area within 10% either side of the peak power frequency (Ap)
    
    if peakPowerIdx == 1 %The case when the peak power occurs at zero frequency
        Ap = 0;
        f_Ap = 0;
        P_Ap = p(peakPowerIdx);
        
    elseif round(tenP_idx) == tenP_idx %The case when ten percent coincides perfectly with the discrete
        Ap = trapz( f(peakPowerIdx-tenP_idx : peakPowerIdx+tenP_idx), p(peakPowerIdx-tenP_idx : peakPowerIdx+tenP_idx) );
        f_Ap = f(peakPowerIdx-tenP_idx : peakPowerIdx+tenP_idx);
        P_Ap = p(peakPowerIdx-tenP_idx : peakPowerIdx+tenP_idx);
        
    else
        [f_Ap, P_Ap]=interpAp(f, p, peakPowerIdx, tenP, tenP_idx); %Interpolates between fourier values to get more accurate coherence area  
        Ap = trapz(f_Ap, P_Ap);
    end

    A = trapz(f,p);
    coherence = Ap/A;
 
end


function [f_Ap, P_Ap]=interpAp(f,P,I,tenP,tenP_idx)
        
        idx_im=I-floor(tenP_idx);
        idx_om=I-ceil(tenP_idx);
        idx_ip=I+floor(tenP_idx);
        idx_op=I+ceil(tenP_idx);
        
        f_im=f(idx_im); %Frequency value at inner, minor (Subscripts: i=inner, m=minor)
        f_ip=f(idx_ip); %Frequency value at inner, plus (Subscripts: i=inner, p=plus)
        f_om=f(idx_om);
        f_op=f(idx_op);
        
        P_im=P(idx_im);
        P_ip=P(idx_ip); 
        P_om=P(idx_om);
        P_op=P(idx_op);
        
        f_mm=f(I)-tenP;
        f_mp=f(I)+tenP; 
        
        smidge_m=abs((f_mm-f_im))/abs((f_om-f_im));
        smidge_p=abs((f_mp-f_ip))/abs((f_op-f_ip));
        P_mm=P_om*smidge_m + P_im*(1-smidge_m);
        P_mp=P_op*smidge_p + P_ip*(1-smidge_p);
        
        % f_mm
        % f(idx_im:idx_ip)
        % f_mp

        f_Ap=[f_mm, f(idx_im:idx_ip), f_mp];
        P_Ap=[P_mm,  P(idx_im:idx_ip), P_mp];
    end