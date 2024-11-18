
% here imoprt the data:
close all,  clear,   clc
%%
%cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes\Clean_DATA_Seb\NHP'
%run('HPHP_fullPath.m');
VBA_Path = fullfile('C:', 'Users', 'zahra', 'OneDrive', 'Documents', 'PostDoc_DPZ', 'Zahra codes', 'VBA_AllFunctions');
addpath(VBA_Path)
starting_dir = fullfile('C:', 'Users', 'zahra', 'OneDrive', 'Documents', 'PostDoc_DPZ', 'Zahra codes', 'Clean_DATA_Seb', 'NHP');
% addpath(starting_dir)
% rmpath(starting_dir)

InsideFold = dir(starting_dir);
AllFolders = {InsideFold.name};
str = AllFolders;
num = regexp(str, '\w+', 'match');
emptyCells = cellfun('isempty', num);
AllFolders = str(~emptyCells);
Actors = {'A','B'};
NaiveConditionString = 'Naiv'
AllConfConditionString = 'Confederate';
trainedName = 'Trained';
ConfTrainedString = 'ConfederateTrained'
NaiveIdx = contains(AllFolders,NaiveConditionString)
ConditionIndex = contains(AllFolders, AllConfConditionString); %filter out Naive folders
NOTtrainedIdx = ~contains(AllFolders, trainedName); %filter out only confederate 
ConfTrainedTogetherConditionIndex = xor(ConditionIndex,NOTtrainedIdx);
ConfTrainedTogetherConditionIndex = ConfTrainedTogetherConditionIndex & (~NaiveIdx);
ConditionIndex = ConditionIndex(NOTtrainedIdx);
% ConditionIndex = ConfTrainedTogetherConditionIndex

RT_ToleranceThreshold = 100;
ConditionFoldersName = AllFolders(ConditionIndex);

ActorAcolor = [204 0 102]./255
ActorBcolor = [0 0 204]./255
ActorBAtSwitchCol = [204 255 229]./255
ActorAatSwitchCol = [255 204 229]./255

MainLineWidth = 2
%%



Actors = {'A','B'};





ActionTimingMeasure = 'AT';
switch ActionTimingMeasure
    case 'GoSig'
        RT_ToleranceThreshold = 500;
    otherwise
        RT_ToleranceThreshold = 100;
end

ActorAcolor = [204 0 102]./255
ActorBcolor = [0 0 204]./255
ActorBAtSwitchCol = [204 255 229]./255
ActorAatSwitchCol = [255 204 229]./255

