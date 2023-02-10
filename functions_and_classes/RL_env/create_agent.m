function [agentObj] = create_agent(load_name, opts, info_, obsObj, actObj, if_DDPG, plot_figure)
    %%%%%% creating 'default' agent    
%     initOpts = rlAgentInitializationOptions('NumHiddenUnit',256);
%     opts = rlSACAgentOptions("SampleTime", sample_time_for_controller);
%     agentObj = rlSACAgent(obsObj,actObj, initOpts, opts);
   
    % options
    repOpts = rlRepresentationOptions('UseDevice',info_.agent_use_device);

    % networks
    load(load_name,'actorNet','criticNet1');
    if ~strcmp(class(actorNet),'nnet.cnn.LayerGraph')
        actorNetGraph = layerGraph(actorNet);
        criticNetGraph = layerGraph(criticNet1);
    else
        actorNetGraph = actorNet;
        criticNetGraph = criticNet1;
    end
    clearvars criticNet1 actorNet

    if ~if_DDPG
        % critics
        input_1_subst = featureInputLayer(info_.agent_obs_number,'Name','ObservationInput');
        input_2_subst = featureInputLayer(info_.agent_act_number,'Name','ActionInput');
        fc_1_subst = fullyConnectedLayer(info_.agent_critic_net_size,'Name','Fc1');
        fc_2_subst = fullyConnectedLayer(info_.agent_critic_net_size,'Name','Fc2');
        fc_body_subst = fullyConnectedLayer(info_.agent_critic_net_size,'Name', 'Body');
        criticNetGraph = replaceLayer(criticNetGraph,'input_1',[input_1_subst]);
        criticNetGraph = replaceLayer(criticNetGraph,'input_2',[input_2_subst]);
        criticNetGraph = replaceLayer(criticNetGraph,'fc_1',[fc_1_subst]);
        criticNetGraph = replaceLayer(criticNetGraph,'fc_2',[fc_2_subst]);
        criticNetGraph = replaceLayer(criticNetGraph,'fc_body',[fc_body_subst]);
        criticNetGraph = replaceLayer(criticNetGraph,'output',[fullyConnectedLayer(1)]);
        repOpts.LearnRate = info_.agent_critic_network_learn_rate;
        criticOne = rlQValueRepresentation((criticNetGraph),obsObj,actObj, ...
         'Observation',{'ObservationInput'}, 'Action',{'ActionInput'},repOpts);
        criticTwo = rlQValueRepresentation((criticNetGraph),obsObj,actObj,...
          'Observation',{'ObservationInput'}, 'Action',{'ActionInput'},repOpts);
        
        % actor
        input_subst = featureInputLayer(info_.agent_obs_number,'Name','ActorInput');
        fc_1_subst = fullyConnectedLayer(info_.agent_actor_net_size,'Name','Fc1');
        fc_body_subst = fullyConnectedLayer(info_.agent_actor_net_size,'Name', 'Body');
        fc_mean_subst = fullyConnectedLayer(info_.agent_act_number, 'Name', 'MeanLay');
        fc_std_subst = fullyConnectedLayer(info_.agent_act_number,'Name','StdLay');
        actorNetGraph = replaceLayer(actorNetGraph,'input_1',[input_subst]);
        actorNetGraph = replaceLayer(actorNetGraph,'fc_1',[fc_1_subst]);
        actorNetGraph = replaceLayer(actorNetGraph,'fc_body',[fc_body_subst]);
        actorNetGraph = replaceLayer(actorNetGraph,'fc_mean',[fc_mean_subst]);
        actorNetGraph = replaceLayer(actorNetGraph,'fc_std',[fc_std_subst]);
        repOpts.LearnRate = info_.agent_actor_network_learn_rate;
        actor = rlStochasticActorRepresentation((actorNetGraph),obsObj,actObj, ...
         'Observation', {'ActorInput'}, repOpts);
    
        % agent
        agentObj = rlSACAgent(actor,[criticOne criticTwo], opts); 
    else

        % actor
        input_subst = featureInputLayer(info_.agent_obs_number,'Name','ActorInput');
        fc_1_subst = fullyConnectedLayer(info_.agent_actor_net_size(1),'Name','Fc1');
        fc_2 = fullyConnectedLayer(info_.agent_actor_net_size(2),'Name','Fc2');
        fc_body_subst = fullyConnectedLayer(info_.agent_actor_net_size(3),'Name', 'Body');
        out_subst = fullyConnectedLayer(info_.agent_act_number, 'Name', 'Outputs');
        actorNetGraph = replaceLayer(actorNetGraph,'input_1',[input_subst]);
        actorNetGraph = replaceLayer(actorNetGraph,'fc_1',[fc_1_subst reluLayer fc_2]);
        actorNetGraph = replaceLayer(actorNetGraph,'fc_body',[fc_body_subst]);
        actorNetGraph = replaceLayer(actorNetGraph,'output',[out_subst]);
        
        repOpts.LearnRate = info_.agent_actor_network_learn_rate;
        actor = rlDeterministicActorRepresentation((actorNetGraph),obsObj,actObj, ...
         'Observation', {'ActorInput'},'Action',{'scale'}, repOpts);

        % critic  
        
        input1_subst = featureInputLayer(info_.agent_obs_number,'Name','ObservationInput');
        input2_subst = featureInputLayer(info_.agent_act_number, 'Name', 'ActionInput');
        criticNetGraph = replaceLayer(criticNetGraph, 'input_1',[input1_subst]);
        criticNetGraph = replaceLayer(criticNetGraph, 'input_2',[input2_subst]);
        fc_1_subst = fullyConnectedLayer(info_.agent_critic_net_size(1),'Name','Fc1');
        fc_2 = fullyConnectedLayer(info_.agent_critic_net_size(2),'Name','Fc2');
        criticNetGraph = replaceLayer(criticNetGraph, 'relu_body', [reluLayer('Name','relu') fc_2 reluLayer("Name",'relu_body')]);
        criticNetGraph = replaceLayer(criticNetGraph, 'fc_1', [fc_1_subst]);
        fc_1_subst.Name = 'Fc1_2';
        criticNetGraph = replaceLayer(criticNetGraph, 'fc_2', [fc_1_subst]);
        fc_body_subst = fullyConnectedLayer(info_.agent_critic_net_size(3),'Name', 'Body');
        out_subst = fullyConnectedLayer(1, 'Name', 'Output');
        criticNetGraph = replaceLayer(criticNetGraph,'fc_body',[fc_body_subst]);
        criticNetGraph = replaceLayer(criticNetGraph,'output',[out_subst]);

        repOpts.LearnRate = info_.agent_critic_network_learn_rate;
        critic = rlQValueRepresentation((criticNetGraph),obsObj,actObj, ...
         'Observation', {'ObservationInput'},'Action',{'ActionInput'}, repOpts);
      
        agentObj = rlDDPGAgent(actor, critic, opts);
    end

    if plot_figure
        figure; subplot(1,2,1); plot(actorNetGraph); subplot(1,2,2); plot(criticNetGraph);
    end

  
end