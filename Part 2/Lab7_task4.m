NMSG = 3; % number of messages

% load the signal x and the sample frequency Fs
for c=1:NMSG
    fname = ['lab07_speech' num2str(c) '.wav'];
    [x,Fs] = audioread(fname);
    
    if c == 1
        signal= zeros(NMSG,length(x)); % signal
    end
    
    signal(c,:)=x';
end

rx_signal=zeros(NMSG,length(x)); % received signal

% get the sample time and the duration of the signal
Ts = 1/Fs; % sample period
Tmax= (length(x)-1)*Ts;
t=0:Ts:Tmax;

% initialize the frequencies
freq_cutoff = 4e3;
freq_carrier = [20e3 40e3 60e3]; % carrier frequencies for FDM


% % % % % % % %
% Transmitter %
% % % % % % % %
tx_wave = zeros(1,length(t));
for i=1:NMSG
    fc = freq_carrier(i);
    xm = modulate(signal(i,:),Fs, fc);
    tx_wave = tx_wave+xm;
end

% % % % % %
% Channel %
% % % % % %
rx_wave = txrx(tx_wave,1,'occupied_band');

% % % % % % %
% Receiver %
% % % % % % %
for i=1:NMSG
    fc = freq_carrier(i);
    
    % Demodulation   
    rx = demodulate(rx_wave,Fs,fc,freq_cutoff);
    fname_out = ['lab07_speech' num2str(i) '_demod.wav'];
    audiowrite(fname_out, rx, Fs);
    rx_signal(i,:) = rx;
end

% Plot amplitude spectra of transmitted and received signals
figure(1);clf;
subplot(2,1,1);
plotAmplitudeSpectrum(tx_wave,Fs,'Amplitude Spectrum of Transmitted Signal');
subplot(2,1,2);
plotAmplitudeSpectrum(rx_wave,Fs,'Amplitude Spectrum of Received Signal');

% Plot amplitude spectra of recovered messages
figure(2);clf;
for i=1:NMSG
    subplot(NMSG,1,i);
    plot_title = ['Amplitude Spectrum of Recovered Message ' num2str(i)];
    plotAmplitudeSpectrum(rx_signal(i,:),Fs,plot_title);
end

% Plot transmitted and recovered messages for comparison
% The received signal is half as big, so we double it to compare
% with the originally transmitted signal
rxa = 2*rx_signal;

figure(3);clf;
for i = 1:NMSG
    subplot(NMSG,1,i);
    nmse = sum((signal(i,:)-rxa(i,:)).^2)/sum((signal(i,:)).^2);
    zoom_start =200000;
    zoom_stop =210001;
    ind = zoom_start:zoom_stop;
    plot(t(ind),signal(i,ind),'b'); hold on;
    plot(t(ind),rxa(i,ind),'--r'); hold off;
    legend('Original','Recovered','Location','NorthEastOutside');
    xlabel('Time(sec)')
    ylabel('Amplitude')
    title(['Message ' num2str(i) ' Waveform (zoom) : nmse = ' num2str(nmse)]);
    axis([t(zoom_start) t(zoom_stop) -0.4 0.4]);
    grid;
end