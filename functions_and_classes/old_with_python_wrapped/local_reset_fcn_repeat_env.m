function in = local_reset_fcn_repeat_env(in)
    global global_episode_counter
%     restart_python();
    start_params = generate_init_params();
    
    in = setVariable(in,'init_params_on_reset',[start_params.w0',start_params.q0, start_params.u0, start_params.u0, 0]); 
    in = setVariable(in,'der_init_params_on_reset',zeros(9,1));
    in = setVariable(in,'umax', start_params.umax);
    in = setVariable(in,'episode_counter',global_episode_counter);

    [rotx, roty ,rotz] = quat2angle(start_params.q0,'XYZ');
    in = setVariable(in,'init_obs',[start_params.w0' rotx roty rotz ]);

    % not used from RL_env.slx level
    in = setVariable(in,'agent_data_random_seed_1',0);
    in = setVariable(in,'agent_data_random_seed_2',0);
    in = setVariable(in,'agent_data_random_seed_3',0);
    in = setVariable(in,'agent_data_random_seed_4',0);

    global_episode_counter = global_episode_counter + 1;
end