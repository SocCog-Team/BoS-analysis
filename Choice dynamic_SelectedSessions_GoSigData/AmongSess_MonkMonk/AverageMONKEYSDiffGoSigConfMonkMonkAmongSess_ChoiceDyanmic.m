

% here imoprt the data:
close all,  clear,   clc
%%
%cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes\Clean_DATA_Seb\NHP'
%run('HPHP_fullPath.m');
% VBA_Path = fullfile('C:', 'Users', 'zahra', 'OneDrive', 'Documents', 'PostDoc_DPZ', 'Zahra codes', 'VBA_AllFunctions');
% addpath(VBA_Path)
starting_dir = fullfile('C:', 'Users', 'zahra', 'OneDrive', 'Documents', 'PostDoc_DPZ', 'Zahra codes', 'Clean_DATA_Seb', 'NewData_ThreeGoSignal');
% addpath(starting_dir)
% rmpath(starting_dir)

InsideFold = dir(starting_dir);
AllFolders = {InsideFold.name};
str = AllFolders;
num = regexp(str, '\w+', 'match');
emptyCells = cellfun('isempty', num);
AllFolders = str(~emptyCells);
Actors = {'A','B'};
calcSEM = @(data) std(data,1,'omitnan') / sqrt(size(data,1));
MainLineWidth = 1




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
HumanString = 'HP'
MonkeyIndex = contains(AllFolders,MonkeyString)
MonkeyFoldersName = AllFolders(MonkeyIndex);
HumanMonkeyIndex =contains(AllFolders,HumanString)
HumanMonkeyFoldersName = AllFolders(HumanMonkeyIndex);
activeFilename = matlab.desktop.editor.getActiveFilename;
[~, scriptName, ~] = fileparts(activeFilename);
if contains(scriptName,'HumMonk')
    MonkeyFoldersName = []
    MonkeyFoldersName = HumanMonkeyFoldersName;
end



ActionTimingMeasure = 'GoSig';
switch ActionTimingMeasure
    case 'GoSig'
        RT_ToleranceThreshold = 500;
    otherwise
        RT_ToleranceThreshold = 100;
end

ActorAcolor = [204 0 102]./255
ActorBcolor = [0 0 204]./255
ActorBAtSwitchCol = [64,224,208]./255 %[204 255 229]./255
ActorAatSwitchCol = [255 204 229]./255

