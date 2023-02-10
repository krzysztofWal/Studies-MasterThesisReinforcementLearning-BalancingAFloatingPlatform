function [] = create_name(str_name, var)
% str_name
% var
    assignin("caller",str_name,var)
%     who
end