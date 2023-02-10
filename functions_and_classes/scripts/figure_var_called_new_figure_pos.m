position = [1920 0 1800 1080];
get(gcf);
if exist("new_figure_pos",'var')
    position = new_figure_pos;
    clear new_figure_pos
end
set(gcf,'Position',position);
clear position