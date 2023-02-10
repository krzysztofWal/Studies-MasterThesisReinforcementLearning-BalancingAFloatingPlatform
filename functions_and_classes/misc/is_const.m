function [boolean_] = is_const(vec,margin)
    boolean_ = true;
    value = vec(1);
    for i = 2 : length(vec)
%         disp(abs(vec(i) - value))
        if abs(vec(i) - value) > margin; boolean_=false;break; end
        
    end

end

