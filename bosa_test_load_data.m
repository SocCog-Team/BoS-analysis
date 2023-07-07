function out = bosa_test_load_data(path2matfile)
%BOAS_TEST_LOAD_DATA		- loads sesssion matfile (triallog) 
%
% Input(s): 	path2matfile    - path to matfile
% Output(s):	out             - data
% Usage:        out = bosa_test_load_data(path2matfile);
% Examples:
% out = bosa_test_load_data('X:\KognitiveNeurowissenschaften\social_neuroscience_data\taskcontroller\SCP_DATA\SCP-CTRL-01\SESSIONLOGS\2023\230705\20230705T134053.A_Curius.B_RS.SCP_01.sessiondir\20230705T134053.A_Curius.B_RS.SCP_01.triallog.v017.mat');

load(path2matfile);

TTT = array2table(report_struct.data,'VariableNames',report_struct.header); % make a table


out.T = T;

