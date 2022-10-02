% load the signal x and the sample frequency Fs
[x,Fs] = audioread('lab07_speech0.wav');
x=x';

% choose a carrier frequency
freq_carrier = 20e3;
freq_cutoff = 4e3;
x=lowpass(x,Fs,freq_cutoff); 

% modulate the carrier wave using x
xm = modulate(x,Fs,freq_carrier);

% % % % % %
% Channel %
% % % % % %
rx_wave = txrx(xm,1,'ideal');
% demodulate the carrier using x_mod
[rx,xd] = demodulate(rx_wave,Fs,freq_carrier,freq_cutoff);

% % % generate some useful plot to debug the function % % %
% Plot the amplitude spectra
figure(1);clf;
subplot(4,1,1);
plotAmplitudeSpectrum(x,Fs,'Amplitude Spectrum of Message');
subplot(4,1,2);
plotAmplitudeSpectrum(xm,Fs,'Amplitude Spectrum of Modulated Message');
subplot(4,1,3);
plotAmplitudeSpectrum(xd,Fs,'Amplitude Spectrum after Mixing');
subplot(4,1,4);
plotAmplitudeSpectrum(rx,Fs,'Amplitude Spectrum after Low Pass Filtering');
% Plot time waveforms
% get the sample time and the duration of the signal
Ts = 1/Fs; % sample period
Tmax= (length(x)-1)*Ts;
t=0:Ts:Tmax;
% The demodulated signal is half as big, so we double it to compare
% with the originally transmitted signal
rxa = 2*rx;
figure(2);clf;
subplot(2,1,1); plot(t,x,'r'); hold on; plot(t,rxa,'--b'); hold off;
legend('Original message','Recovered message');
xlabel('Time (sec)'); ylabel('Amplitude');
nmse = sum((x-rxa).^2)/sum((x).^2);
title(['Original and recovered message waveforms: nmse = ' num2str(nmse)]);
subplot(2,1,2);
zoom_start =200000;
zoom_stop =210001;
ind = zoom_start:zoom_stop;
plot(t(ind),x(ind),'r'); hold on;
plot(t(ind),rxa(ind),'--b'); hold off;
legend('Original message','Recovered message');
xlabel('Time(sec)'); ylabel('Amplitude');
title(['Original and recovered messages (zoom in view)']);
axis([t(zoom_start) t(zoom_stop) -0.4 0.4]); grid;