function res_out = read_from_txt(file_,eps, how_many, steps, columns_data_number)

    h1 = fopen(file_,'r');
    res_ = fscanf(h1,'%f');

    res_cell = cell(eps,1);
    field_names = ["angle_Zw_Zb"; "w"; "angle_vis"; "H_b"; "H_b_dot"; "u_pos"; "r_COM"; "u"];
    
    % output structure array
    res_out = struct();
    for i = 1 : length(field_names)
        res_out.(field_names(i)) = [];
    end
    res_out = repmat(res_out,eps,1);
    
    % divide results into episodes
    for i = 1 : eps
        res_cell{i} = res_((i-1)*length(res_)/eps+1:i*length(res_)/eps);
    end
    
    % for everu episode
    for iter = 1 : length(res_cell)
        res = res_cell{iter};

        n = numel(res);
        b = (how_many+1)*columns_data_number;
        res = mat2cell(res,diff([0:b:n-1,n]));
        
        out_struct = cell(size(field_names));
        out_struct{1} = zeros(how_many*steps+1,1);
    
        for i = 2 : length(field_names)
            out_struct{i} = zeros(how_many*steps+1,3); end
    
        for i = 1 : length(res)
            temp_res = reshape(res{i},columns_data_number,how_many+1)'; 
                if i == 1 % if first simulation
                    out_struct{1}(1:how_many+1,:) = temp_res(1:end,22); % angle_Zw_Zb
                    out_struct{2}(1:how_many+1,:) = temp_res(1:end,1:3);
                    out_struct{3}(1:how_many+1,:) = temp_res(1:end,4:6);
                    out_struct{4}(1:how_many+1,:) = temp_res(1:end,7:9);
                    out_struct{5}(1:how_many+1,:) = temp_res(1:end,10:12);
                    out_struct{6}(1:how_many+1,:) = temp_res(1:end,13:15);
                    out_struct{7}(1:how_many+1,:) = temp_res(1:end,16:18); 
                    out_struct{8}(1:how_many,:) = temp_res(1:end-1,19:21); %u
                else
                    out_struct{1}((i-1)*how_many+2:i*how_many+1,:) = temp_res(2:end,22); % angle_vis
                    out_struct{2}((i-1)*how_many+2:i*how_many+1,:) = temp_res(2:end,1:3);
                    out_struct{3}((i-1)*how_many+2:i*how_many+1,:) = temp_res(2:end,4:6);
                    out_struct{4}((i-1)*how_many+2:i*how_many+1,:) = temp_res(2:end,7:9);
                    out_struct{5}((i-1)*how_many+2:i*how_many+1,:) = temp_res(2:end,10:12);
                    out_struct{6}((i-1)*how_many+2:i*how_many+1,:) = temp_res(2:end,13:15);
                    out_struct{7}((i-1)*how_many+2:i*how_many+1,:) = temp_res(2:end,16:18); 
                    
                    if i == length(res) % if last simulation
                        out_struct{8}((i-1)*how_many+1:i*how_many+1,:) = temp_res(1:end,19:21); %u
                    else
                        out_struct{8}((i-1)*how_many+1:i*how_many,:) = temp_res(1:end-1,19:21); %u
                    end
                end
        end
    
        res = struct();
        for i = 1 : length(field_names)
            res.(field_names(i)) = out_struct{i};
        end
        res_out(iter) = res;


    end

end
