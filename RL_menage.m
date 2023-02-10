% main script controlling training and simulating the agents

if contains(pwd,'simulation_folder'), cd .., end % if stopped in the simualtion folder
% create proper directories if dont exist (in case of matlab online e.g.)
if ~contains(pwd,'with_RLscript')
% do not create when using bash-createdfile from ./with_RLscript level
    if ~exist("text_files","dir"), mkdir text_files; end
    if ~exist("simulation_folder","dir"), mkdir simulation_folder; end
    if ~exist("with_RLscript","dir"), mkdir with_RLscript; end
end
clearvars

%% CHOOSING ACTION 

% 🢃 =============================================================================================== 🢃 
% choosing which path to take
% choose one of the three
% if_RL_learn = 1, training RL agents in an evironment defined below
% if_sim = 1, simulate trained agents in an evironment defined below
if_RL_learn = 1;
if_sim = 0;
% ⇧ =============================================================================================== ⇧ 

if if_sim
% 🢃 =============================================================================================== 🢃 
    if_load_saved_automatically =1; % if 1, then using agent saved by RL Toolbox during training
                                    % not by this script after training
                                    % (different variable names in the
                                    % files)
    base_agent_info = 'data_11_11_tb_1_Agent_987.mat';
% ⇧ =============================================================================================== ⇧ 
end

% 🢃 =============================================================================================== 🢃 
if_test_with_openAI = 0;

% if using 'wrapped' simulink environment
% choose one of the below or set both to zero
if_RL_repeat_env_matlab = 1;    % if using Matlab class to create an environment
                                % which runs simulink file called from the 
                                % function simulink_model_wrap_matlab()

% ⇧ =============================================================================================== ⇧ 

if_RL_repeat_env = 0; if if_RL_repeat_env_matlab, if_RL_repeat_env = 1; if_test_with_openAI = 0;
% 🢃 =============================================================================================== 🢃 
% if_only_time = 1  - when the agent controls the masses with constant
%   velocity by setting time for which they should move
%   exists only when if_RL_repeat_env_matlab = 1
    if_only_time = 1;
% ⇧ =============================================================================================== ⇧ 
end

if if_RL_repeat_env
% 🢃 =============================================================================================== 🢃 
    if_multiply_obs = 1; % if concatenating observations from n steps of simulation
    if_save_txt = 1;    % if save simulation data from each episode in text file
                        % used only when if_RL_repeat_env_matlab = 1
% ⇧ =============================================================================================== ⇧ 
end

if_DDPG = 0; % if using DDPG instead of SAC algorithm
             % may require some modifications in the script, not guaranteed
             % to work

if ~if_test_with_openAI
% 🢃 =============================================================================================== 🢃 
% if to extract data describing the environment
% and reward calculation from simulink files and matlab funtion
% in which they appear
    if_extract_from_slx = 1; % off when using matlab online, uses bash script
    if_extract_starting_conditions = 1; % uses matlab function not bash script
% ⇧ =============================================================================================== ⇧ 
end

% 'legacy' variables
if_debug = 0; 
if_save = 0; 

if if_debug && if_RL_repeat_env
    fid=fopen('simulation_folder/debug.txt','wt'); if_debug = [double(if_debug); fid]; 
    time_ = int32(clock); time_ = time_(4:6); fprintf(fid, "%i:%i:%i" + newline, time_(1), time_(2), time_(3));
else, if_debug = [0; 0]; end
check_bash = "__NOTBASH__"; % changed by the run.sh script
                            % when creating a file by using it
