function [reward, obs, w, q, u, der] = sim_from_py(actions, w0, q0, u0, n, der0, obs_number, ifsave, save_name, cnt)
%%%%% works only if there are six observations !!!!!!!!!!!!!!!!

%     tic
    actions = py.list(actions);
    w0 = py.list(w0);
    q0 = py.list(q0);
    u0 = py.list(u0);
    save_name = py.str(save_name);
    der0 = py.list(der0);
%     n = n;
    
    pyrun("out = py_mod_.sim(actions_,w0_,q0_,u0_,n_, der0_, ifsave_,save_name_, cnt_)", ...
        actions_=actions,w0_=w0,q0_=q0,u0_=u0,n_=n,der0_=der0,ifsave_=py.list(ifsave),save_name_=save_name, cnt_=cnt);

    temp_file = 'temp_data_from_sim.mat';
    reward = load(temp_file,'reward').reward;
    obs = reshape(load(temp_file,'observations').observations',1,[])';
    w = load(temp_file,'w').w;
    q = load(temp_file,'q').q;
    u = load(temp_file,'u_pos').u_pos';
    der = [load(temp_file,'hb_minus1').hb_minus1' load(temp_file,'hb_minus2').hb_minus2' load(temp_file,'w_minus1').w_minus1];

    % if write to text file
    if ifsave(2)
        fprintf(double(ifsave(3)),string(pyrun("out","out")));
    end
        %     res = string(pyrun("out","out"));
%     toc
%     tic
%     split_ = strsplit(string(res),'|'); % last one is empty
%     reward = double(string(split_{1}));
%     w = [double(string(split_{2})) double(string(split_{3})) double(string(split_{4})) ];
%     q = [double(string(split_{5})) double(string(split_{6})) double(string(split_{7})) double(string(split_{8}))];
%     u = [double(string(split_{9})) double(string(split_{10})) double(string(split_{11}))];
%     
%     obs = zeros(n*obs_number,1);
% 
%     base = 11;
% 
%     for i = 1 : n
%     obs((i-1)*obs_number+1:(i)*obs_number) = [double(string(split_{base+(obs_number*(i-1))+1})) ...
%         double(string(split_{base+(obs_number*(i-1))+2})) ...
%         double(string(split_{base+(obs_number*(i-1))+3})) ...
%         double(string(split_{base+(obs_number*(i-1))+4})) ...
%         double(string(split_{base+(obs_number*(i-1))+5})) ...
%         double(string(split_{base+(obs_number*(i-1))+6})) ...
%         ];
%         if i == n, last_index =base+(obs_number*(i-1))+6; end
%     end
%     der = [double(string(split_{last_index+1})) double(string(split_{last_index+2})) double(string(split_{last_index+3})) ...
%         double(string(split_{last_index+4})) double(string(split_{last_index+5})) double(string(split_{last_index+6})) ...
%         double(string(split_{last_index+7})) double(string(split_{last_index+8})) double(string(split_{last_index+9}))];

    %     toc
end