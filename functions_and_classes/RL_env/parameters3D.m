classdef parameters3D
    properties
        d1, d2, d3, p1, p2, p3, m_mass, m_platf, J_platf, tau, roff, g, w0, q0, umax, u0, sim_time, sim_dt
    end
    
    methods
        function obj = parameters3D(d, p, m_mass, m_platf, J_platf, tau, roff, g, w0, q0, u0, umax, sim_time, sim_dt)
            obj.d1 = d(1,:)'; obj.d2 = d(2,:)'; obj.d3 = d(3,:)'; 
            obj.p1 = p(1,:)'; obj.p2 = p(2,:)'; obj.p3 = p(3,:)'; 
            obj.m_mass = m_mass; obj.m_platf = m_platf; obj.J_platf = J_platf;
            obj.tau = tau; obj.roff = roff; obj.g = g; obj.w0 = w0; obj.q0 =q0;
            obj.umax = umax; obj.u0 = u0;
            obj.sim_dt = sim_dt; obj.sim_time = sim_time;
        end
    end
end

