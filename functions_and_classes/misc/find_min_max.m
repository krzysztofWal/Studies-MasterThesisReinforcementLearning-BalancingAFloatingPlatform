function [minima, maxima] = find_min_max(f_abs, sizes_fabs, ifderiv)
    
    % goes through binary files in path with names the same as the files in
    % given directory in the body of the function (d) with given extension
    % from those binary files it extracts parameters from trainigStats structures
    % for every episode gicen in f_abs vector
    % with corresponding sizes given in sizes_fabs vector. It returns
    % maximum and minimum value across all searche files of given
    % parameters or its derivative.

    % for example:
    % [minima, maxima] = find_min_max(["w"],[3], true)
    % returns two 3x1 vectors with minimum and maximum value of every
    % component (3 components) of wdot

    % *NOTE
    % when taking maxima nad minima of derivative, the first and last two
    % samples are ommitted (derivative calculated using derivative
    % function from ../references_comments/ directory)

    %from which directory to take names    
    d = [pwd '/with_RLscript/figures'];
    files = dir(fullfile(d, '*.png'));
    minima = zeros(sum(sizes_fabs),1);
    maxima = zeros(sum(sizes_fabs),1);

    for i = 1 : length(files)
        name_t = files(i).name;
        % if contains 'part' in the name take the linked files
        if contains(name_t,'part'), name_t = [name_t(1:end-11) '_sum.mat'];
        else, name_t = [name_t(1:end-4) '.mat']; end
        % load training stats simulation info
        simulation_info_vec = load(name_t, 'trainingStats').trainingStats.SimulationInfo;
        for j = 1 : length(simulation_info_vec)
            for l = 1 : length(f_abs)
                chosen_parameter = simulation_info_vec(j).results.(f_abs(l)).Data;
                if size(size(chosen_parameter)) == [1 3]
                    chosen_parameter = to_vec(chosen_parameter);
                end
                % if first given parameter
                if l == 1, begin_range = 1; % end_range = sizes_fabs(1);
                else, begin_range = sum(sizes_fabs(1:l-1)) + 1;
%                         end_range = begin_range + sizes_fabs(l) - 1; 
                end

                if ifderiv
                    for m = 1 : length(max(chosen_parameter))
                        chosen_parameter(:,m) = derivative(simulation_info_vec(j).results.w.Time, chosen_parameter(:,m));
                    end
                    chosen_parameter = chosen_parameter(3:end-2,:);
                end

                pot_max = max(chosen_parameter);
                pot_min = min(chosen_parameter);
                for m = 1 : length(pot_max)
                    if pot_max(m) > maxima(begin_range + m - 1 )
                        maxima(begin_range + m - 1) = pot_max(m); end
                    if pot_min(m) < minima(begin_range + m - 1 )
                        minima(begin_range + m - 1) = pot_min(m); end
                end

            end
        end
        disp("Checked " +string(name_t))
    end
end