% Loop through each folder in ConditionFolders
for fol = 4%1:length(ConditionFoldersName)


    % Get the folder name
    folderName = fullfile(starting_dir, ConditionFoldersName{fol});

    % Change directory to the folder
    %cd(folderName);
    MonkeyFoldersName_dirstruct = dir(fullfile(folderName, '*.mat'));

    valid_ConditionFoldersName_dirstruct = MonkeyFoldersName_dirstruct(~[MonkeyFoldersName_dirstruct.isdir]);

    valid_matfile_list = {valid_ConditionFoldersName_dirstruct.name};
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



    for idata = 1 : length(MergedData)
        ColorChoice = [];
        ATA = [];
        ATB = [];
        % diffGoSignalTime_ms_AllTrials = []
        % diffGoSignalTime_ms_DyadicRewarded = []

        BeforeShedding = MergedData{idata};
        if length(BeforeShedding)>1
            for i_struct = 1 : length(BeforeShedding)
                TransientData = [];
                if i_struct == 1
                    TransientData = BeforeShedding{i_struct};
                    RewardedANDdyadicTrialId = find(...
                        TransientData.FullPerTrialStruct.TrialIsRewarded ...
                        & TransientData.FullPerTrialStruct.TrialIsJoint ...
                        & (TransientData.FullPerTrialStruct.NumChoiceTargetsPerTrial == 2)...
                        );

                    % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)

                    ColorChoice(1,:) = TransientData.isOwnChoiceArray(1,:); %own colour = 1
                    ColorChoice(2,:) = TransientData.isOwnChoiceArray(2,:); %own colour = 1

                    ATA = TransientData.FullPerTrialStruct.A_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx);
                    ATB = TransientData.FullPerTrialStruct.B_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx);

                    % diffGoSignalTime_ms_AllTrials = TransientData.FullPerTrialStruct.A_GoSignalTime - TransientData.FullPerTrialStruct.B_GoSignalTime;
                    % diffGoSignalTime_ms_DyadicRewarded = diffGoSignalTime_ms_AllTrials(RewardedANDdyadicTrialId)




                end
                if i_struct > 1

                    TransientData = BeforeShedding{i_struct};

                    RewardedANDdyadicTrialId = find(...
                        TransientData.FullPerTrialStruct.TrialIsRewarded ...
                        & TransientData.FullPerTrialStruct.TrialIsJoint ...
                        & (TransientData.FullPerTrialStruct.NumChoiceTargetsPerTrial == 2)...
                        );

                    % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)
                    TransientsColorChoiceA = [];
                    TransientsColorChoiceA = [ColorChoice(1,:),TransientData.isOwnChoiceArray(1,:)];

                    TransientsColorChoiceB = [];
                    TransientsColorChoiceB = [ColorChoice(2,:),TransientData.isOwnChoiceArray(2,:)];

                    ColorChoice = [];

                    ColorChoice(1,:) = TransientsColorChoiceA; %own colour = 1
                    ColorChoice(2,:) = TransientsColorChoiceB; %own colour = 1


                    TransientATA = [];
                    TransientATB = [];

                    TransientATA = [ATA;TransientData.FullPerTrialStruct.A_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx)];
                    TransientATB = [ATB;TransientData.FullPerTrialStruct.B_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx)];

                    ATA = [];
                    ATB = [];
                    ATA = TransientATA;
                    ATB = TransientATB;


                    % Transient_DiffGoSig = []
                    %
                    %
                    % Transient_DiffGoSig = TransientData.FullPerTrialStruct.A_GoSignalTime - TransientData.FullPerTrialStruct.B_GoSignalTime;
                    % Transient_DiffGoSig = Transient_DiffGoSig(RewardedANDdyadicTrialId);
                    %
                    %
                    % diffGoSignalTime_ms_DyadicRewarded = [diffGoSignalTime_ms_DyadicRewarded;Transient_DiffGoSig]




                end


            end

        end




        if isscalar(BeforeShedding)

            TransientData = BeforeShedding{1};
            % RewardedANDdyadicTrialId = intersect(TransientData.TrialSets.All(logical(TransientData.FullPerTrialStruct. ...
            %     TrialIsRewarded)), TransientData.TrialSets.All(logical(TransientData.FullPerTrialStruct. ...
            %     TrialIsJoint)));

            RewardedANDdyadicTrialId = find(...
                TransientData.FullPerTrialStruct.TrialIsRewarded ...
                & TransientData.FullPerTrialStruct.TrialIsJoint ...
                & (TransientData.FullPerTrialStruct.NumChoiceTargetsPerTrial == 2)...
                );


            % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)
            ColorChoice = [];
            ColorChoice(1,:) = TransientData.isOwnChoiceArray(1,:); %own colour = 1
            ColorChoice(2,:) = TransientData.isOwnChoiceArray(2,:); %own colour = 1

            % Coordinated_trial_ldx = A_ColorChoice | B_ColorChoice;


            ATA = [];
            ATB = [];

            ATA = TransientData.FullPerTrialStruct.A_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx);
            ATB = TransientData.FullPerTrialStruct.B_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx);

            % diffGoSignalTime_ms_AllTrials = []
            % diffGoSignalTime_ms_DyadicRewarded = []
            % diffGoSignalTime_ms_AllTrials = TransientData.FullPerTrialStruct.A_GoSignalTime - TransientData.FullPerTrialStruct.B_GoSignalTime;
            % diffGoSignalTime_ms_DyadicRewarded = diffGoSignalTime_ms_AllTrials(RewardedANDdyadicTrialId)




        end

        if size(ColorChoice,1)>2
            ColorChoice = ColorChoice';
        end

        %% RT

        %% finding turns ids
        switch ActionTimingMeasure
            case 'AT'
                diffRT_AB = [];
                diffRT_AB = ATA - ATB;  % minus means actor A was first, o means simul, positive means Actor A was second

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
                SelfOther_CategorizedSwitches{AC,Turn} = SelfOther_NeededSwitchVector;
                OtherSelf_CategorizedSwitches{AC,Turn} = OtherSelf_NeededSwitchVector;
                MeanSelfOther(Turn,:,AC,idata) = mean(SelfOther_NeededSwitchVector,1,'omitnan');
                MeanOtherSelf(Turn,:,AC,idata) = mean(OtherSelf_NeededSwitchVector,1,'omitnan');

                SelfOtherSwitchNum(Turn,idata,AC) = sum(~isnan(SelfOther_NeededSwitchVector(:,6)));
                OtherSelfSwitchNum(Turn,idata,AC) = sum(~isnan(OtherSelf_NeededSwitchVector(:,6)));

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
                CrossSelfOther_CategorizedSwitches{AC,Turn} = SelfOther_NeededSwitchVector;
                CrossOtherSelf_CategorizedSwitches{AC,Turn} = OtherSelf_NeededSwitchVector;
                CrossMeanSelfOther(Turn,:,AC,idata) = mean(SelfOther_NeededSwitchVector,1,'omitnan');
                CrossMeanOtherSelf(Turn,:,AC,idata) = mean(OtherSelf_NeededSwitchVector,1,'omitnan');

                CrossSelfOtherSwitchNum(Turn,idata,AC) = sum(~isnan(SelfOther_NeededSwitchVector(:,6)));
                CrossOtherSelfSwitchNum(Turn,idata,AC) = sum(~isnan(OtherSelf_NeededSwitchVector(:,6)));



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
                AtSwitch_SelfOther_CategorizedSwitches{AC,Turn} = SelfOther_NeededSwitchVector;
                AtSwitch_OtherSelf_CategorizedSwitches{AC,Turn} = OtherSelf_NeededSwitchVector;
                AtSwitch_MeanSelfOther(Turn,:,AC,idata) = mean(SelfOther_NeededSwitchVector,1,'omitnan');
                AtSwitc_MeanOtherSelf(Turn,:,AC,idata) = mean(OtherSelf_NeededSwitchVector,1,'omitnan');

                AtSwitch_SelfOther_SwitchNum(Turn,idata,AC) = numel(SwitchTypeSelfOtheridx);
                AtSwitch_OtherSelf_SwitchNum(Turn,idata,AC) = numel(SwitchTypeOtherSelfidx);
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
                CrossAtSwitch_SelfOther_CategorizedSwitches{AC,Turn} = SelfOther_NeededSwitchVector;
                CrossAtSwitch_OtherSelf_CategorizedSwitches{AC,Turn} = OtherSelf_NeededSwitchVector;
                CrossAtSwitch_MeanSelfOther(Turn,:,AC,idata) = mean(SelfOther_NeededSwitchVector,1,'omitnan');
                CrossAtSwitc_MeanOtherSelf(Turn,:,AC,idata) = mean(OtherSelf_NeededSwitchVector,1,'omitnan');


                CrossAtSwitch_SelfOther_SwitchNum(Turn,idata,AC) = numel(SwitchTypeSelfOtheridx);
                CrossAtSwitch_OtherSelf_SwitchNum(Turn,idata,AC) = numel(SwitchTypeOtherSelfidx);



            end
        end

    end
    A_Name = cur_session_id_struct_arr.subject_A;
    B_Name = cur_session_id_struct_arr.subject_B;

    AllDates_NotRepeat = unique(key_table)

    extractNumbers = @(str) regexp(str, '[\d.]+', 'match');
    AllDates_NotRepeat = cellfun(extractNumbers, AllDates_NotRepeat, 'UniformOutput', false);

    %% plotting
    alpha = 0.05;
    DegreeFreddom = length(MergedData);
    calcSEM = @(data) std(data,'omitnan') / sqrt(length(data));
    t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
    for idata = 1 : length(MergedData)
        for AC = 1 : 2
            for Turn = 1 :3
                squeezedMeanSelfOther = (squeeze(MeanSelfOther(Turn,:,AC,:)))';
                squeezedMeanOtherSelf = (squeeze(MeanOtherSelf(Turn,:,AC,:)))';
                squeezedAtSwitch_MeanSelfOther = (squeeze(AtSwitch_MeanSelfOther(Turn,:,AC,:)))';
                squeezedAtSwitch_MeanOtherSelf = (squeeze(AtSwitc_MeanOtherSelf(Turn,:,AC,:)))';

                CrossSqueezedMeanSelfOther = (squeeze(CrossMeanSelfOther(Turn,:,AC,:)))';
                CrossSqueezedMeanOtherSelf = (squeeze(CrossMeanOtherSelf(Turn,:,AC,:)))';


                CrossSqueezedAtSwitchMeanSelfOther = (squeeze(CrossAtSwitch_MeanSelfOther(Turn,:,AC,:)))';
                CrossSqueezedAtSwitchMeanOtherSelf = (squeeze(CrossAtSwitc_MeanOtherSelf(Turn,:,AC,:)))';

                MeanOverSessSelfOther(Turn,:,AC) = squeezedMeanSelfOther(idata,:)
                MeanOverSessOtherSelf(Turn,:,AC) = squeezedMeanOtherSelf(idata,:)
                MeanOverSessAtSwitch_MeanSelfOther(Turn,:,AC) = squeezedAtSwitch_MeanSelfOther(idata,:)
                MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,AC) = squeezedAtSwitch_MeanOtherSelf(idata,:)

                CrossMeanOverSessSelfOther(Turn,:,AC) = CrossSqueezedMeanSelfOther(idata,:)
                CrossMeanOverSessOtherSelf(Turn,:,AC) = CrossSqueezedMeanOtherSelf(idata,:)
                CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,AC) = CrossSqueezedAtSwitchMeanSelfOther(idata,:)
                CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,AC) = CrossSqueezedAtSwitchMeanOtherSelf(idata,:)



                % SemOverSessSelfOther = calcSEM(squeezedMeanSelfOther);
                % SemOverSessOtherSelf = calcSEM(squeezedMeanOtherSelf);
                % SemOverSessAtSwitch_MeanSelfOther = calcSEM(squeezedAtSwitch_MeanSelfOther);
                % SemOverSessAtSwitch_MeanOtherSelf = calcSEM(squeezedAtSwitch_MeanOtherSelf);
                %
                % CrossSemOverSessSelfOther = calcSEM(CrossSqueezedMeanSelfOther)
                % CrossSemOverSessOtherSelf = calcSEM(CrossSqueezedMeanOtherSelf)
                % CrossSemOverSessAtSwitchSelfOther = calcSEM(CrossSqueezedAtSwitchMeanSelfOther)
                % CrossSemOverSessAtSwitchOtherSelf = calcSEM(CrossSqueezedAtSwitchMeanOtherSelf)
                %
                %
                % margin_of_errorSelfOther = t_critical * SemOverSessSelfOther;
                % margin_of_errorOtherSelf = t_critical * SemOverSessOtherSelf;
                % margin_of_errorAtSwitchSelfOther = t_critical * SemOverSessAtSwitch_MeanSelfOther;
                % margin_of_errorAtSwitchOtherSelf = t_critical *  SemOverSessAtSwitch_MeanOtherSelf;
                %
                %
                % CrossMarginOfError_SelfOther = t_critical * CrossSemOverSessSelfOther
                % CrossMarginOfError_OtherSelf = t_critical * CrossSemOverSessOtherSelf
                % CrossMarginOfError_AtSwitchSelfOther = t_critical * CrossSemOverSessAtSwitchSelfOther
                % CrossMarginOfError_AtSwitchOtherSelf = t_critical * CrossSemOverSessAtSwitchOtherSelf
                %
                % ci_lowerSelfOther(Turn,:,AC) = MeanOverSessSelfOther(Turn,:,AC) - margin_of_errorSelfOther;
                % ci_upperSelfOther(Turn,:,AC) = MeanOverSessSelfOther(Turn,:,AC) + margin_of_errorSelfOther;
                %
                % ci_lowerOtherSelf(Turn,:,AC) = MeanOverSessOtherSelf(Turn,:,AC) - margin_of_errorOtherSelf;
                % ci_upperOtherSelf(Turn,:,AC) = MeanOverSessOtherSelf(Turn,:,AC) + margin_of_errorOtherSelf;
                %
                % ci_lowerAtSwitchSelfOther(Turn,:,AC) = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,AC) - margin_of_errorAtSwitchSelfOther;
                % ci_upperAtSwitchSelfOther(Turn,:,AC) = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,AC) + margin_of_errorAtSwitchSelfOther;
                %
                % ci_lowerAtSwitchOtherSelf(Turn,:,AC) = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,AC) - margin_of_errorAtSwitchOtherSelf;
                % ci_upperAtSwitchOtherSelf(Turn,:,AC) = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,AC) + margin_of_errorAtSwitchOtherSelf;
                %
                % Cross_ci_lowerSelfOther(Turn,:,AC) = CrossMeanOverSessSelfOther(Turn,:,AC) - CrossMarginOfError_SelfOther
                % Cross_ci_upperSelfOther(Turn,:,AC) = CrossMeanOverSessSelfOther(Turn,:,AC) + CrossMarginOfError_SelfOther
                %
                % Cross_ci_lowerOtherSelf(Turn,:,AC) = CrossMeanOverSessOtherSelf(Turn,:,AC) - CrossMarginOfError_OtherSelf
                % Cross_ci_upperOtherSel(Turn,:,AC) = CrossMeanOverSessOtherSelf(Turn,:,AC) + CrossMarginOfError_OtherSelf
                %
                % Cross_ci_lowerAtSwitchSelfOther(Turn,:,AC) = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,AC) - CrossMarginOfError_AtSwitchSelfOther
                % Cross_ci_upperAtSwitchSelfOther(Turn,:,AC) = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,AC) + CrossMarginOfError_AtSwitchSelfOther
                %
                % Cross_ci_lowerAtSwitchOtherSelf(Turn,:,AC) = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,AC) - CrossMarginOfError_AtSwitchOtherSelf
                % Cross_ci_upperAtSwitchOtherSelf(Turn,:,AC) = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,AC) + CrossMarginOfError_AtSwitchOtherSelf
            end
        end

        %%
        SessionDate = string(AllDates_NotRepeat{idata})
        FigName = strcat(A_Name,'-',B_Name,SessionDate)
        figure('Name', sprintf(FigName), 'NumberTitle', 'off', 'Position', [139.4,49.800000000000004,428.8000000000001,732.8000000000001]);

        for Turn = 1:3
            if Turn == 1
                subplot(3, 2, 1);
                hold on;
                % Blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1), 'o-', 'Color', ActorAcolor,'MarkerFaceColor',ActorAcolor, 'LineWidth', MainLineWidth);

                % Red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessSelfOther(Turn,:,2), 'o-', 'Color', ActorBcolor,'MarkerFaceColor',ActorBcolor, 'LineWidth', MainLineWidth);

                % Pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2), 'o-', 'Color', ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol, 'LineWidth', MainLineWidth);

                % Vertical line
                xline(BeforeAfter_Length+1, '--k', 'LineWidth', 2);

                title(strcat(sprintf(A_Name), ' self to other switch'));
                OveralSwitch = SelfOtherSwitchNum(Turn, idata, 1);
                subtitle(strcat('Switch Num: ', string(OveralSwitch)));
                pbaspect([1 1 1])
                ylim([-0.2 1.2])

                if OveralSwitch == 0
                    hPlots = findobj(gca, 'Type', 'line');
                    delete(hPlots);
                end

                subplot(3, 2, 2);
                hold on;
                % Blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1), 'o-', 'Color', ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth', MainLineWidth);

                % Red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessOtherSelf(Turn,:,2), 'o-', 'Color', ActorBcolor,'MarkerFaceColor',ActorBcolor, 'LineWidth', MainLineWidth);

                % Pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2), 'o-', 'Color', ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol, 'LineWidth', MainLineWidth);

                % Vertical line
                xline(BeforeAfter_Length+1, '--k', 'LineWidth', 2);

                title(strcat(sprintf(A_Name), ' other to self switch'));
                OveralSwitch = OtherSelfSwitchNum(Turn, idata, 1);
                subtitle(strcat('Switch Num: ', string(OveralSwitch)));
                pbaspect([1 1 1])
                ylim([-0.2 1.2])

                if OveralSwitch == 0
                    hPlots = findobj(gca, 'Type', 'line');
                    delete(hPlots);
                end
            end

            if Turn == 2
                subplot(3, 2, 3);
                hold on;
                % Blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1), 'o-', 'Color', ActorAcolor,'MarkerFaceColor',ActorAcolor, 'LineWidth', MainLineWidth);

                % Red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessSelfOther(Turn,:,2), 'o-', 'Color', ActorBcolor,'MarkerFaceColor',ActorBcolor, 'LineWidth', MainLineWidth);

                % Pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2), 'o-', 'Color', ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol, 'LineWidth', MainLineWidth);

                % Vertical line
                xline(BeforeAfter_Length+1, '--k', 'LineWidth', 2);

                title(strcat(sprintf(A_Name), ' self to other switch'));
                OveralSwitch = SelfOtherSwitchNum(Turn, idata, 1);
                subtitle(strcat('Switch Num: ', string(OveralSwitch)));
                pbaspect([1 1 1])
                ylim([-0.2 1.2])

                if OveralSwitch == 0
                    hPlots = findobj(gca, 'Type', 'line');
                    delete(hPlots);
                end

                subplot(3, 2, 4);
                hold on;
                % Blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1), 'o-', 'Color', ActorAcolor,'MarkerFaceColor',ActorAcolor, 'LineWidth', MainLineWidth);

                % Red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessOtherSelf(Turn,:,2), 'o-', 'Color', ActorBcolor,'MarkerFaceColor',ActorBcolor, 'LineWidth', MainLineWidth);

                % Pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2), 'o-', 'Color', ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol, 'LineWidth', MainLineWidth);

                % Vertical line
                xline(BeforeAfter_Length+1, '--k', 'LineWidth', 2);

                title(strcat(sprintf(A_Name), ' other to self switch'));
                OveralSwitch = OtherSelfSwitchNum(Turn, idata, 1);
                subtitle(strcat('Switch Num: ', string(OveralSwitch)));
                pbaspect([1 1 1])
                ylim([-0.2 1.2])

                if OveralSwitch == 0
                    hPlots = findobj(gca, 'Type', 'line');
                    delete(hPlots);
                end
            end

            if Turn == 3
                subplot(3, 2, 5);
                hold on;
                % Blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1), 'o-', 'Color', ActorAcolor,'MarkerFaceColor',ActorAcolor, 'LineWidth', MainLineWidth);

                % Red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessSelfOther(Turn,:,2), 'o-', 'Color', ActorBcolor,'MarkerFaceColor',ActorBcolor, 'LineWidth',MainLineWidth);

                % Pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2), 'o-', 'Color', ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol, 'LineWidth', MainLineWidth);

                % Vertical line
                xline(BeforeAfter_Length+1, '--k', 'LineWidth', 2);

                title(strcat(sprintf(A_Name), ' self to other switch'));
                OveralSwitch = SelfOtherSwitchNum(Turn, idata, 1);
                subtitle(strcat('Switch Num: ', string(OveralSwitch)));
                pbaspect([1 1 1])
                ylim([-0.2 1.2])

                if OveralSwitch == 0
                    hPlots = findobj(gca, 'Type', 'line');
                    delete(hPlots);
                end

                subplot(3, 2, 6);
                hold on;
                % Blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1), 'o-', 'Color', ActorAcolor,'MarkerFaceColor',ActorAcolor, 'LineWidth', MainLineWidth);

                % Red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessOtherSelf(Turn,:,2), 'o-', 'Color', ActorBcolor,'MarkerFaceColor',ActorBcolor, 'LineWidth',MainLineWidth);

                % Pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2), 'o-', 'Color', ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol, 'LineWidth',MainLineWidth);

                % Vertical line
                xline(BeforeAfter_Length+1, '--k', 'LineWidth', 2);

                title(strcat(sprintf(A_Name), ' other to self switch'));
                OveralSwitch = OtherSelfSwitchNum(Turn, idata, 1);
                subtitle(strcat('Switch Num: ', string(OveralSwitch)));
                pbaspect([1 1 1])
                ylim([-0.2 1.2])

                if OveralSwitch == 0
                    hPlots = findobj(gca, 'Type', 'line');
                    delete(hPlots);
                end
            end
        end


        SessionDate = string(AllDates_NotRepeat{idata})
        sgtitle(strcat('Pair: ',sprintf(A_Name),', ',sprintf(B_Name),SessionDate,',AT range: 100ms'))



        annotation('textbox',...
            [0.0111940298507463 0.71943231441048 0.108208955223881 0.0982532751091705],...
            'String',{'Actor B first'});

        annotation('textbox',...
             [0.0149253731343284 0.437772925764193 0.089155784991491 0.0917030567685591],...
            'String',{'Actor B simul'});


        annotation('textbox',...
            [0.0130597014925373 0.161572052401747 0.113805970149254 0.0812314127533525],...
            'String',{'Actor B second'});

        filename = []
        filename = strcat(A_Name,'-',B_Name,SessionDate,'.jpg')
        ax = gcf;
        exportgraphics(ax,sprintf(filename),'Resolution',600)


        %% other player switches
        SessionDate = string(AllDates_NotRepeat{idata})

        FigName = strcat(A_Name,'-Bswitch-',B_Name,SessionDate)
        figure('Name',sprintf(FigName), 'NumberTitle', 'off','Position',[139.4,49.800000000000004,428.8000000000001,732.8000000000001])

        for Turn = 1 : 3
            if Turn == 1
                subplot(3,2,1)
                hold on
                % Blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2), 'o-', 'Color', ActorBcolor,'MarkerFaceColor',ActorBcolor, 'LineWidth',MainLineWidth)
                % Red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessSelfOther(Turn,:,1), 'o-', 'Color', ActorAcolor, 'LineWidth',MainLineWidth)
                % Pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1), 'o-', 'Color', ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol,'LineWidth',MainLineWidth)
                xline(BeforeAfter_Length+1, '--k', 'LineWidth', 2)
                title(strcat(sprintf(B_Name), ' self to other switch'))
                OveralSwitch = SelfOtherSwitchNum(Turn, idata, 2);
                subtitle(strcat('Switch Num: ', string(OveralSwitch)));
                pbaspect([1 1 1])
                ylim([-0.2 1.2])

                if OveralSwitch == 0
                    hPlots = findobj(gca, 'Type', 'line');
                    delete(hPlots);
                end

                subplot(3,2,2)
                hold on
                % Blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2), 'o-', 'Color', ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
                % Red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessOtherSelf(Turn,:,1), 'o-', 'Color', ActorAcolor,'MarkerFaceColor',ActorAcolor, 'LineWidth',MainLineWidth)
                % Pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1), 'o-', 'Color', ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol, 'LineWidth',MainLineWidth)
                xline(BeforeAfter_Length+1, '--k', 'LineWidth', 2)
                title(strcat(sprintf(B_Name), ' other to self switch'))
                OveralSwitch = OtherSelfSwitchNum(Turn, idata, 2);
                subtitle(strcat('Switch Num: ', string(OveralSwitch)));
                pbaspect([1 1 1])
                ylim([-0.2 1.2])

                if OveralSwitch == 0
                    hPlots = findobj(gca, 'Type', 'line');
                    delete(hPlots);
                end
            end

            if Turn == 2
                subplot(3,2,3)
                hold on
                % Blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2), 'o-', 'Color', ActorBcolor,'MarkerFaceColor',ActorBcolor, 'LineWidth',MainLineWidth)
                % Red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessSelfOther(Turn,:,1), 'o-', 'Color', ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
                % Pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1), 'o-', 'Color', ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol,'LineWidth',MainLineWidth)
                xline(BeforeAfter_Length+1, '--k', 'LineWidth', 2)
                title(strcat(sprintf(B_Name), ' self to other switch'))
                OveralSwitch = SelfOtherSwitchNum(Turn, idata, 2);
                subtitle(strcat('Switch Num: ', string(OveralSwitch)));
                pbaspect([1 1 1])
                ylim([-0.2 1.2])

                if OveralSwitch == 0
                    hPlots = findobj(gca, 'Type', 'line');
                    delete(hPlots);
                end

                subplot(3,2,4)
                hold on
                % Blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2), 'o-', 'Color', ActorBcolor,'MarkerFaceColor',ActorBcolor, 'LineWidth',MainLineWidth)
                % Red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessOtherSelf(Turn,:,1), 'o-', 'Color', ActorAcolor,'MarkerFaceColor',ActorAcolor, 'LineWidth',MainLineWidth)
                % Pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1), 'o-', 'Color', ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol,'LineWidth',MainLineWidth)
                xline(BeforeAfter_Length+1, '--k', 'LineWidth', 2)
                title(strcat(sprintf(B_Name), ' other to self switch'))
                OveralSwitch = OtherSelfSwitchNum(Turn, idata, 2);
                subtitle(strcat('Switch Num: ', string(OveralSwitch)));
                pbaspect([1 1 1])
                ylim([-0.2 1.2])

                if OveralSwitch == 0
                    hPlots = findobj(gca, 'Type', 'line');
                    delete(hPlots);
                end
            end

            if Turn == 3
                subplot(3,2,5)
                hold on
                % Blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2), 'o-', 'Color', ActorBcolor,'MarkerFaceColor',ActorBcolor, 'LineWidth',MainLineWidth)
                % Red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessSelfOther(Turn,:,1), 'o-', 'Color', ActorAcolor,'MarkerFaceColor',ActorAcolor, 'LineWidth',MainLineWidth)
                % Pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1), 'o-', 'Color', ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol, 'LineWidth',MainLineWidth)
                xline(BeforeAfter_Length+1, '--k', 'LineWidth', 2)
                title(strcat(sprintf(B_Name), ' self to other switch'))
                OveralSwitch = SelfOtherSwitchNum(Turn, idata, 2);
                subtitle(strcat('Switch Num: ', string(OveralSwitch)));
                pbaspect([1 1 1])
                ylim([-0.2 1.2])

                if OveralSwitch == 0
                    hPlots = findobj(gca, 'Type', 'line');
                    delete(hPlots);
                end

                subplot(3,2,6)
                hold on
                % Blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2), 'o-', 'Color', ActorBcolor,'MarkerFaceColor',ActorBcolor, 'LineWidth',MainLineWidth)
                % Red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessOtherSelf(Turn,:,1), 'o-', 'Color', ActorAcolor,'MarkerFaceColor',ActorAcolor, 'LineWidth',MainLineWidth)
                % Pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length, CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1), 'o-', 'Color', ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol, 'LineWidth',MainLineWidth)
                xline(BeforeAfter_Length+1, '--k', 'LineWidth', 2)
                title(strcat(sprintf(B_Name), ' other to self switch'))
                OveralSwitch = OtherSelfSwitchNum(Turn, idata, 2);
                subtitle(strcat('Switch Num: ', string(OveralSwitch)));
                pbaspect([1 1 1])
                ylim([-0.2 1.2])

                if OveralSwitch == 0
                    hPlots = findobj(gca, 'Type', 'line');
                    delete(hPlots);
                end
            end
        end


        SessionDate = string(AllDates_NotRepeat{idata})

        sgtitle(strcat('Pair: ',sprintf(A_Name),', ',sprintf(B_Name),SessionDate,',AT range: 100ms'))
        %     figname = strcat('Pair: ',sprintf(A_Name),', ',sprintf(B_Name),' two first sessions.jpg')
        %
        % exportgraphics(ax,figname,'Resolution',600)



        % figname = strcat('Pair: ',sprintf(A_Name),', ',sprintf(B_Name),' two last sessions.jpg')
        % exportgraphics(ax,figname,'Resolution',600)


        annotation('textbox',...
            [0.0111940298507463 0.71943231441048 0.108208955223881 0.0982532751091705],...
            'String',{'Actor B first'});

        annotation('textbox',...
             [0.0149253731343284 0.437772925764193 0.089155784991491 0.0917030567685591],...
            'String',{'Actor B simul'});


        annotation('textbox',...
            [0.0130597014925373 0.161572052401747 0.113805970149254 0.0812314127533525],...
            'String',{'Actor B second'});


        filename = []
        filename = strcat(A_Name,'-',B_Name,SessionDate,'Bswitch.jpg')
        ax = gcf;
        exportgraphics(ax,sprintf(filename),'Resolution',600)


    end
end





%
% rmpath(VBA_Path)
%
