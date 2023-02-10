function string_ = array_to_str_with_names(size_, name)
    string_ = "[";
    for i = 1 : size_(1)
        for j = 1 : size_(2)
            string_ = string_ + name + "(" + i + "," + j + ")";
            if j ~= size_(2), string_ = string_ + " ";
            else, if i ~= size_(1), string_ = string_ + "; "; end, end 
        end
    end
    string_ = string_ + "]";
end