function Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet = CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet(WhatOnYaxis,TimeMeasuredBehv,scriptName,MergedData,AT_ToleranceThreshold,MatFile_ActorBgotA_IndexNumber)

%% variables critical for switch determination
%% here you determine if there are at least 'MinimumSameColor'
%% for example at least 3 same choice should be before the switch and 3 same choice should be after the switch otherwise switch is not valid


BeforeAfter_Length = 5;
WindowAroundSwitch = BeforeAfter_Length-1;
MinimumSameColor = 3;

calcSEM = @(data) std(data,1,'omitnan') / sqrt(size(data,1));

%% Define what do you want to look aton the Y axis? Choices or Time related behavior (AT or RT)
%WhatOnYaxis = 'TimeBehavior';
%WhatOnYaxis = 'ChoiceDynamic';

%% Time related behavior should be AT or RT?
%TimeMeasuredBehv = 'AT';
%TimeMeasuredBehv = 'RT';


%%
WholeSess_SelfOther = cell(2,3)
WholeSess_OtherSelf = cell(2,3)

WholeSess_CrossSelfOther = cell(2,3)
WholeSess_CrossOtherSelf = cell(2,3)

WholeSess_AtSwitchSelfother = cell(2,3)
WholeSess_AtSwitchOtherSelf = cell(2,3)

WholeSess_AtSwitchCrossSelfother = cell(2,3)
WholeSess_AtSwitchCrossOtherSelf = cell(2,3)
%% for single sess create cells, then each sess analysis will be stored in

SingleSess_SelfOther =  cellfun(@(x) cell(2, 3), cell(1, length(MergedData)), 'UniformOutput', false);
SingleSess_OtherSelf = cellfun(@(x) cell(2, 3), cell(1, length(MergedData)), 'UniformOutput', false);

SingleSess_CrossSelfOther = cellfun(@(x) cell(2, 3), cell(1, length(MergedData)), 'UniformOutput', false);
SingleSess_CrossOtherSelf = cellfun(@(x) cell(2, 3), cell(1, length(MergedData)), 'UniformOutput', false);

SingleSess_AtSwitchSelfother = cellfun(@(x) cell(2, 3), cell(1, length(MergedData)), 'UniformOutput', false);
SingleSess_AtSwitchOtherSelf = cellfun(@(x) cell(2, 3), cell(1, length(MergedData)), 'UniformOutput', false);

