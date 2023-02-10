
% 'unwrap' info_ parameters for use in the RL_env model
% using the script to have consistency
% 'side effects of' running the script are only nonempty parameters of
% info_ object
list_ = properties(info_);
for i = 1 : length(list_)
    eval(['temp_var=info_.' list_{i} ';']);
    if ~isempty(temp_var), eval([ list_{i} '=temp_var;' ]); end
end
clear list_ temp_var