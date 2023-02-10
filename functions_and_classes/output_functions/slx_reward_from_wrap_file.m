function [string_] = slx_reward_from_wrap_file(file_name,search_par)
     filetext = fileread(file_name);
     if ispc
          split_ = strsplit(filetext,";"+string(char(13)+string(newline)));
     else
         split_ = strsplit(filetext,";"+newline);
     end
    ind_ = (strfind(split_,search_par));
   for i = 1 : length(ind_), if isempty(ind_{i}), ind_{i}=double(intmax); end, end;
   index_= cell2mat(ind_)<double(intmax);
    string_ = string(strtrim(strrep(split_{index_},' ','')));
end 