function [signal_filter, f, p, p_filter] = FFTfilter(signal, cutoff_freq, fs)

%signal is the raw time-domain signal to be filtered
%cutoff freq: frequencies <=cutoff_freq will be filtered out in the power spectra
%fs: sampling frequency of the signal
if size(signal,1)>size(signal, 2)
    signal = signal';
end

Y=fft(signal); % Calculate the fast Fourier transform
L=length(Y);   % Number of elements in fft

% Frequency output by fft is symmetric for real signal with the first half
% being the positive frequencies including 0 (1:L/2+1), and the second half is the complex conjugate negative values. 
% For real signals, we only need the first positive half to plot the power spectrum. 
f = fs*(0:(L/2))/L; %Frequency scaled by fs
P2 = abs(Y/L).^2; 

p = P2(:, 1:floor(L/2)+1);
p(:,2:end-1) = 2*p(:,2:end-1);

filter = f>=cutoff_freq;
filter_rawFFT = [filter, fliplr(filter(2:end))];

p_filter = p.*filter;
Y_filter = Y.*filter_rawFFT;
signal_filter = real(ifft(Y_filter));

end