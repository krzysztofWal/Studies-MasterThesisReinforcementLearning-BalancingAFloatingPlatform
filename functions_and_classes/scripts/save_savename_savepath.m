if ~isempty(char(savename))
    saveas(gcf,string(save_path)+string(savename)+".fig")
    saveas(gcf, string(save_path)+string(savename)+".png")
end