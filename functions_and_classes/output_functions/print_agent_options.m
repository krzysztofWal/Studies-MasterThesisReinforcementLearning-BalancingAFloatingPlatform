function [] = print_agent_options(agentObj,print_opt)
    formatter = java.util.Formatter();
    for i = 1 : length(print_opt)
        formatter = formatter.format(java.lang.String("%-40s"),java.lang.String(print_opt(i)));
        eval(['val=agentObj.AgentOptions.' char(print_opt(i)) ';']);
        formatter = formatter.format(java.lang.String("%10s\n"),java.lang.String(string(val)));
    end
    fprintf(string(formatter))
end
