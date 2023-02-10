function start_params = generate_init_params(ifsimplified, sim_time_in, sim_dt_in, roff_in)
    
    umax = 0.005; %0.005; %
    u0 = 0.0; %[m];
    g = 9.81;
    m_mass = 0.3; % [kg]
    % CHOSEN TO BE CONSTANT
    m_platf = 2;%1753.45 /1000;        % [kg] mass of the platform
    tau = [0; 0; 0];

    J_platf = diag([0.022 0.025 0.026]);

    if nargin >0
        % called from mechanics_euler_init.m

        % d given as [d1x d1y d1z; d2x d2y d2z; d3x d3y d3z] 
        % in rows not in colums, that is taken into account in Simulink
        % to correspond with the rest of the model
        % the same applies to p
        if ifsimplified % d and p - simplified
        % 5 July, changed here and in local_rese_fcn, look there for
        % description
            p = [0 0 0; 0 0 0; 0 0 0];
            d = eye(3);
        else % d and p - real-like structure
            d = [297.95 516.06 -803.06;
                -595.9 0 -803.06;
                297.95 -516.06 -803.06]/1000; %[m]
            p = [48.34 83.72 9.34;
                -96.67 0.0 9.34;
                48.34 -83.72 9.34]/1000; %[m]
        end 

        simTime = sim_time_in;
        sim_dt = sim_dt_in;
    end
    
    if nargin == 0
        %%% called from reset function
        simTime = Inf;
% 🢃 =============================================================================================== 🢃 
% simulation step for the environment 
        sim_dt = 0.05; 
% ⇧ =============================================================================================== ⇧ 
        p = [0 0 0; 0 0 0; 0 0 0];
        d = eye(3);
    end

    if nargin == 4
        roff=roff_in;
    else
% 🢃 =============================================================================================== 🢃 
% COR-COM of the platform itself
%         roff= [0.02; 0.02; -0.04]; 

        roff = [map_with_gap_sim(rand(1),0,1, 0.01, 0.02); 
            map_with_gap_sim(rand(1),0,1, 0.01, 0.02);  
            -0.06]; 
        
% ⇧ =============================================================================================== ⇧ 
    end
    
% 🢃 =============================================================================================== 🢃 
% initial angular velocity [rad/s]

%       omega_x0 = map_m(rand(1),0,1,-deg2rad(5),deg2rad(5));
%       omega_y0 = map_m(rand(1),0,1,-deg2rad(5),deg2rad(5));
%       omega_z0 = map_m(rand(1),0,1,-deg2rad(5),deg2rad(5));
      omega_x0 = deg2rad(5);
      omega_y0 = deg2rad(5);
      omega_z0 = deg2rad(5);
%       omega_x0 =  0;
%       omega_y0 = 0;
%       omega_z0 = 0;
 
% ⇧ =============================================================================================== ⇧ 
    w0 = [omega_x0; omega_y0; omega_z0];
    
% 🢃 =============================================================================================== 🢃 
% initial attitude [rad] (Euler represenation is better for understanding the orientation)

%      phi0    = map_m(rand(1),0,1,-deg2rad(5),deg2rad(5));
%      theta0  = map_m(rand(1),0,1,-deg2rad(5),deg2rad(5));
%      psi0    = map_m(rand(1),0,1,-deg2rad(5),deg2rad(5));
     phi0    = deg2rad(5);
     theta0  = deg2rad(5);
     psi0    = deg2rad(5);
%       phi0    = 0;
%       theta0  = 0;
%       psi0    = 0;

% ⇧ =============================================================================================== ⇧ 
    q0 = eul2quat([phi0, theta0, psi0]); % default rotation order: 'ZYX'

    % return values as parameters3D object
    start_params = parameters3D(d,p,m_mass,m_platf,J_platf,tau,roff,g,w0,q0,u0,umax, simTime, sim_dt);
end