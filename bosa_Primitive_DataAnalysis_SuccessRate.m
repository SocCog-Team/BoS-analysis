close all, clear, clc
%% Main script
answer = string(inputdlg('Which month and day?, import it like 0705'))
loadedDATA = bosa_load_data(answer)






%% Functions!
function loadedDATA = bosa_load_data(answer)
% loadedDATA is data of each session in table format
% bosa_load_data function goes to the directory of the data 2023 and asks
% wich date you want to look at, after giving the date, it opens the file
% of that given date, then loads what inside is and converts it to table.
cd 'C:\Users\zahra\Documents\SCP_DATA\SCP-CTRL-01\SESSIONLOGS\2023'; % year directory
cd(strcat("23",answer)) %opening date folder
InsideFolder = ls; %gets what is inside the date folder
load(InsideFolder(end,:)); %load the mat file inside the  date folder
loadedDATA = array2table(report_struct.data,'VariableNames',report_struct.header); % converts data which is structure to table
end

