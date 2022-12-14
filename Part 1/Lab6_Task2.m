close all;
clear all;
% load a speech signal
[x,Fs] = audioread('test.wav');

% define the frame length
frame_length = 256;

% compute power of each frame
frame_power = get_frame_power(x,frame_length);

% plot original waveform and power in each frame
figure(1);clf;
plot_speech_power(x,frame_power,frame_length);

% find index of frame with maximum power (fnum)
[mxpow,fnum] = max(frame_power);
% initialize variables
nsig = 4;
k = 0:(frame_length/2);

% list of two frames to plot spectra for
% % % % Revise the following code % % % %
nf = [fnum fnum+2];       % <- ???
% % % % Do not change the code below % % % %

figure(2);clf;
for i=1:2
    % extract frame
    frame = extract_frame(x,frame_length,nf(i));
    % compute the Fourier Series amplitude and the phase
    
    [A,phi] = fseries(frame);
    
    % % % % Revise the following code % % % %
    % find indices of most significant frequency components
    %[Y,I] = sort(A,'descend');
    [B,I] = sort(A, 'descend');
    ind = [1:nsig]*floor(frame_length/(2*(nsig)));   % <- ???
    % % % % Do not change the code below % % % %
    
    % extract frequency, amplitude and phase of most significant
    % components
    ksig = k(ind);
    Asig = A(ind);
    phisig = phi(ind);
    
    % generate plots
    % plot the waveform of the frame
    subplot(2,2,i)
    plot(0:(frame_length-1),frame);
    ax = axis;
    axis([0 frame_length-1 ax(3:4)]);
    grid
    title(['Frame ' num2str(nf(i)) ' waveform']);
    xlabel('sample'); ylabel('signal')
    
    % plot the amplitude spectrum of the frame
    subplot(2,2,2+i)
    plot(k,A); hold on;
    plot(ksig,Asig,'rx','LineWidth',2,'MarkerSize',8); hold off;
    title('amplitude spectrum');
    ax = axis;
    axis([0 frame_length/2 ax(3:4)]);
    hold on;
    grid;
    xlabel('k'); ylabel('amplitude')
end