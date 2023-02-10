% paths

%% if reading from RL trainingStats
% if false
%     trainingStats = trainingStats;
%     episode_number = 248;
% 
% %    m_e_i_first = true;
% %     % setting dummy variables for mechanics_euler_script to run correctly
% %     sample_time_for_controller = trainingStats.SimulationInfo(episode_number).tout(2)...
% %          - trainingStats.SimulationInfo(episode_number).tout(1);
% %     trainOpts = struct("MaxStepsPerEpisode",length(trainingStats.SimulationInfo(episode_number).tout));
% %     mechanics_euler_init % setting starting parameters
% %     % changing initial w0 and q0 to those from RL learning episode
% %     % (these are the only values in init_params that change in each
% %     % episode)
% %     init_params.w0 = trainingStats.SimulationInfo(episode_number).w(1,:);
% %     init_params.q0 = trainingStats.SimulationInfo(episode_number).q(1,:);
%     rData = exportWrap3D(trainingStats.SimulationInfo(episode_number));
% end

    rData = res_vec(4);


%% visualisation parameters 
if rData.d == eye(3) % simplified model
    d = [297.95 516.06 -803.06;
        -595.9 0 -803.06;
        297.95 -516.06 -803.06]/1000; %[m]
    p = [48.34 83.72 9.34;
        -96.67 0.0 9.34;
        48.34 -83.72 9.34]/1000; %[m]

    p1 = p(1,:); p2 = p(2,:); p3 = p(3,:);
    d1 = d(1,:); d2 = d(2,:); d3 = d(3,:);

    p1_mag = vecnorm(p1);
    p2_mag = vecnorm(p2);
    p3_mag = vecnorm(p3);
    
    d1_mag = vecnorm(d1);
    d2_mag = vecnorm(d2);
    d3_mag = vecnorm(d3);
    
    % - x_old - length of the arms projected on XY plane
    p1x_old = sqrt(p1(1)^2+p1(2)^2); p1y_old = -p1(3); 
    p2x_old = sqrt(p2(1)^2+p2(2)^2); p2y_old = -p2(3); 
    p3x_old = sqrt(p3(1)^2+p3(2)^2); p3y_old = -p3(3);
    
    % angles of arms on XY plane
    alpha1 = rad2deg(atan(p1(2)/p1(1)));
    alpha2 = 180; 
    alpha3 = rad2deg(atan(p3(2)/p3(1)));
    
    delta1 = rad2deg(acos( (p1_mag^2 + d1_mag^2 - vecnorm(p1+d1)^2 )/(2*p1_mag*d1_mag) ));
    delta2 = rad2deg(acos( (p2_mag^2 + d2_mag^2 - vecnorm(p2+d2)^2 )/(2*p2_mag*d2_mag) ));
    delta3 = rad2deg(acos( (p3_mag^2 + d3_mag^2 - vecnorm(p3+d3)^2 )/(2*p3_mag*d3_mag) ));
    
    u1max = 0.07; u2max = u1max; u3max = u1max;
else %if real-lik1e model
    p1_mag = vecnorm(rData.parameters.p1);
    p2_mag = vecnorm(rData.parameters.p2);
    p3_mag = vecnorm(rData.parameters.p3);
    
    d1_mag = vecnorm(rData.parameters.d1);
    d2_mag = vecnorm(rData.parameters.d2);
    d3_mag = vecnorm(rData.parameters.d3);
    
    % - x_old - length of the arms projected on XY plane
    p1x_old = sqrt(rData.parameters.p1(1)^2+rData.parameters.p1(2)^2); p1y_old = -rData.parameters.p1(3); 
    p2x_old = sqrt(rData.parameters.p2(1)^2+rData.parameters.p2(2)^2); p2y_old = -rData.parameters.p2(3); 
    p3x_old = sqrt(rData.parameters.p3(1)^2+rData.parameters.p3(2)^2); p3y_old = -rData.parameters.p3(3);
    
    % angles of arms on XY plane
    alpha1 = rad2deg(atan(rData.parameters.p1(2)/rData.parameters.p1(1)));
    alpha2 = 180; 
    alpha3 = rad2deg(atan(rData.parameters.p3(2)/rData.parameters.p3(1)));
    
    delta1 = rad2deg(acos( (p1_mag^2 + d1_mag^2 - vecnorm(rData.parameters.p1+rData.parameters.d1)^2 )/(2*p1_mag*d1_mag) ));
    delta2 = rad2deg(acos( (p2_mag^2 + d2_mag^2 - vecnorm(rData.parameters.p2+rData.parameters.d2)^2 )/(2*p2_mag*d2_mag) ));
    delta3 = rad2deg(acos( (p3_mag^2 + d3_mag^2 - vecnorm(rData.parameters.p3+rData.parameters.d3)^2 )/(2*p3_mag*d3_mag) ));
    
    u1max = 0.07; u2max = u1max; u3max = u1max;
