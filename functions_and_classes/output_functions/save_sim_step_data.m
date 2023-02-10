function [out_] = save_sim_step_data(if_save, out, save_name, if_return)
    
    % save variables from the simulation into mat or txt files
    % in case of txr these are saved:
    % w, angle_vis, H_b, H_b_dot, u_pos, r_COM, u,
    % angle_Zw_Zb are
    
    % if if_return=1 the data are returned as a string
    % instead of saving to data

    out_ = strings;

    if boolean(if_save(1))
       %extract var number
        save_name = string(save_name);
        split_ = strsplit(save_name,"|");
        save_name = split_{1};
        
        destination = split_{3} + string(save_name) + ".mat";
        step_number = double(string(split_{2})) + 1;
        episode_number = double(string(split_{4}));
        var_name = "var" + string(episode_number) + "_" + string(step_number);

        if (episode_number) == 1 && step_number == 1
            create_name(var_name, out);% assign out to variable with given_name
            save(destination,var_name,'-mat')
        else
            create_name(var_name, out);% assign out to variable with given_name
            save(destination,var_name,'-append')
        end

    end

    if boolean(if_save(2))
          % parameters_to_save
          % w, angle_vis, H_b, H_b_dot, u_pos, r_COM, u, angle_Zw_Zb

%             w = to_vec(out.results.w.Data);
%             angle_vis = to_vec(out.results.vis_angl_rad.Data);
%             H_b = to_vec(out.results.H.Data);
%             H_b_dot = to_vec(out.results.Hdot_minus1.Data);
%             u_pos = to_vec(out.results.u_pos.Data);
%             r_COM = to_vec(out.results.r_COM.Data);
%             u = to_vec(out.results.u.Data);
%             angle_Zw_zb = to_vec(out.results.angle_between_zw_zb.Data);
            
            print_data = [to_vec(out.results.w.Data) ...
                    to_vec(out.results.vis_angl_rad.Data)...
                    to_vec(out.results.H.Data)...
                    to_vec(out.results.Hdot_minus1.Data)...
                    to_vec(out.results.u_pos.Data)...
                    to_vec(out.results.r_COM.Data)...
                    to_vec(out.results.u.Data)...
                    to_vec(out.results.angle_between_zw_zb.Data)];
            row_nr = size(print_data,1);
            column_nr = size(print_data,2);

            string_to_print = strings;

            for iter = 1 : row_nr
                for iter_2 = 1 : column_nr
                    if if_return
                        string_to_print = string_to_print + sprintf("%.15e ", print_data(iter,iter_2));
                    else
                        fprintf(if_save(3), "%.15e ", print_data(iter,iter_2));
                    end
                end
            end
            

        out_ = string_to_print;
    end
    
end