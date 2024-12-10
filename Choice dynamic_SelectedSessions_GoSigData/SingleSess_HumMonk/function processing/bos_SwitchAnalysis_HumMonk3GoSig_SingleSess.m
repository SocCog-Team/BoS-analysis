% Define the base directory where the project is located (adjust as necessary)
% You might replace this with a base directory that's flexible for the user's setup.
baseFunctDir = 'C:\Users\zahra\OneDrive\Documents\GitHub\BoS-analysis';

% Define the specific paths for functions and data
functionsDir = fullfile(baseFunctDir, 'Functions for ChoiceDynamicAnalysis_AllDataSets');
%dataDir = fullfile(baseDir, 'Clean_DATA_Seb', 'NHP');
% Define the base network path as a string
baseDataPath = '\\172.16.9.188\snd\taskcontroller\DataExchange\Zahra\Data';

% Define the subfolder path
subFolder = fullfile('Clean_DATA_Seb', 'NewData_ThreeGoSignal');

% Combine the paths using fullfile
DataDir = fullfile(baseDataPath, subFolder);

% Add the functions directory to MATLAB's search path
addpath(functionsDir);


% Specify the starting directory for data processing
starting_dir = DataDir;


% Example: Check if paths are added correctly
if ~exist(functionsDir, 'dir')
    error('Functions directory does not exist.');
end
if ~exist(DataDir, 'dir')
    error('Data directory does not exist.');
end
%%
InsideFold = dir(starting_dir);
AllFolders = {InsideFold.name};
str = AllFolders;
num = regexp(str, '\w+', 'match');
emptyCells = cellfun('isempty', num);
AllFolders = str(~emptyCells);
Actors = {'A','B'};

TimeExtractionNameA = {'A_InitialTargetReleaseRT','A_IniTargRel_05MT_RT','A_GoSignalTime'};
TimeExtractionNameB = {'B_InitialTargetReleaseRT','B_IniTargRel_05MT_RT','B_GoSignalTime'};

%%
%This is an example how you can soft code Time variables:
%TimeVarA = TransientData.FullPerTrialStruct.(TimeExtractionNameA{1});
% A_RT = TimeVarA(TransientData.TrialsInCurrentSetIdx)
%%




% NaiveConditionString = 'Naiv'
% AllConfConditionString = 'Confederate';
% trainedName = 'Trained';
% ConfTrainedString = 'ConfederateTrained'
% NaiveIdx = contains(AllFolders,NaiveConditionString)
% ConditionIndex = contains(AllFolders, AllConfConditionString); %filter out Naive folders
% NOTtrainedIdx = ~contains(AllFolders, trainedName); %filter out only confederate
% ConfTrainedTogetherConditionIndex = xor(ConditionIndex,NOTtrainedIdx);
% ConfTrainedTogetherConditionIndex = ConfTrainedTogetherConditionIndex & (~NaiveIdx);
% %ConditionIndex = ConditionIndex(NOTtrainedIdx);
% ConditionIndex = ConfTrainedTogetherConditionIndex
MonkeyString = 'CuriusElmo';
HumanString = 'HP';
MonkeyIndex = contains(AllFolders,MonkeyString);
MonkeyFoldersName = AllFolders(MonkeyIndex);
HumanMonkeyIndex =contains(AllFolders,HumanString);
HumanMonkeyFoldersName = AllFolders(HumanMonkeyIndex);
activeFilename = matlab.desktop.editor.getActiveFilename;
[~, scriptName, ~] = fileparts(activeFilename);
if contains(scriptName,'HumMonk')
    MonkeyFoldersName = [];
    MonkeyFoldersName = HumanMonkeyFoldersName;
end

ConditionFoldersName = MonkeyFoldersName;
%%

%% Define what do you want to look aton the Y axis? Choices or Time related behavior (AT or RT)
%WhatOnYaxis = 'TimeBehavior';
%WhatOnYaxis = 'ChoiceDynamic';

%% Time related behavior should be AT or RT or GoSig?

%TimeMeasuredBehv = 'AT';
%TimeMeasuredBehv = 'RT';
TimeMeasuredBehv = 'GoSig';

switch TimeMeasuredBehv
    case 'GoSig'
        TimeRange_ToleranceThreshold = 500;
    otherwise
        TimeRange_ToleranceThreshold = 100;
end
AT_ToleranceThreshold = TimeRange_ToleranceThreshold;
%%

StartingDir = starting_dir;
%% get the information for current script for functions that process and plot
activeFilename = matlab.desktop.editor.getActiveFilename;
[~, scriptName, ~] = fileparts(activeFilename);
%%


% Loop through each folder in ConditionFolders
for fol = 1 :length(ConditionFoldersName)

    % Get the folder name
    OpenedConditionFoldersName =  ConditionFoldersName{fol};
    [MergedData,MatFile_ActorBgotA_IndexNumber,CS,ACTORA,ACTORB,SessionDate,FirstSessActorA,FirstSessActorB,HumanSubj_AorB] = MergingSplittedSessions_GoSigData(scriptName,StartingDir,OpenedConditionFoldersName);
    Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet = CoreProcessing3of5ChoiceDynamic_GoSigDataSet(scriptName,MergedData,AT_ToleranceThreshold,MatFile_ActorBgotA_IndexNumber,HumanSubj_AorB);
    Plotting3of5ChoiceDynamic_GoSigDataSet(scriptName,ACTORA,ACTORB,FirstSessActorA,FirstSessActorB,SessionDate,MergedData,Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet);



end
% Clean up by removing the functions directory from the path after the script finishes
rmpath(functionsDir);

