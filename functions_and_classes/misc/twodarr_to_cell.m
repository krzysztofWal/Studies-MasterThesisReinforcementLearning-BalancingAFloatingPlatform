function [out] = twodarr_to_cell(in)

    out = cell(size(in,1)/3,1);
    
    for i = 1 : (size(in,1)/3)
        out{i,1} = in(3*(i-1)+1:3*(i-1)+3,:);
    end

end