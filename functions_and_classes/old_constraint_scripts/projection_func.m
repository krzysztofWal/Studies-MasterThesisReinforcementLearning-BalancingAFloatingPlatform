function cnstr = projection_func(g, c, u)

%   based on the work of 

    g  = [g(1) g(2) g(3)];
    
    len_g = size(g,1);
%     len_c = length(c);
 %   len_g
    multipliers = zeros(len_g,1);
    %multipliers
    for i = 1 : len_g
        multipliers(i) = ( dot(g(i,:), u) + c(i) )/( dot(g(i,:),g(i,:)) );
        if multipliers(i) < 0, multipliers(i)=0; end
    end
    %multipliers
    [max_,loc] = max(multipliers);
    correction = max_ * g(loc,:);
   % correction

    cnstr = u' - correction;
    cnstr = cnstr';
    %disp(cnstr)

end
% g is a 3 element vector
% cnstr = double(py.py_mod_.getActionCorrection(...
%     py.numpy.array(g(1)), ...
%     py.numpy.array(g(2)), ...
%     py.numpy.array(g(3)),...
%     c,...
%     u));

