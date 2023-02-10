function sim_res = sim_wrap(path_, file_)
    eval(['cd ' path_])
    sim_res = sim(file_);
    cd ..
end

