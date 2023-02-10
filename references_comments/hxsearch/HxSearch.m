function [SearchResults, NumCommandsAgo] = HxSearch (txtstr, specificity, max_output, session)
% [SearchResults, NumCommandsAgo] = HxSearch (txtstr, specificity, max_output, session)
%   HxSearch searches command history for key word/phrase and produces full command lines that contain key word(s).
%   The search is case sensitive (perhaps future versions will make this flexible).
%
%  INPUTS
%        txtstr:	This is a string that you are searching for in your command history. 
%        txtstr:    Alternatively, txtstr can be a vector of integers (double) 
%                    ([1, 4], for example) which will return the 1st and 4th most recent command(s).
%                    ('specificity' and 'max_output' inputs are ignored in this case) (see examples)
%   specificity:    (optional) Specify if your key word(s) should match the beginning of the commandline (=1) 
%                              or can be found anywhere in the command (=0, default) (see exampes)
%    max_output:    (optional) The max number of results to show (default = 20);  1 is most recent match.  
%       session:    (optional) 1 = search only current matlab session history; 0 = search full saved history (default*).
%                              (open HxSearch.m for more notes on this parameter)
%  OUTPUTS
%    SearchResults:  a char matrix of search results where each row is a command that contains 'txtstr'.  Most recent command last. 
%   NumCommandsAgo:  a double vector matching SearchResults showing the number of commands since each row of SearchResults.  
%   
%  EXAMPLES
%   SearchResults = HxSearch ('help')                  %search full history for 'help' located anywhere in command line (up to 20 results by default)
%   SearchResults = HxSearch ([1, 3:5])                %returns the 1st, 3rd-5th most recent commands
%   SearchResults = HxSearch ([1:10])                  %returns the last 10 commands in history
%   SearchResults = HxSearch ('load', '', '', 1)       %search for history within current session only where 'load' exists in command line
%   SearchRestuls = HxSearch ('save',  1)              %search for history for commands that begin with 'save'
%   SearchResults = HxSearch ('\MATLAB', 0, 10)        %returns up to 10 most recent references to \MATLAB path in history
%   SearchResults = HxSearch ('is', 1, 50)             %search full history for commands beginning with 'is' with up to 50 results
%   SearchResults = HxSearch ('is', 0, 50)             %search full history for commands that have 'is' anywhere in command line
%   SearchResults = HxSearch ('plot', 1, 1)            %returns the most recent 'plot' command
%   [SearchRes, NumCommandsAgo] = HxSearch('open', 1)  %search full history and also return the number of commands issued since each result
%   
%  EXAMPLE IN USE:  Display most recent 'load' command.
%   [SearchRes, NumAgo] = HxSearch('load', 1, 1);
%   disp([SearchRes, ' was loaded ', num2str(NumAgo), ' commands ago.'])
%
%  EXAMPLE IN USE: re-load most recent loaded file (assuming it still exists)
%   eval(HxSearch('load', 1,1));
% 
%  EXAMPLE IN USE: plot bar graph showing history of 'help' command usage
%   [~, NumCommands] = HxSearch('help', 1, 20000);
%   [~, b] = hist(NumCommands);
%   bar(hist(NumCommands));
%   set(gca, 'xticklabel', round(b));
%   xlabel('Number of commands ago'); ylabel('Number of commands'); title('History of HELP command usage');
%
% Adam Danz 150417 adam.danz@gmail.com
% Copyright (c) 2015, Adam Danz
%All rights reserved

%   MORE NOTES ON 'SESSIONS' PARAMETER
%     Matlab versions older than R2014a store command history in fullfile(prefdir, 'history.m') while newer version store history
%     in fullfile(prefdir, 'history.xml').  Additionaly, matlab temporarily and separately stores history from your current session.  
%     Searching the current session takes a fraction of a second but limits command history results to commands made within the current
%     session only.  Searching history.m is fast, too and allow for cross-session history.  Searching history.xml could take 1-4 seconds
%     and also allows for cross-session history.  This code detects what vs of matlab you are using and choses history.m vs. history.xml 
%     appropriately.  If you want a speedy search limited to current session, input session=1.  If you don't mind potentially waiting a 
%     second or two to access your full history, input session=0.  If you are using a double vector for the txtstr input, this code may 
%     automatically switch to session=1 since it is quicker and contains same info as the other methods. History limited to 25,000 lines.
%     If you have problems with this, please contact me so I can fix the code for everyone.  

% Change History notes
%   150417 replaced the old HxSearch.m with this one (see HxSearch_OLD.m in archives).
%   150418 removed matlab version control       

%% inputs

if nargin <1 || isempty(txtstr) || ~(ischar(txtstr) || (isnumeric(txtstr) &&  all(mod(txtstr,1)==0)))
    error ('''txtstr'' missing or incorrect. See ''help HxSearch''')
end

if nargin <2 || isempty(specificity)
    specificity = 0;    
end

if nargin <3 || isempty(max_output)
    max_output = 20;        %maximum number of findings to display 
end

if nargin <4 || isempty(session)
	session = 0;        %search full hx 
end

% additional error checks
if ~ismember(specificity, [0, 1])
    error ('Specificity input needs to be 0 or 1.  See ''help HxSearch''');