% Loop through each folder in ConditionFolders
for fol = 1:length(MonkeyFoldersName)
    CS = 0


    % Get the folder name
    folderName = fullfile(starting_dir, MonkeyFoldersName{fol});

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
    for WholeSess = 1 : numel(UniqSess)
        SessId = unique_key_idx == UniqSess(WholeSess);
        MergedData{WholeSess} = NotMergedDATA(SessId);

    end
    %% also you have to convert the MatFile_ActorBgotA_IndexNumber to idx of merged data
    if  ~isempty(MatFile_ActorBgotA_IndexNumber)
        MatFile_ActorBgotA_IndexNumber =  unique_key_idx(MatFile_ActorBgotA_IndexNumber)
    end
    %%
    if isempty(MatFile_ActorBgotA_IndexNumber)
        MatFile_ActorBgotA_IndexNumber = 0
    end


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

    WholeSess_SelfOther = cell(2,3)
    WholeSess_OtherSelf = cell(2,3)

    WholeSess_CrossSelfOther = cell(2,3)
    WholeSess_CrossOtherSelf = cell(2,3)

    WholeSess_AtSwitchSelfother = cell(2,3)
    WholeSess_AtSwitchOtherSelf = cell(2,3)

    WholeSess_AtSwitchCrossSelfother = cell(2,3)
    WholeSess_AtSwitchCrossOtherSelf = cell(2,3)



    for idata = 1 : length(MergedData)
        ColorChoice = [];
        RTA = [];
        RTB = [];
        diffGoSignalTime_ms_AllTrials = []
        diffGoSignalTime_ms_DyadicRewarded = []

        BeforeShedding = MergedData{idata};
        if length(BeforeShedding)>1
            for i_struct = 1 : length(BeforeShedding)
                TransientData = [];
                if i_struct == 1
                    TransientData = BeforeShedding{i_struct};
                    RewardedANDJointTrialTrialId = find(...
                        TransientData.FullPerTrialStruct.TrialIsRewarded ...
                        & TransientData.FullPerTrialStruct.TrialIsJoint ...
                        & (TransientData.FullPerTrialStruct.NumChoiceTargetsPerTrial == 2)...
                        );

                    DyadicTrialRewardedIdx = intersect(RewardedANDJointTrialId, TransientData.TrialSets.ByTrialSubType.Dyadic);

                    SemiSoloTrialRewardedIdx = intersect(RewardedANDJointTrialId, TransientData.TrialSets.ByTrialSubType.SemiSolo);


                    % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)
                    if ismember(idata,MatFile_ActorBgotA_IndexNumber)
                        WholeTrialsChoiceVectorA = TransientData.FullPerTrialStruct.PreferableTargetSelected_B;
                        WholeTrialsChoiceVectorB = TransientData.FullPerTrialStruct.PreferableTargetSelected_A;

                        ColorChoice(1,:) = WholeTrialsChoiceVectorA(DyadicTrialRewardedIdx); %own colour = 1
                        ColorChoice(2,:) = WholeTrialsChoiceVectorB(DyadicTrialRewardedIdx); %own colour = 1

                        % RTA = TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
                        % RTB = TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);

                        diffGoSignalTime_ms_AllTrials = TransientData.FullPerTrialStruct.B_GoSignalTime - TransientData.FullPerTrialStruct.A_GoSignalTime;
                        diffGoSignalTime_ms_DyadicRewarded = diffGoSignalTime_ms_AllTrials(DyadicTrialRewardedIdx)
                    else

                        WholeTrialsChoiceVectorA = TransientData.FullPerTrialStruct.PreferableTargetSelected_A;
                        WholeTrialsChoiceVectorB = TransientData.FullPerTrialStruct.PreferableTargetSelected_B;

                        ColorChoice(1,:) = WholeTrialsChoiceVectorA(DyadicTrialRewardedIdx); %own colour = 1
                        ColorChoice(2,:) = WholeTrialsChoiceVectorB(DyadicTrialRewardedIdx); %own colour = 1

                        % RTA = TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
                        % RTB = TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);

                        diffGoSignalTime_ms_AllTrials = TransientData.FullPerTrialStruct.A_GoSignalTime - TransientData.FullPerTrialStruct.B_GoSignalTime;
                        diffGoSignalTime_ms_DyadicRewarded = diffGoSignalTime_ms_AllTrials(DyadicTrialRewardedIdx)
                    end





                end
                if i_struct > 1

                    TransientData = BeforeShedding{i_struct};

                    RewardedANDJointTrialTrialId = find(...
                        TransientData.FullPerTrialStruct.TrialIsRewarded ...
                        & TransientData.FullPerTrialStruct.TrialIsJoint ...
                        & (TransientData.FullPerTrialStruct.NumChoiceTargetsPerTrial == 2)...
                        );

                    DyadicTrialRewardedIdx = intersect(RewardedANDJointTrialId, TransientData.TrialSets.ByTrialSubType.Dyadic);

                    SemiSoloTrialRewardedIdx = intersect(RewardedANDJointTrialId, TransientData.TrialSets.ByTrialSubType.SemiSolo);

                    % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)
                    if ismember(idata,MatFile_ActorBgotA_IndexNumber)
                        WholeTrialsChoiceVectorA = TransientData.FullPerTrialStruct.PreferableTargetSelected_B;
                        WholeTrialsChoiceVectorB = TransientData.FullPerTrialStruct.PreferableTargetSelected_A;


                        TransientsColorChoiceA = [];
                        TransientsColorChoiceA = [ColorChoice(1,:),WholeTrialsChoiceVectorA];

                        TransientsColorChoiceB = [];
                        TransientsColorChoiceB = [ColorChoice(2,:),WholeTrialsChoiceVectorB];

                        ColorChoice = [];

                        ColorChoice(1,:) = TransientsColorChoiceA; %own colour = 1
                        ColorChoice(2,:) = TransientsColorChoiceB; %own colour = 1


                        % TransientRTA = [];
                        % TransientRTB = [];
                        %
                        % TransientRTA = [RTA;TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx)];
                        % TransientRTB = [RTB;TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx)];
                        %
                        % RTA = [];
                        % RTB = [];
                        % RTA = TransientRTA;
                        % RTB = TransientRTB;


                        Transient_DiffGoSig = []


                        Transient_DiffGoSig = TransientData.FullPerTrialStruct.B_GoSignalTime - TransientData.FullPerTrialStruct.A_GoSignalTime;
                        Transient_DiffGoSig = Transient_DiffGoSig(DyadicTrialRewardedIdx);


                        diffGoSignalTime_ms_DyadicRewarded = [diffGoSignalTime_ms_DyadicRewarded;Transient_DiffGoSig]
                    else
                        WholeTrialsChoiceVectorA = TransientData.FullPerTrialStruct.PreferableTargetSelected_A;
                        WholeTrialsChoiceVectorB = TransientData.FullPerTrialStruct.PreferableTargetSelected_B;


                        TransientsColorChoiceA = [];
                        TransientsColorChoiceA = [ColorChoice(1,:),WholeTrialsChoiceVectorA];

                        TransientsColorChoiceB = [];
                        TransientsColorChoiceB = [ColorChoice(2,:),WholeTrialsChoiceVectorB];

                        ColorChoice = [];

                        ColorChoice(1,:) = TransientsColorChoiceA; %own colour = 1
                        ColorChoice(2,:) = TransientsColorChoiceB; %own colour = 1


                        % TransientRTA = [];
                        % TransientRTB = [];
                        %
                        % TransientRTA = [RTA;TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx)];
                        % TransientRTB = [RTB;TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx)];
                        %
                        % RTA = [];
                        % RTB = [];
                        % RTA = TransientRTA;
                        % RTB = TransientRTB;


                        Transient_DiffGoSig = []


                        Transient_DiffGoSig = TransientData.FullPerTrialStruct.A_GoSignalTime - TransientData.FullPerTrialStruct.B_GoSignalTime;
                        Transient_DiffGoSig = Transient_DiffGoSig(DyadicTrialRewardedIdx);


                        diffGoSignalTime_ms_DyadicRewarded = [diffGoSignalTime_ms_DyadicRewarded;Transient_DiffGoSig]
                    end






                end


            end

        end




        if isscalar(BeforeShedding)

            TransientData = BeforeShedding{1};
            % RewardedANDdyadicTrialId = intersect(TransientData.TrialSets.All(logical(TransientData.FullPerTrialStruct. ...
            %     TrialIsRewarded)), TransientData.TrialSets.All(logical(TransientData.FullPerTrialStruct. ...
            %     TrialIsJoint)));

            RewardedANDJointTrialTrialId = find(...
                TransientData.FullPerTrialStruct.TrialIsRewarded ...
                & TransientData.FullPerTrialStruct.TrialIsJoint ...
                & (TransientData.FullPerTrialStruct.NumChoiceTargetsPerTrial == 2)...
                );


            RewardedANDJointTrialId = find(...
                TransientData.FullPerTrialStruct.TrialIsRewarded ...
                & TransientData.FullPerTrialStruct.TrialIsJoint ...
                & (TransientData.FullPerTrialStruct.NumChoiceTargetsPerTrial == 2)...
                );

            DyadicTrialRewardedIdx = intersect(RewardedANDJointTrialId, TransientData.TrialSets.ByTrialSubType.Dyadic);

            SemiSoloTrialRewardedIdx = intersect(RewardedANDJointTrialId, TransientData.TrialSets.ByTrialSubType.SemiSolo);

            if ismember(idata,MatFile_ActorBgotA_IndexNumber)
                WholeTrialsChoiceVectorA = TransientData.FullPerTrialStruct.PreferableTargetSelected_B;
                WholeTrialsChoiceVectorB = TransientData.FullPerTrialStruct.PreferableTargetSelected_A;
                ColorChoice = [];

                ColorChoice(1,:) = WholeTrialsChoiceVectorA(DyadicTrialRewardedIdx); %own colour = 1
                ColorChoice(2,:) = WholeTrialsChoiceVectorB(DyadicTrialRewardedIdx); %own colour = 1



                % Coordinated_trial_ldx = A_ColorChoice | B_ColorChoice;

                %
                % RTA = [];
                % RTB = [];
                %
                % RTA = TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
                % RTB = TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);

                diffGoSignalTime_ms_AllTrials = []
                diffGoSignalTime_ms_DyadicRewarded = []
                diffGoSignalTime_ms_AllTrials = TransientData.FullPerTrialStruct.B_GoSignalTime - TransientData.FullPerTrialStruct.A_GoSignalTime;
                diffGoSignalTime_ms_DyadicRewarded = diffGoSignalTime_ms_AllTrials(DyadicTrialRewardedIdx)
            else
                WholeTrialsChoiceVectorA = TransientData.FullPerTrialStruct.PreferableTargetSelected_A;
                WholeTrialsChoiceVectorB = TransientData.FullPerTrialStruct.PreferableTargetSelected_B;
                ColorChoice = [];

                ColorChoice(1,:) = WholeTrialsChoiceVectorA(DyadicTrialRewardedIdx); %own colour = 1
                ColorChoice(2,:) = WholeTrialsChoiceVectorB(DyadicTrialRewardedIdx); %own colour = 1



                % Coordinated_trial_ldx = A_ColorChoice | B_ColorChoice;

                %
                % RTA = [];
                % RTB = [];
                %
                % RTA = TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
                % RTB = TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);

                diffGoSignalTime_ms_AllTrials = []
                diffGoSignalTime_ms_DyadicRewarded = []
                diffGoSignalTime_ms_AllTrials = TransientData.FullPerTrialStruct.A_GoSignalTime - TransientData.FullPerTrialStruct.B_GoSignalTime;
                diffGoSignalTime_ms_DyadicRewarded = diffGoSignalTime_ms_AllTrials(DyadicTrialRewardedIdx)
            end






        end

        if size(ColorChoice,1)>2
            ColorChoice = ColorChoice';
        end

        %% RT

        %% finding turns ids
        switch ActionTimingMeasure
            case 'RT'
                diffRT_AB = [];
                diffRT_AB = RTA - RTB;  % minus means actor A was first, o means simul, positive means Actor A was second

                ATurnIdx = [];
                ATurnIdx = nan(length(diffRT_AB),3);  %first column is actor A first, Second column is actor A/B simul, third column is Actor A second,
                tmp_AgoB = diffRT_AB < (- RT_ToleranceThreshold);
                tmp_BgoA = diffRT_AB > ( RT_ToleranceThreshold);
                tmp_ABgo = ~tmp_AgoB & ~tmp_BgoA;
            case 'GoSig'
                diffRT_AB = [];
                diffRT_AB = diffGoSignalTime_ms_DyadicRewarded;
                ATurnIdx = [];
                ATurnIdx = nan(length(diffRT_AB),3);  %first column is actor A first, Second column is actor A/B simul, third column is Actor A second,
                tmp_AgoB = diffRT_AB < (- RT_ToleranceThreshold);
                tmp_BgoA = diffRT_AB > ( RT_ToleranceThreshold);
                % tmp_ABgo = (diffRT_AB > 0) & (diffRT_AB < RT_ToleranceThreshold);
                tmp_ABgo = diffRT_AB == 0;

        end

        % ATurnIdx(:,1) = diffRT_AB<0;
        % ATurnIdx(:,2) = (diffRT_AB > 0) & (diffRT_AB < RT_ToleranceThreshold);
        % ATurnIdx(:,3) = diffRT_AB>0;

        ATurnIdx(:,1) = tmp_AgoB;
        ATurnIdx(:,2) = tmp_ABgo;
        ATurnIdx(:,3) = tmp_BgoA;


        BTurnIdx = [];
        BTurnIdx = fliplr(ATurnIdx);
        TurnIdx = [];
        TurnIdx(:,:,1) = ATurnIdx;
        TurnIdx(:,:,2) = BTurnIdx;
        %% finding switches ids:
        AswitchesIdx = [];
        BswitchesIdx = [];

        AswitchesIdx = find(abs(diff(ColorChoice(1,:))))+1;
        BswitchesIdx = find(abs(diff(ColorChoice(2,:))))+1;

        A_SelfToOther = [];
        A_OtherToSelf = [];
        A_SelfToOther = find(diff(ColorChoice(1,:))<0)+1;
        A_OtherToSelf = find(diff(ColorChoice(1,:))>0)+1;

        B_SelfToOther = [];
        B_OtherToSelf = [];
        B_SelfToOther = find(diff(ColorChoice(2,:))<0)+1;
        B_OtherToSelf = find(diff(ColorChoice(2,:))>0)+1;

        %% variables critical for switch determination

        BeforeAfter_Length = 5;
        WindowAroundSwitch = BeforeAfter_Length-1;
        MinimumSameColor = 3;
        %%
        ANotValidSwitchID_All_ID = [];
        BNotValidSwitchID_All_ID = [];

        %% in this part you eliminate too early or too final switches (switches at the begining of choice vector which happen before 6 choices
        %% and at the end of choice vector))

        if sum(AswitchesIdx-(BeforeAfter_Length+1)<= 0) >= 1
            ANotValidSwitchID_All_ID = find(AswitchesIdx-(BeforeAfter_Length+1)<= 0);
        end

        if sum(BswitchesIdx-(BeforeAfter_Length+1)<= 0) >= 1
            BNotValidSwitchID_All_ID = find(BswitchesIdx-(BeforeAfter_Length+1)<= 0);
        end

        if sum(AswitchesIdx+(BeforeAfter_Length+1)>= numel(ColorChoice(1,:)))>= 1
            if isempty(ANotValidSwitchID_All_ID)
                ANotValidSwitchID_All_ID = find(AswitchesIdx+(BeforeAfter_Length+1)>= numel(ColorChoice(1,:)));
            end
            if ~isempty(ANotValidSwitchID_All_ID)
                ANotValidSwitchID_All_ID = [ANotValidSwitchID_All_ID,find(AswitchesIdx+(BeforeAfter_Length+1)>= numel(ColorChoice(1,:)))];
            end
        end

        if sum(BswitchesIdx+(BeforeAfter_Length+1)>= numel(ColorChoice(2,:)))>= 1
            if isempty(BNotValidSwitchID_All_ID)
                BNotValidSwitchID_All_ID = find(BswitchesIdx+(BeforeAfter_Length+1)>= numel(ColorChoice(2,:)));
            end
            if ~isempty(BNotValidSwitchID_All_ID)
                BNotValidSwitchID_All_ID = [BNotValidSwitchID_All_ID,find(BswitchesIdx+(BeforeAfter_Length+1)>= numel(ColorChoice(2,:)))];
            end
        end

        ANotValidSwitchID_All_ID = unique(ANotValidSwitchID_All_ID);
        BNotValidSwitchID_All_ID = unique(BNotValidSwitchID_All_ID);

        A_SelfToOther = setdiff(A_SelfToOther,AswitchesIdx(ANotValidSwitchID_All_ID));
        A_OtherToSelf = setdiff(A_OtherToSelf,AswitchesIdx(ANotValidSwitchID_All_ID));

        B_SelfToOther = setdiff(B_SelfToOther,BswitchesIdx(BNotValidSwitchID_All_ID));
        B_OtherToSelf = setdiff(B_OtherToSelf,BswitchesIdx(BNotValidSwitchID_All_ID));

        % SelfToOther = {};
        % SelfToOther{1} = A_SelfToOther;
        % SelfToOther{2} = B_SelfToOther;
        %
        % OtherToSelf = {};
        % OtherToSelf{1} = A_OtherToSelf;
        % OtherToSelf{2} = B_OtherToSelf;

        AswitchesIdx(ANotValidSwitchID_All_ID) = [];
        BswitchesIdx(BNotValidSwitchID_All_ID) = [];

        %% here you determine if there are at least 'MinimumSameColor'
        %% for example at least 3 same choice should be before the switch and 3 same choice should be after the switch otherwise switch is not valid
        ANotValidSwitchID_SelfOther = [];
        BNotValidSwitchID_SelfOther = [];
        SelfOther_NotValidSwitchId = cell(2,1)
        for Ac = 1 : 2
            str = sprintf('%c_SelfToOther', 'A' + (Ac-1));
            c = 1;
            for i_SelfOther = 1 : numel(eval(str))
                DATA = []
                DATA = ColorChoice(Ac,:);
                SwitchVec = []
                SwitchVec = eval(str);
                SwitchChoice = 0;
                BeforeIdx = SwitchVec(i_SelfOther)-BeforeAfter_Length;
                AfterIdx =  SwitchVec(i_SelfOther)+BeforeAfter_Length;

                BeforeSwitchVec =  sum(DATA(BeforeIdx:(BeforeIdx+WindowAroundSwitch)) == not(SwitchChoice)) >= MinimumSameColor
                AfterSwitchVec = sum(DATA(SwitchVec(i_SelfOther)+1:AfterIdx) == SwitchChoice) >= MinimumSameColor
                if not(BeforeSwitchVec&AfterSwitchVec)
                    SelfOther_NotValidSwitchId{Ac}(c) = SwitchVec(i_SelfOther)
                    c = c+1;
                end
            end
        end

        ANotValidSwitchID_SelfOther =  SelfOther_NotValidSwitchId{1};
        BNotValidSwitchID_SelfOther = SelfOther_NotValidSwitchId{2};
        %%
        ANotValidSwitchID_OtherSelf = [];
        BNotValidSwitchID_OtherSelf = [];
        OtherSelf_NotValidSwitchId = cell(2,1);
        for Ac = 1 : 2
            str = sprintf('%c_OtherToSelf', 'A' + (Ac-1));
            c = 1;
            for i_OtherSelf = 1 : numel(eval(str))
                DATA = [];
                DATA = ColorChoice(Ac,:);
                SwitchVec = []
                SwitchVec = eval(str);
                SwitchChoice = 1;
                BeforeIdx = SwitchVec(i_OtherSelf) - BeforeAfter_Length;
                AfterIdx = SwitchVec(i_OtherSelf) + BeforeAfter_Length;

                BeforeSwitchVec = sum(DATA(BeforeIdx:(BeforeIdx+WindowAroundSwitch)) == not(SwitchChoice)) >= MinimumSameColor;
                AfterSwitchVec = sum(DATA(SwitchVec(i_OtherSelf) + 1 : AfterIdx) == SwitchChoice) >= MinimumSameColor;
                if not(BeforeSwitchVec & AfterSwitchVec)
                    OtherSelf_NotValidSwitchId{Ac}(c) = SwitchVec(i_OtherSelf);
                    c = c + 1;
                end
            end
        end

        ANotValidSwitchID_OtherSelf = OtherSelf_NotValidSwitchId{1};
        BNotValidSwitchID_OtherSelf = OtherSelf_NotValidSwitchId{2};
        %%
        A_SelfToOther = setdiff(A_SelfToOther,ANotValidSwitchID_SelfOther);
        A_OtherToSelf = setdiff(A_OtherToSelf,ANotValidSwitchID_OtherSelf);

        B_SelfToOther = setdiff(B_SelfToOther,BNotValidSwitchID_SelfOther);
        B_OtherToSelf = setdiff(B_OtherToSelf,BNotValidSwitchID_OtherSelf);

        SelfToOther = {};
        SelfToOther{1} = A_SelfToOther;
        SelfToOther{2} = B_SelfToOther;

        OtherToSelf = {};
        OtherToSelf{1} = A_OtherToSelf;
        OtherToSelf{2} = B_OtherToSelf;







        %% defining switching vetors: timed defined all trials (red curve)


        A_AllTurn_NonTurn_ReplacedNan = nan(length(diffRT_AB),3); %1st column: first, 2d column: simul...
        B_AllTurn_NonTurn_ReplacedNan = nan(length(diffRT_AB),3);

        for Turn = 1 : 3
            A_AllTurn_NonTurn_ReplacedNan([logical(BTurnIdx(:,Turn))],Turn) = ones(sum(BTurnIdx(:,Turn)),1); %all timings are applied based on actor B time
            B_AllTurn_NonTurn_ReplacedNan([logical(BTurnIdx(:,Turn))],Turn) = ones(sum(BTurnIdx(:,Turn)),1);
        end
        AllTurn_NonTurn_ReplacedNan = [];
        AllTurn_NonTurn_ReplacedNan(:,:,1) = A_AllTurn_NonTurn_ReplacedNan; %first page belongs to actor A
        AllTurn_NonTurn_ReplacedNan(:,:,2) = B_AllTurn_NonTurn_ReplacedNan;

        %row: turn number column: mean of before, at, after switch page: actor


        for AC = 1 : 2
            for Turn = 1 : 3
                NeededSwitchVector = [];
                NeededSwitchVector = AllTurn_NonTurn_ReplacedNan(:,Turn,AC);
                ColorVec = ColorChoice(AC,:)';
                NeededSwitchVector(~isnan(NeededSwitchVector)) = ColorVec(~isnan(NeededSwitchVector));
                SwitchTypeSelfOtheridx = [];
                SwitchTypeOtherSelfidx = [];
                SwitchTypeSelfOtheridx = SelfToOther{AC};
                SwitchTypeOtherSelfidx = OtherToSelf{AC};
                SelfOther_NeededSwitchVector = nan(numel(SwitchTypeSelfOtheridx),BeforeAfter_Length+1+BeforeAfter_Length);
                OtherSelf_NeededSwitchVector = nan(numel(SwitchTypeOtherSelfidx),BeforeAfter_Length+1+BeforeAfter_Length);
                for i = 1 : numel(SwitchTypeSelfOtheridx)
                    BEG = SwitchTypeSelfOtheridx(i)-BeforeAfter_Length;
                    END = SwitchTypeSelfOtheridx(i)+BeforeAfter_Length;
                    SelfOther_NeededSwitchVector(i,:) = NeededSwitchVector(BEG:END);
                end
                for i = 1 : numel(SwitchTypeOtherSelfidx)
                    BEG = SwitchTypeOtherSelfidx(i)-BeforeAfter_Length;
                    END = SwitchTypeOtherSelfidx(i)+BeforeAfter_Length;
                    OtherSelf_NeededSwitchVector(i,:) = NeededSwitchVector(BEG:END);
                end
                if idata == 1
                    A_SelfOther{AC,Turn} = SelfOther_NeededSwitchVector;
                    A_OtherSelf{AC,Turn} = OtherSelf_NeededSwitchVector;
                else
                    A_SelfOther{AC,Turn} = [A_SelfOther{AC,Turn};SelfOther_NeededSwitchVector];
                    A_OtherSelf{AC,Turn} = [A_OtherSelf{AC,Turn};OtherSelf_NeededSwitchVector];
                end
                WholeSess_SelfOther{AC,Turn} = A_SelfOther{AC,Turn};
                WholeSess_OtherSelf{AC,Turn} = A_OtherSelf{AC,Turn};

                % MeanSelfOther(Turn,:,AC,idata) = mean(SelfOther_NeededSwitchVector,1,'omitnan');
                % if calcSEM(SelfOther_NeededSwitchVector) == 0
                %     SEM_OverSess_SelfOther(Turn,:,AC,idata) = zeros(1,(BeforeAfter_Length*2)+1);
                % else
                %     SEM_OverSess_SelfOther(Turn,:,AC,idata) = calcSEM(SelfOther_NeededSwitchVector);
                % end
                %
                %
                % MeanOtherSelf(Turn,:,AC,idata) = mean(OtherSelf_NeededSwitchVector,1,'omitnan');
                % if calcSEM(OtherSelf_NeededSwitchVector) == 0
                %     SEM_OverSess_OtherSelf(Turn,:,AC,idata) = zeros(1,(BeforeAfter_Length*2)+1);
                % else
                %     SEM_OverSess_OtherSelf(Turn,:,AC,idata) = calcSEM(OtherSelf_NeededSwitchVector);
                % end


                SelfOtherSwitchNum(Turn,AC,idata) = sum(~isnan(SelfOther_NeededSwitchVector(:,6)));
                OtherSelfSwitchNum(Turn,AC,idata) = sum(~isnan(OtherSelf_NeededSwitchVector(:,6)));

            end
        end
        %% CRISS CROSS : When actor A switches, what happen to actor B and vice versa


        for AC = 1 : 2
            for Turn = 1 : 3
                NeededSwitchVector = [];
                NeededSwitchVector = AllTurn_NonTurn_ReplacedNan(:,Turn,AC);
                ColorVec = ColorChoice(AC,:)';
                NeededSwitchVector(~isnan(NeededSwitchVector)) = ColorVec(~isnan(NeededSwitchVector));
                SwitchTypeSelfOtheridx = [];
                SwitchTypeOtherSelfidx = [];
                if AC == 1
                    SwitchTypeSelfOtheridx = SelfToOther{2};
                    SwitchTypeOtherSelfidx = OtherToSelf{2};
                else
                    SwitchTypeSelfOtheridx = SelfToOther{1};
                    SwitchTypeOtherSelfidx = OtherToSelf{1};
                end

                SelfOther_NeededSwitchVector = nan(numel(SwitchTypeSelfOtheridx),BeforeAfter_Length+1+BeforeAfter_Length);
                OtherSelf_NeededSwitchVector = nan(numel(SwitchTypeOtherSelfidx),BeforeAfter_Length+1+BeforeAfter_Length);
                for i = 1 : numel(SwitchTypeSelfOtheridx)
                    BEG = SwitchTypeSelfOtheridx(i)-BeforeAfter_Length;
                    END = SwitchTypeSelfOtheridx(i)+BeforeAfter_Length;
                    SelfOther_NeededSwitchVector(i,:) = NeededSwitchVector(BEG:END);
                end
                for i = 1 : numel(SwitchTypeOtherSelfidx)
                    BEG = SwitchTypeOtherSelfidx(i)-BeforeAfter_Length;
                    END = SwitchTypeOtherSelfidx(i)+BeforeAfter_Length;
                    OtherSelf_NeededSwitchVector(i,:) = NeededSwitchVector(BEG:END);
                end

                if idata == 1
                    A_CrossSelfOther{AC,Turn} = SelfOther_NeededSwitchVector;
                    A_CrossOtherSelf{AC,Turn} = OtherSelf_NeededSwitchVector;
                else
                    A_CrossSelfOther{AC,Turn} = [A_CrossSelfOther{AC,Turn};SelfOther_NeededSwitchVector];
                    A_CrossOtherSelf{AC,Turn} = [A_CrossOtherSelf{AC,Turn};OtherSelf_NeededSwitchVector];
                end
                WholeSess_CrossSelfOther{AC,Turn} = A_CrossSelfOther{AC,Turn};
                WholeSess_CrossOtherSelf{AC,Turn} = A_CrossOtherSelf{AC,Turn};

                % CrossMeanSelfOther(Turn,:,AC,idata) = mean(SelfOther_NeededSwitchVector,1,'omitnan');
                % if calcSEM(SelfOther_NeededSwitchVector) == 0
                %     CrossSEM_OverSess_SelfOther(Turn,:,AC,idata) = zeros(1,(BeforeAfter_Length*2)+1);
                % end
                % if size(calcSEM(SelfOther_NeededSwitchVector),2) == 1
                %     CrossSEM_OverSess_SelfOther(Turn,:,AC,idata) = nan(1,(BeforeAfter_Length*2)+1);
                % else
                %     CrossSEM_OverSess_SelfOther(Turn,:,AC,idata) = calcSEM(SelfOther_NeededSwitchVector);
                % end
                %
                %
                %
                % CrossMeanOtherSelf(Turn,:,AC,idata) = mean(OtherSelf_NeededSwitchVector,1,'omitnan');
                % if calcSEM(OtherSelf_NeededSwitchVector) == 0
                %     CrossSEM_OverSess_OtherSelf(Turn,:,AC,idata) = zeros(1,(BeforeAfter_Length*2)+1);
                % end
                % if size(calcSEM(OtherSelf_NeededSwitchVector),2) == 1
                %     CrossSEM_OverSess_OtherSelf(Turn,:,AC,idata) = nan(1,(BeforeAfter_Length*2)+1);
                % else
                %     CrossSEM_OverSess_OtherSelf(Turn,:,AC,idata) = calcSEM(OtherSelf_NeededSwitchVector);
                % end


                CrossSelfOtherSwitchNum(Turn,AC,idata) = sum(~isnan(SelfOther_NeededSwitchVector(:,6)));
                CrossOtherSelfSwitchNum(Turn,AC,idata) = sum(~isnan(OtherSelf_NeededSwitchVector(:,6)));


            end
        end



        %% defining switching vetors: At switch timw defined (pink curve)

        for Turn = 1 : 3
            for AC = 1 : 2
                if AC == 1
                    SelfToOther_AtSwitch{AC,Turn} = intersect(SelfToOther{AC}',find(BTurnIdx(:,Turn)));
                    OtherToSelf_AtSwitch{AC,Turn} = intersect(OtherToSelf{AC}',find(BTurnIdx(:,Turn)));
                else
                    SelfToOther_AtSwitch{AC,Turn} = intersect(SelfToOther{AC}',find(BTurnIdx(:,Turn)));
                    OtherToSelf_AtSwitch{AC,Turn} = intersect(OtherToSelf{AC}',find(BTurnIdx(:,Turn)));
                end
            end
        end
        %This cell contains idx of swhcites based on actor's turn for example when actor was first and switch happens %first row belong to actor A
        %second row belongs to Actor B %first cell is switches when actor was first, second cell is simul, third cell is second
        %row: turn number column: mean of before, at, after switch page: actor




        for AC = 1 : 2
            for Turn = 1 : 3
                NeededSwitchVector = ColorChoice(AC,:)';
                SwitchTypeSelfOtheridx = SelfToOther_AtSwitch{AC,Turn};
                SwitchTypeOtherSelfidx = OtherToSelf_AtSwitch{AC,Turn};
                SelfOther_NeededSwitchVector = nan(numel(SwitchTypeSelfOtheridx),BeforeAfter_Length+1+BeforeAfter_Length);
                OtherSelf_NeededSwitchVector = nan(numel(SwitchTypeOtherSelfidx),BeforeAfter_Length+1+BeforeAfter_Length);
                for i = 1 : numel(SwitchTypeSelfOtheridx)
                    BEG = SwitchTypeSelfOtheridx(i)-BeforeAfter_Length;
                    END = SwitchTypeSelfOtheridx(i)+BeforeAfter_Length;
                    SelfOther_NeededSwitchVector(i,:) = NeededSwitchVector(BEG:END);
                end
                for i = 1 : numel(SwitchTypeOtherSelfidx)
                    BEG = SwitchTypeOtherSelfidx(i)-BeforeAfter_Length;
                    END = SwitchTypeOtherSelfidx(i)+BeforeAfter_Length;
                    OtherSelf_NeededSwitchVector(i,:) = NeededSwitchVector(BEG:END);
                end


                if idata == 1
                    A_AtSwitchSelfother{AC,Turn} = SelfOther_NeededSwitchVector;
                    A_AtSwitchOtherSelf{AC,Turn} = OtherSelf_NeededSwitchVector;
                else
                    A_AtSwitchSelfother{AC,Turn} = [A_AtSwitchSelfother{AC,Turn};SelfOther_NeededSwitchVector];
                    A_AtSwitchOtherSelf{AC,Turn} = [A_AtSwitchOtherSelf{AC,Turn};OtherSelf_NeededSwitchVector];
                end
                WholeSess_AtSwitchSelfother{AC,Turn} = A_AtSwitchSelfother{AC,Turn};
                WholeSess_AtSwitchOtherSelf{AC,Turn} = A_AtSwitchOtherSelf{AC,Turn};


                %
                % AtSwitch_MeanSelfOther(Turn,:,AC,idata) = mean(SelfOther_NeededSwitchVector,1,'omitnan');
                % if  calcSEM(SelfOther_NeededSwitchVector) == 0
                %     SEM_OverSessAtSwitch_SelfOther(Turn,:,AC,idata) = zeros(1,(BeforeAfter_Length*2)+1);
                % end
                % if size(calcSEM(SelfOther_NeededSwitchVector),2) == 1
                %     SEM_OverSessAtSwitch_SelfOther(Turn,:,AC,idata) = nan(1,(BeforeAfter_Length*2)+1);
                % else
                %     SEM_OverSessAtSwitch_SelfOther(Turn,:,AC,idata) = calcSEM(SelfOther_NeededSwitchVector);
                % end
                %
                % AtSwitc_MeanOtherSelf(Turn,:,AC,idata) = mean(OtherSelf_NeededSwitchVector,1,'omitnan');
                % if calcSEM(OtherSelf_NeededSwitchVector) == 0
                %     SEM_OverSessAtSwitch_OtherSelf(Turn,:,AC,idata) = zeros(1,(BeforeAfter_Length*2)+1);
                % end
                % if size(calcSEM(OtherSelf_NeededSwitchVector),2) == 1
                %     SEM_OverSessAtSwitch_OtherSelf(Turn,:,AC,idata) = nan(1,(BeforeAfter_Length*2)+1);
                % else
                %     SEM_OverSessAtSwitch_OtherSelf(Turn,:,AC,idata) = calcSEM(OtherSelf_NeededSwitchVector);
                % end


                AtSwitch_SelfOther_SwitchNum(Turn,AC,idata) = numel(SwitchTypeSelfOtheridx);
                AtSwitch_OtherSelf_SwitchNum(Turn,AC,idata) = numel(SwitchTypeOtherSelfidx);
            end
        end


        %% cross


        %% cross switches
        for Turn = 1 : 3
            for AC = 1 : 2
                if AC == 1
                    CrossSelfToOther_AtSwitch{AC,Turn} = intersect(SelfToOther{2}',find(BTurnIdx(:,Turn)));
                    CrossOtherToSelf_AtSwitch{AC,Turn} = intersect(OtherToSelf{2}',find(BTurnIdx(:,Turn)));
                else
                    CrossSelfToOther_AtSwitch{AC,Turn} = intersect(SelfToOther{1}',find(BTurnIdx(:,Turn)));
                    CrossOtherToSelf_AtSwitch{AC,Turn} = intersect(OtherToSelf{1}',find(BTurnIdx(:,Turn)));
                end
            end
        end

        for AC = 1 : 2
            for Turn = 1 : 3
                NeededSwitchVector = ColorChoice(AC,:)';
                SwitchTypeSelfOtheridx = CrossSelfToOther_AtSwitch{AC,Turn};
                SwitchTypeOtherSelfidx = CrossOtherToSelf_AtSwitch{AC,Turn};
                SelfOther_NeededSwitchVector = nan(numel(SwitchTypeSelfOtheridx),BeforeAfter_Length+1+BeforeAfter_Length);
                OtherSelf_NeededSwitchVector = nan(numel(SwitchTypeOtherSelfidx),BeforeAfter_Length+1+BeforeAfter_Length);
                for i = 1 : numel(SwitchTypeSelfOtheridx)
                    BEG = SwitchTypeSelfOtheridx(i)-BeforeAfter_Length;
                    END = SwitchTypeSelfOtheridx(i)+BeforeAfter_Length;
                    SelfOther_NeededSwitchVector(i,:) = NeededSwitchVector(BEG:END);
                end
                for i = 1 : numel(SwitchTypeOtherSelfidx)
                    BEG = SwitchTypeOtherSelfidx(i)-BeforeAfter_Length;
                    END = SwitchTypeOtherSelfidx(i)+BeforeAfter_Length;
                    OtherSelf_NeededSwitchVector(i,:) = NeededSwitchVector(BEG:END);
                end

                if idata == 1
                    A_AtSwitchCrossSelfother{AC,Turn} = SelfOther_NeededSwitchVector;
                    A_AtSwitchCrossOtherSelf{AC,Turn} = OtherSelf_NeededSwitchVector;
                else
                    A_AtSwitchCrossSelfother{AC,Turn} = [A_AtSwitchCrossSelfother{AC,Turn};SelfOther_NeededSwitchVector];
                    A_AtSwitchCrossOtherSelf{AC,Turn} = [A_AtSwitchCrossOtherSelf{AC,Turn};OtherSelf_NeededSwitchVector];
                end
                WholeSess_AtSwitchCrossSelfother{AC,Turn} = A_AtSwitchCrossSelfother{AC,Turn};
                WholeSess_AtSwitchCrossOtherSelf{AC,Turn} = A_AtSwitchCrossOtherSelf{AC,Turn};

                % CrossAtSwitch_MeanSelfOther(Turn,:,AC,idata) = mean(SelfOther_NeededSwitchVector,1,'omitnan');
                % if calcSEM(SelfOther_NeededSwitchVector) == 0
                %     CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,AC,idata) = zeros(1,(BeforeAfter_Length*2)+1);
                % end
                % if size(calcSEM(SelfOther_NeededSwitchVector),2) == 1
                %     CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,AC,idata) = nan(1,(BeforeAfter_Length*2)+1);
                % else
                %     CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,AC,idata) = calcSEM(SelfOther_NeededSwitchVector);
                % end
                %
                % CrossAtSwitc_MeanOtherSelf(Turn,:,AC,idata) = mean(OtherSelf_NeededSwitchVector,1,'omitnan');
                % if calcSEM(OtherSelf_NeededSwitchVector) == 0
                %     CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,AC,idata)  = zeros(1,(BeforeAfter_Length*2)+1);
                % end
                % if size(calcSEM(OtherSelf_NeededSwitchVector),2) == 1
                %     CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,AC,idata) = nan(1,(BeforeAfter_Length*2)+1);
                % else
                %     CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,AC,idata) = calcSEM(OtherSelf_NeededSwitchVector);
                % end



                CrossAtSwitch_SelfOther_SwitchNum(Turn,AC,idata) = numel(SwitchTypeSelfOtheridx);
                CrossAtSwitch_OtherSelf_SwitchNum(Turn,AC,idata) = numel(SwitchTypeOtherSelfidx);

            end
        end

    end
    A_Name = cur_session_id_struct_arr.subject_A;
    B_Name = cur_session_id_struct_arr.subject_B;
    %% plotting
    alpha = 0.05;
    % DegreeFreddom = length(MergedData);
    % t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);

   for AC = 1 : 2
        for Turn = 1 :3
            MeanOverSessAtSwitch_MeanSelfOther(Turn,:,AC) = mean(WholeSess_AtSwitchSelfother{AC,Turn},1,'omitmissing');
            SEM_OverSessAtSwitch_SelfOther(Turn,:,AC) = calcSEM(WholeSess_AtSwitchSelfother{AC,Turn});

            CrossMeanOverSessSelfOther(Turn,:,AC) = mean(WholeSess_CrossSelfOther{AC,Turn},1,'omitmissing');
            CrossSEM_OverSess_SelfOther(Turn,:,AC) = calcSEM(WholeSess_CrossSelfOther{AC,Turn});

            CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,AC) = mean(WholeSess_AtSwitchCrossSelfother{AC,Turn},1,'omitmissing');
            if size(calcSEM(WholeSess_AtSwitchCrossSelfother{AC,Turn}),2)< (2*BeforeAfter_Length)+1
                CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,AC) = zeros(1,(2*BeforeAfter_Length)+1);
            else
                CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,AC) = calcSEM(WholeSess_AtSwitchCrossSelfother{AC,Turn});
            end


            MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,AC) = mean(WholeSess_AtSwitchOtherSelf{AC,Turn},1,'omitmissing');
            SEM_OverSessAtSwitch_OtherSelf(Turn,:,AC) = calcSEM(WholeSess_AtSwitchOtherSelf{AC,Turn});

            CrossMeanOverSessOtherSelf(Turn,:,AC) = mean(WholeSess_CrossOtherSelf{AC,Turn},1,'omitmissing');
            CrossSEM_OverSess_OtherSelf(Turn,:,AC) = calcSEM(WholeSess_CrossOtherSelf{AC,Turn});

            CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,AC) = mean(WholeSess_AtSwitchCrossOtherSelf{AC,Turn},1,'omitmissing');
            CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,AC) = calcSEM(WholeSess_AtSwitchCrossOtherSelf{AC,Turn});







        end
    end


    %% The rule for plotting switch dynamic is this: there is a "switcher" who switches are defined based on him and there is a "subject" who is subjected to those switches
    %% Be aware that timing is based on subject. Example: if switches are defined based on Flaffus and Curius' choices are plotted around Flaffus'switches and timing should be
    %% curius first, curius simul, curius second
     FigName = strcat(FirstSessActorA{1},'-',FirstSessActorB{1})
    figure('Name',sprintf(FigName), 'NumberTitle', 'off','Position',[488,49.800000000000004,500.2,732.8000000000001])
    for Turn = 1 : 3
        if Turn == 1
            subplot(3,2,5)
            hold on
            % here you plot choices when monkey  itself switches from own
            % to other and he was first (timing applies only at switch)
            XAX = []
            XAX = 1:BeforeAfter_Length+1+BeforeAfter_Length;
            YAX = []
            YAX = mean([MeanOverSessAtSwitch_MeanSelfOther(Turn+2,:,1);MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2)],1,'omitmissing');
            plot(XAX,YAX,'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
            %% calcualte and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_SelfOther_SwitchNum(Turn+2,1,:))+sum(AtSwitch_SelfOther_SwitchNum(Turn,2,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);

            MeanAmongSessSem_SelfOther_AtSwitch_ActorA = []
            MeanAmongSessSem_SelfOther_AtSwitch_ActorB = []
            MeanAmongSessSem_SelfOther_AtSwitch_ActorA = SEM_OverSessAtSwitch_SelfOther(Turn+2,:,1);
            MeanAmongSessSem_SelfOther_AtSwitch_ActorB = SEM_OverSessAtSwitch_SelfOther(Turn,:,2);
            MeanAmongMonksSem = []
            MeanAmongMonksSem = mean([MeanAmongSessSem_SelfOther_AtSwitch_ActorA;MeanAmongSessSem_SelfOther_AtSwitch_ActorB],1,'omitmissing');

            margin_of_errorAtSwitchSelfOther = t_critical * MeanAmongMonksSem
            ci_lowerAtSwitchSelfOther = YAX - margin_of_errorAtSwitchSelfOther;
            ci_upperAtSwitchSelfOther = YAX + margin_of_errorAtSwitchSelfOther;
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',[1 1 1],'LineWidth',0.5)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',[1 1 1],'LineWidth',0.5)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');

            % here you plot choices when monkey's partner switches from
            % own to other When monkey was first(timing applies on all trials)
            YAX = []
            YAX = mean([CrossMeanOverSessSelfOther(Turn,:,1);CrossMeanOverSessSelfOther(Turn+2,:,2)],1,'omitmissing')
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
            %% calcualte and plot 95% confidence interval based on t dist SEM
            MeanAmongSessSem_SelfOther_CrossActorA = []
            MeanAmongSessSem_SelfOther_CrossActorB = []

            MeanAmongSessSem_SelfOther_CrossActorA = CrossSEM_OverSess_SelfOther(Turn,:,1);
            MeanAmongSessSem_SelfOther_CrossActorB = CrossSEM_OverSess_SelfOther(Turn+2,:,2);

            MeanAmongMonksSem = []
            MeanAmongMonksSem = mean([MeanAmongSessSem_SelfOther_CrossActorA;MeanAmongSessSem_SelfOther_CrossActorB],1,'omitmissing');

            CrossMarginOfError_SelfOther = t_critical * MeanAmongMonksSem
            Cross_ci_lowerSelfOther = YAX - CrossMarginOfError_SelfOther;
            Cross_ci_upperSelfOther = YAX + CrossMarginOfError_SelfOther;
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',[1 1 1],'LineWidth',0.5)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',[1 1 1 ],'LineWidth',0.5)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],'b', 'FaceAlpha', 0.3,'EdgeColor','none');




            % here you plot choices when monkey's partner swichtes from
            % own to other when monkey was first( timing applies at switch )
            YAX = []
            YAX = mean([CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1);CrossMeanOverSessAtSwitch_MeanSelfOther(Turn+2,:,2)],1,'omitmissing')
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth)
            %% calcualte and plot 95% confidence interval based on t dist SEM

            MeanAmongSessSem_SelfOther_AtSwitch_ActorA = []
            MeanAmongSessSem_SelfOther_AtSwitch_ActorB = []


            MeanAmongSessSem_SelfOther_AtSwitch_ActorA = CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,1);
            MeanAmongSessSem_SelfOther_AtSwitch_ActorB = CrossAtSwitch_SEM_OverSess_SelfOther(Turn+2,:,2);

            MeanAmongMonksSem = []
            MeanAmongMonksSem = mean([MeanAmongSessSem_SelfOther_AtSwitch_ActorA;MeanAmongSessSem_SelfOther_AtSwitch_ActorB],1,'omitmissing');

            CrossMarginOfError_AtSwitchSelfOther = t_critical * MeanAmongMonksSem
            Cross_ci_lowerSelfOther = YAX - CrossMarginOfError_AtSwitchSelfOther;
            Cross_ci_upperSelfOther = YAX + CrossMarginOfError_AtSwitchSelfOther;
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',[1 1 1],'LineWidth',0.5)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',[1 1 1],'LineWidth',0.5)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',0.5)
            %
            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',0.5)
            %
            % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchSelfOther(Turn,:,2), fliplr(Cross_ci_upperAtSwitchSelfOther(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
            xline(BeforeAfter_Length+1,'--','LineWidth',2)

            pbaspect([1 1 1])
            ylim([-0.2 1.2])

            % title(strcat(sprintf(A_Name),' own to other switch'))
            title(' SECOND, own to other switch')

            OveralSwitch = []
            OveralSwitch = sum(SelfOtherSwitchNum(Turn+2,1,:),3)+sum(SelfOtherSwitchNum(Turn,2,:),3)
            subtitle(strcat('Switch Num: ',string(OveralSwitch)))
             set(gca, 'XColor', 'none'); % Make x-axis invisible
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
            end
            %%
            subplot(3,2,6)
            hold on
            % here you plot choices when monkey itself switches from own
            % to other and he was first (timing applies only at switch)
            XAX = [];
            XAX = 1:BeforeAfter_Length+1+BeforeAfter_Length;
            YAX = [];
            YAX = mean([MeanOverSessAtSwitch_MeanOtherSelf(Turn+2,:,1);MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2)],1,'omitmissing');
            plot(XAX,YAX,'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
            %% calcualte and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_OtherSelf_SwitchNum(Turn+2,1,:))+sum(AtSwitch_OtherSelf_SwitchNum(Turn,2,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);

            MeanAmongSessSem_OtherSelf_AtSwitch_ActorA = [];
            MeanAmongSessSem_OtherSelf_AtSwitch_ActorB = [];
            MeanAmongSessSem_OtherSelf_AtSwitch_ActorA = SEM_OverSessAtSwitch_OtherSelf(Turn+2,:,1);
            MeanAmongSessSem_OtherSelf_AtSwitch_ActorB = SEM_OverSessAtSwitch_OtherSelf(Turn,:,2);
            MeanAmongMonksSem = [];
            MeanAmongMonksSem = mean([MeanAmongSessSem_OtherSelf_AtSwitch_ActorA;MeanAmongSessSem_OtherSelf_AtSwitch_ActorB],1,'omitmissing');

            margin_of_errorAtSwitchOtherSelf = t_critical * MeanAmongMonksSem;
            ci_lowerAtSwitchOtherSelf = YAX - margin_of_errorAtSwitchOtherSelf;
            ci_upperAtSwitchOtherSelf = YAX + margin_of_errorAtSwitchOtherSelf;
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',[1 1 1],'LineWidth',0.5);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',[1 1 1],'LineWidth',0.5);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');

            % here you plot choices when monkey's partner switches from
            % own to other When monkey was first(timing applies on all trials)
            YAX = [];
            YAX = mean([CrossMeanOverSessOtherSelf(Turn,:,1);CrossMeanOverSessOtherSelf(Turn+2,:,2)],1,'omitmissing');
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
            %% calcualte and plot 95% confidence interval based on t dist SEM
            MeanAmongSessSem_OtherSelf_CrossActorA = [];
            MeanAmongSessSem_OtherSelf_CrossActorB = [];

            MeanAmongSessSem_OtherSelf_CrossActorA = CrossSEM_OverSess_OtherSelf(Turn,:,1);
            MeanAmongSessSem_OtherSelf_CrossActorB = CrossSEM_OverSess_OtherSelf(Turn+2,:,2);

            MeanAmongMonksSem = [];
            MeanAmongMonksSem = mean([MeanAmongSessSem_OtherSelf_CrossActorA;MeanAmongSessSem_OtherSelf_CrossActorB],1,'omitmissing');

            CrossMarginOfError_OtherSelf = t_critical * MeanAmongMonksSem;
            Cross_ci_lowerOtherSelf = YAX - CrossMarginOfError_OtherSelf;
            Cross_ci_upperOtherSelf = YAX + CrossMarginOfError_OtherSelf;
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',[1 1 1],'LineWidth',0.5);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',[1 1 1 ],'LineWidth',0.5);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],'b', 'FaceAlpha', 0.3,'EdgeColor','none');

            % here you plot choices when monkey's partner switches from
            % own to other when monkey was first( timing applies at switch )
            YAX = [];
            YAX = mean([CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1);CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn+2,:,2)],1,'omitmissing');
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM

            MeanAmongSessSem_OtherSelf_AtSwitch_ActorA = [];
            MeanAmongSessSem_OtherSelf_AtSwitch_ActorB = [];

            MeanAmongSessSem_OtherSelf_AtSwitch_ActorA = CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,1);
            MeanAmongSessSem_OtherSelf_AtSwitch_ActorB = CrossAtSwitch_SEM_OverSess_OtherSelf(Turn+2,:,2);

            MeanAmongMonksSem = [];
            MeanAmongMonksSem = mean([MeanAmongSessSem_OtherSelf_AtSwitch_ActorA;MeanAmongSessSem_OtherSelf_AtSwitch_ActorB],1,'omitmissing');

            CrossMarginOfError_AtSwitchOtherSelf = t_critical * MeanAmongMonksSem;
            Cross_ci_lowerOtherSelf = YAX - CrossMarginOfError_AtSwitchOtherSelf;
            Cross_ci_upperOtherSelf = YAX + CrossMarginOfError_AtSwitchOtherSelf;
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',[1 1 1],'LineWidth',0.5);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',[1 1 1],'LineWidth',0.5);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');

            xline(BeforeAfter_Length+1,'--','LineWidth',2)

            pbaspect([1 1 1])
            ylim([-0.2 1.2])

            % title(strcat(sprintf(A_Name),' own to other switch'))
            title(' SECOND, other to own switch')

            OveralSwitch = [];
            OveralSwitch = sum(OtherSelfSwitchNum(Turn+2,1,:),3)+sum(OtherSelfSwitchNum(Turn,2,:),3);
            subtitle(strcat('Switch Num: ',string(OveralSwitch)))
             set(gca, 'XColor', 'none'); % Make x-axis invisible
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
            end



        end
        %%
        if Turn == 2
            subplot(3,2,3)
            hold on
            % here you plot choices when monkey itself switches from own
            % to other and he was first (timing applies only at switch)
            XAX = [];
            XAX = 1:BeforeAfter_Length+1+BeforeAfter_Length;
            YAX = [];
            YAX = mean([MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1); MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2)], 1,'omitmissing');
            plot(XAX,YAX,'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)

            %% calculate and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_SelfOther_SwitchNum(Turn,1,:)) + sum(AtSwitch_SelfOther_SwitchNum(Turn,2,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);

            MeanAmongSessSem_SelfOther_AtSwitch_ActorA = mean(SEM_OverSessAtSwitch_SelfOther(Turn,:,1,:),4,'omitmissing');
            MeanAmongSessSem_SelfOther_AtSwitch_ActorB = mean(SEM_OverSessAtSwitch_SelfOther(Turn,:,2,:),4,'omitmissing');
            MeanAmongMonksSem = mean([MeanAmongSessSem_SelfOther_AtSwitch_ActorA; MeanAmongSessSem_SelfOther_AtSwitch_ActorB], 1,'omitmissing');

            margin_of_errorAtSwitchSelfOther = t_critical * MeanAmongMonksSem;
            ci_lowerAtSwitchSelfOther = YAX - margin_of_errorAtSwitchSelfOther;
            ci_upperAtSwitchSelfOther = YAX + margin_of_errorAtSwitchSelfOther;
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length, ci_lowerAtSwitchSelfOther, '-', 'Color', [1 1 1], 'LineWidth', 0.5)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length, ci_upperAtSwitchSelfOther, '-', 'Color', [1 1 1], 'LineWidth', 0.5)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)], ActorAcolor, 'FaceAlpha', 0.3, 'EdgeColor', 'none');

            % plot choices when monkey's partner switches from own to other When monkey was first (timing applies on all trials)
            YAX = mean([CrossMeanOverSessSelfOther(Turn,:,1); CrossMeanOverSessSelfOther(Turn,:,2)], 1,'omitmissing');
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)

            %% calculate and plot 95% confidence interval based on t dist SEM
            MeanAmongSessSem_SelfOther_CrossActorA = CrossSEM_OverSess_SelfOther(Turn,:,1);
            MeanAmongSessSem_SelfOther_CrossActorB = CrossSEM_OverSess_SelfOther(Turn,:,2);
            MeanAmongMonksSem = mean([MeanAmongSessSem_SelfOther_CrossActorA; MeanAmongSessSem_SelfOther_CrossActorB], 1,'omitmissing');

            CrossMarginOfError_SelfOther = t_critical * MeanAmongMonksSem;
            Cross_ci_lowerSelfOther = YAX - CrossMarginOfError_SelfOther;
            Cross_ci_upperSelfOther = YAX + CrossMarginOfError_SelfOther;
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',[1 1 1],'LineWidth',0.5)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',[1 1 1],'LineWidth',0.5)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)], 'b', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

            % plot choices when monkey's partner switches from own to other when monkey was first (timing applies at switch)
            YAX = mean([CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1); CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2)], 1);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth)

            %% calculate and plot 95% confidence interval based on t dist SEM
            MeanAmongSessSem_SelfOther_AtSwitch_ActorA = CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,1);
            MeanAmongSessSem_SelfOther_AtSwitch_ActorB = CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,2);
            MeanAmongMonksSem = mean([MeanAmongSessSem_SelfOther_AtSwitch_ActorA; MeanAmongSessSem_SelfOther_AtSwitch_ActorB], 1,'omitmissing');

            CrossMarginOfError_AtSwitchSelfOther = t_critical * MeanAmongMonksSem;
            Cross_ci_lowerSelfOther = YAX - CrossMarginOfError_AtSwitchSelfOther;
            Cross_ci_upperSelfOther = YAX + CrossMarginOfError_AtSwitchSelfOther;
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',[1 1 1],'LineWidth',0.5)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',[1 1 1],'LineWidth',0.5)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)], ActorBAtSwitchCol, 'FaceAlpha', 0.3, 'EdgeColor', 'none');

            xline(BeforeAfter_Length+1, '--', 'LineWidth', 2)

            pbaspect([1 1 1])
            ylim([-0.2 1.2])

            title(' SIMUL, own to other switch')

            OveralSwitch = sum(SelfOtherSwitchNum(Turn,1,:),3) + sum(SelfOtherSwitchNum(Turn,2,:),3);
            subtitle(strcat('Switch Num: ', string(OveralSwitch)))
             set(gca, 'XColor', 'none'); % Make x-axis invisible

            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');
                hXLines = findobj(gca, 'Type', 'ConstantLine');
                hPatches = findobj(gca, 'Type', 'patch');
                delete([hPlots; hXLines; hPatches]);
            end

            %%
            subplot(3,2,4)
            hold on
            % here you plot choices when monkey itself switches from own
            % to other and he was first (timing applies only at switch)
            XAX = [];
            XAX = 1:BeforeAfter_Length+1+BeforeAfter_Length;
            YAX = [];
            YAX = mean([MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1);MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2)],1,'omitmissing');
            plot(XAX,YAX,'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
            %% calcualte and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_OtherSelf_SwitchNum(Turn,1,:))+sum(AtSwitch_OtherSelf_SwitchNum(Turn,2,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);

            MeanAmongSessSem_OtherSelf_AtSwitch_ActorA = [];
            MeanAmongSessSem_OtherSelf_AtSwitch_ActorB = [];
            MeanAmongSessSem_OtherSelf_AtSwitch_ActorA = SEM_OverSessAtSwitch_OtherSelf(Turn,:,1);
            MeanAmongSessSem_OtherSelf_AtSwitch_ActorB = SEM_OverSessAtSwitch_OtherSelf(Turn,:,2);
            MeanAmongMonksSem = [];
            MeanAmongMonksSem = mean([MeanAmongSessSem_OtherSelf_AtSwitch_ActorA;MeanAmongSessSem_OtherSelf_AtSwitch_ActorB],1,'omitmissing');

            margin_of_errorAtSwitchOtherSelf = t_critical * MeanAmongMonksSem;
            ci_lowerAtSwitchOtherSelf = YAX - margin_of_errorAtSwitchOtherSelf;
            ci_upperAtSwitchOtherSelf = YAX + margin_of_errorAtSwitchOtherSelf;
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',[1 1 1],'LineWidth',0.5);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',[1 1 1],'LineWidth',0.5);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');

            % here you plot choices when monkey's partner switches from
            % own to other When monkey was first(timing applies on all trials)
            YAX = [];
            YAX = mean([CrossMeanOverSessOtherSelf(Turn,:,1);CrossMeanOverSessOtherSelf(Turn,:,2)],1,'omitmissing');
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
            %% calcualte and plot 95% confidence interval based on t dist SEM
            MeanAmongSessSem_OtherSelf_CrossActorA = [];
            MeanAmongSessSem_OtherSelf_CrossActorB = [];

            MeanAmongSessSem_OtherSelf_CrossActorA = CrossSEM_OverSess_OtherSelf(Turn,:,1);
            MeanAmongSessSem_OtherSelf_CrossActorB = CrossSEM_OverSess_OtherSelf(Turn,:,2);

            MeanAmongMonksSem = [];
            MeanAmongMonksSem = mean([MeanAmongSessSem_OtherSelf_CrossActorA;MeanAmongSessSem_OtherSelf_CrossActorB],1,'omitmissing');

            CrossMarginOfError_OtherSelf = t_critical * MeanAmongMonksSem;
            Cross_ci_lowerOtherSelf = YAX - CrossMarginOfError_OtherSelf;
            Cross_ci_upperOtherSelf = YAX + CrossMarginOfError_OtherSelf;
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',[1 1 1],'LineWidth',0.5);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',[1 1 1 ],'LineWidth',0.5);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],'b', 'FaceAlpha', 0.3,'EdgeColor','none');

            % here you plot choices when monkey's partner switches from
            % own to other when monkey was first( timing applies at switch )
            YAX = [];
            YAX = mean([CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1);CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2)],1,'omitmissing');
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM

            MeanAmongSessSem_OtherSelf_AtSwitch_ActorA = [];
            MeanAmongSessSem_OtherSelf_AtSwitch_ActorB = [];

            MeanAmongSessSem_OtherSelf_AtSwitch_ActorA = CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,1);
            MeanAmongSessSem_OtherSelf_AtSwitch_ActorB = CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,2);

            MeanAmongMonksSem = [];
            MeanAmongMonksSem = mean([MeanAmongSessSem_OtherSelf_AtSwitch_ActorA;MeanAmongSessSem_OtherSelf_AtSwitch_ActorB],1,'omitmissing');

            CrossMarginOfError_AtSwitchOtherSelf = t_critical * MeanAmongMonksSem;
            Cross_ci_lowerOtherSelf = YAX - CrossMarginOfError_AtSwitchOtherSelf;
            Cross_ci_upperOtherSelf = YAX + CrossMarginOfError_AtSwitchOtherSelf;
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',[1 1 1],'LineWidth',0.5);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',[1 1 1],'LineWidth',0.5);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');

            xline(BeforeAfter_Length+1,'--','LineWidth',2)

            pbaspect([1 1 1])
            ylim([-0.2 1.2])

            % title(strcat(sprintf(A_Name),' own to other switch'))
            title(' SIMUL, other to own switch')

            OveralSwitch = [];
            OveralSwitch = sum(OtherSelfSwitchNum(Turn,1,:),3)+sum(OtherSelfSwitchNum(Turn,2,:),3);
            subtitle(strcat('Switch Num: ',string(OveralSwitch)))
             set(gca, 'XColor', 'none'); % Make x-axis invisible
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
            end




        end
        %%
        if Turn == 3
            subplot(3,2,1)
            hold on
            % here you plot choices when monkey  itself switches from own
            % to other and he was first (timing applies only at switch)
            XAX = []
            XAX = 1:BeforeAfter_Length+1+BeforeAfter_Length;
            YAX = []
            YAX = mean([MeanOverSessAtSwitch_MeanSelfOther(Turn-2,:,1);MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2)],1,'omitmissing');
            plot(XAX,YAX,'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
            %% calculate and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_SelfOther_SwitchNum(Turn-2,1,:))+sum(AtSwitch_SelfOther_SwitchNum(Turn,2,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);

            MeanAmongSessSem_SelfOther_AtSwitch_ActorA = []
            MeanAmongSessSem_SelfOther_AtSwitch_ActorB = []
            MeanAmongSessSem_SelfOther_AtSwitch_ActorA = SEM_OverSessAtSwitch_SelfOther(Turn-2,:,1);
            MeanAmongSessSem_SelfOther_AtSwitch_ActorB = SEM_OverSessAtSwitch_SelfOther(Turn,:,2);
            MeanAmongMonksSem = []
            MeanAmongMonksSem = mean([MeanAmongSessSem_SelfOther_AtSwitch_ActorA;MeanAmongSessSem_SelfOther_AtSwitch_ActorB],1,'omitmissing');

            margin_of_errorAtSwitchSelfOther = t_critical * MeanAmongMonksSem
            ci_lowerAtSwitchSelfOther = YAX - margin_of_errorAtSwitchSelfOther;
            ci_upperAtSwitchSelfOther = YAX + margin_of_errorAtSwitchSelfOther;
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',[1 1 1],'LineWidth',0.5)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',[1 1 1],'LineWidth',0.5)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');

            % here you plot choices when monkey's partner switches from
            % own to other When monkey was first (timing applies on all trials)
            YAX = []
            YAX = mean([CrossMeanOverSessSelfOther(Turn,:,1);CrossMeanOverSessSelfOther(Turn-2,:,2)],1,'omitmissing')
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
            %% calculate and plot 95% confidence interval based on t dist SEM
            MeanAmongSessSem_SelfOther_CrossActorA = []
            MeanAmongSessSem_SelfOther_CrossActorB = []

            MeanAmongSessSem_SelfOther_CrossActorA = CrossSEM_OverSess_SelfOther(Turn,:,1);
            MeanAmongSessSem_SelfOther_CrossActorB = CrossSEM_OverSess_SelfOther(Turn-2,:,2);

            MeanAmongMonksSem = []
            MeanAmongMonksSem = mean([MeanAmongSessSem_SelfOther_CrossActorA;MeanAmongSessSem_SelfOther_CrossActorB],1,'omitmissing');

            CrossMarginOfError_SelfOther = t_critical * MeanAmongMonksSem
            Cross_ci_lowerSelfOther = YAX - CrossMarginOfError_SelfOther;
            Cross_ci_upperSelfOther = YAX + CrossMarginOfError_SelfOther;
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',[1 1 1],'LineWidth',0.5)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',[1 1 1 ],'LineWidth',0.5)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],'b', 'FaceAlpha', 0.3,'EdgeColor','none');


            % here you plot choices when monkey's partner switches from
            % own to other when monkey was first (timing applies at switch)
            YAX = []
            YAX = mean([CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1);CrossMeanOverSessAtSwitch_MeanSelfOther(Turn-2,:,2)],1,'omitmissing')
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth)
            %% calculate and plot 95% confidence interval based on t dist SEM

            MeanAmongSessSem_SelfOther_AtSwitch_ActorA = []
            MeanAmongSessSem_SelfOther_AtSwitch_ActorB = []

            MeanAmongSessSem_SelfOther_AtSwitch_ActorA = CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,1);
            MeanAmongSessSem_SelfOther_AtSwitch_ActorB = CrossAtSwitch_SEM_OverSess_SelfOther(Turn-2,:,2);

            MeanAmongMonksSem = []
            MeanAmongMonksSem = mean([MeanAmongSessSem_SelfOther_AtSwitch_ActorA;MeanAmongSessSem_SelfOther_AtSwitch_ActorB],1,'omitmissing');

            CrossMarginOfError_AtSwitchSelfOther = t_critical * MeanAmongMonksSem
            Cross_ci_lowerSelfOther = YAX - CrossMarginOfError_AtSwitchSelfOther;
            Cross_ci_upperSelfOther = YAX + CrossMarginOfError_AtSwitchSelfOther;
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',[1 1 1],'LineWidth',0.5)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',[1 1 1],'LineWidth',0.5)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');

            xline(BeforeAfter_Length+1,'--','LineWidth',2)

            pbaspect([1 1 1])
            ylim([-0.2 1.2])

            % title(strcat(sprintf(A_Name),' own to other switch'))
            title(' FIRST, own to other switch')

            OveralSwitch = []
            OveralSwitch = sum(SelfOtherSwitchNum(Turn-2,1,:),3)+sum(SelfOtherSwitchNum(Turn,2,:),3)
            subtitle(strcat('Switch Num: ',string(OveralSwitch)))
             set(gca, 'XColor', 'none'); % Make x-axis invisible
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
            end

            %%
            subplot(3,2,2)
            hold on
            % here you plot choices when monkey  itself switches from own
            % to other and he was first (timing applies only at switch)
            XAX = []
            XAX = 1:BeforeAfter_Length+1+BeforeAfter_Length;
            YAX = []
            YAX = mean([MeanOverSessAtSwitch_MeanOtherSelf(Turn-2,:,1);MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2)],1,'omitmissing');
            plot(XAX,YAX,'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
            %% calculate and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_OtherSelf_SwitchNum(Turn-2,1,:))+sum(AtSwitch_OtherSelf_SwitchNum(Turn,2,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);

            MeanAmongSessSem_OtherSelf_AtSwitch_ActorA = []
            MeanAmongSessSem_OtherSelf_AtSwitch_ActorB = []
            MeanAmongSessSem_OtherSelf_AtSwitch_ActorA = SEM_OverSessAtSwitch_OtherSelf(Turn-2,:,1);
            MeanAmongSessSem_OtherSelf_AtSwitch_ActorB = SEM_OverSessAtSwitch_OtherSelf(Turn,:,2);
            MeanAmongMonksSem = []
            MeanAmongMonksSem = mean([MeanAmongSessSem_OtherSelf_AtSwitch_ActorA;MeanAmongSessSem_OtherSelf_AtSwitch_ActorB],1,'omitmissing');

            margin_of_errorAtSwitchOtherSelf = t_critical * MeanAmongMonksSem
            ci_lowerAtSwitchOtherSelf = YAX - margin_of_errorAtSwitchOtherSelf;
            ci_upperAtSwitchOtherSelf = YAX + margin_of_errorAtSwitchOtherSelf;
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',[1 1 1],'LineWidth',0.5)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',[1 1 1],'LineWidth',0.5)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');

            % here you plot choices when monkey's partner switches from
            % own to other When monkey was first (timing applies on all trials)
            YAX = []
            YAX = mean([CrossMeanOverSessOtherSelf(Turn,:,1);CrossMeanOverSessOtherSelf(Turn-2,:,2)],1,'omitmissing')
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
            %% calculate and plot 95% confidence interval based on t dist SEM
            MeanAmongSessSem_OtherSelf_CrossActorA = []
            MeanAmongSessSem_OtherSelf_CrossActorB = []

            MeanAmongSessSem_OtherSelf_CrossActorA = CrossSEM_OverSess_OtherSelf(Turn,:,1);
            MeanAmongSessSem_OtherSelf_CrossActorB = CrossSEM_OverSess_OtherSelf(Turn-2,:,2);

            MeanAmongMonksSem = []
            MeanAmongMonksSem = mean([MeanAmongSessSem_OtherSelf_CrossActorA;MeanAmongSessSem_OtherSelf_CrossActorB],1,'omitmissing');

            CrossMarginOfError_OtherSelf = t_critical * MeanAmongMonksSem
            Cross_ci_lowerOtherSelf = YAX - CrossMarginOfError_OtherSelf;
            Cross_ci_upperOtherSelf = YAX + CrossMarginOfError_OtherSelf;
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',[1 1 1],'LineWidth',0.5)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',[1 1 1 ],'LineWidth',0.5)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],'b', 'FaceAlpha', 0.3,'EdgeColor','none');


            % here you plot choices when monkey's partner switches from
            % own to other when monkey was first (timing applies at switch)
            YAX = []
            YAX = mean([CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1);CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn-2,:,2)],1,'omitmissing')
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth)
            %% calculate and plot 95% confidence interval based on t dist SEM

            MeanAmongSessSem_OtherSelf_AtSwitch_ActorA = []
            MeanAmongSessSem_OtherSelf_AtSwitch_ActorB = []

            MeanAmongSessSem_OtherSelf_AtSwitch_ActorA = CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,1);
            MeanAmongSessSem_OtherSelf_AtSwitch_ActorB = CrossAtSwitch_SEM_OverSess_OtherSelf(Turn-2,:,2);

            MeanAmongMonksSem = []
            MeanAmongMonksSem = mean([MeanAmongSessSem_OtherSelf_AtSwitch_ActorA;MeanAmongSessSem_OtherSelf_AtSwitch_ActorB],1,'omitmissing');

            CrossMarginOfError_AtSwitchOtherSelf = t_critical * MeanAmongMonksSem
            Cross_ci_lowerOtherSelf = YAX - CrossMarginOfError_AtSwitchOtherSelf;
            Cross_ci_upperOtherSelf = YAX + CrossMarginOfError_AtSwitchOtherSelf;
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',[1 1 1],'LineWidth',0.5)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',[1 1 1],'LineWidth',0.5)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');

            xline(BeforeAfter_Length+1,'--','LineWidth',2)

            pbaspect([1 1 1])
            ylim([-0.2 1.2])

            % title(strcat(sprintf(A_Name),' own to other switch'))
            title(' FIRST, other to own switch')

            OveralSwitch = []
            OveralSwitch = sum(OtherSelfSwitchNum(Turn-2,1,:),3)+sum(OtherSelfSwitchNum(Turn,2,:),3)
            subtitle(strcat('Switch Num: ',string(OveralSwitch)))
             set(gca, 'XColor', 'none'); % Make x-axis invisible
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
            end



        end
    end


    % annotation('textbox',...
    %     [0.029188324670132,0.721615720524018,0.08796481407437,0.085152838427947],...
    %     'String',{'Actor B first'});
    %
    % annotation('textbox',...
    %     [0.029188324670132,0.435589519650655,0.091163534586166,0.080786026200873],...
    %     'String',{'Actor B simul'});
    %
    %
    % annotation('textbox',...
    %     [0.022790883646541,0.146288209606987,0.105557776889244,0.086689928037195],...
    %     'String',{'Actor B second'});

    filename = []
    filename = strcat(FirstSessActorA{1},'-',FirstSessActorB{1},'MONKEYSaverage.jpg')
    filenameSCABLE = strcat(FirstSessActorA{1},'-',FirstSessActorB{1},'MONKEYSaverage')

    sgtitle(strcat(FirstSessActorA{1},'-',FirstSessActorB{1},'-Sess Num: ',string(CS),' MONKEYS average'))
    ax = gcf;
    exportgraphics(ax,sprintf(filename),'Resolution',600)

    print(ax,sprintf(filenameSCABLE), '-dsvg','-r600');

end