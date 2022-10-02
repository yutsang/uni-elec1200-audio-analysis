function [rx, xd] = demodulate(x,Fs,freq_carrier,freq_cutoff)
% DEMODULATE: Demodulate a waveform X.
%
% [RX, XD] = DEMODULATE(X, FS, FREQ_CARRIER, FREQ_CUTOFF) demodulates a waveform
%    Inputs:
%        X = waveform to demodulate
%        FS = sampling frequency
%        FREQ_CARRIER = frequency of cosinusoidal carrier
%        FREQ_CUTOFF = cut-off frequency of low pass filter 
%    Outputs:
%        RX = demodulated waveform
%        XD = X mixed with cosinusoidal carrier wave (for debugging)

% get the sample time and the duration of the signal 
Ts = 1/Fs; %  sample period
Tmax= (length(x)-1)*Ts; 
t=0:Ts:Tmax;
 
% % % % Revise the following code  % % % % 
% mix waveform with carrier

% apply lowpass filtering
y = x.*cos(2*pi*freq_carrier*t); % demodulation
xd = x.*y;
rx = lowpass(xd,Fs,freq_cutoff);


%%%% Do not change the code below %%%%

end