% visible variables from RL_manage :    m_e_i_first
%                                       sample_time_for_controller
%                                       no_sim

global counter_29_10_temp;

if contains(pwd,'3D_model'), cd .., end

if exist('no_sim','var')
    simulate = false;
else
    simulate = true;
end

if simulate
    m_e_i_first = true;
    agent_act_number = 2;
end

%% Initial conditions and model parameters

if m_e_i_first

    if_simplified = true;
%     simTime = 10;
%     sim_dt = 1e-3;
    simTime = 120;
%         simTime = 20;
    if ~exist('set_sim_dt','var')
        sim_dt = 0.001;
    else
        sim_dt = set_sim_dt;
    end
    if simulate
        fprintf("sim_dt = %.5f\n",sim_dt)
    end
    % some parameters below are random some are set, see inside the
    % function
    if exist('set_roff')
        init_params = generate_init_params(true,simTime,sim_dt,set_roff);
    else
        init_params = generate_init_params(true,simTime,sim_dt);
    end
    d = [ init_params.d1' ; init_params.d2'; init_params.d3'];
    p = [ init_params.p1' ; init_params.p2'; init_params.p3'];
    m_mass = init_params.m_mass;
    m_platf = init_params.m_platf;
    J_platf = init_params.J_platf;
    tau = init_params.tau;
    roff = init_params.roff;
    g = init_params.g;
    w0 = init_params.w0;
    q0 = init_params.q0;
    umax = init_params.umax;
    u0 = init_params.u0;

end
%% Input vectors and simulation

if simulate
    t = 0 : sim_dt : simTime;
    f = 1/10;
%     u1 = [t; [umax/2* sin(2 * pi * f * t(1:(end-1)/2)) + umax/2] umax/2*ones(length(t)-(length(t)-1)/2,1)'  ]';
%     u2 = [t; [umax/2* sin(4 * pi * f * t(1:(end-1)/2)) + umax/2] umax/2*ones(length(t)-(length(t)-1)/2,1)'  ]';
%     u3 = [t; [umax/2* sin(6 * pi * f * t(1:(end-1)/2)) + umax/2] umax/2*ones(length(t)-(length(t)-1)/2,1)' ]';
%     u1_ = [ 0.05;    0.05;   0.05;       0;      0;      0;      0;      0;      0;      0;...
%             0.01;    0.01;   0.01;       0;      0;      0;      0;      0;      0;      0;...
%             0;       0;      0;          0;      0;      0;      0;      0;      0;      0;...
%             0.01;    0.01;   0;          0;      0;      0;      0;      0;      0;      0;...
%             0.05;    0.05;   0.05;       0.05;   0.05;   0.05;   0.05;   0.05;   0;      0;...
%             ] * 0;
%     u2_ = [ 0.05;    0.05;   0.05;       0;      0;      0;      0;      0;      0;      0;...
%             0.01;    0.01;   0.01;       0.01;   0.01;   0;      0;      0;      0;      0;...
%             0.02;    0.02;      0;       0;      0;      0;      0;      0;      0;      0;...
%             0.07;    0.07;   0.07;       0;      0;      0;      0;      0;      0;      0;...
%             0.02;    0;      0;          0;      0;      0;      0;      0;      0;      0;...
%             ] * 0 ;
% 
    if false
        res_u = res.u;
        diff_ = [diff(res_u); 0 0 0];
        flag_ = [false false];
        flag_out = boolean(zeros(size(res_u)));
        flag_out2 = flag_out;
        for i = 1 : length(res.angle_Zw_Zb)
            if mod(i-1,22) == 0
                flag_ = [false false];
                flag2_ = [false false];
            end
            if diff_(i,1) ~= 0
                flag_(1) = true;
            end
            if diff_(i,2) ~= 0
                flag_(2) = true;
            end
            if mod(i,22) == 0 && ~flag_(1)
                flag2_(1) = true;
            end
            if mod(i,22) == 0 && ~flag_(2)
                flag2_(2) = true;
            end
            flag_out(i,1:2) = flag_;
            flag_out2(i,1:2) = flag2_;
        end
        diff_2 = diff(flag_out);
        diff_3 = [0 0 0; diff_2(1:end,:)];
        diff_4 = diff_3 > 0;
    
        diff_4_2 = diff_4 .* res_u;

        diff_5 = [0 0 0; diff_4_2(1:end-1,:)];
        u_ = diff_5 + res_u;
        %         
% 
%         mask_ = diff_4 + flag_out2;
%         u_ = mask_ .* res_u;
%         u_ = res_u - u_;
    end

%     u1 = [t; res.u(:,1)']';
%     u2 = [t; res.u(:,2)']';
    u3 = [t; 0 * ones(size(t))]';
     u1 = u3;
     u2 = u3;
    actions = [u1 u2];

  
    time_1 = double(intmax);
    time_2 = double(intmax);
    Hb_minus1_mem = [0;0;0];
    Hb_minus2_mem = [0;0;0];
    w_minus1_mem = [ 0 ;0; 0];

%       [~,velocity, acc] = generate_trapezoid_velocity(30, 0.02, simTime, 0.5, 0.5, sim_dt, false);
%       vel = cumtrapz(acc)/1000;

%        velocity = 0.04/8.888493827160494e-04/(30/5)*velocity';
%        figure; plot(velocity)

%  u1 = [t' 4*velocity'];
%      u2 = [t' 4*velocity'];
  %   u3 = [t' vel'];

%     velocity = deriv_cen(velocity,sim_dt);
%     velocity = real([velocity(1); velocity; velocity(end)]); 
%     switch_flag = true;
%     for i = 1 : length(velocity)
%         if isnan(velocity(i))
%             if switch_flag
%                 velocity(i) = max(velocity);
%             else
%                 velocity(i) = min(velocity);
%             end
%             switch_flag = ~switch_flag;
%         end
%     end

%     velocity = res_vec(counter_29_10_temp).u(:,1)-ones(size(max(res_vec(counter_29_10_temp).u(:,1))))*max(res_vec(counter_29_10_temp).u(:,1));
%     hold on;  plot(velocity,'-'); 

%     [~,~, acc] = generate_trapezoid_velocity(1, 0.02, simTime, 0.5, 0.01, sim_dt, true);
%     velocity = 0.04*(1/1.580246913580247e-06*flip(acc') + ones(length(acc),1))/2;
%      figure; plot(velocity)
%     velocity = deriv_cen(velocity,sim_dt);
%     velocity = real([velocity(1); velocity; velocity(end)]); 
%     switch_flag = true;
%     for i = 1 : length(velocity)
%         if isnan(velocity(i))
%             if switch_flag
%                 velocity(i) = max(velocity);
%             else
%                 velocity(i) = min(velocity);
%             end
%             switch_flag = ~switch_flag;
%         end
%     end
%    hold on;  plot(velocity,'-'); 

%     u1 = timeseries(velocity, t');
%     u2 = timeseries(velocity, t');



%      sample = trainingStatsFirstBatch4.SimulationInfo(135, 1).results.u.Data(:,1:2);
%     sample1 = sample(:,1);
%     sample2 = sample(:,2);
%      sample1_up = interp1(0 : 0.05 : (length(sample1)-1)*0.05, sample1, t) ;
%      sample2_up = interp1(0 : 0.05 : (length(sample1)-1)*0.05, sample2, t) ;
% 
% %      sample1_up = interp1(0 : 0.01 : (length(sample1)-1)*0.01, sample1, t) ;
% %      sample2_up = interp1(0 : 0.01 : (length(sample1)-1)*0.01, sample2, t) ;
% %     one_dim=2; two_dim=2; my_figure 
% %     nexttile, plot(t,sample1_up); nexttile; plot(t, sample2_up); 
% %     nexttile, plot(0 : 0.05 : (length(res_second1(1).u(:,1))-1)*0.05,sample1); nexttile;plot(0 : 0.05 : (length(res_second1(1).u(:,1))-1)*0.05,sample2);
%     
%     for funnyIterator  = 1 : length(sample2_up) 
%         if isnan(sample1_up(funnyIterator))
%             sample1_up(funnyIterator) = 0;
%         end
%         if isnan(sample2_up(funnyIterator))
%             sample2_up(funnyIterator) = 0;
%         end
%     end
% 
%     u1 = timeseries(sample1_up, t');
%     u2 = timeseries(sample2_up, t');

    slx_act_number_dme = 2;

    tic
    readData = sim_wrap('3D_model','dynamic_model_euler_copy');
    toc
    rData = exportWrap3D(readData, t');
    if false % if comparing with three
        fprintf("Simulation time : ")
        tic
        readDataComparison = sim_wrap('simulation_folder','dynamic_model_euler_beforeModelCleanUp6thJuly');
        toc
        rDataComparison = exportWrap3D_old(init_params, readDataComparison, t');
    
        % comparison with original model
        m = m_platf;
        J = J_platf;
    
        out = sim_wrap('simulation_folder','dynamic_model_euler_as_received');
        cd /home/krzysztof/Documents/GitHub/my-MSc-Wal/Models
    end
    
end

if ~simulate
    if m_e_i_first
        disp("m_e_i_first == true")
        if exist('nr_steps', 'var')
            t = 0 : sample_time_for_controller : sample_time_for_controller * nr_steps;
        else
            t = 0 : sample_time_for_controller : sample_time_for_controller * trainOpts.MaxStepsPerEpisode;
        end
        u2 = [t; 0.0 * ones(size(t))]';
        u3 = [t; 0.0 * ones(size(t))]';
        u1 = u2;
        sim_dt = sample_time_for_controller;
        m_e_i_first = false;
    end

    % overwriting of initial conditions

    % some parameters below are random some are set, see inside the
    % function
    init_params = generate_init_params(true,simTime,sim_dt);
    
    d = [ init_params.d1' ; init_params.d2'; init_params.d3'];
    p = [ init_params.p1' ; init_params.p2'; init_params.p3'];
    m_mass = init_params.m_mass;
    m_platf = init_params.m_platf;
    J_platf = init_params.J_platf;
    tau = init_params.tau;
    roff = init_params.roff;
    g = init_params.g;
    w0 = init_params.w0;
    q0 = init_params.q0;
    umax = init_params.umax;
    u0 = init_params.u0;
end