end
if ~(isnumeric(max_output) && mod(max_output,1)==0 && max_output>0)
    error ('max_output needs to be a positive integer.  See ''help HxSearch''');
end
if ~ismember(session, [0, 1])
    error ('Session input needs to be 0 or 1.  See ''help HxSearch''');
end

% determine type of search
if ischar(txtstr)
    searchtype = 'ch';  %char
elseif isnumeric(txtstr)
    searchtype = 'nu';  %numeric
    max_output = length(txtstr);
else
    error('txtstr input needs to be string of char or a vector of integers');
end
    
 if ismember(searchtype, {'nu'})
    % If max_output is =< the number of commands it current session history, 
    %   force code to search in current session hx rather than full hx since
    %   that is faster and will provide same results
    currhistory = com.mathworks.mlservices.MLCommandHistoryServices.getSessionHistory;
    if (strcmp(searchtype, 'nu') && max(txtstr)<=size(currhistory,1))           %if using dbl vec and max is less than num of curr commands
        session = 1;
    end
 end

%% Grab History

switch session
    case 0 %full hx
        %search History.xml (R2014a or later) (this conditional section modified from Bogdan Roman, 2014 preserve_history.m)
        hpath = fullfile(prefdir,'History.xml');
        hpathold = fullfile(prefdir, 'history.m');
        if exist(hpath,'file') %searchest history.xml on R2014a +
            % Read the XML file into a string to look as the older history.m (i.e. remove all XML tags)
            mathist = fileread(hpath);
            mathist = regexprep(mathist, '(<[^>]+>\s*)+', '$$**@@', 'lineanchors');	% '$$**@@' arbitrarily chosen to mark end of each line for later parsing
            % translate html entities and remove leading newline
            mathist = strrep(mathist(7:end), '&gt;', '>');
            mathist = strrep(mathist, '&lt;', '<');
            % replace \r and \r\n with \n (safe to copy between OSes)
            mathist = regexprep(mathist, '\r(\n)?', '\n');
            % parse mathist into cell
            mathist = strsplit(mathist, '$$**@@');
        elseif exist(hpathold, 'file') %searches history.m in prefdir for later vs of matlab
            mathist = fileread(hpathold);
            mathist = regexprep(mathist, '\r(\n)?', '$$**@@', 'lineanchors' );
            mathist = strsplit(mathist, '$$**@@');
        else
            disp ('History.xml or history.m not found.  Try setting ''session'' to 1 to search history from current session.')
            disp ('See help for more info.')
            return
        end
       
    case 1 %current session hx
        currhistory = com.mathworks.mlservices.MLCommandHistoryServices.getSessionHistory;
        %historyText = char(currhistory);  %no longer needed
        mathist = cell(currhistory)';

end %end switch
% By now mathist should be a [1, n] cell array of cells each representing a line of history with most recent last. 

% Sometimes last line of mathist is empty, if so, remove it
if isequal(mathist(end) , {''})
    mathist(end) = [];
end

% remove last line of mathist if it is the command that just ran this function (ie: came from the command window)
source = size(struct2cell(dbstack('-completenames')));
if source(2) == 1  && ~cellfun('isempty', strfind(mathist(end), 'HxSearch')) %dbstack will only have 1 entry if called from command window.
    mathist(end) = [];
end

%number of elements in hx
numhx = size(mathist,2); 
max_output = min(max_output, numhx);
%% Search the History

switch searchtype
    case 'ch' %searching for char string
        % now search for the txtsrt
        if specificity == 1 %if we're searching for the start of a command
             % found_idx = strmatch(txtstr, mathist);                            	%this is an index of mathist containing txtstr
            found_idx = find(strncmp(mathist, txtstr, length(txtstr)));            	%same as above (tested) 
        elseif specificity == 0 %if we're search anywhere in the command line
            found_idx= strfind(mathist, txtstr);
            found_idx = find(not(cellfun('isempty', found_idx)));
        else 
            disp ('INPUT ''''specificity'''' is a 1/0.  See help file')
            return
        end
        
    case 'nu'
        if max(txtstr)>numhx,
            disp (['You only have ', num2str(numhx), ' lines of history saved'])
            return
        end
        found_idx = numhx - fliplr(txtstr) + 1; %fliplr so the last result is most recent
        found = mathist(found_idx);
end %end switch
%now we've got the found_idx of all txtstr in history  

% quit if nothing found
if isempty(found_idx)
    disp (['''', txtstr, ''' not found.'])
    SearchResults = {};
    NumCommandsAgo = [];
    return
end

if strcmp(searchtype, 'ch')
    % eliminate duplicates
    [found, IA] = unique(fliplr(mathist(found_idx)), 'stable');               	%now we have the same list in same order but without any duplicates (fliplr is to preserve order!);  IA is idx of found_idx that matches 'found'.

    % dispay results tailored to paramerets
    temp = fliplr(found_idx); 
    found = fliplr(found);    %re-invert
    max_output = min(max_output, length(found));
    found = found(end-max_output+1:end);                               
    found_idx = fliplr(temp(IA(1:max_output)));
end

% found_idx(IA(end-max_output+1 : end));
commands_ago = numhx - found_idx + 1;

%% outputs
SearchResults = (char(found'));
NumCommandsAgo = commands_ago';



%% NOTES

