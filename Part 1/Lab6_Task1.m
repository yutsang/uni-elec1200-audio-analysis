% load a speech signal
[x,Fs] = audioread('test.wav');

% % % % Revise the following code % % % %
% define the frame length
frame_length = 512;

% % % % Do not change the code below % % % %
% compute power of each frame
frame_power = get_frame_power(x,frame_length);

% plot original waveform and power in each frame
figure(1);clf;
plot_speech_power(x,frame_power,frame_length);

% find index of frame with maximum power (fnum)
[mxpow,fnum] = max(frame_power);

% extract that frame
frame = extract_frame(x,frame_length,fnum);
% approximate frame with 4 largest frequency components
numcom = 4;
app_frame = approximate_frame(frame,numcom);

% compare the original and approximated frame
figure(2);clf;
plot_approx(frame,app_frame,numcom);