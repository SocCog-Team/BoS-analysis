%% Main script: for running on personal laptop, use this part
%% otherwise write answer = (directory of data) in command window then run the function
% close all, clear, clc
% answer = string(inputdlg('Which month and day?, import it like 0705')) %% or put this: answer = directory of data
% [loadedDATA, report_struct] = bosa_behav_analysis(answer)
% cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes'

%% Functions!
function [loadedDATA, report_struct] = Bosa_ZahraVersion_Behavioral_DataAnalysis(answer)
% report structure is whole information (headers and string information) from each session
% loadedDATA is data of each session in table format
% bosa_load_data function goes to the directory of the data 2023 and asks
% wich date you want to look at, after giving the date, it opens the file
% of that given date, then loads what inside is and converts it to table.
% cd 'C:\Users\zahra\Documents\SCP_DATA\SCP-CTRL-01\SESSIONLOGS\2023'; % year directory
% cd(strcat("23",answer)) %opening date folder
cd(answer)
InsideFolder = ls; %gets what is inside the date folder
load(InsideFolder(end,:)); %load the mat file inside the  date folder
loadedDATA = array2table(report_struct.data,'VariableNames',report_struct.header); % converts data which is structure to table
Rewarded_Aborted  = report_struct.unique_lists.A_OutcomeENUM(loadedDATA.A_OutcomeENUM_idx); % this vector shows which trial was aborted, which was successful,
% if you use a cellarray.a vector, you create repetiton of cell member
% and vector is used as index( I learned it from Igor!) 
% example C = cell(1,3) C{1} = 'a' C{2} = 'b' C{3} = 'c'  C([1 2 1 2 2 3
% 3]) = {'a'}
%       {'b'}
%       {'a'}
%       {'b'}
%       {'b'}
%       {'c'}
%       {'c'}
Trial_TaskType = report_struct.unique_lists.A_TrialSubTypeENUM(loadedDATA.A_TrialSubTypeENUM_idx); % this vector shows trial type based on task.
RewardedCount = sum(strcmp(Rewarded_Aborted,'REWARD')); %it gives you number of rewarded trials: ( I learned it from Igor!) strcmp compares two string and the output is one logical(1 or 0)
% becarfeul that strcmp is letter sensitive and it compares the whole
% strings (not letter by letter, if you want to compare strings letter by
% letter use: txt = ["This" "is a" "string" "array" "."];
%%pat = lettersPattern;
%contains(txt,pat)
%% AS A SANITY CHECK, COMPARE RewardedCount with what is reported in the excel file (number of rewarded trials) for that session)
RewardedID = find(strcmp(Rewarded_Aborted,'REWARD')); % indices of rewarded trials
SoloAID = find(strcmp(Trial_TaskType,'SoloA')); % Be careful! This vector contains all trial IDs that presumably were SoloA, (rewarded "AND" SoloA is in TaskType_AND_Rewarded vector)
SemiSoloID = find(strcmp(Trial_TaskType,'SemiSolo'));

RewadValues = loadedDATA.A_NumberRewardPulsesDelivered_HIT(RewardedID); % this: loadedDATA.A_NumberRewardPulsesDelivered_HIT cotains
% reward values on each trials, 0 means trial was aborted, 1 means 1 from
% the payoff matrix and 2 means 2 from the payoff matrix, it is filtered by
% RewardedID because we only want rewarded values on rewarded trials.
TaskType_AND_Rewarded = Trial_TaskType(RewardedID);

SoloA_AND_RewardedID = intersect(SoloAID,RewardedID); % I learned it from Igor!,insted of "AND rule filter" simply use builtin function "intersect"
SemiSolo_AND_RewardedID = intersect(SemiSoloID,RewardedID);


diffGoSignalTime_ms_AllTrials = loadedDATA.A_GoSignalTime_ms - loadedDATA.B_GoSignalTime_ms; % negative means actor A is first 
% initiation of each trial is by "Go signal", if we seperate Go signal time
% of each subject from each other, it will be clear who was the first
% actor, % pay attention this vector is all trials (aborted and rewarded)
diffGoSignalTime_ms_Rewarded = diffGoSignalTime_ms_AllTrials(RewardedID); 

RT_A_ms_AllTrials  = loadedDATA.A_InitialFixationReleaseTime_ms - loadedDATA.A_GoSignalTime_ms;
RT_B_ms_AllTrials  = loadedDATA.B_InitialFixationReleaseTime_ms - loadedDATA.B_GoSignalTime_ms;

RT_A_ms_Rewarded  = RT_A_ms_AllTrials(RewardedID)
RT_B_ms_Rewarded  = RT_B_ms_AllTrials(RewardedID)

Actor_A = string(report_struct.unique_lists.A_Name)
Actor_B = string(report_struct.unique_lists.B_Name)

%% plotting: x-ax : trial number   y-ax: reward value
% A colour is always red
scatter(1:numel(RewardedID),RewadValues,"|")
yticks(unique(loadedDATA.A_NumberRewardPulsesDelivered_HIT))
ylim([min(RewadValues)-0.1 max(RewadValues)+0.1])
hold on

%split into 3 categories: simultaneous, A first, B first
% RTs are defined correctly? Intitial release and Go epoch?

