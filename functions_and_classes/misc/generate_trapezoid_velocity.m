function [time_, velocity, acceleration] = generate_trapezoid_velocity(how_many,how_far,time_in,steep_vel,steep_acc,dt, bool_acc)
    tau_temp = floor((time_in/how_many)/dt);
    tau = tau_temp*dt;
    vel = how_far/((1-steep_vel)*tau);
    velocity = zeros(1,time_in/dt+1);
    
    
    delta_temp = floor((steep_acc*steep_vel*tau/2)/dt);
    delta_1 = delta_temp*dt;
    acc = vel/(steep_vel*tau);
    acceleration = zeros(1,int32((time_in+delta_1)/dt + 1));
    

    for i = 1 : how_many
        offset = tau*(i-1);
        y2 = offset+steep_vel*tau;
        y3 = offset+tau*(1-steep_vel);
        t0 = y2 + (y3-y2)/2;

        [time_, velocity_] =  generate_trapezoid(0,time_in, ...
            offset, y2, y3 , i*tau, vel, dt);
        velocity = velocity+ (-1)^(i+1)*velocity_;
    
        if bool_acc
        if i == 1
             [~, acceleration_1] = generate_trapezoid(0,time_in+delta_1, ...
                 -2*delta_1, 0, steep_vel*tau, steep_vel*tau+2*delta_1, acc, dt);
%                 0, 2*delta_1, steep_vel*tau, steep_vel*tau+2*delta_1, acc, dt);
             acceleration = acceleration_1;
        end
        y1 = offset + tau*(1-steep_vel);
        y2 = y1 +  2* delta_1;
        y3 = y2 + 2* steep_vel*tau - 2*delta_1 ;
        y4 = y3 + 2* delta_1 ;
        t0 = y2 + (y3-y2)/2;
        
        if i ~= how_many
        [~,acceleration_] = generate_trapezoid(0,time_in+delta_1, ...
            y1, y2, y3, y4, acc, dt);
         acceleration = acceleration + (-1)^(i)*acceleration_;
        end

        end
    end

    if bool_acc
    acceleration = acceleration(delta_1/dt+1:end) + (-1)^how_many * flip(acceleration_1((delta_1/dt+1:end)));
    end
%      figure;
%      plot(time_,velocity, time_,acceleration);

end

