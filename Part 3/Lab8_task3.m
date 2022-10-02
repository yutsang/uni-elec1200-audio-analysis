n_users = 4;
load('frames.mat'); % load the matrix frames
result = zeros(size(frames,1),3);

for i=1:size(frames,1)
    %% code
    frame = frames(i,:);
    
    % check the received message
    nb = 4;
    
    % % % % Revise the following code % % % %
    % check whether the checkbit of the received frame
    checkbit = mod((frame(1:4)+frame(5:8)+frame(9:12)+frame(13:16)),2);

    % % % % Do not change the code below % % % %
    
    % check whether the checkbit of the received frame is zero
    cs_ok  =  isequal(checkbit,zeros(1,4));
    
    % check the preamble
    pre_ok = isequal(frame(1:4),[1 0 1 0]);

    % check whether the id is valid
    id =bin2num(frame(5:8));
    id_ok = id>0 & id<n_users+1;

    % check the whole frame (valid is the above three parts are all valid)
    frame_ok = id_ok & pre_ok & cs_ok;
    
    % store the checking result
    result(i,1) = cs_ok;
    result(i,2) = pre_ok;
    result(i,3) = id_ok;
    result(i,4) = frame_ok;
end

evaluateTask3(n_users,frames,result); % this function will display error if your code is not correct
