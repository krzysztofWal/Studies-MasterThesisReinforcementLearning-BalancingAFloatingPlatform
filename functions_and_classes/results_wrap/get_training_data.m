function [] = get_training_data(name_string_vec, average_len, ifsave, ifmerge, if_turn_on_multiple_plot, size_first, save_name, multiple_plot, range, char_vec, what_to_plot,margin_in, ...
    legend_in, size_in, xlabel_in, ylabel_in, multiple_legend_location)

% all string inputs should be string objects - "" not ''
a_fig = []

    if true % so it can fold nicely
        save_name = char(save_name);
    
        if strcmp(pwd,'/home/krzysztof/Documents/GitHub/my-MSc-Wal/Models') && ifsave && ~isempty(save_name)
            system([' [! -e ./temp_figures/temp_scripts/' save_name '.m ] || rm ./temp_figures/temp_scripts/' save_name '.m']);
            save_string = string(HxSearch('get_training_data','',1));
            save_string = "(echo '" + save_string + "' && cat ./get_training_data.m ) >> ./temp_figures/temp_scripts/" +  save_name + ".m";
            [~, ~] = system(save_string);
        end

        if strcmp(pwd,'C:\Users\Randomowa Nazwa\Documents\LinuxWorkspace\my-MSc-Wal\Models') && ifsave && ~isempty(save_name)
            system_string = [' [! -e ./temp_figures/temp_scripts/' save_name '.m ] || rm ./temp_figures/temp_scripts/' save_name '.m'];
            wrap1 = 'start "" "%ProgramFiles%\Git\git-bash.exe" -c " ';
            wrap2 = ' && /usr/bin/bash --login -i"';
            system([wrap1 system_string wrap2]);
            save_string = string(HxSearch('get_training_data','',1));
            save_string = "(echo '" + save_string + "' && cat ./get_training_data.m ) >> ./temp_figures/temp_scripts/" +  save_name + ".m";
            [~, ~] = system([wrap1 char(save_string) wrap2]);
        end
    
    % name_string = [ "data_10_08_pendulum_classic_SAC_2.mat"
    %     ];
    % name_string = ["data_8june_agent_workspace.mat"
    %     "data_9june_agent_workspace1.mat"
    %     "data_9june_agent_workspace2.mat"];
        if ~isempty(multiple_plot)
            
            if length(multiple_plot) > 1
                multiple_plot_concat = [];
                for k = 1 : length(multiple_plot)
                    temp_number = multiple_plot{k};
                    for j = 1 :length(temp_number)
                        multiple_plot_concat(end+1) = temp_number(j);
                    end
                end
            else
                multiple_plot_concat = multiple_plot;
            end
            multiple_plot_data = cell.empty([length(multiple_plot) 0]);
            cnt = 1;
        
            subplots_ = true;
            temp_char = char_vec(1);
            if length(char_vec) > 1
                for j = 2 : length(char_vec)
                    if ~strcmp(char_vec(j),temp_char), subplots_ = false; break, end
                end
            end
        end
    
        if if_turn_on_multiple_plot
            for iter_1 = 1 : length(name_string_vec)
                name_string = name_string_vec(iter_1);
                [multiple_plot_data, cnt ] = body_block(name_string, ifmerge, multiple_plot, average_len, multiple_plot_concat, ifsave, cnt, multiple_plot_data, iter_1,size_first, save_name);
            end
        else
             name_string = name_string_vec;%(iter);
            [multiple_plot_data, ~ ] = body_block(name_string, ifmerge, multiple_plot, average_len, '', ifsave, '','','',size_first, save_name);
        end
        
        if ~isempty(multiple_plot)
            a=[];one_dim=1;
            if subplots_, two_dim = length(char_vec); axes_mem = []; else, two_dim = 1; end
            my_figure
            if ~subplots_, nexttile,legend_str = string.empty;  max_ = []; min_ = []; end
           
            for m = 1 : length(multiple_plot)
                if subplots_, nexttile, legend_str = string.empty;  max_ = []; min_ = []; end
                temp_number = multiple_plot{m};
                
                for j = 1 : length(temp_number)
                    index = find_(multiple_plot_data, temp_number(j));
                    data_ = multiple_plot_data{index};
                    data_to_plot = data_{1}; % chose data not index
                    data_to_plot_with_what = data_to_plot.(what_to_plot{m});
                    if isequal(class(range),"string")
                        string_range = regexp(range,'\d+\.?\d*','match');
                        first_range = int32(double(string(string_range{1})));
                        if length(string_range) == 1
                            last_range = max(size(data_to_plot_with_what));
                        else
                            last_range = int32(double(string_range{2}));
                        end
                    else
                        first_range = range(1);
                        last_range = range(end);
                    end
                    max_(end+1) = max(data_to_plot_with_what(first_range:last_range))
                    min_(end+1) = min(data_to_plot_with_what(first_range:last_range))

                    % here plotting happens
                    plot(first_range:last_range,data_to_plot_with_what(first_range:last_range),char_vec(m)), hold on

                    legend_str(end+1) = data_{3} + "_";
                end
                if subplots_
                    legend_str_2 = "(";
                    for k = 1 : length(legend_str), legend_str_2=legend_str_2+""""+legend_str(k)+""""+","; end
                    temp_legend_str = char(legend_str_2);
                    legend_str_2 = string(temp_legend_str(1:end-1)) + ")";
                    if isempty(legend_in)
                        eval(['legend' char(legend_str_2)])
                    else
                        legend(legend_in{m})
                    end
                    temp_lab = xlabel_in{m};
                    xlabel(temp_lab(1))
                    temp_lab = ylabel_in{m};
                    ylabel(temp_lab(1))
                     ylim([ min(min_); max(max_) + abs(margin_in*abs(max(max_)-min(min_)))]);
                end
            end
            if ~subplots_
                legend_str_2 = "(";
                for k = 1 : length(legend_str), legend_str_2=legend_str_2+""""+legend_str(k)+""""+","; end
                temp_legend_str = char(legend_str_2);
                legend_str_2 = string(temp_legend_str(1:end-1)) + ")";
                if isempty(legend_in)
                    eval(['legend' char(legend_str_2)])  
                else 
                    legend(legend_in,'Location',multiple_legend_location)
                end
                
                temp_lab = xlabel_in{1};
                xlabel(temp_lab(1))
                temp_lab = ylabel_in{1};
                ylabel(temp_lab(1))
                ylim([ min(min_); max(max_) + abs(margin_in*abs(max(max_)-min(min_)))]);
                xlim tight;


            end
            position = [];
            if ~isempty(size_in)
                new_figure_pos = [0 0 size_in(1) size_in(2)];
            end
            figure_var_called_new_figure_pos
            sgtitle(' ')
            if ifsave && ~isempty(save_name)
                saveas(gcf, "./temp_figures/"+string(save_name)+".png")
                saveas(gcf, "./temp_figures/"+string(save_name)+".fig")
            end
        end
    end

    function [index] = find_(multiple_plot_data, iter_in)
    for iter_ = 1 : length(multiple_plot_data)
        temp_ = multiple_plot_data{iter_};
        if iter_in == temp_{2}
            index = iter_;
            break
        end
    end
