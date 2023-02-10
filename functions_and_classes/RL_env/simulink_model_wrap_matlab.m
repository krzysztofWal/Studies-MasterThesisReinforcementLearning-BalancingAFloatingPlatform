function [reward, obs, w, q, u_pos, der] = ...
    simulink_model_wrap_matlab( ...
        if_only_time, actions_in, ... % action space switch (2 or 4) and action values
        w0_in,q0_in,u0_in, ... % initial parameters - masses position, platforms orientation and velocity
        episode_roff, ... % r_COM offset (of the platform alone) during the episode
        w1,w2, ... % weights for calculating reward 
        n, ... % number of environmental steps to run
        der0_in, ... % intial values for calculating derivatives
        if_save) % manage saving simulation data to file
    
    % if if_only_time=1 these are times, otherwise velocities
    actions = actions_in(1:2);

    if ~if_only_time
    % if using 4 actions these are times telling for how long the masses should move
        time1 = actions_in(3); time2 = actions_in(4);
    else
    % if using 2 actions - time1 and time2 are maximal possible integers file
    % dynamic_model_euler_copy.slx will treat 'actions' variable as times
        time1 = double(intmax); time2 = double(intmax);
    end
       
    % initial values for calculating derivatives inside
    % dynamic_model_euler_copy.slx
    hb_min1_mem = der0_in(1:3);
    hb_min2_mem = der0_in(4:6);
    w_min1_mem = der0_in(7:9);

    in = Simulink.SimulationInput('dynamic_model_euler_copy');
    start_params = generate_init_params();

    % constant environment parameters
    in = setVariable(in,'m_platf',start_params.m_platf); %3
    in = setVariable(in,'m_mass',start_params.m_mass); %8
    in = setVariable(in, 'J_platf', start_params.J_platf); %13
    in = setVariable(in,'tau', start_params.tau); %4
    in = setVariable(in,'d',[ start_params.d1' ; start_params.d2'; start_params.d3']); %6
    in = setVariable(in,'p',[ start_params.p1' ; start_params.p2'; start_params.p3']); %7
    in = setVariable(in,'umax',start_params.umax); %10
    in = setVariable(in,'g',start_params.g); %9

    sim_dt = start_params.sim_dt;
    simTime = sim_dt*n;

    % set roff - set once every episdoe
    in = setVariable(in,'roff',episode_roff); %5
    
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
    in = setVariable(in,'q0',q0_in'); % 2
    in = setVariable(in,'u0',u0_in); %10
    
    % memory blocks for derivation
    in = setVariable(in, 'Hb_minus1_mem', hb_min1_mem);
    in = setVariable(in, 'Hb_minus2_mem', hb_min2_mem);
    in = setVariable(in, 'w_minus1_mem', w_min1_mem);

    % dummy variables
    t = 0 : 0.01 : 0.01 * 10;
    u = [t; zeros(1,length(t))]';
    in = setVariable(in,'u1',u);     
    in = setVariable(in,'u2',u);
    in = setVariable(in,'u3',u);

%     fprintf("%d %d %d %d %d %d %d %d %d %d %d %d %d %d ", ...
%         actions(1),actions(2),time1, time2,w0_in(1),w0_in(2),w0_in(3),q0_in(1),q0_in(2),q0_in(3),q0_in(4),u0_in(1),u0_in(2),u0_in(3));
    out = sim(in);
    

% 🢃 =============================================================================================== 🢃 
% reward calculations
% because of imperfect searching of this file by
% slx_reward_from_wrap_file(), used reward must be declared with 'rewward ='
% while others have to be with 'reward=' (no space before = sign)

%     dummy_variable = '';
%     reward = -w1*sum(abs(to_vec(out.reward_sig(:,:,2:end))))-w2*(actions_in(1)*actions_in(3)+actions_in(2)*actions_in(4);
    
    dummy_variable = '';
    reward= -w1*sum(abs(to_vec(out.reward_sig(:,:,2:end))))-w2*(actions_in(1)+actions_in(2));
	
    % version below for fourth group of experiments (summing up last steps
    % of reward)
%     temp_size_rew = size(out.reward_sig,3);
%     reward= -w1*sum(abs(to_vec(out.reward_sig(:,:,temp_size_rew - 4 + 1: 10 : temp_size_rew))))-w2*(actions_in(1)+actions_in(2));
% ⇧ =============================================================================================== ⇧ 


% 🢃 =============================================================================================== 🢃 
% observation vector 

  obs= out.observations(2:1:end,:);% not counting the first step
  obs = reshape(obs',1,[])';

    % version below for fourth group of experiments
% 	[rotx, roty ,rotz] = quat2angle(q0_in,'XYZ');
% 	obs = [reshape(w0_in,1,[])'; rotx; roty; rotz; out.results.u_pos.Data(1,:,end);out.results.u_pos.Data(2,:,end)]; % has to be column
% ⇧ =============================================================================================== ⇧ 


    w = out.results.w.Data(end:end,:);
    q = out.results.q.Data(end:end,:);
    u_pos = out.results.u_pos.Data(:,:,end)';
    hb_minus1 = to_vec(out.results.H.Data(:,:,end-1));
    hb_minus2 = to_vec(out.results.H.Data(:,:,end-2));
    w_minus1 = out.results.w.Data(end-1,:);
    der = [hb_minus1' hb_minus2' w_minus1];
    
    % manage saving of selected signals from simulation into txt or mat
    % file
    save_sim_step_data(if_save, out, '', 0);

%     fprintf("%d %d %d %d %d %d %d %d %d %d " + newline, ...
%         w(1),w(2),w(3),q(1),q(2),q(3),q(4),u_pos(1),u_pos(2),u_pos(3));


end