end
%% run visualisation
% vis_rData = sim('');
if true
    sim_dt = rData.time(end) - rData.time(end-1);
    simTime = (length(rData.time)-1)*sim_dt;
    t_ = 0 : sim_dt : simTime;
    rData.angle_x_vis(:,1) = t_';
    rData.angle_y_vis(:,1) = t_';
    rData.angle_z_vis(:,1) = t_';
    rData.u1_vis(:,1) = t_';
    rData.u2_vis(:,1) = t_';
    rData.u3_vis(:,1) = t_';
    vis_rData = sim_wrap('3D_model','env3d_v2_vis.slx');

end
%% Plot r in 3D-space from Simulink model and Simscape
if false
    figure
    a = tiledlayout(1,3, 'Padding', 'none', 'TileSpacing', 'compact');
    nexttile
        r1 = rData.inInertialCoordinates(rData.r_b1);
        r2 = rData.inInertialCoordinates(rData.r_b2);
        r3 = rData.inInertialCoordinates(rData.r_b3);
        plot3(r1(:,1),r1(:,2),r1(:,3)); hold on; axis tight
        plot3(r2(:,1),r2(:,2),r2(:,3)); hold on; axis tight
        plot3(r3(:,1),r3(:,2),r3(:,3)); hold on; axis tight
        title("odczytane z modelu")
        grid on
    % nexttile
    % for i = 1 : length(rData.time)
    %     rotx_ = (rotx((rData.ang_rot(i,1))));
    %     roty_ = (roty((rData.ang_rot(i,2))));
    %     rotz_ = (rotz((rData.ang_rot(i,3))));x
    %     r1_out(i,1:3) =  (rotz_*roty_*rotx_) * (rData.r1(i,:))';
    % end
    % plot3(r1_out(:,1),r1_out(:,2),r1_out(:,3)); grid on;axis tight; hold on
    % title("r1 - wymnożone z rotacją")
    nexttile
        plot3(vis_rData.m1_pos.Data(:,1),vis_rData.m1_pos.Data(:,2),vis_rData.m1_pos.Data(:,3)); hold on; axis tight;
        plot3(vis_rData.m2_pos.Data(:,1),vis_rData.m2_pos.Data(:,2),vis_rData.m2_pos.Data(:,3)); hold on; axis tight;
        plot3(vis_rData.m3_pos.Data(:,1),vis_rData.m3_pos.Data(:,2),vis_rData.m3_pos.Data(:,3)); hold on; axis tight;
        grid on
        title("Simscape")
    nexttile
        plot3(r1(:,1),r1(:,2),r1(:,3),'b'); hold on; axis tight;
        % plot3(r1_out(:,1),r1_out(:,2),r1_out(:,3)); grid on;axis tight; hold on
        plot3(vis_rData.m1_pos.Data(:,1),vis_rData.m1_pos.Data(:,2),vis_rData.m1_pos.Data(:,3),'r'); hold on; axis tight
        % legend('simulink','wymnożone z rotacją','Simscape')
        plot3(r2(:,1),r2(:,2),r2(:,3),'b'); hold on; axis tight;
        plot3(vis_rData.m2_pos.Data(:,1),vis_rData.m2_pos.Data(:,2),vis_rData.m2_pos.Data(:,3),'r'); hold on; axis tight
        plot3(r3(:,1),r3(:,2),r3(:,3),'b'); hold on; axis tight;
        plot3(vis_rData.m3_pos.Data(:,1),vis_rData.m3_pos.Data(:,2),vis_rData.m3_pos.Data(:,3),'r'); hold on; axis tight
        legend('simulink','Simscape')
        grid on
