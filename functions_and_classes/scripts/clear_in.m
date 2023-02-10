% CLEAR_IN
%   clears variables which end with '_in"

temp_var_list = who; temp_is_last = false(size(temp_var_list));
for i = 1 : length(temp_var_list), temp_var = temp_var_list{i}; 
    if length(temp_var) > 2, temp_is_last(i) = (strcmp(temp_var(end-2:end),'_in')); end
    if temp_is_last(i) == true, eval(['clear  ' temp_var]); end
end, clear i temp_var_list temp_is_last temp_var 