SingleSess_AtSwitchCrossSelfother = cellfun(@(x) cell(2, 3), cell(1, length(MergedData)), 'UniformOutput', false);
SingleSess_AtSwitchCrossOtherSelf = cellfun(@(x) cell(2, 3), cell(1, length(MergedData)), 'UniformOutput', false);
%%
for idata = 1 : length(MergedData)

    ColorChoice = [];
    TimeRecord_A = [];
    TimeRecord_B = [];

    AllSubj_AT = [];

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
                if ismember(idata,MatFile_ActorBgotA_IndexNumber)
                    ColorChoice(1,:) = TransientData.isOwnChoiceArray(2,:); %own colour = 1
                    ColorChoice(2,:) = TransientData.isOwnChoiceArray(1,:); %own colour = 1

                    switch TimeMeasuredBehv
                        case 'AT'
                            TimeRecord_A = TransientData.FullPerTrialStruct.B_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx);
                            TimeRecord_B = TransientData.FullPerTrialStruct.A_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx);

                        case 'RT'

                            TimeRecord_A = TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
                            TimeRecord_B = TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
                    end



                else

                    ColorChoice(1,:) = TransientData.isOwnChoiceArray(1,:); %own colour = 1
                    ColorChoice(2,:) = TransientData.isOwnChoiceArray(2,:); %own colour = 1

                    switch TimeMeasuredBehv
                        case 'AT'
                            TimeRecord_A = TransientData.FullPerTrialStruct.A_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx);
                            TimeRecord_B = TransientData.FullPerTrialStruct.B_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx);

                        case 'RT'

                            TimeRecord_A = TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
                            TimeRecord_B = TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
                    end
                end
                AllSubj_AT = [];
                AllSubj_AT(1,:) = TimeRecord_A;
                AllSubj_AT(2,:) = TimeRecord_B;




                %RTA = TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
                %RTB = TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);






            end
            if i_struct > 1

                TransientData = BeforeShedding{i_struct};

                RewardedANDdyadicTrialId = find(...
                    TransientData.FullPerTrialStruct.TrialIsRewarded ...
                    & TransientData.FullPerTrialStruct.TrialIsJoint ...
                    & (TransientData.FullPerTrialStruct.NumChoiceTargetsPerTrial == 2)...
                    );

                % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)
                if ismember(idata,MatFile_ActorBgotA_IndexNumber)
                    TransientsColorChoiceA = [];
                    TransientsColorChoiceA = [ColorChoice(1,:),TransientData.isOwnChoiceArray(2,:)];

                    TransientsColorChoiceB = [];
                    TransientsColorChoiceB = [ColorChoice(2,:),TransientData.isOwnChoiceArray(1,:)];

                    ColorChoice = [];

                    ColorChoice(1,:) = TransientsColorChoiceA; %own colour = 1
                    ColorChoice(2,:) = TransientsColorChoiceB; %own colour = 1


                    Transient_TimeRecordA = [];
                    Transient_TimeRecordB = [];

                    % TransientRTA = [RTA;TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx)];
                    % TransientRTB = [RTB;TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx)];

                    switch TimeMeasuredBehv
                        case 'AT'
                            Transient_TimeRecordA = [TimeRecord_A;TransientData.FullPerTrialStruct.B_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx)];
                            Transient_TimeRecordB = [TimeRecord_B;TransientData.FullPerTrialStruct.A_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx)];
                        case 'RT'

                            TimeRecord_A = [TimeRecord_A;TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx)];
                            TimeRecord_B = [TimeRecord_B;TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx)];
                    end





                else
                    TransientsColorChoiceA = [];
                    TransientsColorChoiceA = [ColorChoice(1,:),TransientData.isOwnChoiceArray(1,:)];

                    TransientsColorChoiceB = [];
                    TransientsColorChoiceB = [ColorChoice(2,:),TransientData.isOwnChoiceArray(2,:)];

                    ColorChoice = [];

                    ColorChoice(1,:) = TransientsColorChoiceA; %own colour = 1
                    ColorChoice(2,:) = TransientsColorChoiceB; %own colour = 1


                    Transient_TimeRecordA = [];
                    Transient_TimeRecordB = [];

                    % TransientRTA = [RTA;TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx)];
                    % TransientRTB = [RTB;TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx)];

                    % Transient_TimeRecordA = [TimeRecord_A;TransientData.FullPerTrialStruct.A_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx)];
                    % Transient_TimeRecordB = [TimeRecord_B;TransientData.FullPerTrialStruct.B_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx)];

                    switch TimeMeasuredBehv
                        case 'AT'
                            Transient_TimeRecordA = [TimeRecord_A;TransientData.FullPerTrialStruct.A_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx)];
                            Transient_TimeRecordB = [TimeRecord_B;TransientData.FullPerTrialStruct.B_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx)];
                        case 'RT'

                            TimeRecord_A = [TimeRecord_A;TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx)];
                            TimeRecord_B = [TimeRecord_B;TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx)];
                    end
                end


                TimeRecord_A = [];
                TimeRecord_B = [];
                TimeRecord_A = Transient_TimeRecordA;
                TimeRecord_B = Transient_TimeRecordB;

                AllSubj_AT = [];
                AllSubj_AT(1,:) = TimeRecord_A;
                AllSubj_AT(2,:) = TimeRecord_B;




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
        if ismember(idata,MatFile_ActorBgotA_IndexNumber)
            % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)
            ColorChoice = [];
            ColorChoice(1,:) = TransientData.isOwnChoiceArray(2,:); %own colour = 1
            ColorChoice(2,:) = TransientData.isOwnChoiceArray(1,:); %own colour = 1

            % Coordinated_trial_ldx = A_ColorChoice | B_ColorChoice;


            TimeRecord_A = [];
            TimeRecord_B = [];

            switch TimeMeasuredBehv
                case 'AT'
                    TimeRecord_A = TransientData.FullPerTrialStruct.B_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx);
                    TimeRecord_B = TransientData.FullPerTrialStruct.A_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx);

                case 'RT'

                    TimeRecord_A = TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
                    TimeRecord_B = TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
            end

        else


            % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)
            ColorChoice = [];
            ColorChoice(1,:) = TransientData.isOwnChoiceArray(1,:); %own colour = 1
            ColorChoice(2,:) = TransientData.isOwnChoiceArray(2,:); %own colour = 1

            % Coordinated_trial_ldx = A_ColorChoice | B_ColorChoice;


            TimeRecord_A = [];
            TimeRecord_B = [];
            switch TimeMeasuredBehv
                case 'AT'
                    TimeRecord_A = TransientData.FullPerTrialStruct.A_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx);
                    TimeRecord_B = TransientData.FullPerTrialStruct.B_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx);

                case 'RT'

                    TimeRecord_A = TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
                    TimeRecord_B = TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
            end

            % TimeRecord_A = TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
            % TimeRecord_B = TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
        end
        AllSubj_AT = [];
        AllSubj_AT(1,:) = TimeRecord_A;
        AllSubj_AT(2,:) = TimeRecord_B;



    end







    if size(ColorChoice,1)>2
        ColorChoice = ColorChoice';
    end

    %% AT
    diff_Timerecord_AB = [];
    diff_Timerecord_AB = TimeRecord_A - TimeRecord_B;  % minus means actor A was first, o means simul, positive means Actor A was second

    %% finding turns ids
    ATurnIdx = [];
    ATurnIdx = nan(length(diff_Timerecord_AB),3);  %first column is actor A first, Second column is actor A/B simul, third column is Actor A second,
    tmp_AgoB = diff_Timerecord_AB < (- AT_ToleranceThreshold);
    tmp_BgoA = diff_Timerecord_AB > ( AT_ToleranceThreshold);
    tmp_ABgo = ~tmp_AgoB & ~tmp_BgoA;

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
    %%
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


    A_AllTurn_NonTurn_ReplacedNan = nan(length(diff_Timerecord_AB),3); %1st column: first, 2d column: simul...
    B_AllTurn_NonTurn_ReplacedNan = nan(length(diff_Timerecord_AB),3);

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
            switch WhatOnYaxis
                case 'ChoiceDynamic'
                    ChoiceOrTimeVec = ColorChoice(AC,:)';

                case 'TimeBehavior'
                    ChoiceOrTimeVec = AllSubj_AT(AC,:)';

            end
            NeededSwitchVector(~isnan(NeededSwitchVector)) = ChoiceOrTimeVec(~isnan(NeededSwitchVector));
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
            %% If you are analyzing single session, at the end WholeSess_... contains concatenated
            %choices from all sessions, youn need to know from which row
            %to which row belong to a specific session, ..._SingleSessID tells
            %you
            if contains(scriptName,'SingleSess') || contains(scriptName,'OnlyLasts')

                SingleSess_SelfOther{idata}{AC,Turn} = SelfOther_NeededSwitchVector;

                SingleSess_OtherSelf{idata}{AC,Turn} = OtherSelf_NeededSwitchVector;

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

            MeanSelfOther(Turn,:,AC,idata) = mean(SelfOther_NeededSwitchVector,1,'omitnan');
            if calcSEM(SelfOther_NeededSwitchVector) == 0
                SEM_OverSess_SelfOther(Turn,:,AC,idata) = zeros(1,(BeforeAfter_Length*2)+1);
            else
                SEM_OverSess_SelfOther(Turn,:,AC,idata) = calcSEM(SelfOther_NeededSwitchVector);
            end


            MeanOtherSelf(Turn,:,AC,idata) = mean(OtherSelf_NeededSwitchVector,1,'omitnan');
            if calcSEM(OtherSelf_NeededSwitchVector) == 0
                SEM_OverSess_OtherSelf(Turn,:,AC,idata) = zeros(1,(BeforeAfter_Length*2)+1);
            else
                SEM_OverSess_OtherSelf(Turn,:,AC,idata) = calcSEM(OtherSelf_NeededSwitchVector);
            end


            SelfOtherSwitchNum(Turn,AC,idata) = sum(~isnan(SelfOther_NeededSwitchVector(:,6)));
            OtherSelfSwitchNum(Turn,AC,idata) = sum(~isnan(OtherSelf_NeededSwitchVector(:,6)));

        end
    end
    %% CRISS CROSS : When actor A switches, what happen to actor B and vice versa


    for AC = 1 : 2
        for Turn = 1 : 3
            NeededSwitchVector = [];
            NeededSwitchVector = AllTurn_NonTurn_ReplacedNan(:,Turn,AC);
            switch WhatOnYaxis
                case 'ChoiceDynamic'
                    ChoiceOrTimeVec = ColorChoice(AC,:)';

                case 'TimeBehavior'
                    ChoiceOrTimeVec = AllSubj_AT(AC,:)';

            end
            NeededSwitchVector(~isnan(NeededSwitchVector)) = ChoiceOrTimeVec(~isnan(NeededSwitchVector));
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
            if contains(scriptName,'SingleSess' ) || contains(scriptName,'OnlyLasts')

                SingleSess_CrossSelfOther{idata}{AC,Turn} = SelfOther_NeededSwitchVector;
                SingleSess_CrossOtherSelf{idata}{AC,Turn} = OtherSelf_NeededSwitchVector;

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

            CrossMeanSelfOther(Turn,:,AC,idata) = mean(SelfOther_NeededSwitchVector,1,'omitnan');
            if calcSEM(SelfOther_NeededSwitchVector) == 0
                CrossSEM_OverSess_SelfOther(Turn,:,AC,idata) = zeros(1,(BeforeAfter_Length*2)+1);
            end
            if size(calcSEM(SelfOther_NeededSwitchVector),2) == 1
                CrossSEM_OverSess_SelfOther(Turn,:,AC,idata) = nan(1,(BeforeAfter_Length*2)+1);
            else
                CrossSEM_OverSess_SelfOther(Turn,:,AC,idata) = calcSEM(SelfOther_NeededSwitchVector);
            end



            CrossMeanOtherSelf(Turn,:,AC,idata) = mean(OtherSelf_NeededSwitchVector,1,'omitnan');
            if calcSEM(OtherSelf_NeededSwitchVector) == 0
                CrossSEM_OverSess_OtherSelf(Turn,:,AC,idata) = zeros(1,(BeforeAfter_Length*2)+1);
            end
            if size(calcSEM(OtherSelf_NeededSwitchVector),2) == 1
                CrossSEM_OverSess_OtherSelf(Turn,:,AC,idata) = nan(1,(BeforeAfter_Length*2)+1);
            else
                CrossSEM_OverSess_OtherSelf(Turn,:,AC,idata) = calcSEM(OtherSelf_NeededSwitchVector);
            end


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
            switch WhatOnYaxis
                case 'ChoiceDynamic'
                    ChoiceOrTimeVec = ColorChoice(AC,:)';

                case 'TimeBehavior'
                    ChoiceOrTimeVec = AllSubj_AT(AC,:)';

            end
            NeededSwitchVector = ChoiceOrTimeVec;
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
            if contains(scriptName,'SingleSess' ) || contains(scriptName,'OnlyLasts')

                SingleSess_AtSwitchSelfother{idata}{AC,Turn} = SelfOther_NeededSwitchVector;
                SingleSess_AtSwitchOtherSelf{idata}{AC,Turn} = OtherSelf_NeededSwitchVector;

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
            AtSwitch_MeanSelfOther(Turn,:,AC,idata) = mean(SelfOther_NeededSwitchVector,1,'omitnan');
            if  calcSEM(SelfOther_NeededSwitchVector) == 0
                SEM_OverSessAtSwitch_SelfOther(Turn,:,AC,idata) = zeros(1,(BeforeAfter_Length*2)+1);
            end
            if size(calcSEM(SelfOther_NeededSwitchVector),2) == 1
                SEM_OverSessAtSwitch_SelfOther(Turn,:,AC,idata) = nan(1,(BeforeAfter_Length*2)+1);
            else
                SEM_OverSessAtSwitch_SelfOther(Turn,:,AC,idata) = calcSEM(SelfOther_NeededSwitchVector);
            end

            AtSwitc_MeanOtherSelf(Turn,:,AC,idata) = mean(OtherSelf_NeededSwitchVector,1,'omitnan');
            if calcSEM(OtherSelf_NeededSwitchVector) == 0
                SEM_OverSessAtSwitch_OtherSelf(Turn,:,AC,idata) = zeros(1,(BeforeAfter_Length*2)+1);
            end
            if size(calcSEM(OtherSelf_NeededSwitchVector),2) == 1
                SEM_OverSessAtSwitch_OtherSelf(Turn,:,AC,idata) = nan(1,(BeforeAfter_Length*2)+1);
            else
                SEM_OverSessAtSwitch_OtherSelf(Turn,:,AC,idata) = calcSEM(OtherSelf_NeededSwitchVector);
            end


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
             switch WhatOnYaxis
                case 'ChoiceDynamic'
                    ChoiceOrTimeVec = ColorChoice(AC,:)';

                case 'TimeBehavior'
                    ChoiceOrTimeVec = AllSubj_AT(AC,:)';

            end
            NeededSwitchVector = ChoiceOrTimeVec;
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

            if contains(scriptName,'SingleSess' ) || contains(scriptName,'OnlyLasts')

                SingleSess_AtSwitchCrossSelfother{idata}{AC,Turn} = SelfOther_NeededSwitchVector;
                SingleSess_AtSwitchCrossOtherSelf{idata}{AC,Turn} = OtherSelf_NeededSwitchVector;

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

            CrossAtSwitch_MeanSelfOther(Turn,:,AC,idata) = mean(SelfOther_NeededSwitchVector,1,'omitnan');
            if calcSEM(SelfOther_NeededSwitchVector) == 0
                CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,AC,idata) = zeros(1,(BeforeAfter_Length*2)+1);
            end
            if size(calcSEM(SelfOther_NeededSwitchVector),2) == 1
                CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,AC,idata) = nan(1,(BeforeAfter_Length*2)+1);
            else
                CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,AC,idata) = calcSEM(SelfOther_NeededSwitchVector);
            end

            CrossAtSwitc_MeanOtherSelf(Turn,:,AC,idata) = mean(OtherSelf_NeededSwitchVector,1,'omitnan');
            if calcSEM(OtherSelf_NeededSwitchVector) == 0
                CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,AC,idata)  = zeros(1,(BeforeAfter_Length*2)+1);
            end
            if size(calcSEM(OtherSelf_NeededSwitchVector),2) == 1
                CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,AC,idata) = nan(1,(BeforeAfter_Length*2)+1);
            else
                CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,AC,idata) = calcSEM(OtherSelf_NeededSwitchVector);
            end



            CrossAtSwitch_SelfOther_SwitchNum(Turn,AC,idata) = numel(SwitchTypeSelfOtheridx);
            CrossAtSwitch_OtherSelf_SwitchNum(Turn,AC,idata) = numel(SwitchTypeOtherSelfidx);

        end
    end


