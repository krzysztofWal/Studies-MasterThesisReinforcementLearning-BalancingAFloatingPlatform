function [arr] = data_arr(data)
    names = fieldnames(data);
    len = length(names) - 1;
    data_length = 0;
    % first field does not contain data 
    eval(['data_length=length(data.' names{2} ');' ]);
    
    arr = zeros(data_length, len);
    
    for iter = 2 : len+1  % first field does not contain data 
        eval(['arr(:,iter-1)=data.' names{iter} ';']);  
    end

end

