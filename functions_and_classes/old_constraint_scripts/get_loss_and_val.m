function [output_cell] = get_loss_and_val(cell_cells_of_structs)
%   cell contains cells with structs
    number_of_parameters = 2;
    t_ = cell_cells_of_structs{1}; 
    output_cell = cell(length(cell_cells_of_structs)*number_of_parameters,length(t_)+5);

    row = 1;
    index = 1;
    % cells with different types of networks
    for iter_cell = 1 : length(cell_cells_of_structs)
        t_ = cell_cells_of_structs{iter_cell};
        output_cell{row,1} = index;
        mean_t = 0; mean_t_2 = 0;
        arr_t = double.empty; arr_t_2 = double.empty;
        % cell with particular network type
        for iter_cell_one_type = 2 : length(t_)
            output_cell{row,iter_cell_one_type} = t_{iter_cell_one_type}.FinalValidationLoss;
            output_cell{row+1,iter_cell_one_type} = t_{iter_cell_one_type}.FinalValidationRMSE;
            % store in array to calculate
            arr_t(end+1) = t_{iter_cell_one_type}.FinalValidationLoss;
            arr_t_2(end+1) = t_{iter_cell_one_type}.FinalValidationRMSE;

        end

        output_cell{row, iter_cell_one_type + 2} = mean(arr_t);
        output_cell{row+1, iter_cell_one_type + 2} = mean(arr_t_2);
        output_cell{row, iter_cell_one_type + 3} = std(arr_t);
        output_cell{row+1, iter_cell_one_type + 3} = std(arr_t_2);
        output_cell{row, iter_cell_one_type + 4} = min(arr_t);
        output_cell{row+1, iter_cell_one_type + 4} = min(arr_t_2);
        output_cell{row, iter_cell_one_type + 5} = max(arr_t);
        output_cell{row+1, iter_cell_one_type + 5} = max(arr_t_2);

        row = row + 2;
        index = index + 1;
    end
end