end

%% Fill in the results: choices before and after switch
Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.WholeSess_Selfother = WholeSess_SelfOther;
Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.WholeSess_OtherSelf = WholeSess_OtherSelf;

Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.WholeSess_AtSwitchSelfother = WholeSess_AtSwitchSelfother;
Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.WholeSess_CrossSelfOther = WholeSess_CrossSelfOther;
Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.WholeSess_AtSwitchCrossSelfother = WholeSess_AtSwitchCrossSelfother;
Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.WholeSess_AtSwitchOtherSelf = WholeSess_AtSwitchOtherSelf;
Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.WholeSess_CrossOtherSelf = WholeSess_CrossOtherSelf;
Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.WholeSess_AtSwitchCrossOtherSelf = WholeSess_AtSwitchCrossOtherSelf;
%% switch num

Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.SelfOtherSwitchNum =  SelfOtherSwitchNum;
Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.OtherSelfSwitchNum =  OtherSelfSwitchNum;

Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.CrossSelfOtherSwitchNum =  CrossSelfOtherSwitchNum;
Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.CrossOtherSelfSwitchNum =  CrossOtherSelfSwitchNum;

Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.AtSwitch_SelfOther_SwitchNum =  AtSwitch_SelfOther_SwitchNum;
Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.AtSwitch_OtherSelf_SwitchNum =  AtSwitch_OtherSelf_SwitchNum;

Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.CrossAtSwitch_SelfOther_SwitchNum =  CrossAtSwitch_SelfOther_SwitchNum;
Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.CrossAtSwitch_OtherSelf_SwitchNum =  CrossAtSwitch_OtherSelf_SwitchNum;
%% sem over switches for each session

Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.CrossAtSwitch_SEM_OverSess_SelfOther = CrossAtSwitch_SEM_OverSess_SelfOther;

Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.CrossAtSwitch_SEM_OverSess_OtherSelf = CrossAtSwitch_SEM_OverSess_OtherSelf;

Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.SEM_OverSessAtSwitch_SelfOther = SEM_OverSessAtSwitch_SelfOther;

Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.SEM_OverSessAtSwitch_OtherSelf = SEM_OverSessAtSwitch_OtherSelf;

Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.CrossSEM_OverSess_SelfOther = CrossSEM_OverSess_SelfOther;

Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.CrossSEM_OverSess_OtherSelf = CrossSEM_OverSess_OtherSelf;

Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.SEM_OverSess_SelfOther = SEM_OverSess_SelfOther;

Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.SEM_OverSess_OtherSelf = SEM_OverSess_OtherSelf;
%% saving single sess choice


if contains(scriptName,'SingleSess') || contains(scriptName,'OnlyLasts')

    Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.Selfother_SingleSess = SingleSess_SelfOther;
    Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.OtherSelf_SingleSess = SingleSess_OtherSelf;

    Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.AtSwitchSelfother_SingleSess = SingleSess_AtSwitchSelfother;
    Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.CrossSelfOther_SingleSess = SingleSess_CrossSelfOther;
    Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.AtSwitchCrossSelfother_SingleSess = SingleSess_AtSwitchCrossSelfother;
    Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.AtSwitchOtherSelf_SingleSess = SingleSess_AtSwitchOtherSelf;
    Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.CrossOtherSelf_SingleSess = SingleSess_CrossOtherSelf;
    Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet.AtSwitchCrossOtherSelf_SingleSess = SingleSess_AtSwitchCrossOtherSelf;
end








