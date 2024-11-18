function [MergedData,MatFile_ActorBgotA_IndexNumber,CS,ACTORA,ACTORB,SessionDate,FirstSessActorA,FirstSessActorB,HumanSubj_AorB] = MergingSplittedSessions_GoSigData(scriptName,StartingDir,OpenedConditionFoldersName)
CS = 0
Actors = {'A','B'};


% Get the folder name
folderName = fullfile(StartingDir, OpenedConditionFoldersName);
% Change directory to the folder
%cd(folderName);
MonkeyFoldersName_dirstruct = dir(fullfile(folderName, '*.mat'));

valid_ConditionFoldersName_dirstruct = MonkeyFoldersName_dirstruct(~[MonkeyFoldersName_dirstruct.isdir]);

valid_matfile_list = {valid_ConditionFoldersName_dirstruct.name};
if contains(scriptName,'MonkMonk')
    valid_matfile_list = valid_matfile_list(contains(valid_matfile_list,'JointTrials'))
end

PlayerA_Name = cell(1,length(valid_matfile_list))
for i_matfile = 1 : length(valid_matfile_list)
    MatFileName = valid_matfile_list{i_matfile};
    NeededString = extractBetween(MatFileName,'triallog','IC');
    PlayerAName = extractBetween(NeededString,Actors{1},Actors{2})
    PlayerA_Name{i_matfile} = extractBetween(PlayerAName,'.','.')
end
%% evaluate if the all mat file inside the current folder, have the same actor A or actor A changed to B in some sessions:
FirstSessActorA = PlayerA_Name{1}
FirstSessActorB = extractBetween(valid_matfile_list{1},'triallog','IC')
FirstSessActorB = extractBetween(FirstSessActorB,Actors{2},'_')
FirstSessActorB = extractAfter(FirstSessActorB,'.')
Actor_A_matchesIdx = cellfun(@(x) strcmp(x, FirstSessActorA), PlayerA_Name)
MatFile_ActorBgotA_IndexNumber = []
if sum(Actor_A_matchesIdx) ~= length(valid_matfile_list)
    MatFile_ActorBgotA_IndexNumber = find(~Actor_A_matchesIdx)
end
for i_matfile = 1 : length(valid_matfile_list)
    cur_valid_matfile = valid_matfile_list{i_matfile};

    cur_session_id = regexprep(regexp(cur_valid_matfile, '\w*\.\w*\.\w*\.\w*\.triallog', 'match'), '^DATA_', '');
    cur_session_id = regexprep(cur_session_id, '.triallog$', '');


    cur_session_id = fn_parse_session_id(cur_session_id);
    if i_matfile == 1
        cur_session_id_struct_arr = cur_session_id;
    else
        cur_session_id_struct_arr = [cur_session_id_struct_arr, cur_session_id];
    end
end

key_table = strcat({cur_session_id_struct_arr.YYYYMMDD_string}, {cur_session_id_struct_arr.subject_A}, {cur_session_id_struct_arr.subject_B});

[unique_keys, ~, unique_key_idx] = unique(key_table);
NotMergedDATA = cell(1,length(valid_matfile_list));
% if (length(unique_keys) < length(key_table))
for i_matfile = 1 : length(valid_matfile_list)

    NotMergedDATA{i_matfile} = load(fullfile(folderName, valid_matfile_list{i_matfile}));
end

UniqSess = unique(unique_key_idx);
MergedData = cell(1,numel(UniqSess));
AllDates_NotRepeat = unique(key_table)

extractNumbers = @(str) regexp(str, '[\d.]+', 'match');
AllDates_NotRepeat = cellfun(extractNumbers, AllDates_NotRepeat, 'UniformOutput', false);
for WholeSess = 1 : numel(UniqSess)
    SessId = unique_key_idx == UniqSess(WholeSess);
    MergedData{WholeSess} = NotMergedDATA(SessId);

end

   SubjA_All = {cur_session_id_struct_arr.subject_A};
    SubjB_All = {cur_session_id_struct_arr.subject_B};

    SubjA_NotRep_Sess = SubjA_All(UniqSess)
    SubjB_NotRep_Sess = SubjB_All(UniqSess)

    SubjA_LetterToNum = cellfun(@(x) regexprep(x, '[A-Za-z]', '1'), SubjA_NotRep_Sess, 'UniformOutput', false); %CONVERT EVERY LETTER TO 1
    SubjB_LetterToNum = cellfun(@(x) regexprep(x, '[A-Za-z]', '1'), SubjB_NotRep_Sess, 'UniformOutput', false); %CONVERT EVERY LETTER TO 1

    %The logic behind finding human actor: every human is encoded with two
    %letters so if we convert letters to 1 and find 11 (two 1s after each other), we
    %know if the subject was human or non human
    SubjA_numeric = cellfun(@str2double, SubjA_LetterToNum)
    SubjB_numeric = cellfun(@str2double, SubjB_LetterToNum)

    HumanSubj_AorB = cell(1,length(valid_matfile_list))
    HumanSubj_AorB(SubjA_numeric == 11) = {'A'};
    HumanSubj_AorB(SubjB_numeric == 11) = {'B'};


%% Merging two frist sessions to one session and two last sessions to one session
% NumberOfMerging = 2;  %number of sessions we want to look at
% FirstTwoMerged = cell(2,1);
% LastTwoMerged = cell(2,1);

%% Use cellfun to assign first two cells of MergedData to FirstTwoMerged
% FirstTwoMerged = cellfun(@(x) x, MergedData(1:NumberOfMerging), 'UniformOutput', false);

%% Use cellfun to assign last two cells of MergedData to LastTwoMerged
%LastTwoMerged = cellfun(@(x) x, MergedData(end-(NumberOfMerging-1):end), 'UniformOutput', false);

% FirstLastAll = [FirstTwoMerged;LastTwoMerged]
% NumberOfTimePoints = 2;  % we want to look at two time points, first and last periods of training

%FirstLastAll = [FirstTwoMerged;LastTwoMerged]
%NumberOfTimePoints = 2;  % we want to look at two time points, first and last periods of training
CS = length(MergedData);

 for idata = 1 : length(MergedData)
        ACTORA{idata} = cur_session_id_struct_arr(idata).subject_A;
        ACTORB{idata} = cur_session_id_struct_arr(idata).subject_B;
        SessionDate{idata} = string(AllDates_NotRepeat{idata});
 end