end
%% Plot ||r|| and u
if true
    figure
    a = tiledlayout(2,2, 'Padding', 'none', 'TileSpacing', 'compact');
    nexttile
        plot(rData.time,rData.u(:,1),'-'); axis tight; grid on; title('u_1')
    nexttile
        plot(rData.time,rData.u(:,2),'-'); axis tight; grid on; title('u_2')
    nexttile
        plot(rData.time,rData.u(:,3),'-'); axis tight; grid on; title('u_3')
    nexttile
        plot(rData.time,vecnorm(rData.r_b1,2,2),rData.time, vecnorm(rData.r_b2,2,2),rData.time,vecnorm(rData.r_b3,2,2)); 
        axis tight;
        grid on; legend('r_1','r_2','r_3')
end
%% plotting w
if true %wx, wy, wz
    figure
    wbf = cell(length(rData.time)-1,1);
    C_cell = twodarr_to_cell(rData.C);
    C_dot_cell = twodarr_to_cell(derivative(rData.time, rData.C));
    for i = 2 : length(rData.time)
        wbf{i-1,1} = - 180 / pi *( C_dot_cell{i} * inv(C_cell{i}) );
    end
    a = tiledlayout(2,3,'Padding','none','TileSpacing','compact');
    nexttile; 
        plot(rData.time(2:end), rData.w(2:end,1));
        hold on, plot(rData.time(2:end), J_to_vec(3,2,wbf)); 
        legend('\omega_x','\omega_{bfx}')
    nexttile; 
        plot(rData.time(2:end), rData.w(2:end,2));
        hold on, plot(rData.time(2:end), J_to_vec(1,3,wbf)); 
        legend('\omega_y','\omega_{bfy}')
    nexttile; 
        plot(rData.time(2:end), rData.w(2:end,3));
        hold on, plot(rData.time(2:end), J_to_vec(2,1,wbf)); 
        legend('\omega_x','\omega_{bfx}')
   nexttile; 
        plot(rData.time(2:end), rData.w(2:end,1) - J_to_vec(3,2,wbf)); 
        legend('e_{\omega_y}')
    nexttile; 
        plot(rData.time(2:end), rData.w(2:end,2)- J_to_vec(1,3,wbf)); 
        legend('e_{\omega_y}')
    nexttile; 
        plot(rData.time(2:end), rData.w(2:end,3) - J_to_vec(2,1,wbf)); 
        legend('e_{\omega_y}')

end
if false % amplituda w_w i w_b
    w_world_mag = vecnorm(vis_rData.w_w.Data,2,2);
    w_mag = vecnorm(rData.w,2,2);

    figure
    a = tiledlayout(1, 2, 'Padding', 'none', 'TileSpacing', 'compact');
    nexttile
        plot(rData.time, w_world_mag); grid on; %title('w_{world}')
        hold on;
