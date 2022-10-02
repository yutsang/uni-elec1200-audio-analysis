% load the signal x and the sample frequency Fs
[x,Fs] = audioread('lab07_speech1.wav');
x=x';

% % % % % % % %
% Transmitter %
% % % % % % % %
tx_wave = modulate_task3(x, Fs);
% % % % % %
% Channel %
% % % % % %
rx_wave = txrx(tx_wave,1,'ideal');

% % % % % % %
% Receiver %
% % % % % % %
% % % % Revise the following code % % % %
freq_carrier = 0;           % Find the carrier frequency
freq_cutoff = 0;            % Find the cutoff frequency of the low pass filter(BW of the original signal)

% % % % Do not change the code below % % % %

% Demodulation
rx = demodulate(rx_wave,Fs,freq_carrier,freq_cutoff);

% Plot the amplitude spectra
figure(1);clf;
subplot(3,1,1);
plotAmplitudeSpectrum(x,Fs,'Amplitude Spectrum of Message');
subplot(3,1,2);
plotAmplitudeSpectrum(tx_wave,Fs,'Amplitude Spectrum of Modulated Message');
subplot(3,1,3);
plotAmplitudeSpectrum(rx,Fs,'Amplitude Spectrum of Demodulated Message');

% Plot time waveforms
% get the sample time and the duration of the signal
Ts = 1/Fs; % sample period
Tmax= (length(x)-1)*Ts;
t=0:Ts:Tmax;

% The received signal is half as big, so we double it to compare
% with the originally transmitted signal
rxa = 2*rx;
figure(2);clf;
subplot(2,1,1)
plot(t,rxa,'r'); hold on;
plot(t,x,'--b'); hold off;
legend('Original message','Recovered message');
xlabel('Time(sec)')
ylabel('Amplitude')
nmse = sum((x-rxa).^2)/sum((x).^2);
title(['Original and recovered message waveforms: nmse = ' num2str(nmse)]);

subplot(2,1,2)
zoom_start =200000;
zoom_stop =210001;
ind = zoom_start:zoom_stop;
plot(t(ind),rxa(ind),'r'); hold on;
plot(t(ind),x(ind),'--b'); hold off;
legend('Original message','Recovered message');
xlabel('Time(sec)')
ylabel('Amplitude')
title(['Original and recovered messages (zoom in view)']);
axis([t(zoom_start) t(zoom_stop) -0.4 0.4]);
grid;