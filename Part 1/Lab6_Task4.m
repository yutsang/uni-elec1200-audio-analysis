close all; clear all;
% Exponential factor controlling step response of channel
ach = 0.93;
% Exponential factor controlling the equalizer. This is the
% equalizer's estimate of the a of the channel. Ideally, this
% should equal ach, but in practice, there is often mismatch.
aeq = 0.93;

nsamp = 1200;
n=0:(nsamp-1);

flist = logspace(-3,-1);
h_rx = zeros(1,length(flist));
h_eq_rx = zeros(1,length(flist));
h_eq_tx = zeros(1,length(flist));

for i=1:length(flist)


% normalized frequency of the signal (cycles/sample)
freq = flist(i);

% create a sinusoidal function with frequency freq and nsamp samples
tx_wave = sin(2*pi*freq*n);

% send the signal through the channel
rx_wave = txrx(tx_wave,ach,'pureexp');

 % Estimate the amplitude as half the peak to peak amplitude 
    % of the channel output
    ind = 200:length(rx_wave);
    h_rx(i)= ( max(rx_wave(ind))-min(rx_wave(ind)) )/2;
 
    % % % % Revise the following code % % % %
    
    eq_rx = equalizer(rx_wave,aeq);
    h_eq_rx(i)= (max(eq_rx(ind))-min(eq_rx(ind)))/2;
    %h_eq_rx(i) = 1+rand(1);
    
    eq_tx = equalizer(tx_wave,aeq); 
    h_eq_tx(i) = (max(eq_tx(ind))-min(eq_tx(ind)))/2;;
    
   % % % % % Do not change the code below % % % %

end

% generate plots
figure(1);clf;
loglog(flist,h_rx,'b');
hold on;
loglog(flist,h_eq_rx,'r');
loglog(flist,h_eq_tx,'g'); hold off;
grid
legend('channel','channel + equalizer','equalizer');
xlabel('Normalized Frequency');
ylabel('Amplitude');
title('Frequency responses');