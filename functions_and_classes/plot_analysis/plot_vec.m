function res = plot_vec_3D(vec)
    addpath('/media/krzysztof/OS/Tools/matlab_fig_accs/arrow3')
    figure
    arrow3([0 0 0],vec*1000); grid on
end