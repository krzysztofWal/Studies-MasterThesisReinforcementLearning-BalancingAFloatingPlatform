function [agentObj, info_, rng_state, trainingStats] = print_saved_agent_and_info(file_,sac_ddpg)
    agentObj = load(file_,'agentObj').agentObj; 
    info_ = load(file_, 'info_').info_;
    rng_state = load(file_,'rng_state').rng_state;
    trainingStats = load(file_,'trainingStats').trainingStats;

    print_options_default_agent = [...
        "SampleTime","DiscountFactor","TargetUpdateFrequency",...
        "TargetSmoothFactor",...
        "ExperienceBufferLength", "MiniBatchSize", "ResetExperienceBufferBeforeTraining", ...
        "SaveExperienceBufferWithAgent"];
    if strcmp(sac_ddpg, 'sac')
        print_options_default_agent = [print_options_default_agent "EntropyWeightOptions.TargetEntropy" "CriticUpdateFrequency" "PolicyUpdateFrequency" ];
    end
    if strcmp(sac_ddpg, 'ddpg')
        print_options_default_agent = [print_options_default_agent "NoiseOptions.Mean" "NoiseOptions.MeanAttractionConstant" "NoiseOptions.StandardDeviation"];
    end
    

    print_agent_options(agentObj,print_options_default_agent);
    info_.print_chosen(info_.create_filled_params_string, 33, 17);

end