end

    function [multiple_plot_data, cnt ] = body_block(name_string, ifmerge, multiple_plot, average_len, multiple_plot_concat, ifsave, cnt, multiple_plot_data, iter, size_first, save_name) 
    % programmer was crying when doing this but also did not really care at the
    % same time
        temp_strct = 0;
        trainingStats = 0;
        % combine
        for i = 1 : length(name_string)
            if i == 1,eval( ['trainingStats = load("' char(name_string(i)) ...
                    '","trainingStats").trainingStats;']);
                    len_=length(trainingStats.TimeStamp);
                    % if data was saved in newer version Matlab (online) as a
                    % object not struct
                    if strcmp(class(trainingStats),'rl.train.rlTrainingResult')
                        trainingStats_struct = ...
                            struct('EpisodeIndex',trainingStats.EpisodeIndex, ...
                                'EpisodeReward', trainingStats.EpisodeReward, ...
                                'EpisodeSteps', trainingStats.EpisodeSteps, ...
                                'AverageReward',trainingStats.AverageReward, ...
                                'TotalAgentSteps', trainingStats.TotalAgentSteps, ...
                                'AverageSteps', trainingStats.AverageSteps, ...
                                'EpisodeQ0', trainingStats.EpisodeQ0, ...
                                'SimulationInfo', trainingStats.SimulationInfo, ...
                                'TrainingOptions', trainingStats.TrainingOptions, ...
                                'TimeStamp', trainingStats.TimeStamp);
                        trainingStats = trainingStats_struct;
                        if ifmerge
                            split_ = strsplit(name_string(i),'.');
                            save(strcat(split_{1},'_struct.mat'),"trainingStats",'-mat')
                        end
    
                    end
            else
                eval(['temp_strct = load("' char(name_string(i)) ...
                    '","trainingStats").trainingStats;']);
                len = length(temp_strct.TimeStamp);
    
        %         len_*(i-1)+1
        %         len_*(i-1)+len
                trainingStats.TimeStamp(len_+1:len_+len) =          temp_strct.TimeStamp;
                trainingStats.EpisodeIndex(len_+1:len_+len) =       temp_strct.EpisodeIndex;
                trainingStats.EpisodeReward(len_+1:len_+len) =      temp_strct.EpisodeReward;
                trainingStats.EpisodeSteps(len_+1:len_+len) =       temp_strct.EpisodeSteps;
                trainingStats.AverageReward(len_+1:len_+len) =      temp_strct.AverageReward;
                trainingStats.AverageSteps(len_+1:len_+len) =       temp_strct.AverageSteps;
                trainingStats.TotalAgentSteps(len_+1:len_+len) =    temp_strct.TotalAgentSteps;
                trainingStats.EpisodeQ0(len_+1:len_+len) =          temp_strct.EpisodeQ0;
                trainingStats.SimulationInfo(len_+1:len_+len) =     temp_strct.SimulationInfo;
                len_=len_+len; 
            end
        end
        
        % plot
        title_ = strrep(name_string,"_","\_");
        
        import java.text.SimpleDateFormat
        import java.lang.String
        import java.util.Calendar.*
        import java.text.DateFormat
        dateFormat = SimpleDateFormat(String("HH:mm:ss"));
        reference = dateFormat.parse("00:00:00");
        
        times_ = zeros(1,length(trainingStats.TimeStamp));
        previous_ = 0;
        last_add_ = 0;
        for i = 1 : length(trainingStats.AverageReward)
            date = dateFormat.parse(String(trainingStats.TimeStamp(i)));
            times_temp_ =  (date.getTime() - reference.getTime())/1000/60;
            if times_temp_ < previous_
                 last_add_ = last_add_ + previous_;
             end
            times_(i) = times_temp_;
            previous_ = times_temp_;
        end
    
        if isempty(multiple_plot) 
             normal_plot(trainingStats, ifsave, save_name, size_first, name_string, average_len, dateFormat, reference, times_, last_add_, title_)
        end
    
        temp_str = name_string(end);
    
        % create merge file
        if ifmerge && length(name_string) > 1 
            temp_str = name_string(end);
            spl_str = strsplit(temp_str,"_");
            temp_name = "";
            for i = 1 : length(spl_str) - 2
                temp_name = temp_name + spl_str(i) + "_"; 
            end
            temp_name = temp_name + "sum.mat";
            cd ./with_RLscript/
            agentObj = load(name_string(end),'agentObj').agentObj;
            rng_state = load(name_string(end), 'rng_state').rng_state;
            save(temp_name,'trainingStats')
            save(temp_name,"agentObj",'-append')
            save(temp_name,"rng_state",'-append')
            cd ..
        end
    
        % multiple plot add data
        if ~isempty(multiple_plot)
            if sum(find(iter == multiple_plot_concat)) ~= 0 
                multiple_plot_data{cnt} = {trainingStats, iter, temp_str};
                cnt = cnt+1;
            end
        end
    end

    function [] =  normal_plot(trainingStats, ifsave, save_name, size_first, name_string, average_len, dateFormat, reference, times_, last_add_, title_)
        import java.text.SimpleDateFormat
        import java.lang.String
        import java.util.Calendar.*
        import java.text.DateFormat

        figure
        a_ = tiledlayout(2,2, 'Padding', 'none', 'TileSpacing', 'compact');
         nexttile
               date = dateFormat.parse(String(trainingStats.TimeStamp(end)));
              times_temp_ =  (date.getTime() - reference.getTime())/1000/60;
               plot(times_); title(['Time t_{all} = ' char(string(last_add_+times_temp_)) ])
        nexttile
            plot(movmean(trainingStats.EpisodeReward,[average_len-1 0])); hold on;
            plot(trainingStats.EpisodeReward,':'); hold off;
            title(['Rewards t_{all} = ' char(string((last_add_+times_temp_)/60))]);
           title(['Rewards, len_{window} = ' char(string(average_len))])
