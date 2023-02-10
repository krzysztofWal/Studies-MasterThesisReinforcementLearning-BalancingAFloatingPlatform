function [time_steps, count_] = calculate_number_and_time_cnstrt_violation(trainingStats, episode_range, steps_range, cnstr, smooth_factor)
time_steps = zeros(length(episode_range),1);
count_ = zeros(length(episode_range),1);
iter = 1;
for i = episode_range
    y = trainingStats.SimulationInfo(i).results.angle_between_zw_zb.Data(steps_range);
    time_steps(iter) = sum(y > cnstr);

    y = smooth(trainingStats.SimulationInfo(i).results.angle_between_zw_zb.Data(steps_range),smooth_factor);
    above_cnstr = false; counter = 0;
    for j = 1 : length(y)
        if y(j) > cnstr && ~above_cnstr, counter = counter+1; above_cnstr=true; end
        if y(j) <= cnstr && above_cnstr, above_cnstr=false; end
    end
    count_(iter) = counter; 
    iter = iter+1;
end
    
end

