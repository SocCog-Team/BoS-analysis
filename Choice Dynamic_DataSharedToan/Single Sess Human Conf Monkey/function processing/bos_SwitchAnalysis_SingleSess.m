
% Define the base directory where the project is located (adjust as necessary)
% You might replace this with a base directory that's flexible for the user's setup.
baseFunctDir = 'C:\Users\zahra\OneDrive\Documents\GitHub\BoS-analysis';

% Define the specific paths for functions and data
functionsDir = fullfile(baseFunctDir, 'Functions for ChoiceDynamicAnalysis_AllDataSets');
%dataDir = fullfile(baseDir, 'Clean_DATA_Seb', 'NHP');
% Define the base network path as a string
baseDataPath = '\\172.16.9.188\snd\taskcontroller\DataExchange\Zahra\Data';
%baseDataPath = 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes';

% Define the subfolder path
subFolder = fullfile('Clean_DATA_Seb', 'NHP');

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
NaiveConditionString = 'Naiv';
AllConfConditionString = 'Confederate';
trainedName = 'Trained';
ConfTrainedString = 'ConfederateTrained';
NaiveIdx = contains(AllFolders,NaiveConditionString);
ConditionIndex = contains(AllFolders, AllConfConditionString); %filter out Naive folders
NOTtrainedIdx = ~contains(AllFolders, trainedName); %filter out only confederate 
ConfTrainedTogetherConditionIndex = xor(ConditionIndex,NOTtrainedIdx);
ConfTrainedTogetherConditionIndex = ConfTrainedTogetherConditionIndex & (~NaiveIdx);
ConditionIndex = ConditionIndex(NOTtrainedIdx);
% ConditionIndex = ConfTrainedTogetherConditionIndex
ConditionFoldersName = AllFolders(ConditionIndex);


%%
AT_ToleranceThreshold = 100; % be aware that in this script, RT got replaced with Action time, AT. though the name of variable is still RT
%% Define what do you want to look aton the Y axis? Choices or Time related behavior (AT or RT)
WhatOnYaxis = 'TimeBehavior';
%WhatOnYaxis = 'ChoiceDynamic';

%% Time related behavior should be AT or RT?
TimeMeasuredBehv = 'AT';
%TimeMeasuredBehv = 'RT';

%%ConditionFoldersName = AllFolders(ConditionIndex);
StartingDir = starting_dir;
%% get the information for current script for functions that process and plot
activeFilename = matlab.desktop.editor.getActiveFilename;
[~, scriptName, ~] = fileparts(activeFilename);
%%
% Now, you can call your functions as needed
% Loop through each folder in ConditionFolders
for fol = 1 :length(ConditionFoldersName)

    % Get the folder name
    OpenedConditionFoldersName =  ConditionFoldersName{fol};
    [MergedData,MatFile_ActorBgotA_IndexNumber,CS,ACTORA,ACTORB,SessionDate,FirstSessActorA,FirstSessActorB] = MergingSplittedSessions_NoGoSigData(StartingDir,OpenedConditionFoldersName);
    Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet = CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet(WhatOnYaxis,TimeMeasuredBehv,scriptName,MergedData,AT_ToleranceThreshold,MatFile_ActorBgotA_IndexNumber);
    Plotting3of5ChoiceDynamic_NoGoSigDataSet(WhatOnYaxis,TimeMeasuredBehv,scriptName,ACTORA,ACTORB,FirstSessActorA,FirstSessActorB,SessionDate,MergedData,Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet);


end

% Clean up by removing the functions directory from the path after the script finishes
rmpath(functionsDir);


