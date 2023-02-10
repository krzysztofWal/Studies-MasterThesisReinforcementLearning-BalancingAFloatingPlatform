function string_ = array_to_str(arr, if_scalar_without_brackets)
    string_ = "[";
    for i = 1 : size(arr,1)
        for j = 1 : size(arr,2)
            string_ = string_ + string(arr(i,j));
            if j ~= size(arr,2), string_ = string_ + " ";
            else, if i ~= size(arr,1), string_ = string_ + "; "; end, end 
        end
    end
    string_ = string_ + "]";

    % !!!!!!!! do not correct the underlined && below - it doesnt work then
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    if size(arr) == [1 1] & if_scalar_without_brackets
        char_ = char(string_); string_ = string(char_(2:end-1)); end

end