if if_sim, tic; end
%%  SETTING TUNABLE BASH PARAMETERS 
if if_RL_learn || if_sim
    using_bash = false; % true if using run.sh script
    if strcmp(check_bash,"BASH"), using_bash = true; end
    %W HEN USING BASH AUTOMATION
    if using_bash
        if contains(pwd,'with_RLscript')
	        cd .. % file in that case is read from ./with_RLscript directory
        end
        try
			openProject([pwd '\Msc.prj'])
        catch
            disp("Not opening project")
        end
        
		% agent creation
        agent_created_in = AGENTCREATE;
        if ~agent_created_in
            agent_load_name_in = "AGENTLOADNAME";
            agent_if_shuffle_nonetheless_in = false;
            slx_w1_in = W1;
            slx_w2_in = W2;
            slx_sample_time_in = SAMPLETIME;
        else
            agent_actor_net_size_in = ACTORNETSIZE;
            agent_critic_net_size_in = CRITICNETSIZE;
            agent_target_upd_freq_in = TARGETUPDATE;
            agent_critic_learning_rate_in = CRITICRATE;
            agent_actor_learning_rate_in = ACTORRATE;
            if ~if_DDPG
                agent_target_entropy_in = -ENTROPY;
                agent_critic_update_freq_in = CRITICUPDATE;
                agent_actor_update_freq_in = ACTORUPDATE;
            end
            slx_w1_in = W1;
            slx_w2_in = W2;
            slx_sample_time_in = SAMPLETIME;

        end
        agent_save_name_in = "AGENTSAVENAME";
        % training parameters
	    train_max_episodes_in = MAXEPISODES;
	    train_max_steps_per_episode_in = MAXSTEPSPEREP;
	    train_stop_training_value_in = STOPTRAINVALUE;

        if if_RL_repeat_env && ~if_RL_repeat_env_matlab, restart_python(); end
    end
    % WHEN NOT USING BASH
    if ~using_bash
        % agent creation

% 🢃 =============================================================================================== 🢃 
% when set to 1 new agent is created
        agent_created_in = 1;
% ⇧ =============================================================================================== ⇧ 

        if ~agent_created_in
% 🢃 =============================================================================================== 🢃 
% when loading an agent
            agent_load_name_in = "test.mat";
            agent_if_shuffle_nonetheless_in = 1; % whether to shuffle the of the random number 
                                                 % generator or used the loaded state

            slx_w1_in = 1;
            slx_w2_in = 0;
            slx_sample_time_in = 5;
% ⇧ =============================================================================================== ⇧ 
        else

% 🢃 =============================================================================================== 🢃 
% when craeating a new agent before training
            agent_actor_net_size_in = [ 512  ];
            agent_critic_net_size_in = [ 256 ];
            agent_target_upd_freq_in = 1;
            agent_critic_learning_rate_in = 0.001;
            agent_actor_learning_rate_in = 0.001;
            if ~if_DDPG
                agent_target_entropy_in = -2;
                agent_critic_update_freq_in = 1;
                agent_actor_update_freq_in = 1;
            end
            
            % when using RL_env.slx sample time should be the same as from
            % generate_init_params()
            % otherwise for each training step
            % n=slx_sample_time_in/generate_init_params().sim_dt
            % simulation steps will be conducted
            
%             slx_sample_time_in = generate_init_params().sim_dt;
            slx_sample_time_in = 0.1;

            slx_w1_in = 1;
            slx_w2_in = 0;
% ⇧ =============================================================================================== ⇧ 
        end

% 🢃 =============================================================================================== 🢃 
    if if_sim
        agent_save_name_in = "sim_100_" + base_agent_info;
    else
    % when training an agent
        agent_save_name_in = "test.mat";
    end
% ⇧ =============================================================================================== ⇧ 

% 🢃 =============================================================================================== 🢃 
% 'most often changed' training parameters
	    train_max_episodes_in = 2;
	    train_max_steps_per_episode_in = 200; %1000
	    train_stop_training_value_in = 1000000;
% ⇧ =============================================================================================== ⇧ 
    end

end

if if_RL_learn || if_sim
    temp_agent_name = char(agent_save_name_in);
end
%% saving simulation data management
if if_RL_repeat_env
    if if_save_txt
        fid=fopen(['data/wrapped_sim_out/sim_data_' temp_agent_name(1:end-3) 'txt'],'wt');
        slx_if_save = [double(if_save); double(if_save_txt); fid]; 
    else
        slx_if_save = [double(if_save); 0; 0]; 
    end
