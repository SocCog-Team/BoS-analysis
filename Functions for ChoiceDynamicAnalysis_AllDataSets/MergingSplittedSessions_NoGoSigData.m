function [MergedData,MatFile_ActorBgotA_IndexNumber,CS,ACTORA,ACTORB,SessionDate,FirstSessActorA,FirstSessActorB] = MergingSplittedSessions_NoGoSigData(StartingDir,OpenedConditionFoldersName)
CS = 0
Actors = {'A','B'};
folderName = fullfile(StartingDir, OpenedConditionFoldersName);

% Change directory to the folder
%cd(folderName);
ConditionFoldersName_dirstruct = dir(fullfile(folderName, '*.mat'));

valid_ConditionFoldersName_dirstruct = ConditionFoldersName_dirstruct(~[ConditionFoldersName_dirstruct.isdir]);

valid_matfile_list = {valid_ConditionFoldersName_dirstruct.name};
PlayerA_Name = cell(1,length(valid_matfile_list));
for i_matfile = 1 : length(valid_matfile_list)
    MatFileName = valid_matfile_list{i_matfile};
    NeededString = extractBetween(MatFileName,'triallog','IC');
    PlayerAName = extractBetween(NeededString,Actors{1},Actors{2});
    PlayerA_Name{i_matfile} = extractBetween(PlayerAName,'.','.');
end
%% evaluate if the all mat file inside the current folder, have the same actor A or actor A changed to B in some sessions:
FirstSessActorA = PlayerA_Name{1};
FirstSessActorB = extractBetween(valid_matfile_list{1},'triallog','IC');
FirstSessActorB = extractBetween(FirstSessActorB,Actors{2},'_');
FirstSessActorB = extractAfter(FirstSessActorB,'.');
Actor_A_matchesIdx = cellfun(@(x) strcmp(x, FirstSessActorA), PlayerA_Name);
MatFile_ActorBgotA_IndexNumber = [];
if sum(Actor_A_matchesIdx) ~= length(valid_matfile_list)
    MatFile_ActorBgotA_IndexNumber = find(~Actor_A_matchesIdx);
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

AllDates_NotRepeat = unique(key_table);

extractNumbers = @(str) regexp(str, '[\d.]+', 'match');
AllDates_NotRepeat = cellfun(extractNumbers, AllDates_NotRepeat, 'UniformOutput', false);

for WholeSess = 1 : numel(UniqSess)
    SessId = unique_key_idx == UniqSess(WholeSess);
    MergedData{WholeSess} = NotMergedDATA(SessId);

    ACTORA{WholeSess} = cur_session_id_struct_arr.subject_A;
    ACTORB{WholeSess} = cur_session_id_struct_arr.subject_B;

    SessionDate{WholeSess} = string(AllDates_NotRepeat{WholeSess});




end
%% also you have to convert the MatFile_ActorBgotA_IndexNumber to idx of merged data
if  ~isempty(MatFile_ActorBgotA_IndexNumber)
    MatFile_ActorBgotA_IndexNumber =  unique_key_idx(MatFile_ActorBgotA_IndexNumber);
end
%%
if isempty(MatFile_ActorBgotA_IndexNumber)
    MatFile_ActorBgotA_IndexNumber = 0;
end
CS = length(MergedData);