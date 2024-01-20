%% Description
% Script to read one of muli-channel oscilloscope data and transform data format
% to human readable standard (time and value)

%% Start operations
% Clear console, clear variables, close figures
clc;clear;close all;

%% Start parameters constants
start = 0;                                      % start time
increment = 1e-6;                               % sampling increment 
filename = 'NewFile1.csv';                      % filename from which data is read
samplesCol = 1;                                 % define which data column are samples
valueCol = 3;                                   % defines wchich data are values

%% Validate inputs
if isempty(filename) || ~ischar(filename)
    error('Invalid filename. Please enter a valid string.');
end

if ~isnumeric(samplesCol) || ~isnumeric(valueCol) || ...
        samplesCol < 1 || valueCol < 1
    error('Invalid column index. Please enter a valid positive integer.');
end
if ~isnumeric(start) || ~isnumeric(increment)
    error('Start or Increment are not numeric data');
end
%% Load data from oscilloscope csv
ScopeData = readmatrix(filename);

%% CH1 main program body
% Create file CH1
CH1 = 'CH1_anagraf.txt';                        % Give name to file
CH1_o = fopen(CH1, 'w');                        % Open file

% Check for errors
errorHandleMessage = OpenError(CH1_o);

% Check for errors
if ~strcmp(errorHandleMessage, 'File opened')
    % An error occurred
    fclose(CH1_o);
    error(errorHandleMessage,'Details: %s', exception.message);
else
    % Fill file with content
    transform(CH1_o, ScopeData,increment,samplesCol,valueCol);

    % Close File
    fclose(CH1_o);
    disp(['Content Loaded ', CH1]);
end

%% Functions

% veryfication process (if file not opened)
function OpenErrorHandleMessage = OpenError(CH1_o)
    if CH1_o == -1
        OpenErrorHandleMessage = 'File not opened.'; % error message
    else
        OpenErrorHandleMessage = 'File opened'; % No error, File opened
    end
end

% data format transformation
function transform(CH1_o, ScopeData,increment,samplesCol,valueCol)
    try
        % Fill file with content
        fprintf(CH1_o, '~ Scope Data Rigol CSV\n');
        fprintf(CH1_o, 'CH1 time\n');

        % Read data from channel 1
        samples = ScopeData(:, samplesCol);          % read samples vector from matrix
        values  = ScopeData(:, valueCol);            % read values vector from matrix

        % transform samples to time values [s]
        time = samples*increment;

        fprintf(CH1_o, '%.6f   %.6f\n', [values, time]'); % write data to file
        
    catch exception
        % If an error occurs, close the file and display the specific error message
        fclose(CH1_o);
        error('Error. Loading content not possible. Details: %s', exception.message);
    end
end
