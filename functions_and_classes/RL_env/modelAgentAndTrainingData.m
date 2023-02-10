classdef modelAgentAndTrainingData
    properties
         %%% ======= AGENT ===========
        agent_obs_number = [];
        agent_act_number = [];
        agent_actor_net_size = [];
        agent_critic_net_size = [];
        agent_use_device = [];
        agent_actor_network_learn_rate = [];
        agent_critic_network_learn_rate = [];
        % when loaded
        agent_if_shuffle_nonetheless = [];
        agent_load_name
        
        %%% ======== MODEL ============
        slx_environment_
        slx_sample_time = [];
        slx_sample_time_for_con_enf = [];
        slx_w1 = [];
        slx_w2 = [];
        slx_if_only_time = [];
        slx_if_input_normalization = [];
        slx_if_not_constrain = [];
        slx_constr_bound = [];
        slx_multiplier = [];
        slx_min_t = [];
        slx_max_t = [];
        slx_how_many_steps_in_run
        slx_reward_str
        slx_reward_wrap_file
        slx_reward_in_mechanics
        slx_condition_str
        slx_matlab_wrap_is_done
        slx_obs_str
        % init params
        slx_init_sim_dt
        slx_init_roff
        slx_init_omega_x0
        slx_init_omega_y0
        slx_init_omega_z0
        slx_init_phi0
        slx_init_theta0
        slx_init_psi0
        slx_init_m_mass
        slx_init_umax
        %%% ======= USED CONSTRAINT NETWORK  (if used) ======
        slx_con_network_set_name
        slx_con_network_index
        slx_con_network_final_RMSE
        slx_con_network_final_loss
       
        %%% ======= TRAINING ========
        train_max_episodes = [];
        train_max_steps_per_episode = [];
        train_stop_training_value = [];
        train_stop_criteria = [];
        train_if_parallel = [];
        train_averaging_window
        train_save_criteria
        train_save_value
        train_save_path
        % if using openAI environment
        openAIenv
        
        % for formatting purpouses
        slx_ObsMinimal = [];
        slx_ObsMaximal = [];
    end

    methods

        function this = modelAgentAndTrainingData(properties_vec, values_vec)
            if nargin == 2
                this = this.add(properties_vec,values_vec);
            end
        end
    
        function obj = add(obj, properties_vec, values_vec)
            if length(properties_vec) ~= length(values_vec)
                error('===! My error !===: Input vectors have different lengths')
            end
            for i = 1 : length(properties_vec)
                branch_ = isstring(values_vec{i}); % is parameter value a string
                if ~branch_
                    name_picked_field = "values_vec{" + i + "}"; 
                    eval(['size_ = size(' char(name_picked_field) ');']);
                    exec_char = ['obj.' char(string(properties_vec(i))) '=' char(array_to_str_with_names(size_,name_picked_field)) ';'];
                else % if the parameter values is a string
                    exec_char = ['obj.' char(string(properties_vec(i))) '="' char(string(values_vec{i})) '";'];
                end
%                  disp(exec_char);
                eval(exec_char);
            end
        end

        function width_ = print_chosen(obj, properties_vec, width1, width2)
            formatter = java.util.Formatter();
            for i = 1 : length(properties_vec)
                eval(['formatter = formatter.format(java.lang.String("%-' char(string(width1)) 's"),java.lang.String("' char(properties_vec(i)) '"));']);
                eval(['val=obj.' char(properties_vec(i)) ';']);
                string_temp = "%" + string(width2) + "s\n";
                if length(char(array_to_str(val,1))) > width2, string_temp="%"+string(140-33)+"s\n"; width2 = 140-33; end%formatter.format(java.lang.String("%s"),java.lang.String("\n\t")); end
                if isstring(val) && ~isempty(size(strfind(char(val),'%'),1)), val = string(strrep(char(val),'%',"#")); end
                formatter = formatter.format(java.lang.String(string_temp),java.lang.String(array_to_str(val,1)));
            end
            fprintf(string(formatter))
            width_ = width1 + width2;
        end

        function [res_string] = create_filled_params_string(obj)
            prop_cell = properties(obj);
            prop_list = py.list(prop_cell');
            for i = 1 : length(prop_cell)
                if isempty(obj.(prop_cell{i}))
                    prop_list.remove(prop_cell{i})
%                     fprintf("%s\n",prop_cell{i})
                end
            end
            res_string = string(cell(prop_list));
        end

    end
end