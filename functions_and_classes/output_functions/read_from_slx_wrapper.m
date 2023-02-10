function [reward_str, condition_str, obs_str, rew_str] = read_from_slx_wrapper(cmdout)
     split_ = strsplit(cmdout,newline);
     
     ind_r = find(strcmp(split_,char("'=====Reward:====="))) + 1;
     reward = strsplit(split_{ind_r},'xml:');
     reward = reward{2};
     ind_r_dwukropek = strfind(reward,':');
     reward_str = string(reward(ind_r_dwukropek+1:end));

     ind_condition = find(strcmp(split_,char("'=====Stop condition:====="))) + 1;
     condition = strsplit(split_{ind_condition},'xml:');
     condition = condition{2};
     ind_condition_dwukropek = strfind(condition,':');
     condition_str = condition(ind_condition_dwukropek+1:end);
     condition_str = string(strrep(condition_str,'&gt;','>'));

     ind_obs = find(contains(split_,' Name="ObservationSelector"')) + 1;
     obs = strsplit(split_{ind_obs}, 'Name=');
     obs = strsplit(obs{2},'>');
     obs = strsplit(obs{2},'<');
     obs_str = string(obs{1});

     ind_rew = find(contains(split_,' Name="RewardSelector"')) + 1;
     rew = strsplit(split_{ind_rew}, 'Name=');
     rew = strsplit(rew{2},'>');
     rew = strsplit(rew{2},'<');
     rew_str = string(rew{1});

end