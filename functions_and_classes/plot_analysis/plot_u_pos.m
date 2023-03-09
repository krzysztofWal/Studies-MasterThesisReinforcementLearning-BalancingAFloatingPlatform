function [] = plot_u_pos(trainingStats, set_, title_, each_sample, axis)
    one_dim=1; two_dim=1; my_figure
    nexttile
    for i = 1: length(set_)
        temp_=trainingStats.SimulationInfo(set_(i)).results.u_pos.Data(:,axis);
        hold on; plot(temp_(1:each_sample:end)); text(int32(length(temp_)*0.8),temp_(int32(end*0.8)),string(set_(i)));
    end
    sgtitle(title_)
    figure_var_called_new_figure_pos
end