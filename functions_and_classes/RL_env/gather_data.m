function [data,rng_state,raw_param_hist, info_, seed_mem] ...
    = gather_data(nr_steps, count, info_, if_save_raw_params)

    % collect data using random actions
    simOptions = rlSimulationOptions('MaxSteps',nr_steps);
    num = 0;
    data = cell.empty();
    seed_mem = zeros(count,3);

    if if_save_raw_params, raw_param_hist = Simulink.SimulationOutput.empty(0,ceil(count/nr_steps));
        else, raw_param_hist = []; end
    iter = 1;
    % print message
    print_line(50,'-')
    fprintf("Gathering data for constraint function learning, max_steps = %i\n", count)
    print_line(50,'-')

    % for mechanincs_euler_init
    m_e_i_first = true;
    sample_time_for_controller = info_.sample_time;

    while num<=count

        no_sim = true;
        mechanics_euler_init
        clear no_sim

        % Seed for random action
        % agent_data_ra ndom_seed = double(mod(ZonedDateTime.now().toInstant().toEpochMilli(),1000));
        agent_data_random_seed_1  = randi(1000);
        agent_data_random_seed_2  = randi(1000);
        agent_data_random_seed_3  = randi(1000);
        seed_mem(num+1,:) = [agent_data_random_seed_1 agent_data_random_seed_2 agent_data_random_seed_3];
        % Simulate model for one episode.
        exp = sim(env,agentObj,simOptions);
        if if_save_raw_params, raw_param_hist(iter) = exp.SimulationInfo; end
        % Process simulation output for the episode.
        disp("Episode " + string(iter) + " finished")
        
        episode_length = length(exp.Action.act1.Data(1,:,:));
        zer_temp = zeros(episode_length,1);
        % give what parameters you would like to save
        episode_data_t = struct(...
            "velocity_x" , zer_temp, "velocity_y", zer_temp, "velocity_z", zer_temp, ...
            "Hdot_minus1", zer_temp, ...
            "c" ,zer_temp, "c_next", zer_temp, ...
            "u1", zer_temp, "u2", zer_temp, "u3", zer_temp);
        episode_data = episode_data_t;
        if ~isempty(exp.Action)
            % constraints
            episode_data.c = exp.Observation.obs1.Data(4,:,1:episode_length);
            episode_data.c_next = exp.Observation.obs1.Data(4,:,2:episode_length+1);  
            % observations
            episode_data.velocity_x = exp.Observation.obs1.Data(1,:,1:episode_length); 
            episode_data.velocity_y = exp.Observation.obs1.Data(2,:,1:episode_length); 
            episode_data.velocity_z = exp.Observation.obs1.Data(3,:,1:episode_length); 
            episode_data.Hdot_minus1 = exp.Observation.obs1.Data(5,:,1:episode_length);
            % actions
            episode_data.u1 = exp.Action.act1.Data(1,:,1:episode_length); 
            episode_data.u2 = exp.Action.act1.Data(2,:,1:episode_length);
            episode_data.u3 = exp.Action.act1.Data(3,:,1:episode_length);
            % Copy episode data to output
            data{end+1} = episode_data;

            % for next iteration
            num = num + episode_length;
        end
        iter = iter + 1;
    end
    % save rng state
    rng_state = rng;
end