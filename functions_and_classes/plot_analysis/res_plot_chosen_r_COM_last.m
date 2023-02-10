
function [] = res_plot_chosen_r_COM_last(res, set_, title_)
    one_dim=1; two_dim=1; my_figure
    temp_1 = [];
    temp_2 = [];
    
    for i = 1: length(set_)
        temp_1(end+1) = res(set_(i)).r_COM(end,1);
        temp_2(end+1) = res(set_(i)).r_COM(end,2);
    end

    plot(temp_1,'xr'); hold on
    plot(temp_2, 'xb')

    grid on
    sgtitle(title_)
    figure_var_called_new_figure_pos
end
