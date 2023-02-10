function [] = write_debug(file_id, string_)
    fprintf(file_id, string_ + newline);
end