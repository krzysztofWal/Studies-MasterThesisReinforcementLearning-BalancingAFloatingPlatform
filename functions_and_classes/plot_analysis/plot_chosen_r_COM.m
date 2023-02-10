
function [] = res_plot_chosen_r_COM_last(trainingStats, set_, title_, each_sample)
    one_dim=3; two_dim=1; my_figure
    for iter = 1 : 3
        nexttile
        for i = 1: length(set_)
            temp_=180/pi*trainingStats.SimulationInfo(set_(i)).results.r_COM.Data(:,iter);
            hold on; plot(temp_(1:each_sample:end));
            text(int32(length(temp_)*0.8),temp_(int32(end*0.8)),string(set_(i)));
        end
    end
    sgtitle(title_)
    figure_var_called_new_figure_pos
end
