 function [vec] = to_vec(in)
        % if array is 3D
        if size(size(in)',1) == 3
            vec = zeros([size(in,3) size(in,1)]);
            for i = 1 : size(in,3)
                vec(i,:) = in(:,:,i); 
            end
            vec = vec;
        else
            vec = in;
        end
    end