%     nexttiletitle('w_{world}'
        plot(rData.time, w_mag,'--r'); grid on;% title('w_{body}')
        legend('world frame', 'body frame')
    nexttile
        plot(rData.time(2:end), w_mag(2:end) - w_world_mag(2:end)), title('\Delta')
        axis tight; grid on; xlabel('Time without first sample'); ylabel('deg/sec')
    sgtitle('Velocity (\omega_{mag}) in different frames comparison')
end
if false % wp i w_gb
    figure
    a = tiledlayout(2,3,'Padding','none','TileSpacing','compact');
    nexttile
        plot(rData.time, vecnorm(rData.w_gb,2,2));
        axis tight; grid on; title('\omega_{gb}')
    nexttile
        plot(rData.time, vecnorm(rData.w_p,2,2));
        axis tight; grid on; title('\omega_{p}')
    nexttile
        plot(rData.time,abs(rData.w_w(:,3)))
        axis tight; grid on; title('|\omega_{wz}|')
    nexttile
        plot(rData.time, vecnorm(rData.w_gb+rData.w_p,2,2))
        axis tight; grid on; title('\omega_{gb}+\omega_{p}')
    nexttile
        plot(rData.time, vecnorm(rData.w,2,2))
        axis tight; grid on; title('\omega_{b}')
    nexttile
        plot(rData.time, vecnorm(rData.w_w,2,2))
        axis tight; grid on; title('\omega_{w}')
end
if false %w_w i w_w Simulink a Simscape
    figure
    a = tiledlayout(1,1,'Padding','none','TileSpacing','compact');
    nexttile
    plot(rData.time(2:end),vis_rData.w_w.Data(2:end,:) - rData.w_w(2:end,:))
        title('\Delta_{\omega_{w}} Simulink a Simscape'); grid on
end
%% plotting r and main axes of J_masses
if false
    figure
    a = tiledlayout(2,1,'Padding','none','TileSpacing','compact');
    nexttile
        tmp1_ = J_to_vec(1,1,rData.J_mass);
        tmp2_ = J_to_vec(2,2,rData.J_mass);
        tmp3_ = J_to_vec(3,3,rData.J_mass);
        max_tmp = max([max(tmp1_) max(tmp2_) max(tmp3_)]);
        min_tmp =min([min(tmp1_) min(tmp2_) min(tmp3_)]);
        plot(rData.time, J_to_vec(1,1,rData.J_mass)); hold on;
        plot(rData.time, J_to_vec(2,2,rData.J_mass)); hold on;
        plot(rData.time, J_to_vec(3,3,rData.J_mass)); hold on;
        grid on; legend('I_{xx}','I_{yy}','I_{zz}'); title('I_{masses}')
        ylim([-(1.2*abs(min_tmp)) 1.2*max_tmp])
    nexttile
        plot(rData.time,vecnorm(rData.r1,2,2),rData.time, vecnorm(rData.r2,2,2),rData.time,vecnorm(rData.r3,2,2)); 
        grid on; legend('r_1','r_2','r_3'); title('r')
        axis tight;
end
%% plotting C matrix
if false
    figure
    a = tiledlayout(3,3,'Padding','none','TileSpacing','compact');
    rng_tmp = 2 : length(rData.time);
        for i = 1 : 3
            for j = 1 : 3
            nexttile
                C_tmp = J_to_vec(i,j,rData.C);
                J_tpm_2 = J_to_vec(i,j,rData.C_dot);
                plot(rData.time(rng_tmp), C_tmp(rng_tmp) , ...
                    rData.time(rng_tmp), J_tpm_2(rng_tmp));
                legend('C','dC/dt')
            end
        end
end
%% plotting energies
if false
    figure
    a = tiledlayout(1,1,'Padding','none','TileSpacing','compact');
    nexttile
        %plot(rData.time,rData.e_pot, rData.time,rData.e_kin, rData.time,rData.e_total)
        plot(rData.time, rData.e_pot_w,rData.time, rData.e_kin, rData.time, rData.e_kin+rData.e_pot_w)
        axis tight
        legend('Potential energy','Kinetic energy', 'Sum')
        title('With epot_w')
    show_on_desktop1
end
%% plot H, H_dot and M
if true
    H_w = rData.inInertialCoordinates(rData.H_b);
    Hb_deriv = [derivative(rData.time, rData.H_b(:,1)) ...              
             derivative(rData.time, rData.H_b(:,2)) ...
             derivative(rData.time, rData.H_b(:,3))];
    Hw_deriv = [derivative(rData.time, H_w(:,1)) ...
             derivative(rData.time, H_w(:,2)) ...
             derivative(rData.time, H_w(:,3))];

    figure
    a = tiledlayout(3,2,'Padding','none','TileSpacing','compact');
    nexttile
        plot(rData.time(1:end), rData.H_b(1:end,:)), legend('H_x','H_y','H_z')
    nexttile
        plot(rData.time(1:end), H_w(1:end,:)); legend('H_{wx}','H_{wy}','H_{wz}')
    nexttile
        plot(rData.time, rData.M_b)
        title('M_b')
    nexttile
       M_w = rData.inInertialCoordinates(rData.M_b)'; %transpose due to 'legacy' reasons
       plot(rData.time, M_w)
       title('M_w = C * M_b')
%     nexttile
%         for i = 1 : length(rData.time)
%             M_w_(:,i) = cross(readData.r_COM_w(i,:)',[0; 0; -g]);
%         end
%        plot(rData.time, (rData.parameters.m_platf + 3 * rData.parameters.m_mass)*M_w_'  );
%       title('M_w = r_{COM_{w}} \times [0;0;-g]')   
    nexttile
        plot(rData.time, Hb_deriv(:,1), ...
            rData.time, Hb_deriv(:,2), ...
            rData.time, Hb_deriv(:,3))
        title('[dH_{b}/dt]_B')
    nexttile
        plot(rData.time, Hw_deriv(:,1), ...
            rData.time, Hw_deriv(:,2), ...
            rData.time, Hw_deriv(:,3))
        title('dH_{w}/dt')
    figure_var_called_new_figure_pos
    %%%%% ERRORS
    figure
    a = tiledlayout(3,1,'Padding','none','TileSpacing','compact');
    nexttile
        plot(rData.time, vecnorm(H_w')-vecnorm(rData.H_b'));
        title('vecnorm(H) error')
    nexttile
        Hb_der_err_x = Hb_deriv(:,1)-rData.M_b(:,1);
        Hb_der_err_y = Hb_deriv(:,2)-rData.M_b(:,2);
        Hb_der_err_z = Hb_deriv(:,3)-rData.M_b(:,3);
        
        plot(rData.time, Hb_der_err_x, ...
            rData.time,  Hb_der_err_y, ...
            rData.time,  Hb_der_err_z)
        title('[dH_{b}/dt]_B - M_b')
    nexttile
        plot(rData.time, Hw_deriv(:,1)-M_w(1,:)', ...
            rData.time, Hw_deriv(:,2)-M_w(2,:)', ...
            rData.time, Hw_deriv(:,3)-M_w(3,:)')
        title('dH_{w}/dt - M_w')
    figure_var_called_new_figure_pos
    %%%%%% 
    figure
    a = tiledlayout(3,1,'Padding','none','TileSpacing','compact');
    nexttile
        plot(rData.time, rData.M_b)
        title('M_b')
    nexttile
        for i = 1 : length(rData.time)
            cross_p(i,:) = (cross(rData.w(i,:)',rData.H_b(i,:)'))';
        end
        plot(rData.time, Hb_deriv+cross_p)
        title('[dH_{b}/dt]_B + \omega \times H_b')
    nexttile
        plot(rData.time, Hb_deriv+cross_p-rData.M_b)
        title('[dH_{b}/dt]_B + \omega \times H_b - M_b')
    figure_var_called_new_figure_pos
end
%% comparison of derivatives
if true
    figure
    a = tiledlayout(2,1,'Padding','none','TileSpacing','compact');
    
    Hb_deriv = [derivative(rData.time, rData.H_b(:,1)) ...
                 derivative(rData.time, rData.H_b(:,2)) ...
                 derivative(rData.time, rData.H_b(:,3))];
    for i = 1 : length(rData.time)
            cross_p(i,:) = (cross(rData.w(i,:)',rData.H_b(i,:)'))';
    end

%     Hw = rData.inInertialCoordinates(rData.Hb);
%     Hw_deriv = [derivative(rData.time, Hw(:,1)) ...
%                  derivative(rData.time, Hw(:,2)) ...
%                  derivative(rData.time, Hw(:,3))];
%     M_w = rData.inInertialCoordinates(rData.Mb);
%     w_w = rData.inInertialCoordinates(rData.w);
% 
%     for i = 1 : length(rData.time)
%             cross_p_w(i,:) = pi/180*(cross(w_w(i,:)',Hw(i,:)'))';
%     end
       
    nexttile
        plot(rData.time(2:end-1,:), Hb_deriv(2:end-1,:)+cross_p(2:end-1,:) - rData.H_b_dot(3:end,:))

end
%% export to .mat file and plot rotation of body frame
if false
    tmp = rData.zb_in_w;
%    tmp = rData.w_w/100;
    save python_plot/pythonPlot.mat tmp;
    rb1 = rData.rb1; rb2 = rData.rb2; rb3 = rData.rb3;
    save python_plot/pythonPlot.mat rb1 -append;
    save python_plot/pythonPlot.mat rb2 -append;
    save python_plot/pythonPlot.mat rb3 -append;
    clear tmp  rb1 rb2 rb3;
    cd python_plot/
          system('gnome-terminal -x sh -c "python3 plotVec.py"','-echo')
         % system('gnome-terminal -x sh -c "python3 plotVec_rb.py"','-echo')
    cd ..
end
%% checking I_mass calculation
if false

    % calculating 'step-by-step'
    m = rData.m_mass;
    cell_ = {rData.r_b1,rData.r_b2,rData.r_b3};
    for iter = 1 : 3
        %for each mass
        r = cell_{iter};
        for t = 1 : length(rData.time) 
            rt = r(t,:);
            % for each time sample
            I{t} = [ m*(rt(2)^2+rt(3)^2) -m*rt(1)*rt(2)       -m*rt(1)*rt(3);
                  -m*rt(1)*rt(2)      m*(rt(1)^2+rt(3)^2)     -m*rt(2)*rt(3);
                  -m*rt(1)*rt(3)      -m*rt(2)*rt(3)          m*(rt(1)^2+rt(2)^2)];
        end
        I_for_each{iter} = I;
    end
    
    tmp_1 = I_for_each{1}; tmp_2 = I_for_each{2}; tmp_3 = I_for_each{3};
    for t =  1 : length(rData.time)
        I_masses_total{t} =  tmp_1{t} + tmp_2{t} + tmp_3{t};
    end
    % calculating difference
    
    for t = 1:length(rData.time)
        I_masses_diff{t} = I_masses_total{t} - rData.J_mass(:,:,t);
    end
    
    % plotting difference
    figure
    a = tiledlayout(3,3,'Padding','none','TileSpacing','compact');
    nexttile; plot(rData.time, J_to_vec(1,1,I_masses_diff)); hold on; title('xx'); axis tight;
    nexttile; plot(rData.time, J_to_vec(1,2,I_masses_diff)); hold on; title('xy'); axis tight;
    nexttile; plot(rData.time, J_to_vec(1,3,I_masses_diff)); hold on; title('xz'); axis tight;

    nexttile; plot(rData.time, J_to_vec(2,1,I_masses_diff)); hold on; title('yx'); axis tight;
    nexttile; plot(rData.time, J_to_vec(2,2,I_masses_diff)); hold on; title('yy'); axis tight;
    nexttile; plot(rData.time, J_to_vec(2,3,I_masses_diff)); hold on; title('yz'); axis tight;

    nexttile; plot(rData.time, J_to_vec(3,1,I_masses_diff)); hold on; title('zx'); axis tight;
    nexttile; plot(rData.time, J_to_vec(3,2,I_masses_diff)); hold on; title('zy'); axis tight;
    nexttile; plot(rData.time, J_to_vec(3,3,I_masses_diff)); hold on; title('zz'); axis tight;
    sgtitle('Checking J_{masses}')
        
end
%% comparison of models
if true
    position = [0 0 1800 1080];
    if false % velocities
        figure
        a = tiledlayout(1,3,'Padding','none','TileSpacing','compact');
        nexttile
            plot(rData.time, 180/pi*rData.w(:,1), 'ro', rData.time, rDataComparison.w(:,1),'g', rData.time, 180/pi*out.w_orig.Data(:,1),'m')
            title('\omega_{x}')   
        nexttile
            plot(rData.time, 180/pi*rData.w(:,2),'ro', rData.time, rDataComparison.w(:,2),'g', rData.time, 180/pi*out.w_orig.Data(:,2),'m')
            title('\omega_{y}')
        nexttile
            plot(rData.time, 180/pi*rData.w(:,3),'ro', rData.time, rDataComparison.w(:,3),'g', rData.time, 180/pi*out.w_orig.Data(:,3),'m')
            title('\omega_{z}')
        get(gcf);
        set(gcf,'Position',position);
        legend('Current model','Older model', 'Original')
    end
    if false % gb
        figure
        a = tiledlayout(1,3,'Padding','none','TileSpacing','compact');
        nexttile
            plot(rData.time, rData.g_b(:,1),'or', rData.time, readDataComparison.gb(:,1),'g', rData.time, out.gb_orig.Data(:,1), 'm')
            title('g_{bx}')   
        nexttile
            plot(rData.time, rData.g_b(:,2),'or', rData.time, readDataComparison.gb(:,2), 'g', rData.time, out.gb_orig.Data(:,2), 'm')
            title('g_{by}')
        nexttile
            plot(rData.time, rData.g_b(:,3),'or', rData.time, readDataComparison.gb(:,3), 'g', rData.time, out.gb_orig.Data(:,3), 'm')
            title('g_{bz}')
        get(gcf);
        set(gcf,'Position',position);
        legend('Current model','Older model', 'Original')
    end
    if false  %quaternions
        figure
        a = tiledlayout(2,2,'Padding','none','TileSpacing','compact');
        nexttile
            plot(rData.time, rData.q(:,1),'or', rData.time, rDataComparison.q(:,1), 'g',rData.time, out.q_orig.Data(:,1),'m')
            title('q_{1}')   
        nexttile
            plot(rData.time, rData.q(:,2),'or', rData.time, rDataComparison.q(:,2), 'g',rData.time, out.q_orig.Data(:,2),'m')
            title('q_{2}')   
        nexttile
            plot(rData.time, rData.q(:,3),'or', rData.time, rDataComparison.q(:,3), 'g',rData.time, out.q_orig.Data(:,3),'m')
            title('q_{3}') 
        nexttile
            plot(rData.time, rData.q(:,4),'or', rData.time, rDataComparison.q(:,4), 'g', rData.time, out.q_orig.Data(:,4),'m')
            title('q_{4}')
        get(gcf);
        set(gcf,'Position',position);
        legend('Current model','Older model', 'Original')
    end
    if true % energies
        figure
        a = tiledlayout(2,2,'Padding','none','TileSpacing','compact');
        nexttile
            %plot(rData.time,rData.e_pot, rData.time,rData.e_kin, rData.time,rData.e_total)
            plot(rData.time, rData.e_pot_w,rData.time, rData.e_kin, rData.time, rData.e_kin+rData.e_pot_w)
            axis tight
            legend('Potential energy','Kinetic energy', 'Sum')
            title('With epot_w')
        nexttile
            plot(rData.time, rData.e_pot,'or')
            axis tight
%             legend('Current model','Older model', 'Original')
            title('e_{pot}')
        nexttile
            plot(rData.time, rData.e_kin, 'or')
            axis tight
%             legend('Current model','Older model', 'Original')
            title('e_{kin}')
        nexttile
            plot(rData.time, rData.e_total , 'or')
            axis tight
%             legend('Current model','Older model', 'Original')
            title('e_{total}')
        get(gcf);
        set(gcf,'Position',position);
    end
    if false %J_masses
        figure
        a = tiledlayout(3,3,'Padding','none','TileSpacing','compact');
        rng_tmp = 1 : length(rData.time);
            for i = 1 : 3
                for j = 1 : 3
                nexttile
                    J_tmp = to_vec(rData.J_mass(i,j,:));
                    J_tpm_2 = J_to_vec(i,j,twodarr_to_cell(rDataComparison.J_mass));
                    plot(rData.time(rng_tmp), J_tmp(rng_tmp),'m' , ...
                        downsample(rData.time(rng_tmp),50), downsample(J_tpm_2(rng_tmp),50),'og');
                axis tight
                end
            end
            legend('new model','older model')
        get(gcf);
        set(gcf,'Position',position);
    end
end
%% plot constraint
if true
    one_dim = 1; two_dim = 1; my_figure
    nexttile
        plot(rData.time, 180/pi*rData.angle_Zw_Zb)
end
%% plot u der using derivation 'after the fact'
if true
    one_dim = 1; two_dim = 3; my_figure
    nexttile
        plot(derivative(rData.time, rData.u_pos(:,1))); title('u_{pos1}')
    nexttile
        plot(derivative(rData.time, rData.u_pos(:,2))); title('u_{pos2}')
    nexttile
        plot(derivative(rData.time, vecnorm(rData.u_pos(:,:)')'))
end