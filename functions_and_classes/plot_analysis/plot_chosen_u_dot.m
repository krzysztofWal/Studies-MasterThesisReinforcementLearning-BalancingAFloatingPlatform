
function [] = plot_chosen_u_dot(trainingStats, set_, title_, each_sample)
    one_dim=2; two_dim=1; my_figure
    for iter = 1 : 2
        nexttile
        for i = 1: length(set_)
            temp_=180/pi*trainingStats.SimulationInfo(set_(i)).results.udot_minus1.Data(iter,:);
            hold on; plot(temp_(1:each_sample:end));
        end
    end
    sgtitle(title_)
    figure_var_called_new_figure_pos
end