end
%%  ENVIRONMENT PARAMETERS 
if ~if_test_with_openAI && ~if_RL_repeat_env_matlab
% simulink file parameters 

% 🢃 =============================================================================================== 🢃 
    % -----  when using environments created from simulink file -------
    % normalization
    slx_if_input_normalization = 0;
    if slx_if_input_normalization
        slx_ObsMinimal = [-5  -5   -5     -pi-0.01 -pi-0.01  -pi-0.01]; 
        slx_ObsMaximal = [5   5   5       pi+0.01  pi+0.01   pi+0.01]; 
    end
% ⇧ =============================================================================================== ⇧

    slx_environment_ = "RL_env";
    slx_agent_block_ = slx_environment_ + "/controller";
    % sampling time of an agent
    slx_sample_time = slx_sample_time_in;
    slx_sample_time_for_con_enf = slx_sample_time;
    % reward calculation
    slx_w1 = slx_w1_in; slx_w2 = slx_w2_in;

    slx_act_number_dme = 2;
    % variables existing for 'legacy' reasons, constraints approximators
    % not implemented
    slx_use_external = false; % for constraint function approximator
    slx_if_not_constrain = true; % if true than no constraints applied
    slx_multiplier = 1;
    slx_min_t =  -slx_multiplier; slx_max_t = slx_multiplier;
   % read parameters from generate_init_params
    if if_extract_starting_conditions
        % to include a inital parameter assignment in info_ object add its name
        % as is in the initializing function. also add the created variable name as an argument
        % and to the parameters of the info_ object's class, rest should be
        % handled by this script
        init_find = ["roff","omega_x0","omega_y0","omega_z0","phi0","theta0","psi0","m_mass","umax", "sim_dt"];
        res_vec = extract_init_params('generate_init_params.m',init_find);
        init_variable_prefix = 'slx_init_';
        for i =1 : length(init_find), eval([init_variable_prefix char(init_find(i)) '="' char(erase(res_vec(i),char(13))) '";']), end
    else
        warning('===! My warning !===: Not extracting information about starting conditions')
    end
    % read parameters from simulink file (extracts data from currently saved)
    if if_extract_from_slx
        if ~ispc
                [cmd_status, cmdout] = system('./read_from_slx/read_from_slx.sh');
        else
                [cmd_status, cmdout] = system('cd read_from_slx && read_from_slx.bat');
        end
        if cmd_status==0, [slx_reward_str, slx_condition_str, slx_obs_str, slx_reward_in_mechanics] = ...
            read_from_slx_wrapper(cmdout);
        else, error('===! My error !===: Error in reading information from slx files'), end

    else
        warning('===! My warning !===: Not extracting information from slx files')
    end

else
    if if_test_with_openAI
    % needed for agent options
        slx_sample_time = 1;
    end

    if if_RL_repeat_env_matlab
% 🢃 =============================================================================================== 🢃 
% --- if using matlab environment wrapping simulink (if_RL_repeat_env_matlab = true) ---
        slx_if_input_normalization = 1;

        if slx_if_input_normalization
            slx_ObsMinimal = [-5  -5   -5     -pi-0.01 -pi-0.01  -pi-0.01]; 
            slx_ObsMaximal = [5   5   5       pi+0.01  pi+0.01   pi+0.01]; 
%  			slx_ObsMinimal = [-5 -5 -5  -deg2rad(90)-0.01 -deg2rad(90)-0.01 -deg2rad(180)-0.01 -0.05 -0.05];
%  			slx_ObsMaximal = [5 5 5 deg2rad(90)+0.01 deg2rad(90)+0.01 deg2rad(180)+0.01 0.05 0.05];
        end