%              xlabel('Episode number')
             
        nexttile
              plot(trainingStats.EpisodeQ0,'--')
%              leg = legend("Avg. reward","Q_0");
%              leg.Location = 'southeast';
              title("Q_0"), hold on
             plot(trainingStats.EpisodeReward,':'); hold off;
         nexttile
             plot(trainingStats.EpisodeSteps);
    %     nexttile
    %         plot(trainingStats.AverageReward./trainingStats.EpisodeSteps); hold on;
    %         plot(trainingStats.EpisodeReward./trainingStats.EpisodeSteps,':'); 
        
         sgtitle(title_)
%         title('#4')
%          ylim([-1000 15])
        new_figure_pos = [200 200 size_first(1) size_first(2)]; figure_var_called_new_figure_pos;
    
        if ifsave 
            if ~ispc
                if isempty(save_name)
                    saveas(gcf, "./with_RLscript/figures/"+strrep(name_string(end),".mat",".png"))
                    saveas(gcf, "./with_RLscript/figures/"+strrep(name_string(end),".mat",".fig"))
                else
                    saveas(gcf, "./temp_figures/"+string(save_name)+".png")
                    saveas(gcf, "./temp_figures/"+string(save_name)+".fig")
                end
            else
                if isempty(save_name)
                    saveas(gcf, string(pwd)+"\with_RLscript\figures\"+strrep(name_string(end),".mat",".png"))
                    saveas(gcf, string(pwd)+"\with_RLscript\figures\"+strrep(name_string(end),".mat",".fig"))
                else
                    saveas(gcf, string(pwd)+"\temp_figures\"+string(save_name)+".png")
                    saveas(gcf, string(pwd)+"\temp_figures\"+string(save_name)+".fig")
                end
            end
        end
    end

end
