classdef SimulinkRLWrapper < rl.env.MATLABEnvironment 
    properties
        init_params
        der_init_params
        cnt = 0;
        episode_cnt = 0;
        episode_roff = [0;0;0];

        % unchangeble
% %         how_many_steps_in_run
% %         agent_obs_number
% %         physical_params
% %         min_t
% %         max_t
% %         u_time_min - for using map_m in actions
% %         u_time_max
% %         dt_wrapped
% %         w1 w2
% %         if_input_normalization (obs_min, obs_max,  multiply_obs, how_many_multiply)
% %         if_save


        params_struct
        episode_rew_buff = [];
       
    end
    methods
        function this = SimulinkRLWrapper(obsObj,actObj,init_params, der_init_params, params_struct)
            
            % Initialize Observation settings
            ObservationInfo = obsObj;
            ObservationInfo.Name = 'DMEObservations';
            ObservationInfo.Description = '';
            
            % Continous Action Specification
            ActionInfo = actObj; 
            ActionInfo.Name = 'DMEActions';
            
            % The following line implements built-in functions of RL env
            this = this@rl.env.MATLABEnvironment(ObservationInfo,ActionInfo);

            this.init_params = init_params;
            this.der_init_params = der_init_params;
                
            this.params_struct = params_struct;
      end
    
        % Apply system dynamics and simulate the environment with the 
        % given action for one step.
        function [Observation,Reward,IsDone,LoggedSignals] = step(this,action)


            if this.params_struct.if_only_time
                % map from agent to environmental ranges
                action_time = map_m(double(action),repmat(this.params_struct.min_t,2,1), ...
                    repmat(this.params_struct.max_t,2,1), ...
                    repmat(-this.params_struct.u_time_max,2,1), ...
                    repmat(this.params_struct.u_time_max,2,1));
                % round time action to the closest multiple of dt_wrapped
                action_time = round(round(action_time*10^(-(order(this.params_struct.dt_wrapped))-1) ...
                    / this.params_struct.dt_wrapped)/(10^-(order(this.params_struct.dt_wrapped)+1))) ...
                    * this.params_struct.dt_wrapped;

                action_into = [action_time];
            else
                action_vel = double(action(1:2));
                action_time = double(action(3:4));
                % map from agent to environmental ranges
                action_vel = map_m(action_vel, repmat(this.params_struct.min_t,2,1), ...
                    repmat(this.params_struct.max_t,2,1), ...
                    repmat(-this.params_struct.physical_params.umax,2,1), ...
                    repmat(this.params_struct.physical_params.umax,2,1));
        
                action_time = map_m(action_time, repmat(this.params_struct.min_t,2,1), ...
                    repmat(this.params_struct.max_t,2,1), ...
                    repmat(this.params_struct.u_time_min,2,1), ...
                    repmat(this.params_struct.u_time_max,2,1));
        
                % round time action to the closest multiple of dt_wrapped
                action_time = round(round(action_time*10^(-(order(this.params_struct.dt_wrapped))-1) ...
                    / this.params_struct.dt_wrapped)/(10^-(order(this.params_struct.dt_wrapped)+1))) ...
                    * this.params_struct.dt_wrapped;

                action_into = [action_vel ; action_time];
            end

            w0 = this.init_params(1:3)'; q0 = this.init_params(4:7); u0 = this.init_params(8:10)';
            der0 = this.der_init_params;
            
            % simulate n=how_many_steps_in_run step of the environmenrt
            [reward, observations, w, q, u, der] = ...
                simulink_model_wrap_matlab(this.params_struct.if_only_time, ...
                action_into, w0, q0, u0, this.episode_roff , ...
                this.params_struct.w1, this.params_struct.w2, ...
                this.params_struct.how_many_steps_in_run, der0, ...
                this.params_struct.if_save);
            

            % save new boundary conditions 
            this.init_params = [w q u];
            this.der_init_params = der;
          
            % collect results
            if this.params_struct.if_input_normalization
                observations = map_m(observations,  ...
                    this.params_struct.obs_min, this.params_struct.obs_max, ...
                    -1*ones(size(observations)), ones(size(observations)) );
            end

            Observation = observations;
            Reward = reward;
            IsDone= false;
%             if abs(reward) < 0.003, IsDone = true; end;
  
            LoggedSignals = [];

            this.cnt = this.cnt + 1;
        end
        
        % Reset environment to initial state and output initial observation
        function InitialObservation = reset(this)

            start_params = generate_init_params();
            this.init_params = [start_params.w0',start_params.q0, start_params.u0, start_params.u0, 0];
            
            if this.episode_cnt == 0, disp("In the 'old' not 'steps-are-eps' code"), end
            
            % 'restart' environmebt

            %this.init_params = zeros(1,10);
            this.der_init_params = zeros(1,9);
            [rotx, roty ,rotz] = quat2angle(start_params.q0,'XYZ');
            
            if this.params_struct.multiply_obs
                InitialObservation = repmat([start_params.w0' rotx roty rotz]', ...
                this.params_struct.how_many_multiply,1); 
            else
                InitialObservation = [start_params.w0' rotx roty rotz 0 0]';
                % two zeroes at the end if final position of u1 and u2 is
                % included in the observation
            end
        
            if this.params_struct.if_input_normalization
                InitialObservation = map_m(InitialObservation,  ...
                    this.params_struct.obs_min, this.params_struct.obs_max, ...
                    -1*ones(size(InitialObservation)), ones(size(InitialObservation)) );
            end
            
            this.episode_cnt = this.episode_cnt + 1;
            this.cnt = 0;
            this.episode_roff = start_params.roff;
        end

    end

    
end