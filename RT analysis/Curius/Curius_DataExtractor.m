%% before running the function, go to task controller, insert the user and pass
%% There are some sessions that contains no behavioral data, they are replaced by 'NaN' in the output


% function [DataAllsessions DataNamesAllSessions] = Curius_DataExtractor(Year)
Year = '2023'
NameOfDirectory = strcat('\\172.16.9.188\snd\taskcontroller\SCP_DATA\SCP-CTRL-01\SESSIONLOGS\',Year);
cd(NameOfDirectory)
MonthsFolders = dir;
MonthsFolders = struct2cell(MonthsFolders);
MonthsFolders = MonthsFolders(1,:);
pat = digitsPattern; %pattern to detect 6 digit number, the goal is to remove '.' from the months names
Months = string(MonthsFolders(contains(MonthsFolders,pat)));
DataNamesAllSessions = cell(length(Months),1);
DataAllsessions = cell(length(Months),1);
for Day = 1 : length(Months)
    cd(Months(Day))
InsideFolder = dir;
InsideFolder = struct2cell(InsideFolder);
InsideFolder = InsideFolder(1,:);
InsideFolder = string(InsideFolder(contains(InsideFolder,pat)));
PAT1 = 'sessiondir';
if contains(InsideFolder,PAT1) == 0
    cd ..\
    DataNamesAllSessions{Day} = NaN;
    DataAllsessions{Day} = NaN;
end
if sum(contains(InsideFolder,PAT1))>0
PAT2 = 'GAZE';
InsideFolder(contains(InsideFolder,PAT2)) = [];
PAT3 = 'Synapse';
InsideFolder(contains(InsideFolder,PAT3)) = [];
PAT4 = 'Test';
InsideFolder(contains(InsideFolder,PAT4)) = [];
if isempty(InsideFolder)
     cd ..\
    DataNamesAllSessions{Day} = NaN;
    DataAllsessions{Day} = NaN;
end
if ~isempty(InsideFolder)
   PAT_SpecificSess1 = ("20230328"|"20230707");
   if sum(contains(InsideFolder,"20230328"))>0
      SpecificFolderNumber = 2; 
        cd(InsideFolder(SpecificFolderNumber));
   end
   if sum(contains(InsideFolder,"20230707"))>0
      SpecificFolderNumber = 3; 
        cd(InsideFolder(SpecificFolderNumber));
   end
   if sum(contains(InsideFolder,PAT_SpecificSess1)) == 0
      cd(InsideFolder(end));
   end
MainFolder = dir;
MainFolder = struct2cell(MainFolder);
MainFolder = MainFolder(1,:);
PAT = 'v017';
DataNamesAllSessions{Day} = string(MainFolder(contains(MainFolder,PAT)));
DataAllsessions{Day} = load(DataNamesAllSessions{Day});
cd ..\..
end
end
end
cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes'
%%
DataNamesAllSessions = cellfun(@char, DataNamesAllSessions, 'UniformOutput', false);
PAT = 'triallog'
EmptySessionIDs = find(~contains(DataNamesAllSessions,PAT)); % there are some sessions that lack of behavioral data
% extract the IDs of those sessions and exclude them from the DataNamesAllSessions
DataNamesAllSessions(EmptySessionIDs) = [];
DataAllsessions(EmptySessionIDs) = [];
c = 1;
 %Mostly real data is located at the last folder of 'Insidefolder' otherwise  the location of exceptions are written in this variable
Corrupted_SessNum = {};
for SessNum = 1 : numel(DataAllsessions)
    if numel(fieldnames(DataAllsessions{SessNum}.report_struct))< 33
       Corrupted_SessNum{c} = DataNamesAllSessions{SessNum};
       c = c+1;
    end
end
%%
%% Just go to the session folders and look at the corrupted session, provide a list that which folder is real data and
%% either remove the corrupted session or define if conditions for that list while extracting data:
%% session: '20230323T140615.A_Curius.B_None.SCP_01.triallog.v017.mat' is corrupted, remove it from the data and name list
CorruptedPAT = '20230323T140615.A_Curius.B_None.SCP_01.triallog.v017.mat';
CorruptedID = find(contains(DataNamesAllSessions,CorruptedPAT));
DataNamesAllSessions{CorruptedID} = []
DataAllsessions{CorruptedID} = []
DataNamesAllSessions = cellfun(@char, DataNamesAllSessions, 'UniformOutput', false);
PAT = 'triallog'
EmptySessionIDs = find(~contains(DataNamesAllSessions,PAT)); % there are some sessions that lack of behavioral data
% extract the IDs of those sessions and exclude them from the DataNamesAllSessions
DataNamesAllSessions(EmptySessionIDs) = [];
DataAllsessions(EmptySessionIDs) = [];
%%
cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes\RT analysis\Curius'
 matlab.io.saveVariablesToScript('NameOfDataAllSessions','DataNamesAllSessions')
