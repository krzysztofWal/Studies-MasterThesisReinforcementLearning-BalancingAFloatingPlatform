for i = 1 : length(init_find)
    eval(['addition = "' init_variable_prefix char(init_find(i)) '";'])
    params_to_save(end+1) = addition;
end