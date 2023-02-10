function [time_steps] = calculate_time_Hdotz_above(trainingStats, episode_range, steps_range, threshold)
%gives number of time steps in which Hdot (z  axis) is above threshold

time_steps = zeros(length(episode_range),1);
iter = 1;
for i = episode_range
    y = to_vec(trainingStats.SimulationInfo(i).results.Hdot_minus1.Data);
    y = y(steps_range,3);
    time_steps(iter) = sum(y > threshold);
    iter = iter+1;
end
    
end

