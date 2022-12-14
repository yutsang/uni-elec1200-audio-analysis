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

% extract frame fnum
frame = extract_frame(x,frame_length,fnum);

% extract 4 most significant frequency components of the frame
nsig = 4;
[ksig,Asig,phisig] = get_sig_fc(frame,nsig);

% plot amplitude spectrum of frame
figure(2);clf;
k = 0:(frame_length/2);
[A,phi] = fseries(frame);
plot(k,A); hold on;
plot(ksig,Asig,'rx','LineWidth',2,'MarkerSize',8); hold off;
title('amplitude spectrum');
ax = axis;
axis([0 frame_length/2 ax(3:4)]);
hold on;
grid;
xlabel('k'); ylabel('amplitude')


% create vector of sample indicies
n = 0:(frame_length-1);

% Using the values of ksig, Asig and phisig
% compute the best approximations to the frame
% based on a limited number of cosine waves
% as a function of n, the vector of sample indices
% fa(1,:) = approximation based on 1 cosine
% fa(2,:) = approximation based on 2 cosines
% fa(3,:) = approximation based on 4 cosines
fa = zeros(3,frame_length);

% % % % Revise the following code % % % %
fa(1,:) = Asig(1)*cos(2*pi*ksig(1)*n/frame_length+phisig(1));
fa(2,:) = Asig(1)*cos(2*pi*ksig(1)*n/frame_length+phisig(1))+Asig(2)*cos(2*pi*ksig(2)*n/frame_length+phisig(2));
fa(3,:) = Asig(1)*cos(2*pi*ksig(1)*n/frame_length+phisig(1))+Asig(2)*cos(2*pi*ksig(2)*n/frame_length+phisig(2))+Asig(3)*cos(2*pi*ksig(3)*n/frame_length+phisig(3))+Asig(4)*cos(2*pi*ksig(4)*n/frame_length+phisig(4));

% % % % Do not change the code below % % % %

% generate plots
figure(3);clf;
numcom = [1 2 4]; % vector with number of components used
for c=1:3
subplot(3,1,c)
plot_approx(frame,fa(c,:),numcom(c))
end