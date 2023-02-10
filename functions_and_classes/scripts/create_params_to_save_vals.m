% get values of the parameters in a cell
params_to_save_vals = cell.empty;
for i = 1 : length(params_to_save),eval("params_to_save_vals{"+i+"}="+params_to_save(i)+";");end