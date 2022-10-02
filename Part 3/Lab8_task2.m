rng(0) % make the rand() to generate exactly the same 'random' numbers

% parameters
n_slots =1000; % total number of slots
p=0.1;         % probability a node transmits
n_users = 4;   % number of nodes

% used to init the simulation of the ALOHA system
initSimulation(n_users,n_slots)

% result
n_succ = 0; % number of successful transmissions
n_empty= 0; % number of empty slots
n_coll = 0; % number of slots with collisions
slot_status = zeros(n_users,n_slots); % used for the plot

% simulate the transmission process for n_slots
for t = 1:n_slots % Loop for each slot
    slot = zeros(1,16); % reset the slot
    for id=1:n_users
        % get the current frame and check if it is empty
        if isempty(getFrame(id))
            % get a new datagram
            datagram = getNewDatagram(id);
            
            % create the frame using the user id and the datagram
            preamble=[1 0 1 0];
            id_bin=num2bin(id,4);
            words = [preamble id_bin datagram]; % create the first 12 bits
            
            % % % % Revise the following code % % % %
            
            %checksum = [mod((preamble(1)+id_bin(1)+datagram(1)),2) mod((preamble(2)+id_bin(2)+datagram(2)),2) mod((preamble(3)+id_bin(3)+datagram(3)),2) mod((preamble(4)+id_bin(4)+datagram(4)),2)]; % generate the checksum
            checksum = mod((preamble+id_bin+datagram),2);
                 
            % % % % Do not change the code below % % % %
            
            % Check if your checksum is correctly calculated
            cs_ok = IsChecksumCorrect(words,checksum);
            if (~cs_ok)
                disp('Revise your code, checksum is wrong!');
            end
            frame = [preamble id_bin datagram checksum];
            % save the new frame
            updateFrame(id,frame);
        end
        % determine when to transmit
        if ( rand(1)<p ) % generate a Bernoulli random variable with parameter p
            % transmission: update the slot using a logical or
            slot = or(slot,getFrame(id));
            % delete the frame, so that we can transmit a new one
            resetFrame(id);
            % update the slot_status for the final plot
            slot_status(id,t) = 1;
        end
    end
    % is there a new message?
    if ~isequal(slot,zeros(1,16))
        % check the received message
        if checkReceivedFrame(slot,n_users)
            n_succ = n_succ + 1; % update the counter of frame trasmitted successfully
        else
            n_coll = n_coll + 1; % update the counter for the collisions
        end
    else
        n_empty = n_empty +1; % update the number of empty frames
    end
end

% display
disp(['Total number of slots: ' num2str(n_slots) ]);
disp(['Empty slots: ' num2str(n_empty) ]);
disp(['Collisions: ' num2str(n_coll) ]);
disp(['Frame transmitted successfully: ' num2str(n_succ) ]);

% plot
fh = figure(1); clf;
window_size =50;
plotTraffic(fh,slot_status,n_users,window_size);