rng(0)
% parameters
n_slots =1000;
p_list = 0:0.05:1;
n_users = 4;

% used to init the simulation of the ALOHA system
initSimulation(n_users,n_slots)

% counters
n_succ = zeros(1,length(p_list)); % number of successful transmissions
n_empty= zeros(1,length(p_list)); % number of empty slots
n_coll = zeros(1,length(p_list)); % number of slots with collisions
frame = zeros(n_users,16);

%send always the same frame to speed up the simulation
for id=1:n_users
    %get a new datagram
    datagram = getNewDatagram();
    frame(id,:) = createFrame(id,datagram);
end

for pc=1:length(p_list)
    p = p_list(pc);
    % simulate the transmission process for n_slots
    for t = 1:n_slots % Loop for each slot
        send_frame = rand(n_users,1)<p;
        slot = sum(frame((send_frame),:),1)>=1; % Logical OR of transmitted frames
        % check the received message
        if ~isequal(slot,zeros(1,16))
            if checkReceivedFrame(slot,n_users)
                n_succ(pc) = n_succ(pc) + 1; % update the counter of frame trasmitted successfully
            else
                n_coll(pc) = n_coll(pc) + 1;
            end
        else
            n_empty(pc) = n_empty(pc) +1; % update the number of empty frames
        end
    end
end

% % % % Revise the following code % % % %
eff_v = n_succ/n_slots;
empty_v= n_empty/n_slots;
coll_v = n_coll/n_slots;
expeff_v= n_users.*p_list.*(1-p_list).^(n_users-1);


% % % % Do not change the code below % % % %
figure(1);clf; hold off;
plot(p_list,eff_v,'LineWidth',2);
hold on;
plot(p_list,expeff_v,'--','LineWidth',2);
plot(p_list,coll_v,'-','LineWidth',2);
plot(p_list,empty_v,'-','LineWidth',2);

legend('Efficiency','Expected Efficiency','Collisions','Empty Slots','Location','east');
xlabel('probability')
h=gca;
h.YGrid='on';