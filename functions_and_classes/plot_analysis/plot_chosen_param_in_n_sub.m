
function [] = plot_chosen_param_in_n_sub(ifres, ifsep, iftime, trainingStats, param_string, ...
    nvec, set_, title_, size_, xlabel_, ylabel_, each_sample, multiplier, ylim_, line_width, line_style)
    if ifsep, one_dim=length(nvec); else, one_dim=1; end 
    two_dim=1; my_figure
    for iter = 1 : length(nvec)
        if ifsep, nexttile; end
        for i = 1: length(set_)
            if ifres
                temp_=trainingStats(set_(i)).(param_string);
                temp_=multiplier*reshape(temp_,max(size(temp_)),[]);
                temp_=temp_(:,nvec(iter));
                 
            else
                temp_=to_vec(trainingStats.SimulationInfo(set_(i)).results.(param_string).Data);
                time_=to_vec(trainingStats.SimulationInfo(set_(i)).results.(param_string).Time);
                time_=reshape(time_,max(size(time_)),[]);
                temp_=multiplier*reshape(temp_,max(size(temp_)),[]);
                temp_=temp_(:,nvec(iter));
            end
            
            if isempty(line_width), line_width = 0.5; end
            if isempty(char(line_style)), line_style = '-'; end
            % plot
            if iftime && ~ifres
                plot(time_(1:each_sample:end),temp_(1:each_sample:end),line_style,'LineWidth',line_width);
            else
                plot(temp_(1:each_sample:end),line_style,'LineWidth',line_width);
            end
            hold on; 
            % labels
            if ~isempty(char(xlabel_((iter))))
                xlabel(xlabel_(iter))
            end
            if ~isempty(char(ylabel_((iter))))
                ylabel(ylabel_((iter)))
            end
        end
        % set limits of y axes
        if ~isempty(ylim_)
            ylim(ylim_{iter})
        end
    end
    sgtitle(title_)
    axis tight
    new_figure_pos = [0 0 size_(1) size_(2)];
    figure_var_called_new_figure_pos

end
