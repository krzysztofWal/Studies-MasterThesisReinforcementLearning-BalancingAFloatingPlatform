function [exp_wr_arr] = concatenate_sim_outs(destination, filename, what_take_as_no_initial_param, number_per_episode)

    %%% ASSUMING THAT THE SIMULATION OUTPUT IS LARGER THAN what_take_as_no_initial_param

    full_name = string(destination) + string(filename) +".mat";
    variableInfo = who('-file', full_name);
    if mod((length(variableInfo)/number_per_episode),1)~=0, error("Wrong number of simulations per episode"); end
    for i = 1 : length(variableInfo)
        split_ = strsplit(string(strrep(variableInfo{i,1},'var','')),'_');
        variableInfo{i,2} = double(string(split_{1}));
        variableInfo{i,3} = double(string(split_{2}));
    end 
    variableInfo = sortrows(variableInfo,[2 3]);

    % get properties list
    exp_wr = exportWrap3D(load(full_name,variableInfo{1,1}).(variableInfo{1,1}));
    properties_of_exp_wr = properties(exp_wr);

    prop_list = string.empty(); % list of the parameters to copy
    for j = 1 : length(properties_of_exp_wr) % iterate through names of properties
        prop = properties_of_exp_wr{j};
        % if property value is not an initial parameter (look at the beginning)
        % any of the dimensions is big enough
        if size(exp_wr.(prop),1) > what_take_as_no_initial_param || ...
          size(exp_wr.(prop),2) > what_take_as_no_initial_param || ...
          size(exp_wr.(prop),3) > what_take_as_no_initial_param
            prop_list(end+1) = string(prop);
        end
    end

    exp_wr_arr = exportWrap3D.empty();

    for iter = 1 : (length(variableInfo)/number_per_episode)
        %first in an episode
        exp_wr = exportWrap3D(load(full_name,variableInfo{(iter-1)*number_per_episode+1,1}). ...
            (variableInfo{(iter-1)*number_per_episode+1,1}));

        % add data in the rest of the files
        if (number_per_episode) > 1
    %%%%%%%%%%%%%%%%%%%%% take the last action row from exp_wr, it does not contribute to
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% anything
            exp_wr = exp_wr.set('u',exp_wr.u(1:end-1,:));
            % add next
            for i = (iter-1)*number_per_episode+2 : iter*number_per_episode
                exp_wr_temp = exportWrap3D(load(full_name,variableInfo{i,1}).(variableInfo{i,1}));
                for j = 1 : length(prop_list)
                    curr_field = exp_wr_temp.(prop_list(j));
                    if size(curr_field,3) == 1 % not a 3d array
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% if it isa an action take it without the last
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% row, unless it is the last run
                        if strcmp(prop_list(j),'u') 
                            if i ~= (length(variableInfo)/number_per_episode), curr_field = curr_field(1:end-1,:); end
                        else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% otherwise do not take the first row
                            curr_field = curr_field(2:end,:);
                        end
                        exp_wr = exp_wr.set(prop_list(j),[exp_wr.(prop_list(j)); curr_field]); 
                    else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   do not take the first samples (in case of 3D matrices)
                        curr_field = curr_field(:,:,2:end);
                        exp_wr = exp_wr.set(prop_list(j),cat(3,exp_wr.(prop_list(j)), curr_field));
                    end
                end
            end
        end
        exp_wr_arr = [exp_wr_arr; exp_wr];
    end
end