% ⇧ =============================================================================================== ⇧

        slx_sample_time = slx_sample_time_in;
        slx_if_only_time = if_only_time;
        slx_w1 = slx_w1_in;
        slx_w2 = slx_w2_in;
        % agent action output range
        slx_min_t = -1;
        slx_max_t = 1;

        % calculations and data extraction
        if if_extract_starting_conditions
            % extracting initial parameters, just as in case of the
            % simulink environments
            init_find = ["roff","omega_x0","omega_y0","omega_z0","phi0","theta0","psi0","m_mass","umax", "sim_dt"];
            res_vec = extract_init_params('generate_init_params.m',init_find);
            init_variable_prefix = 'slx_init_';
            for i =1 : length(init_find), eval([init_variable_prefix char(init_find(i)) '="' char(erase(res_vec(i),char(13))) '";']), end
        else
            warning('===! Error !===: Extracting sim_dt from generate_init_params is mandatory!')
        end

        slx_how_many_steps_in_run = slx_sample_time/ double(regexp(slx_init_sim_dt,'\d.\d*','Match'));
        
        slx_how_many_steps_in_run = round(slx_how_many_steps_in_run*1e10)/1e10;

        if mod(slx_how_many_steps_in_run,1)~=0
            error('===! My error !===: Wrong sampling times, slx_how_many_steps_in_run should be an integer'), end

        % extracting reward calculation from simulink simulation wrapper
        slx_reward_wrap_file = slx_reward_from_wrap_file('simulink_model_wrap_matlab.m','reward =');
        slx_matlab_wrap_is_done = slx_reward_from_wrap_file('SimulinkRLWrapper.m','IsDone ='); 

        % multiplying
        if slx_if_input_normalization && if_multiply_obs
             slx_ObsMinimal = repmat(slx_ObsMinimal,1,slx_how_many_steps_in_run);
             slx_ObsMaximal = repmat(slx_ObsMaximal,1,slx_how_many_steps_in_run);
        end

        temp_agent_name = char(agent_save_name_in);
    end
end
%% AGENT OPTIONS
agent_created = agent_created_in;
if if_RL_learn || if_sim, agent_save_name = agent_save_name_in; end
% 🢃 =============================================================================================== 🢃 
% actions and observations
% if for each training steps several environment steps are simulated
% and the observations are concatenated, the 'single', 'non-concatenated'
% size from one environment step should be given
agent_obs_number = 6;
agent_act_number = 2;
% ⇧ =============================================================================================== ⇧
if if_RL_repeat_env, if if_multiply_obs, agent_obs_number = agent_obs_number * slx_how_many_steps_in_run; end, end


if agent_created

% 🢃 =============================================================================================== 🢃 
    % agent parameters not defined in the 'tunable bash parameters header'
    % structure properties
    agent_mini_batch_size = 64;                                                  % default = 64
    agent_experience_buffer_length = 2*1e4;                                         % default = 1e4;
    agent_if_reset_exp_buff_before_train = false;                                  % default = true
    agent_if_save_exp_buff_with_agent = true;                                       % default = false;
    % algorithm parameters
    agent_discount_factor = 0.99;                                                 % default = 0.99
    agent_target_smooth_factor = 5*1e-3;                                            % default = 1e-3;
    if if_DDPG
        agent_OU_mean_att_const = 0.15;                                           % default = 0.15
        agent_OU_mean = 0;                                                        % default = 0
        agent_OU_std = 0.2;                                                       % default = 0.3; 
    end
    %'hardware' options
    agent_use_device = "cpu";
