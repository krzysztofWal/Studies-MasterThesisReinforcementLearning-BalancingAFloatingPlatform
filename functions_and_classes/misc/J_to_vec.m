function [vec] = J_to_vec(i,j,J_cell)
    vec = zeros(length(J_cell),1);
    for it = 1 : length(J_cell)
        tmp = J_cell{it};
        vec(it) = tmp(i,j);
    end
end