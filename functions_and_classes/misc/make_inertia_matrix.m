function [J_platf, I] = make_inertia_matrix(ifSave)
    
    tmp_arr = readmatrix("3D_model/Model Properties.xlsx",Sheet="MODEL",Range="H9:H14");
    tmp_descr = readcell("3D_model/Model Properties.xlsx",Sheet="MODEL",Range="D9:D14");
    I = struct(tmp_descr{1},tmp_arr(1));
    for i = 2 : length(tmp_arr)
        eval(['I.' tmp_descr{i} '=tmp_arr(' char(string({i})) ');'])
    end
    J_platf = [I.xx I.xy I.xz; I.xy I.yy I.yz; I.xz I.yz I.zz]/1e6;

    if nargin == 1
        if ifSave, save 3D_model/I_plat.mat J_platf -mat, end
    end
end

