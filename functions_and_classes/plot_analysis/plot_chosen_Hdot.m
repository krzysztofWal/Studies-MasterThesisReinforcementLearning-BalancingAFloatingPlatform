
function [] = plot_chosen_Hdot(trainingStats, set_, title_, each_sample)
    one_dim=1; two_dim=1; my_figure
    nexttile
    for i = 1: length(set_)
        temp_=trainingStats.SimulationInfo(set_(i)).results.Hdot_minus1.Data(3,:);
        hold on; plot(temp_(1:each_sample:end));
         plot(temp_(1:each_sample:end)); text(int32(length(temp_)*0.8),temp_(int32(end*0.8)),string(set_(i)));
    end
    sgtitle(title_)
   figure_var_called_new_figure_pos
end