% ⇧ =============================================================================================== ⇧

    % structure properties  
    agent_actor_net_size = agent_actor_net_size_in;
    agent_critic_net_size = agent_critic_net_size_in;                             % default symmetric = 256
    % algorithm parameters
    agent_sample_time_agent = slx_sample_time;                                    % default = 1
                                                                                  % Within a Simulink® environment, the agent gets executed every 
                                                                                  %                         SampleTime seconds of simulation time
    if ~if_DDPG, agent_target_entropy = agent_target_entropy_in; end              % deafult = -dim(A)
    agent_target_upd_freq = agent_target_upd_freq_in;                                                    % default = 1
    if ~if_DDPG, agent_critic_update_freq = agent_critic_update_freq_in;  end                               % default = 1
    if ~if_DDPG, agent_actor_update_freq = agent_actor_update_freq_in; end                                  % default = 1
    agent_actor_network_learn_rate = agent_actor_learning_rate_in;                % default = 0.01;
    agent_critic_network_learn_rate = agent_critic_learning_rate_in;
end
if ~agent_created
    agent_sample_time_agent = slx_sample_time;
    agent_load_name = agent_load_name_in;
    agent_if_shuffle_nonetheless = agent_if_shuffle_nonetheless_in;
end

%% TRAINING PARAMETERS 
if if_RL_learn 
   
% 🢃 =============================================================================================== 🢃 
    train_stop_criteria = 'AverageSteps';
    train_save_criteria = 'EpisodeReward';
    train_save_value = -50;
    train_averaging_window = 40;
    train_if_parallel = 0;
    train_if_verbose = 1;
% ⇧ =============================================================================================== ⇧

    train_max_episodes = train_max_episodes_in;
    train_max_steps_per_episode = train_max_steps_per_episode_in;
    train_stop_training_value = train_stop_training_value_in;
    train_save_path = string(temp_agent_name(1:end-4));
end
%% ENVIRONMENT CREATION
if ~if_test_with_openAI && ~ if_RL_repeat_env_matlab
    % 'fabricate' data nesecerry for the model to run if they are not used
    if slx_if_not_constrain, slx_constr_bound = 0; end
    if ~slx_if_input_normalization, slx_ObsMaximal = zeros(agent_obs_number,1);
        slx_ObsMinimal = zeros(agent_obs_number,1); end
    % create environment
    obsObj = rlNumericSpec([agent_obs_number 1]);
    actObj = rlNumericSpec([agent_act_number 1], "LowerLimit", -1, 'UpperLimit', 1);
    if if_RL_learn || if_sim, env = rlSimulinkEnv(slx_environment_,slx_agent_block_,obsObj,actObj); end
elseif if_test_with_openAI
    % create environment
    obsObj = rlNumericSpec([agent_obs_number 1]);
    actObj = rlNumericSpec([agent_act_number], "LowerLimit", -2, 'UpperLimit', 2);
    env = OpenAIWrapper(obsObj,actObj);
