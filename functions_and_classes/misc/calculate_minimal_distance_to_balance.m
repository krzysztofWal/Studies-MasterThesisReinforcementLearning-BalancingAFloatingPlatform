function [umax] = calculate_minimal_distance_to_balance(roff, m, M)
    % umax = [umax_x; umax_y; umax_z] if roff is a column
    umax = abs(-M/m*roff);
end