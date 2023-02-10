function [time_steps] = calculate_par_par_res(res, if_two_iter,if_transpose, episode_range, steps_range, par_name, par_col, to_calc_name)

    time_steps = zeros(length(episode_range),length(par_col));
    iter = 1;
    for i = episode_range
        if if_transpose, par_name = string(par_name) + "'"; end
            
        eval(['y = res(' char(string(i)) ').' char(string(par_name)) ';'])
        y = y(steps_range,par_col);
     
        if if_two_iter
            eval(['time_steps(iter,:) = ' char(string(to_calc_name)) '(y));'])
        else
            eval(['time_steps(iter,:) = ' char(string(to_calc_name)) '(y);'])
        end
        iter = iter+1;
    end
    function res = get_last_func(x)
        res = x(end);
    end 
    function res = get_first_func(x)
        res = x(1);
    end
end