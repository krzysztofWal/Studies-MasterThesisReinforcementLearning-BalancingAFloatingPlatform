function [] = plot_chosen_angles(trainingStats, set_,title_)
    figure
    for i = 1: length(set_)
        hold on; plot(180/pi*trainingStats.SimulationInfo(set_(i)).results.angle_between_zw_zb);
    end
    title(title_)
     figure_var_called_new_figure_pos
end
