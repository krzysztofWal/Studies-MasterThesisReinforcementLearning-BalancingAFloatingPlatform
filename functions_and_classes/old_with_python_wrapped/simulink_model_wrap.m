function [var] = simulink_model_wrap(actions_in,w0_in,q0_in,u0_in,n,der0_in,if_save,save_name,cnt)
    % if save == 1, save
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    obs_number = 6;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % conversion from python arguments (of type eng.cell)
    actions = [actions_in{1}; actions_in{2}];
    time1 = actions_in{3};
    time2 = actions_in{4};

    %%%%%%%%%%%%%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%     time1 = 0; time2 = 0;

    w0_in = [w0_in{1}; w0_in{2}; w0_in{3}];
    q0_in = [q0_in{1} q0_in{2} q0_in{3} q0_in{4}];
    u0_in = [u0_in{1}; u0_in{2}; u0_in{3}];
    hb_min1_mem = [der0_in{1} der0_in{2} der0_in{3}];
    hb_min2_mem = [der0_in{4} der0_in{5} der0_in{6}];
    w_min1_mem = [der0_in{7} der0_in{8} der0_in{9}];
    if_save = double([if_save{1} if_save{2} if_save{3}]);

    start_params = generate_init_params();
    in = Simulink.SimulationInput('dynamic_model_euler_copy');

    in = setVariable(in,'m_platf',start_params.m_platf); %3
    in = setVariable(in,'m_mass',start_params.m_mass); %8
    in = setVariable(in, 'J_platf', start_params.J_platf); %13
    in = setVariable(in,'tau', start_params.tau); %4
    in = setVariable(in,'roff',start_params.roff); %5
    in = setVariable(in,'d',[ start_params.d1' ; start_params.d2'; start_params.d3']); %6
    in = setVariable(in,'p',[ start_params.p1' ; start_params.p2'; start_params.p3']); %7
    in = setVariable(in,'umax',start_params.umax); %10
    in = setVariable(in,'g',start_params.g); %9

    sim_dt = start_params.sim_dt;
    simTime = sim_dt*n;

    time_vec = (0:sim_dt:simTime)';
    actions = [time_vec actions(1)*ones(size(time_vec)) actions(2)*ones(size(time_vec))];

    % actions and simulation time
    in = setVariable(in,'sim_dt', sim_dt); 
    in = setVariable(in, 'simTime', simTime);
    in = setVariable(in,'actions',actions);
    in = setVariable(in,'time_1',time1);
    in = setVariable(in,'time_2',time2);

    % initial conditions
    in = setVariable(in,'w0',w0_in); % 1
    in = setVariable(in,'q0',q0_in); % 2
    in = setVariable(in,'u0',u0_in); %10

    % memory blocks for derivation
    in = setVariable(in, 'Hb_minus1_mem', hb_min1_mem');
    in = setVariable(in, 'Hb_minus2_mem', hb_min2_mem');
    in = setVariable(in, 'w_minus1_mem', w_min1_mem');

    % dummy variables
    t = 0 : 0.01 : 0.01 * 10;
    u = [t; zeros(1,length(t))]';
    in = setVariable(in,'u1',u);     
    in = setVariable(in,'u2',u);
    in = setVariable(in,'u3',u);
    

%      size(hb_min1_mem)
%      size(hb_min2_mem)
%      size(w_min1_mem)
%      size(w0_in)
%      size(u0_in)
%      size(q0_in)
    
%     fprintf("%i %d %d %d %d %d %d %d %d %d %d %d %d %d %d ", ...
%         int32(cnt),actions(1),actions(2),time1, time2,w0_in(1),w0_in(2),w0_in(3),q0_in(1),q0_in(2),q0_in(3),q0_in(4),u0_in(1),u0_in(2),u0_in(3));
    out = sim(in);
%     fprintf("%i ", int32(cnt));to_vec(out.reward_sig)'
%     out.reward_sig;
    reward = -sum(abs(to_vec(out.reward_sig(:,:,2:end))));
%     if cnt == 0
        observations = out.observations(2:end,:);% not counting the first step
%     else
%         observations = out.observations(:,:);
%     end
    w = out.results.w.Data(end:end,:);
    q = out.results.q.Data(end:end,:);
    u_pos = out.results.u_pos.Data(:,:,end);

%     fprintf("%d %d %d %d %d %d %d %d %d %d " + newline, ...
%         w(1),w(2),w(3),q(1),q(2),q(3),q(4),u_pos(1),u_pos(2),u_pos(3));

    hb_minus1 = to_vec(out.results.H.Data(:,:,end-1));
    hb_minus2 = to_vec(out.results.H.Data(:,:,end-2));
    w_minus1 = out.results.w.Data(end-1,:);
    
    save('temp_data_from_sim.mat','reward','observations','w','q',"u_pos",'hb_minus1','hb_minus2','w_minus1');
%     out_ = "";
%     char_ = '%.32f|';
%     out_ = out_ + sprintf(string(repmat(char_,1,1)),reward);
%     out_ = out_ + sprintf(string(repmat(char_,1,10)), w(1),w(2),w(3), q(1),q(2),q(3),q(4), u_pos(1), u_pos(2), u_pos(3));
%     for i = 1 : size(observations,1)
% %         i, n, obs_number
%         out_ = out_ + sprintf(string(repmat(char_,1,n*obs_number)),observations(i,1),observations(i,2),observations(i,3),observations(i,4),observations(i,5),observations(i,6));
%     end
%     out_ = out_ + sprintf(string(repmat(char_,1,9)), hb_minus1(1), hb_minus1(2), hb_minus1(3), ...
%                                                     hb_minus2(1), hb_minus2(2), hb_minus2(3), ...
%                                                     w_minus1(1), w_minus1(2), w_minus1(3));
%     tic
%     if boolean(ifsave)
%        %extract var number
%         save_name = string(save_name);
%         split_ = strsplit(save_name,"|");
%         save_name = split_{1};
%         
%         destination = split_{3} + string(save_name) + ".mat";
% 
%         step_number = double(string(split_{2})) + 1;
%         episode_number = double(string(split_{4}));
%         var_name = "var" + string(episode_number) + "_" + string(step_number);
% 
%         if (episode_number) == 1 && step_number == 1
%             create_name(var_name, out);% assign out to variable with given_name
%             save(destination,var_name,'-mat')
%         else
%             create_name(var_name, out);% assign out to variable with given_name
%             save(destination,var_name,'-append')
%         end
%     end
% %     toc
    var = save_sim_step_data(if_save, out, save_name, 1);

end