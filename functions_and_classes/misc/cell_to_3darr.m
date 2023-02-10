function out =  cell_to_3darr(in)
    out = zeros(3,3,length(in));
    for i = 1 : length(in)
        out(:,:,i) = in{i};
    end
end