function xm = modulate(x,Fs,freq_carrier)
% MODULATE: Modulate a cosinusoidal carrier wave with a message X.
% XM = MODULATE(X, FS, FREQ_CARRIER) returns the modulated signal XM.
%    It takes as input 
%        X = the message signal
%        FS = the sampling frequency 
%        FREQ_CARRIER = the cosinusoidal carrier wave frequency

% Create vector of sample times 
Ts = 1/Fs; %  sample period
Tmax= (length(x)-1)*Ts; 
t=0:Ts:Tmax;

% Modulate the signal    
% % % % Revise the following code  % % % % 
xm = x;
y = cos(2*pi*freq_carrier*t);
xm = x.*y;

end