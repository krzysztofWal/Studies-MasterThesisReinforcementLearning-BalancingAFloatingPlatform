function [time_steps] = calculate_par_par(trainingStats,if_results, if_two_iter,if_transpose, episode_range, steps_range, par_name, par_col, to_calc_name)

    time_steps = zeros(length(episode_range),1);
    iter = 1;
    for i = episode_range
        if if_transpose, par_name = string(par_name) + "'"; end
        if if_results
            eval(['y = to_vec(trainingStats.SimulationInfo(i).results.' char(string(par_name)) '.Data);'])
            y = y(steps_range,par_col);
        else
            eval(['y = to_vec(trainingStats.SimulationInfo(i).' char(string(par_name)) ');'])
            y = y(steps_range,par_col);
        end
        if if_two_iter
            eval(['time_steps(iter) = ' char(string(to_calc_name)) '(y));'])
        else
            eval(['time_steps(iter) = ' char(string(to_calc_name)) '(y);'])
        end

        iter = iter+1;
    end
    function res = get_first_func(x)
        res = x(1);
    end
end