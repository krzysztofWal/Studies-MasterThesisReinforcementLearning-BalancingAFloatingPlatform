
function [] = res_plot_chosen_Hdot(res, set_, title_, each_sample)
    one_dim=1; two_dim=1; my_figure
    nexttile
    for i = 1: length(set_)
        temp_=res(i).H_b_dot(:,3);
        hold on; plot(temp_(1:each_sample:end));
         plot(temp_(1:each_sample:end)); text(int32(length(temp_)*0.8),temp_(int32(end*0.8)),string(set_(i)));
    end
    sgtitle(title_)
    axis tight

   figure_var_called_new_figure_pos
end