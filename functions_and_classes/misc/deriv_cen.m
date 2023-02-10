function out =  deriv_cen(sig,dt)
    out = zeros(length(sig)-2,1);
    for i = 1 : length(sig) - 2
        out(i) = (sig(i+2) - sig(i))/2/dt;
    end
end
