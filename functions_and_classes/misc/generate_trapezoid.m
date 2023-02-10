function [time_, output] = generate_trapezoid(y_start, y_end, y1,y2,y3,y4,A, dt)    

    tau1 = y4-y1;
    tau2 = y3-y2;
    t0 = y2 + tau2/2;
    A2 = A*tau2/(tau1-tau2);
    A1 = A + A2;

    [~, first] = triangle(y_start,y_end,t0,tau1,A1,dt);
    [time_, second] = triangle(y_start,y_end,t0,tau2,A2,dt);

    output = first-second;


    
%     figure
%     plot(first-second);

    function [t_tr,imp_tr] = triangle(t_start_tr,t_end_tr,t_0_tr,tau_tr,A_tr,dt)
        % impuls trojkątny
        t_tr = t_start_tr : dt : t_end_tr;
        imp_tr = zeros(1,length(t_tr));
        
        if (t_start_tr < 0) 
            st_ = round((t_0_tr - tau_tr/2)/dt + abs(t_start_tr)/dt) ;end_ = round((t_0_tr + tau_tr/2)/dt + abs(t_start_tr)/dt);
            else, st_ = round((t_0_tr - tau_tr/2)/dt - abs(t_start_tr)/dt);end_ = round((t_0_tr + tau_tr/2)/dt - abs(t_start_tr)/dt);
        end
        
        mdl_ = int64((tau_tr/dt)/2+1); t_subst = 0:end_-st_+1;
        slope_ = t_subst(1:mdl_)/t_subst(mdl_);
        imp_bare_ = A_tr*[slope_ flip(slope_(1:end-1))];
        
        imp_ind_tr = zeros(1,length(t_tr));
        % wskaż zakres zajęty przez impuls
        imp_ind_tr(((st_ > 0)*(st_+1) + ~(st_ > 0)*1) :(end_ <= length(t_tr))*(end_) + ~(end_ < length(t_tr))*length(t_tr))=1; 
        
        if st_ <= 0 && end_ <= length(t_tr)   % obcięty tylko z lewej strony
            imp_tr(1:sum(imp_ind_tr>0)+1) = imp_bare_(end-sum(imp_ind_tr>0):end);
        elseif st_ > 0 && end_ > length(t_tr) % obcięty tylko z prawej strony
            imp_tr(end-sum(imp_ind_tr>0)+1:end) = imp_bare_(1:sum(imp_ind_tr>0));
        elseif st_ <= 0 && end_ > length(t_tr) % obcięty z obydwu
            imp_tr(:) = imp_bare_(abs(st_)+1:abs(st_)+length(t_tr));
        else
            imp_tr(st_+1:end_+1) = imp_bare_;
        end
    end
        

end

