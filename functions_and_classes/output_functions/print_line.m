function [] = print_line(number,char_)
    if string(char_) == "=", fprintf("'"), end
    for i = 1 : number
        fprintf("%s",char_)
    end
    fprintf("\n")
end

