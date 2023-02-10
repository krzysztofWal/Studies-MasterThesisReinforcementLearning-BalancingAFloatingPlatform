function [found_vec] = extract_init_params(file_,var_vec)
    % extracts assigned variables from given file (name)
    % for example
%     var = [1 2 3;
%            3 4 5] % comment in file
%     var = [1 2 3]
    % will pick up the last one
    
    % the quality of the code and the logic it realises
    % is to put it mildly messed up, but well, life

    filetext = fileread(file_);
     % zmienna musi być zdeklarowana w jednej linijce !!!!!!!!!!
    split_ = strsplit(filetext,";"+newline); % podziel przy ';\n' - żeby  nie brać pod uwagę ';' w macierzach 
    % ind = (strfind(split_,'phi0')); % zlokalizuj miejsca gdzie jest zmienna
    % for i = 1 : length(ind)
    %     if ~isempty(ind{i})
    % %         fprintf("%i %i \n",i,ind{i});
    % %         disp(split_{i});
    %         split_between_newlines = strsplit(split_{i},newline); % podziel te ciągi gdzie znaleziono nazwę zmiennej według nowych linii 
    %         ind_newlines = (strfind(split_between_newlines,'phi0')); % znajdź te ciągi gdzie jest nazwa zmiennej
    %         for j = length(ind_newlines)
    %             if isempty(strfind(split_between_newlines{j},"%")) && ...
    %                     ~isempty(ind_newlines{j}) % jeśli w ciągu znaków jest nazwa zmiennej ale nie ma znaku komentarza to znaczy 
    %                                               % że tam jest deklaracja
    %                 found = strrep(split_between_newlines{j},' ','')
    %             end
    %         end
    %     end
    % end
    found_vec = string.empty;
    for iter = 1 : length(var_vec)
        var = char(var_vec(iter));
        found = string.empty;
        ind = (strfind(split_,var)); % zlokalizuj miejsca gdzie jest zmienna
        for i = 1 : length(ind)
            if ~isempty(ind{i})
        %         fprintf("%i %i \n",i,ind{i});
        %         disp(split_{i});
                split_between_newlines = strsplit(split_{i},newline); % podziel te ciągi gdzie znaleziono nazwę zmiennej według nowych linii 
                ind_newlines = (strfind(split_between_newlines,var)); % znajdź te ciągi gdzie jest nazwa zmiennej
                for j = 1 : length(ind_newlines)
                    arr_ind = ind_newlines{j};
                    line_ = split_between_newlines{j};
                    if  ~isempty(arr_ind) % jeśli w ciągu znaków jest nazwa zmiennej 
                        index = 1;
                        break_flag = false;
                        while ~break_flag 
                            if index > length(line_)
                                break
                            end
                            if line_(index) == '%'
                                break_flag = true; 
                            else
                                index = index + 1;
                            end
                        end
                        % jeśli znaleziony '%'
                        if break_flag
                            % jeśli znaleziony po pierwszym wystąpieniu nazwy zmiennej
                            % to jest niezakomentowana wartość
                            if index > arr_ind(1)
                                found_ = char(strrep(split_between_newlines{j},' ',''));
                                ind_check = strfind(found_,var);
                                if strcmp(found_(ind_check(1)+length(var)),'=')
                                    split_found_ = strsplit(found_,'%');
                                    found(end+1) = string(split_found_{1});
                                end
                            end
                        else
                            % albo jeśli w ogóle nie znaleziono '%'
                            found_ = char(strrep(split_between_newlines{j},' ',''));
                            ind_check = strfind(found_,var);
                            if strcmp(found_(ind_check(1)+length(var)),'=')
                                if length(strfind(found_,'[')) >= 1
                                    % jeśli jest '[' w znalezionej linii
                                    if length(strfind(found_,'[')) == length(strfind(found_,']'))
                                        % jesli sa w tej samej ilosci '[' i ']'
                                        found(end+1) = string(found_);
                                    else
                                        % jesli sa w roznej ilosci dodawaj
                                        % kolejne ciagi miedzy nowymi
                                        % liniami z dostepnych az
                                        % znajdziesz domkniecie ']'
                                        for l = j+1 : length(split_between_newlines)
                                            found_ = [found_ char(strrep(split_between_newlines{l},' ',''))];
                                            if length(strfind(found_,'[')) == length(strfind(found_,']'))
                                                split_found_ = strsplit(found_,'%');
                                                found(end+1) = string(split_found_{1});
                                                break
                                            end
                                        end
                                    end
                                else
                                    found(end+1) = string(found_);
                                end
                                
                            end
                        end
                        
                    end
                end
            end
        end
        if ~isempty(found)
            found= found(end);
        else
           error(['===! My error !===: something is not right with reading from generate_init_params.m -> ' var])
        end
    found_vec(end+1) = found;
    end
end