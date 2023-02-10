function [random_] = plot_random_angles(trainingStats,number_, title_, dontplot)
    random_ = round(map_m(rand([number_ 1]),0,1,1,length(trainingStats.SimulationInfo)));
    if nargin < 4 || (nargin==4 && dontplot == false)
        figure
        for i = 1: length(random_)
            hold on; plot(180/pi*trainingStats.SimulationInfo(random_(i)).results.angle_between_zw_zb);
        end
        title(title_)
        figure_var_called_new_figure_pos
    end
end