else %  if_RL_repeat_env_matlab
    obsObj = rlNumericSpec([agent_obs_number 1]);
    actObj = rlNumericSpec([agent_act_number 1], "LowerLimit", -1, 'UpperLimit',1);
    start_params = generate_init_params();
    params_struct = struct("how_many_steps_in_run", slx_how_many_steps_in_run, ...
        "physical_params", start_params, ...        
        "min_t",slx_min_t, ...
        "max_t",slx_max_t, ...
        "w1", slx_w1, "w2", slx_w2, ...
        "if_only_time", slx_if_only_time, ...
        "u_time_min", 0, ...
        "u_time_max", double(regexp(slx_init_sim_dt,'\d.\d*','Match'))*slx_how_many_steps_in_run, ...
        "dt_wrapped", double(regexp(slx_init_sim_dt,'\d.\d*','Match')), ...
        "if_input_normalization", slx_if_input_normalization, ...
        "if_save", slx_if_save);
        params_struct.multiply_obs = if_multiply_obs;
		params_struct.how_many_multiply = slx_how_many_steps_in_run; 
    if slx_if_input_normalization, params_struct.obs_min = slx_ObsMinimal';
        params_struct.obs_max = slx_ObsMaximal';end
    init_boundary_params = [start_params.w0',start_params.q0, start_params.u0, start_params.u0, 0]; % the last zero
                                                                               % stands for the third non-controlled
                                                                               % mass
    der_init_boundary_params = zeros(9,1);
    % create environment
    env = SimulinkRLWrapper(obsObj, actObj, init_boundary_params, der_init_boundary_params, params_struct);
end

% turn on fast restart in the simulink file if using wrapped environment
if if_RL_repeat_env_matlab, dme=load_system('dynamic_model_euler_copy.slx');
    set_param(dme,'FastRestart','on'); end

% default options to print to the console for an agent
print_options_default_agent_base = [...
        "SampleTime","DiscountFactor","TargetUpdateFrequency",...
        "TargetSmoothFactor",...
        "ExperienceBufferLength", "MiniBatchSize", "ResetExperienceBufferBeforeTraining", ...
        "SaveExperienceBufferWithAgent"];
print_options_default_agent_SAC = [print_options_default_agent_base "EntropyWeightOptions.TargetEntropy" "CriticUpdateFrequency" "PolicyUpdateFrequency" ];
print_options_default_agent_DDPG = [print_options_default_agent_base "NoiseOptions.Mean" "NoiseOptions.MeanAttractionConstant" "NoiseOptions.StandardDeviation"];
print_options_default_agent_2 = ["agent_obs_number", "agent_act_number", ...
        "agent_actor_net_size", "agent_critic_net_size", "agent_use_device",...
        "agent_actor_network_learn_rate","agent_critic_network_learn_rate"];
%% CLEAR INPUT VARIABLES
% script deletes from workspace variables ending with '_in'
clear_in
%%  DIARY ON
% start diary with the name of the agent save as the title
if if_RL_learn || if_sim, temp_agent_name = char(agent_save_name); end
if exist(['text_files/' temp_agent_name(1:end-3) 'txt'],'file') && ~strcmp(temp_agent_name,'test.mat')
    error(['===! My error !===: Diary with given name: ' temp_agent_name(1:end-3) 'txt  exists, ' ...
        'if you want you can overwrite ' char("'") 'test.txt' char("'")])
end
eval(['diary ' 'text_files/' temp_agent_name(1:end-3) 'txt']);
clear temp_agent_name
%%  AGENT CREATION 
if agent_created
	print_line(49,'=')

    rng shuffle
    disp("Shuffled the seed")
    
    % save rng_begin state
    rng_begin = rng;

    % 'base' default agent file
    if ~if_DDPG
        load_name = "./data/agentNetworks/defaultAgentNetworks5obs.mat";
    else
        load_name = "./data/agentNetworks/defaultDDPG64.mat";
    end

    if ~if_DDPG
         opts = rlSACAgentOptions("SampleTime", agent_sample_time_agent, 'DiscountFactor', agent_discount_factor, ...
        'TargetUpdateFrequency', agent_target_upd_freq, 'CriticUpdateFrequency', agent_critic_update_freq, ...
        'PolicyUpdateFrequency', agent_actor_update_freq, 'TargetSmoothFactor', agent_target_smooth_factor, ...
        'ExperienceBufferLength', agent_experience_buffer_length, 'MiniBatchSize', agent_mini_batch_size, ...
        'ResetExperienceBufferBeforeTraining', agent_if_reset_exp_buff_before_train,...
        'SaveExperienceBufferWithAgent', agent_if_save_exp_buff_with_agent);
        opts.EntropyWeightOptions.TargetEntropy = agent_target_entropy;
    else 
         opts = rlDDPGAgentOptions("SampleTime", agent_sample_time_agent, 'DiscountFactor', agent_discount_factor, ...
        'TargetUpdateFrequency', agent_target_upd_freq, 'TargetSmoothFactor', agent_target_smooth_factor, ...
        'ExperienceBufferLength', agent_experience_buffer_length, 'MiniBatchSize', agent_mini_batch_size, ...
        'ResetExperienceBufferBeforeTraining', agent_if_reset_exp_buff_before_train, ...
        'SaveExperienceBufferWithAgent', agent_if_save_exp_buff_with_agent);
        opts.NoiseOptions.Mean = agent_OU_mean;
        opts.NoiseOptions.MeanAttractionConstant = agent_OU_mean_att_const;
        opts.NoiseOptions.StandardDeviation = agent_OU_std;
    end

    % create data object with info about the agent and the necesseray
    % information about the environment, more added when training
    
    % which parameters to assign in the constructor
    params_to_save = ["agent_obs_number", "agent_act_number", ...
        "agent_actor_net_size", "agent_critic_net_size", "agent_use_device", ...
        "agent_actor_network_learn_rate", "agent_critic_network_learn_rate"];
    % get values of the parameters in a cell (using script to maintain
    % conbsistency throught the program)
    create_params_to_save_vals
    % create object with information
    info_ = modelAgentAndTrainingData(params_to_save,params_to_save_vals);

    % create the agent (prints info to the command window)
    agentObj = create_agent(load_name, opts, info_, obsObj, actObj, if_DDPG, 1);

    % print to command window
    if if_DDPG
        print_options = print_options_default_agent_DDPG;
    else
        print_options = print_options_default_agent_SAC;
    end
    disp(['Agent created ' repmat('-',1,36)]);
    print_agent_options(agentObj,print_options);
    print_opt = print_options_default_agent_2;
    print_line(50,'-')
    info_.print_chosen(print_opt,33,17);

end
%%  AGENT LOADING 
if ~agent_created
    if if_sim && if_load_saved_automatically
    agentObj = load(agent_load_name,'saved_agent').saved_agent;
    else
    load(agent_load_name,'agentObj')
    end
    %%%%%% print output to the console
    print_line(49,'=')
    disp("Agent " + agent_load_name + " read")
    print_line(50,'-')
    if if_DDPG
        print_options = print_options_default_agent_DDPG;
    else
        print_options = print_options_default_agent_SAC;
    end
    print_agent_options(agentObj,print_options);
    
    %%%%%% add agent_if_shuffle_nonetheless to the info_ in the agent .mat file
    variableInfo = who('-file', agent_load_name);
    if ismember('info_', variableInfo) 
        load(agent_load_name,'info_');
        info_.agent_if_shuffle_nonetheless = agent_if_shuffle_nonetheless;
        info_.agent_load_name = agent_load_name;
    %%%%% print data about the agent from info_
        print_opt = print_options_default_agent_2;
        print_line(50,'-')
        info_.print_chosen(print_opt,33,17);
    else
        warning('===! My warning !===: Agent file does not contain _info variable')
    end

    if agent_if_shuffle_nonetheless
        rng shuffle
        print_line(50,'-')
        disp("Shuffled the seed")
    else
        rng(load(agent_load_name,'rng_state').rng_state)
        print_line(50,'-')
        disp("Loaded the rng state")
    end
    
end
%% TRAINING RL AGENT 
if if_RL_learn
    if contains(pwd,'simulation_folder'), cd .., end
    
    if ~if_test_with_openAI && ~if_RL_repeat_env_matlab
        if slx_use_external == true
            error('===! My error !===: slx_use_external == true and you want to do RL learning')
        end
    
        %%%%% add environmmental and training parameters to the info_ object
        % which parameters to add
        params_to_save = ["slx_environment_", "slx_sample_time", "slx_sample_time_for_con_enf", ...
            "slx_if_input_normalization", "slx_if_not_constrain", ...
            "slx_multiplier", "slx_min_t", "slx_max_t", ...
            "train_max_episodes", "train_max_steps_per_episode", ... 
            "train_stop_training_value","train_stop_criteria", "train_if_parallel", ...
            "train_averaging_window", "train_save_criteria", "train_save_value", "train_save_path"];
        % add parameters if it makes sense to save them
        if slx_if_input_normalization, params_to_save(end+1:end+2) = ["slx_ObsMinimal", "slx_ObsMaximal"]; end
        if ~slx_if_not_constrain, params_to_save(end+1:end+5) = ["slx_constr_bound","slx_con_network_set_name", ...
            "slx_con_network_index", "slx_con_network_final_loss", "slx_con_network_final_RMSE"]; end
        if if_extract_from_slx, params_to_save(end+1:end+4) = ["slx_reward_str","slx_obs_str","slx_condition_str", "slx_reward_in_mechanics"]; end
        if if_RL_repeat_env, params_to_save(end+1:end+2) = ["slx_reward_wrap_file", "slx_how_many_steps_in_run"]; 
        else params_to_save(end+1:end+2)=["slx_w1", "slx_w2"]; end
        % add the name of initial parameters chosen at the begining of this
        % script - the script adds to params_to_save, uses init_variable_prefix
        % and init_find vector to create the parameters names
        % to preserve print formatting it should be added as last
        if if_extract_starting_conditions, add_init_params_to_vector, end
        % get values of the parameters in a cell (using script to maintain
        % conbsistency throught the program)
        create_params_to_save_vals  
    else
        params_to_save = ["train_max_episodes","train_max_steps_per_episode", "train_stop_training_value",...
            "train_if_parallel", "train_stop_criteria","train_averaging_window", "train_save_criteria", "train_save_value", "train_save_path"];
        if if_RL_repeat_env_matlab
            params_to_save(end+1:end+10) = [ "slx_reward_wrap_file", ...
            "slx_how_many_steps_in_run", "slx_sample_time", "slx_min_t","slx_max_t","slx_if_input_normalization", "slx_matlab_wrap_is_done", "slx_w1", "slx_w2", "slx_if_only_time"];
            if slx_if_input_normalization, params_to_save(end+1:end+2) = ["slx_ObsMinimal" "slx_ObsMaximal"]; end
        end
        
        if ~if_test_with_openAI
            % add the name of initial parameters chosen at the begining of this
            % script
            if if_extract_starting_conditions, add_init_params_to_vector, end
        end
        % get values of the parameters in a cell (using script to maintain
        % conbsistency throught the program)
        create_params_to_save_vals
    end
    info_ = info_.add(params_to_save,params_to_save_vals);

    % print to the console
    fprintf("Training "); print_line(42,'-')
    print_opt = params_to_save;
    % method print_chosen outputs to the console
    print_line(info_.print_chosen(print_opt, 33,17),'-');
    
    % go to simulation_folder
    cd simulation_folder
    
    %%%% training 
    [agentObj, trainingStats, ~, rng_state] = ...
        RL_learn(agentObj, env, info_, if_test_with_openAI, [if_RL_repeat_env if_RL_repeat_env_matlab], train_if_verbose);

    % step out of /simulation_folder/
    cd .. 

    % save results into the results directory
    cd with_RLscript
    save(agent_save_name,'trainingStats')
    save(agent_save_name,"agentObj",'-append')
    save(agent_save_name,"rng_state",'-append')
    save(agent_save_name,"info_",'-append')
    if exist('rng_begin','var'), save(agent_save_name,"rng_begin",'-append'), end
    cd ..

    % print to the console
    print_line(50,'-')
    fprintf("Agent saved as " + agent_save_name + "\n");
    print_line(49,'=')

    diary off
end
%% SIMULATE AGENT
if if_sim

    if if_RL_repeat_env && ~if_RL_repeat_env_matlab
        global_episode_counter = 1;
        env.ResetFcn = @(in)local_reset_fcn_repeat_env(in);
        train_max_steps_per_episode = 200;
    end

    if if_sim, toc, end

    if if_sim, tic; end
    SimulationResult = sim(agentObj,env,rlSimulationOptions("MaxSteps",1,"NumSimulations",100));
    if if_sim, toc, end

    diary off
end
%% CLOSE DEBUG AND?OR SAVE FILES
if if_debug(1) && if_RL_repeat_env, if_not_closed=fclose('all')
elseif if_RL_repeat_env_matlab
    if slx_if_save(2),  if_not_closed=fclose('all'), end
end
