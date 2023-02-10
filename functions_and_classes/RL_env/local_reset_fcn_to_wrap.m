function [] = local_reset_fcn_to_wrap()
    
    % initial parameters that may or may not be random (see inside the
    % function)

    in = Simulink.SimulationInput('dynamic_model_euler_copy');

    start_params = generate_init_params();

    in = setVariable(in,'sim_dt', start_params.sim_dt); %11
    in = setVariable(in, 'simTime', start_params.sim_time); %12

    in = setVariable(in,'m_platf',start_params.m_platf); %3
    in = setVariable(in,'m_mass',start_params.m_mass); %8
    in = setVariable(in, 'J_platf', start_params.J_platf); %13
    in = setVariable(in,'tau', start_params.tau); %4
    in = setVariable(in,'roff',start_params.roff); %5
    in = setVariable(in,'d',[ start_params.d1' ; start_params.d2'; start_params.d3']); %6
    in = setVariable(in,'p',[ start_params.p1' ; start_params.p2'; start_params.p3']); %7

    in = setVariable(in,'umax',start_params.umax); %10
    
    in = setVariable(in,'g',start_params.g); %9

    in = setVariable(in,'w0',start_params.w0); % 1
    in = setVariable(in,'q0',start_params.q0); % 2
    in = setVariable(in,'u0',start_params.u0); %10


    % not used from RL_env.slx level
%     t = 0 : 0.01 : 0.01 * 10;
%     u = [t; zeros(1,length(t))]';
%     in = setVariable(in,'u1',u);     
%     in = setVariable(in,'u2',u);
%     in = setVariable(in,'u3',u);
%     in = setVariable(in,'agent_data_random_seed_1',0);
%     in = setVariable(in,'agent_data_random_seed_2',0);
%     in = setVariable(in,'agent_data_random_seed_3',0);
    
end