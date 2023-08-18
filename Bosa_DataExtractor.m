%% before running the function, go to task controller, insert the user and pass
%% There are some sessions that contains no behavioral data, they are replaced by 'NaN' in the output
function [DataAllsessions DataNamesAllSessions] = Bosa_DataExtractor(Year)
%% Year = '2023'
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
cd(InsideFolder(end));
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
cd ..\..\..
