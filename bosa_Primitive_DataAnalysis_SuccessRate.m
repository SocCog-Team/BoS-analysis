close all, clear, clc
%% Main script
answer = string(inputdlg('Which month and day?, import it like 0705'))
loadedDATA = bosa_load_data(answer)
%% From what I understrood from the data table, column: A_TotalRewardActiveDur_ms
%% contains accumulated rewards, if we get dif of this column,numbers inside this column tell me that minimum reward is 210 ( 1 in payoff  matrix)
%% then 2*210 = 420 means "2" in payoff matrix, 630 means 3 and 840 here, means 4 in payoff matrix
%% one very simple approach to discover REAL TRIALS is to look at this column(lets call it Accumulated_REWARD vector)
%% and get the difference between rows, when trial is NOT real, difference of reward between two trials is zero
%% because if trials is fucked up, there is no reward to be accumulated to the next trial.

Accumulated_REWARD = diff(loadedDATA.A_TotalRewardActiveDur_ms);
Reward_Value = Accumulated_REWARD./210; % reward value for each trial, values are from payoff matrix
RealTrials_ID = find(Reward_Value>0); %Real trial ID that are not aborted or fucked up and subject received reward



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

