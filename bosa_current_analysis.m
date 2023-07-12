function [loadedDATA, report_struct] = bosa_current_analysis(path2matfile)
%BOAS_TEST_LOAD_DATA		- loads sesssion matfile (triallog) 
%
% Input(s): 	path2matfile    - path to matfile
% Output(s):	out             - data
% Usage:        [loadedDATA, report_struct] = bosa_test_load_data(path2matfile);
% Examples:
% [loadedDATA, report_struct] = bosa_current_analysis('X:\KognitiveNeurowissenschaften\social_neuroscience_data\taskcontroller\SCP_DATA\SCP-CTRL-01\SESSIONLOGS\2023\230705\20230705T134053.A_Curius.B_RS.SCP_01.sessiondir\20230705T134053.A_Curius.B_RS.SCP_01.triallog.v017.mat');

load(path2matfile);
loadedDATA = array2table(report_struct.data,'VariableNames',report_struct.header); % make a table

outcomeAll  = report_struct.unique_lists.A_OutcomeENUM(loadedDATA.A_OutcomeENUM_idx);
trialSubTypeAll = report_struct.unique_lists.A_TrialSubTypeENUM(loadedDATA.A_TrialSubTypeENUM_idx);
NSuccess = sum(strcmp(outcomeAll,'REWARD'));

idxSuccess = find(strcmp(outcomeAll,'REWARD')); % successful trials
idxSoloA = find(strcmp(trialSubTypeAll,'SoloA'));
idxSemiSolo = find(strcmp(trialSubTypeAll,'SemiSolo'));

rewardSuccess = loadedDATA.A_NumberRewardPulsesDelivered_HIT(idxSuccess);
trialSubTypeSuccess = trialSubTypeAll(idxSuccess);

idxSuccessSoloA = intersect(idxSoloA,idxSuccess);
idxSuccessSemiSolo = intersect(idxSemiSolo,idxSuccess);


diffGoSignalTime_ms_All = loadedDATA.A_GoSignalTime_ms - loadedDATA.B_GoSignalTime_ms; % negative means A is first
diffGoSignalTime_ms_Success = diffGoSignalTime_ms_All(idxSuccess);

RT_A_ms  = loadedDATA.A_InitialFixationReleaseTime_ms - loadedDATA.A_GoSignalTime_ms;
RT_B_ms  = loadedDATA.B_InitialFixationReleaseTime_ms - loadedDATA.B_GoSignalTime_ms;

% split into 3 categories: simultaneous, A first, B first







