classdef exportWrap3D < handle
    properties
        umax, d, p, m_mass, m_platf, J_platf, roff, g, tau, w0, q0, u0, u_pos
        %
        time
        %
        w ,w_gb, w_p,C, q, angle_Zw_Zb, g_b, M_b 
        r_COM, r_b1, r_b2, r_b3
        % visualization
        angle_x_vis, angle_y_vis, angle_z_vis
        %
        H_b, H_b_dot,J_mass, e_total, e_kin, e_pot, e_pot_w, u,
        % visualization
        u1_vis, u2_vis, u3_vis
    end
    
    methods
        function obj = exportWrap3D(out, time_)
%             tic
            
%             obj.parameters = params;
            % struct with Timeseries objects
            struct_tmp = out.results;

            if nargin == 2
                obj.time = time_;
            else
                obj.time = struct_tmp.w.Time;
            end
            
            field_names = [         "w",    "C",   "q",     "angle_Zw_Zb",          "g_b",    "M_b",    "r_COM",   "J_mass",   "e_total",     "e_kin",  "e_pot",  "e_pot_w",      "u"];
            struct_field_names = [  "w",    "C",    "q",    "angle_between_zw_zb",  "gb",     "M",      "r_COM",   "J_masses", "etot",        "ekin",   "epot",   "epot_outside", "u"];
            
            field_names = [field_names                  "umax", "d", "p", "m_mass", "m_platf", "J_platf", "roff", "g", "tau", "w0", "q0", "u0"];
            struct_field_names = [struct_field_names    "umax", "d", "p", "m_mass", "m_platf", "J_platf", "roff", "g", "tau", "w0", "q0", "u0"];
            
            permute_field_names =  ["w_gb",   "w_p",   "H_b",   "H_b_dot"];
            permute_struct_field_names = ["wg",    "wp",    "H",     "Hdot_minus1"]; 
            
            % quick fix of shenanigans from dynamic_model_euler_copy
            if size(struct_tmp.u_pos.Data,2) == 3, field_names = [field_names "u_pos"]; struct_field_names = [struct_field_names "u_pos"];
            else permute_field_names = [permute_field_names "u_pos"]; permute_struct_field_names = [permute_struct_field_names "u_pos"]; end

            if size(struct_tmp.u.Data,2) == 3, field_names = [field_names "u"]; struct_field_names = [struct_field_names "u"];
            else permute_field_names = [permute_field_names "u"]; permute_struct_field_names = [permute_struct_field_names "u"]; end

            for i = 1 : length(field_names)
                obj.(field_names(i)) = struct_tmp.(struct_field_names(i)).Data; 
            end

            for i = 1 : length(permute_field_names)
                obj.(permute_field_names(i)) = permute(struct_tmp.(permute_struct_field_names(i)).Data,[3 1 2]);
            end

            % r_b, vis_angl_rad, u1_vis, u2_vis, u3_vis;
            rb_tmp = permute(struct_tmp.r_b.Data,[3 1 2]);
            obj.r_b1 = rb_tmp(:,:,1);
            obj.r_b2 = rb_tmp(:,:,2);
            obj.r_b3 = rb_tmp(:,:,3);
           
            obj.angle_x_vis = [obj.time struct_tmp.vis_angl_rad.Data(:,1)];
            obj.angle_y_vis = [obj.time struct_tmp.vis_angl_rad.Data(:,2)];
            obj.angle_z_vis = [obj.time struct_tmp.vis_angl_rad.Data(:,3)];
            
            obj.u1_vis = [obj.time obj.u_pos(:,1)];
            obj.u2_vis = [obj.time obj.u_pos(:,2)];
            obj.u3_vis = [obj.time obj.u_pos(:,3)];

%             toc
        end
        function res = inInertialCoordinates(obj, arg_1)
            for i = 1 : length(obj.time)
                res(i,:) = (obj.C(:,:,i)' * arg_1(i,:)')';
                % transposed C matrix times column vector
                % and transposed to be written in rows in res matrix
            end
        end

        function obj = set(obj,name,value)
            obj.(name) = value;
        end
      
    end
end


