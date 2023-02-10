function [data_out] = to_one_data_struct(data_in,  field_names_t)
    if nargin == 1
        names = fieldnames(data_in{1});
        %for each field create an array
%         for iter = 1:length(names)
%             eval([names{iter} '=double.empty();']);
%         end
    else
        names = field_names_t;
    end
    velocity_x = double.empty();
    velocity_y = double.empty();
    velocity_z = double.empty();
    vel_proj_x = double.empty();
    vel_proj_y = double.empty();
    vel_proj_z = double.empty();
    ekin = double.empty();
    rb1x = double.empty(); rb1y = double.empty(); rb1z = double.empty();
    rb2x = double.empty(); rb2y = double.empty(); rb2z = double.empty();
    rb3x = double.empty(); rb3y = double.empty(); rb3z = double.empty();
    u1 = double.empty(); u2 = double.empty(); u3 = double.empty();
    c = double.empty(); c_next = double.empty();
    
    data_out = struct("init",'init_field');

    episode_length = 0;

    for iter = 1:length(data_in)
        % for each episode give length
         eval(['episode_length=length(data_in{iter}.' names{1} ');']);
        for iter_name = 1:length(names)
%                 disp(names{iter_name})
            eval([names{iter_name} '(end+1 : end+episode_length,1)=to_vec(data_in{iter}.' names{iter_name} ');']);
        end
    end

    for iter = 1 : length(names)
        eval(['data_out.' names{iter} '=' names{iter} ';'])
    end


end

