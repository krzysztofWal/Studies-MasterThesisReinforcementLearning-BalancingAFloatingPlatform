if exist("batch_vec",'var') && exist("alg_vec",'var') && ...
        exist("prefix",'var') && exist("it_took",'var') && ...
        exist("structure_iter",'var')
    debug = 0;
    
    cd ./data/

    cell_with_networks = cell(length(batch_vec)*length(alg_vec),1);
    iter = 1;
    for i = batch_vec
        for j = alg_vec
            for k = 1 : structure_iter
                eval(['cell_with_networks{iter} = ' char(string(prefix)+"net_"+j+"_"+i+"_"+k) ';']); 
    
                % save networks and structures into the file with prefix name
                if iter == 1, str_1 = [char("save ") prefix char("file.mat ") ...
                   char(string(prefix)+"net_"+j+"_"+i+"_"+k) '_nets;'];
                else str_1 = [char("save ") prefix char("file.mat ") ...
                   char(string(prefix)+"net_"+j+"_"+i+"_"+k) '_nets' char(" -append;")]; end
    
                str_2 = [char("save ") prefix char("file.mat ") ...
                   char(string(prefix)+"net_"+j+"_"+i+"_"+k) char(" -append;")];
                str_3 = [char("save ") prefix char("file.mat ") ...
                    char(string(prefix)+"net_"+j+"_"+i+"_"+k+"_network_structure") char(" -append;")];
                str_4 = [char("save ") prefix char("file.mat ") ...
                    char(string(prefix)+"net_"+j+"_"+i+"_"+k+"_options") char(" -append;")];
                if ~debug, eval(str_1);eval(str_2);eval(str_3);eval(str_4);
                else, disp(str_1);disp(str_2);disp(str_3);disp(str_4); end
    
                iter = iter+1;
            end
        end
    end

    val_and_loss = get_loss_and_val(cell_with_networks);

    % add val_and_loss to file 
    str_5 = string(prefix) + "info=val_and_loss;";
    str_6 = [char("save ") prefix char("file.mat ") ...
               prefix 'info' char(" -append;")];
    str_7 = [char("save ") prefix char("file.mat ") ...
               'it_took' char(" -append;")];
    
    if ~debug, eval(str_5); eval(str_6);eval(str_7); else, disp(str_5); disp(str_6); disp(str_7); end

    cd ..

else
    disp("Cannot generate result struct names")
end