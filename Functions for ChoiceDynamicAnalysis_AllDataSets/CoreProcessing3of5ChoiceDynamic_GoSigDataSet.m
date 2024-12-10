function Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet = CoreProcessing3of5ChoiceDynamic_GoSigDataSet(scriptName,MergedData,AT_ToleranceThreshold,MatFile_ActorBgotA_IndexNumber,HumanSubj_AorB)

%% variables critical for switch determination
%% here you determine if there are at least 'MinimumSameColor'
%% for example at least 3 same choice should be before the switch and 3 same choice should be after the switch otherwise switch is not valid


BeforeAfter_Length = 5;
WindowAroundSwitch = BeforeAfter_Length-1;
MinimumSameColor = 3;

calcSEM = @(data) std(data,1,'omitnan') / sqrt(size(data,1));

ActionTimingMeasure = 'GoSig';
TimeRange_ToleranceThreshold = AT_ToleranceThreshold;
SimulGoSig_DividingThreshold = 100;
TrialThreshold = 100;

%%
WholeSess_SelfOther = cell(2,3);
WholeSess_OtherSelf = cell(2,3);

WholeSess_CrossSelfOther = cell(2,3);
WholeSess_CrossOtherSelf = cell(2,3);

WholeSess_AtSwitchSelfother = cell(2,3);
WholeSess_AtSwitchOtherSelf = cell(2,3);

WholeSess_AtSwitchCrossSelfother = cell(2,3);
WholeSess_AtSwitchCrossOtherSelf = cell(2,3);
%% for single sess create cells, then each sess analysis will be stored in

SingleSess_SelfOther =  cellfun(@(x) cell(2, 3), cell(1, length(MergedData)), 'UniformOutput', false);
SingleSess_OtherSelf = cellfun(@(x) cell(2, 3), cell(1, length(MergedData)), 'UniformOutput', false);

SingleSess_CrossSelfOther = cellfun(@(x) cell(2, 3), cell(1, length(MergedData)), 'UniformOutput', false);
SingleSess_CrossOtherSelf = cellfun(@(x) cell(2, 3), cell(1, length(MergedData)), 'UniformOutput', false);

SingleSess_AtSwitchSelfother = cellfun(@(x) cell(2, 3), cell(1, length(MergedData)), 'UniformOutput', false);
SingleSess_AtSwitchOtherSelf = cellfun(@(x) cell(2, 3), cell(1, length(MergedData)), 'UniformOutput', false);

SingleSess_AtSwitchCrossSelfother = cellfun(@(x) cell(2, 3), cell(1, length(MergedData)), 'UniformOutput', false);
SingleSess_AtSwitchCrossOtherSelf = cellfun(@(x) cell(2, 3), cell(1, length(MergedData)), 'UniformOutput', false);

SubTypeTrialString_AllSess = cell(1,length(MergedData));
%%
if contains(scriptName,'Hum' )

    for idata = 1 : length(MergedData)
        ColorChoice = [];
        RTA = [];
        RTB = [];
        diffGoSignalTime_ms_AllTrials = [];
        diffGoSignalTime_ms_DyadicRewarded = [];

        BeforeShedding = MergedData{idata};

        ShuffledBlocked_StringName = "TransientData.TrialSets.ByConfChoiceCue_RndMethod.Side";
        ShuffledBlocked_StringName = strcat(ShuffledBlocked_StringName,HumanSubj_AorB{idata}); %here you reconstruct the name of data for shuffle or blocked


        if length(BeforeShedding)>1
            for i_struct = 1 : length(BeforeShedding)
                TransientData = [];
                if i_struct == 1
                    TransientData = BeforeShedding{i_struct};
                    RewardedANDJointTrialId = find(...
                        TransientData.FullPerTrialStruct.TrialIsRewarded ...
                        & TransientData.FullPerTrialStruct.TrialIsJoint ...
                        & (TransientData.FullPerTrialStruct.NumChoiceTargetsPerTrial == 2)...
                        );

                    DyadicTrialRewardedIdx = intersect(RewardedANDJointTrialId, TransientData.TrialSets.ByTrialSubType.Dyadic);

                    SemiSoloTrialRewardedIdx = intersect(RewardedANDJointTrialId, TransientData.TrialSets.ByTrialSubType.SemiSolo);

                    if isempty(DyadicTrialRewardedIdx)
                        continue
                    end




                    try
                        BlockedOrShuffledStruct = eval(ShuffledBlocked_StringName);
                        BlockedTrialsAll = BlockedOrShuffledStruct.BLOCKED_GEN_LIST;
                        ShuffledTrialsAll = BlockedOrShuffledStruct.RND_GEN_LIST;

                        ShuffledDyadicRewarded = intersect(ShuffledTrialsAll,DyadicTrialRewardedIdx);
                        BlockedDyadicRewarded = intersect(BlockedTrialsAll,DyadicTrialRewardedIdx);

                    catch
                        ShuffledDyadicRewarded = [];
                        BlockedDyadicRewarded = DyadicTrialRewardedIdx;
                    end


                    I = [];
                    I = sum([numel(ShuffledDyadicRewarded)>=TrialThreshold,numel(BlockedDyadicRewarded)>=TrialThreshold]);

                    WholeTrialsChoiceVectorA = TransientData.FullPerTrialStruct.PreferableTargetSelected_A;
                    WholeTrialsChoiceVectorB = TransientData.FullPerTrialStruct.PreferableTargetSelected_B;

                    AllRTA = TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT;
                    AllRTB = TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT;

                    AllATA = TransientData.FullPerTrialStruct.A_IniTargRel_05MT_RT;
                    AllATB = TransientData.FullPerTrialStruct.B_IniTargRel_05MT_RT;

                    diffGoSignalTime_ms_AllTrials = TransientData.FullPerTrialStruct.A_GoSignalTime - TransientData.FullPerTrialStruct.B_GoSignalTime;




                    if numel(ShuffledDyadicRewarded)>=TrialThreshold
                        % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)

                        ShuffledColorChoice = [];
                        ShuffledColorChoice(1,:) = WholeTrialsChoiceVectorA(ShuffledDyadicRewarded); %own colour = 1
                        ShuffledColorChoice(2,:) = WholeTrialsChoiceVectorB(ShuffledDyadicRewarded); %own colour = 1

                        % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)



                        % ColorChoice = [];
                        % ColorChoice(1,:) = TransientData.isOwnChoiceArray(1,:); %own colour = 1
                        % ColorChoice(2,:) = TransientData.isOwnChoiceArray(2,:); %own colour = 1
                        ShuffledRTA = AllRTA(ShuffledDyadicRewarded);
                        ShuffledRTB = AllRTB(ShuffledDyadicRewarded);

                        ShuffledATA = AllATA(ShuffledDyadicRewarded);
                        ShuffledATB = AllATB(ShuffledDyadicRewarded);



                        ShuffleddiffGoSignalTime_ms_DyadicRewarded = diffGoSignalTime_ms_AllTrials(ShuffledDyadicRewarded);

                    end
                    if numel(BlockedDyadicRewarded) >= TrialThreshold
                        % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)

                        BlockedColorChoice = [];
                        BlockedColorChoice(1,:) = WholeTrialsChoiceVectorA(BlockedDyadicRewarded); %own colour = 1
                        BlockedColorChoice(2,:) = WholeTrialsChoiceVectorB(BlockedDyadicRewarded); %own colour = 1

                        % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)

                        % ColorChoice = [];
                        % ColorChoice(1,:) = TransientData.isOwnChoiceArray(1,:); %own colour = 1
                        % ColorChoice(2,:) = TransientData.isOwnChoiceArray(2,:); %own colour = 1
                        BlockedRTA = AllRTA(BlockedDyadicRewarded);
                        BlockedRTB = AllRTB(BlockedDyadicRewarded);

                        BlockedATA = AllATA(BlockedDyadicRewarded);
                        BlockedATB = AllATB(BlockedDyadicRewarded);

                        BlockeddiffGoSignalTime_ms_DyadicRewarded = diffGoSignalTime_ms_AllTrials(BlockedDyadicRewarded);
                    end



                end
                if i_struct > 1

                    TransientData = BeforeShedding{i_struct};

                    RewardedANDJointTrialId = find(...
                        TransientData.FullPerTrialStruct.TrialIsRewarded ...
                        & TransientData.FullPerTrialStruct.TrialIsJoint ...
                        & (TransientData.FullPerTrialStruct.NumChoiceTargetsPerTrial == 2)...
                        );
                    DyadicTrialRewardedIdx = intersect(RewardedANDJointTrialId, TransientData.TrialSets.ByTrialSubType.Dyadic);

                    SemiSoloTrialRewardedIdx = intersect(RewardedANDJointTrialId, TransientData.TrialSets.ByTrialSubType.SemiSolo);


                    if isempty(DyadicTrialRewardedIdx)
                        continue
                    end



                    try
                        BlockedOrShuffledStruct = eval(ShuffledBlocked_StringName);
                        BlockedTrialsAll = BlockedOrShuffledStruct.BLOCKED_GEN_LIST;
                        ShuffledTrialsAll = BlockedOrShuffledStruct.RND_GEN_LIST;

                        ShuffledDyadicRewarded = intersect(ShuffledTrialsAll,DyadicTrialRewardedIdx);
                        BlockedDyadicRewarded = intersect(BlockedTrialsAll,DyadicTrialRewardedIdx);

                    catch
                        ShuffledDyadicRewarded = [];
                        BlockedDyadicRewarded = DyadicTrialRewardedIdx;
                    end

                    transientI = [];
                    transientI = sum([numel(ShuffledDyadicRewarded)>=TrialThreshold,numel(BlockedDyadicRewarded)>=TrialThreshold]);
                    I = I+transientI;

                    WholeTrialsChoiceVectorA = TransientData.FullPerTrialStruct.PreferableTargetSelected_A;
                    WholeTrialsChoiceVectorB = TransientData.FullPerTrialStruct.PreferableTargetSelected_B;

                    AllRTA = TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT;
                    AllRTB = TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT;

                    AllATA = TransientData.FullPerTrialStruct.A_IniTargRel_05MT_RT;
                    AllATB = TransientData.FullPerTrialStruct.B_IniTargRel_05MT_RT;

                    diffGoSignalTime_ms_AllTrials = TransientData.FullPerTrialStruct.A_GoSignalTime - TransientData.FullPerTrialStruct.B_GoSignalTime;


                    if numel(ShuffledDyadicRewarded)>=TrialThreshold
                        % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)

                        TransientShuffledColorChoice = [];
                        TransientShuffledColorChoice(1,:) = WholeTrialsChoiceVectorA(ShuffledDyadicRewarded); %own colour = 1
                        TransientShuffledColorChoice(2,:) = WholeTrialsChoiceVectorB(ShuffledDyadicRewarded); %own colour = 1

                        ShuffledColorChoice = [ShuffledColorChoice,TransientShuffledColorChoice];

                        % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)



                        % ColorChoice = [];
                        % ColorChoice(1,:) = TransientData.isOwnChoiceArray(1,:); %own colour = 1
                        % ColorChoice(2,:) = TransientData.isOwnChoiceArray(2,:); %own colour = 1
                        ShuffledRTA = [ShuffledRTA,AllRTA(ShuffledDyadicRewarded)];
                        ShuffledRTB = [ShuffledRTB,AllRTB(ShuffledDyadicRewarded)];

                        ShuffledATA = [ShuffledATA,AllATA(ShuffledDyadicRewarded)];
                        ShuffledATB = [ShuffledATB,AllATB(ShuffledDyadicRewarded)];



                        ShuffleddiffGoSignalTime_ms_DyadicRewarded = [ShuffleddiffGoSignalTime_ms_DyadicRewarded,diffGoSignalTime_ms_AllTrials(ShuffledDyadicRewarded)];

                    end
                    if numel(BlockedDyadicRewarded) >= TrialThreshold
                        % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)

                        TransientBlockedColorChoice = [];
                        TransientBlockedColorChoice(1,:) = WholeTrialsChoiceVectorA(BlockedDyadicRewarded); %own colour = 1
                        TransientBlockedColorChoice(2,:) = WholeTrialsChoiceVectorB(BlockedDyadicRewarded); %own colour = 1

                        BlockedColorChoice = [BlockedColorChoice,TransientBlockedColorChoice];

                        % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)

                        % ColorChoice = [];
                        % ColorChoice(1,:) = TransientData.isOwnChoiceArray(1,:); %own colour = 1
                        % ColorChoice(2,:) = TransientData.isOwnChoiceArray(2,:); %own colour = 1
                        BlockedRTA = [BlockedRTA,AllRTA(BlockedDyadicRewarded)];
                        BlockedRTB = [BlockedRTB,AllRTB(BlockedDyadicRewarded)];

                        BlockedATA = [BlockedATA,AllATA(BlockedDyadicRewarded)];
                        BlockedATB = [BlockedATB,AllATB(BlockedDyadicRewarded)];

                        BlockeddiffGoSignalTime_ms_DyadicRewarded = [BlockeddiffGoSignalTime_ms_DyadicRewarded,diffGoSignalTime_ms_AllTrials(BlockedDyadicRewarded)];
                    end




                end


            end

        end




        if isscalar(BeforeShedding)

            TransientData = BeforeShedding{1};
            % RewardedANDdyadicTrialId = intersect(TransientData.TrialSets.All(logical(TransientData.FullPerTrialStruct. ...
            %     TrialIsRewarded)), TransientData.TrialSets.All(logical(TransientData.FullPerTrialStruct. ...
            %     TrialIsJoint)));

            RewardedANDJointTrialId = find(...
                TransientData.FullPerTrialStruct.TrialIsRewarded ...
                & TransientData.FullPerTrialStruct.TrialIsJoint ...
                & (TransientData.FullPerTrialStruct.NumChoiceTargetsPerTrial == 2)...
                );

            DyadicTrialRewardedIdx = intersect(RewardedANDJointTrialId, TransientData.TrialSets.ByTrialSubType.Dyadic);

            SemiSoloTrialRewardedIdx = intersect(RewardedANDJointTrialId, TransientData.TrialSets.ByTrialSubType.SemiSolo);

            if isempty(DyadicTrialRewardedIdx)
                continue
            end
            try
                BlockedOrShuffledStruct = eval(ShuffledBlocked_StringName);
                BlockedTrialsAll = BlockedOrShuffledStruct.BLOCKED_GEN_LIST;
                ShuffledTrialsAll = BlockedOrShuffledStruct.RND_GEN_LIST;

                ShuffledDyadicRewarded = intersect(ShuffledTrialsAll,DyadicTrialRewardedIdx);
                BlockedDyadicRewarded = intersect(BlockedTrialsAll,DyadicTrialRewardedIdx);

            catch
                ShuffledDyadicRewarded = [];
                BlockedDyadicRewarded = DyadicTrialRewardedIdx;
            end




            I = [];
            I = sum([numel(ShuffledDyadicRewarded)>=TrialThreshold,numel(BlockedDyadicRewarded)>=TrialThreshold]);

            WholeTrialsChoiceVectorA = TransientData.FullPerTrialStruct.PreferableTargetSelected_A;
            WholeTrialsChoiceVectorB = TransientData.FullPerTrialStruct.PreferableTargetSelected_B;

            AllRTA = TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT;
            AllRTB = TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT;

            AllATA = TransientData.FullPerTrialStruct.A_IniTargRel_05MT_RT;
            AllATB = TransientData.FullPerTrialStruct.B_IniTargRel_05MT_RT;

            diffGoSignalTime_ms_AllTrials = TransientData.FullPerTrialStruct.A_GoSignalTime - TransientData.FullPerTrialStruct.B_GoSignalTime;




            if numel(ShuffledDyadicRewarded)>=TrialThreshold
                % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)

                ShuffledColorChoice = [];
                ShuffledColorChoice(1,:) = WholeTrialsChoiceVectorA(ShuffledDyadicRewarded); %own colour = 1
                ShuffledColorChoice(2,:) = WholeTrialsChoiceVectorB(ShuffledDyadicRewarded); %own colour = 1

                % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)



                % ColorChoice = [];
                % ColorChoice(1,:) = TransientData.isOwnChoiceArray(1,:); %own colour = 1
                % ColorChoice(2,:) = TransientData.isOwnChoiceArray(2,:); %own colour = 1
                ShuffledRTA = AllRTA(ShuffledDyadicRewarded);
                ShuffledRTB = AllRTB(ShuffledDyadicRewarded);

                ShuffledATA = AllATA(ShuffledDyadicRewarded);
                ShuffledATB = AllATB(ShuffledDyadicRewarded);



                ShuffleddiffGoSignalTime_ms_DyadicRewarded = diffGoSignalTime_ms_AllTrials(ShuffledDyadicRewarded);

            end
            if numel(BlockedDyadicRewarded) >= TrialThreshold
                % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)

                BlockedColorChoice = [];
                BlockedColorChoice(1,:) = WholeTrialsChoiceVectorA(BlockedDyadicRewarded); %own colour = 1
                BlockedColorChoice(2,:) = WholeTrialsChoiceVectorB(BlockedDyadicRewarded); %own colour = 1

                % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)

                % ColorChoice = [];
                % ColorChoice(1,:) = TransientData.isOwnChoiceArray(1,:); %own colour = 1
                % ColorChoice(2,:) = TransientData.isOwnChoiceArray(2,:); %own colour = 1
                BlockedRTA = AllRTA(BlockedDyadicRewarded);
                BlockedRTB = AllRTB(BlockedDyadicRewarded);

                BlockedATA = AllATA(BlockedDyadicRewarded);
                BlockedATB = AllATB(BlockedDyadicRewarded);

                BlockeddiffGoSignalTime_ms_DyadicRewarded = diffGoSignalTime_ms_AllTrials(BlockedDyadicRewarded);
            end




        end



        if ~exist('BlockedOrShuffledStruct')
            ColorChoice = [];
            ColorChoice = BlockedColorChoice;
            RTA = [];
            RTB = [];
            RTA = BlockedRTA;
            RTB = BlockedRTB;
            ATA = [];
            ATB = [];
            ATA = BlockedATA;
            ATB = BlockedATB;
            diffGoSignalTime_ms_DyadicRewarded = [];
            diffGoSignalTime_ms_DyadicRewarded = BlockeddiffGoSignalTime_ms_DyadicRewarded;
            %%
            if size(ColorChoice,1)>2
                ColorChoice = ColorChoice';
            end

            switch ActionTimingMeasure
                case 'RT'
                    %% RT
                    diffRT_AB = [];
                    diffRT_AB = RTA - RTB;  % minus means actor A was first, o means simul, positive means Actor A was second
                case 'AT'
                    %% RT
                    diffRT_AB = [];
                    diffRT_AB = ATA - ATB;  % minus means actor A was first, o means simul, positive means Actor A was second
                case 'GoSig'
                    diffRT_AB = [];
                    diffRT_AB = diffGoSignalTime_ms_DyadicRewarded;

            end
            %% finding turns ids
            switch ActionTimingMeasure
                case 'AT'
                    diffRT_AB = [];
                    diffRT_AB = ATA - ATB;  % minus means actor A was first, o means simul, positive means Actor A was second

                    ATurnIdx = [];
                    ATurnIdx = nan(length(diffRT_AB),3);  %first column is actor A first, Second column is actor A/B simul, third column is Actor A second,
                    tmp_AgoB = diffRT_AB < (- AT_ToleranceThreshold);
                    tmp_BgoA = diffRT_AB > ( AT_ToleranceThreshold);
                    tmp_ABgo = ~tmp_AgoB & ~tmp_BgoA;
                case 'GoSig'
                    diffRT_AB = [];
                    diffRT_AB = diffGoSignalTime_ms_DyadicRewarded;
                    ATurnIdx = [];
                    ATurnIdx = nan(length(diffRT_AB),3);  %first column is actor A first, Second column is actor A/B simul, third column is Actor A second,
                    tmp_AgoB = diffRT_AB < (- AT_ToleranceThreshold);
                    tmp_BgoA = diffRT_AB > ( AT_ToleranceThreshold);
                    % tmp_ABgo = (diffRT_AB > 0) & (diffRT_AB < RT_ToleranceThreshold);
                    tmp_ABgo = diffRT_AB == 0;
                    DiifAT = [];
                    DiifAT = ATA - ATB;
                    GoSimul_AgoB = DiifAT < (- SimulGoSig_DividingThreshold);
                    GoSimul_BgoA = DiifAT > ( SimulGoSig_DividingThreshold);
                    GoSimul_ABgo = ~GoSimul_AgoB & ~GoSimul_BgoA;
                    tmp_AgoB(GoSimul_AgoB == 1) = 1;  %adding up trials to A faster B based on when Go signal was simul and A was faster than B based on AT
                    tmp_BgoA(GoSimul_BgoA == 1) = 1;
                    tmp_ABgo = GoSimul_ABgo;



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
            SelfOther_NotValidSwitchId = cell(1,2);
            for Ac = 1 : 2
                str = sprintf('%c_SelfToOther', 'A' + (Ac-1));
                c = 1;
                for i_SelfOther = 1 : numel(eval(str))
                    DATA = [];
                    DATA = ColorChoice(Ac,:);
                    SwitchVec = [];
                    SwitchVec = eval(str);
                    SwitchChoice = 0;
                    BeforeIdx = SwitchVec(i_SelfOther)-BeforeAfter_Length;
                    AfterIdx =  SwitchVec(i_SelfOther)+BeforeAfter_Length;

                    BeforeSwitchVec =  sum(DATA(BeforeIdx:(BeforeIdx+WindowAroundSwitch)) == not(SwitchChoice)) >= MinimumSameColor;
                    AfterSwitchVec = sum(DATA(SwitchVec(i_SelfOther)+1:AfterIdx) == SwitchChoice) >= MinimumSameColor;
                    if not(BeforeSwitchVec&AfterSwitchVec)
                        SelfOther_NotValidSwitchId{Ac}(c) = SwitchVec(i_SelfOther);
                        c = c+1;
                    end
                end
            end

            ANotValidSwitchID_SelfOther =  SelfOther_NotValidSwitchId{1};
            BNotValidSwitchID_SelfOther = SelfOther_NotValidSwitchId{2};
            %%
            ANotValidSwitchID_OtherSelf = [];
            BNotValidSwitchID_OtherSelf = [];
            OtherSelf_NotValidSwitchId = cell(1,2);
            for Ac = 1 : 2
                str = sprintf('%c_OtherToSelf', 'A' + (Ac-1));
                c = 1;
                for i_OtherSelf = 1 : numel(eval(str))
                    DATA = [];
                    DATA = ColorChoice(Ac,:);
                    SwitchVec = [];
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

                    SingleSess_SelfOther{idata}{AC,Turn} = SelfOther_NeededSwitchVector;

                    SelfOther_CategorizedSwitches{AC,Turn} = SelfOther_NeededSwitchVector;
                    OtherSelf_CategorizedSwitches{AC,Turn} = OtherSelf_NeededSwitchVector;
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



            for AC = 1 : 2
                for Turn = 1 :3
                    squeezedMeanSelfOther = (squeeze(MeanSelfOther(Turn,:,AC,idata)));
                    squeezedMeanOtherSelf = (squeeze(MeanOtherSelf(Turn,:,AC,idata)));
                    squeezedAtSwitch_MeanSelfOther= (squeeze(AtSwitch_MeanSelfOther(Turn,:,AC,idata)));
                    squeezedAtSwitch_MeanOtherSelf = (squeeze(AtSwitc_MeanOtherSelf(Turn,:,AC,idata)));

                    CrossSqueezedMeanSelfOther = (squeeze(CrossMeanSelfOther(Turn,:,AC,idata)));
                    CrossSqueezedMeanOtherSelf = (squeeze(CrossMeanOtherSelf(Turn,:,AC,idata)));


                    CrossSqueezedAtSwitchMeanSelfOther = (squeeze(CrossAtSwitch_MeanSelfOther(Turn,:,AC,idata)));
                    CrossSqueezedAtSwitchMeanOtherSelf = (squeeze(CrossAtSwitc_MeanOtherSelf(Turn,:,AC,idata)));

                    MeanOverSessSelfOther(Turn,:,AC) = (squeezedMeanSelfOther);
                    MeanOverSessOtherSelf(Turn,:,AC) = (squeezedMeanOtherSelf);
                    MeanOverSessAtSwitch_MeanSelfOther(Turn,:,AC) = (squeezedAtSwitch_MeanSelfOther);
                    MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,AC) = (squeezedAtSwitch_MeanOtherSelf);

                    CrossMeanOverSessSelfOther(Turn,:,AC) = (CrossSqueezedMeanSelfOther);
                    CrossMeanOverSessOtherSelf(Turn,:,AC) = (CrossSqueezedMeanOtherSelf);
                    CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,AC) = (CrossSqueezedAtSwitchMeanSelfOther);
                    CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,AC) = (CrossSqueezedAtSwitchMeanOtherSelf);



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
            SubTypeTrialString = [];
            SubTypeTrialString = " Blocked";
            SubTypeTrialString_AllSess{idata} = SubTypeTrialString;


        else
            for ii = 1 : I

                if ii == 1
                    ColorChoice = [];
                    ColorChoice = ShuffledColorChoice;
                    RTA = [];
                    RTB =[];
                    RTA = ShuffledRTA;
                    RTB = ShuffledRTB;
                    ATA = [];
                    ATB = [];
                    ATA = ShuffledATA;
                    ATB = ShuffledATB;
                    diffGoSignalTime_ms_DyadicRewarded = [];
                    diffGoSignalTime_ms_DyadicRewarded = ShuffleddiffGoSignalTime_ms_DyadicRewarded;

                else
                    ColorChoice = [];
                    ColorChoice = BlockedColorChoice;
                    RTA = [];
                    RTB = [];
                    RTA = BlockedRTA;
                    RTB = BlockedRTB;
                    ATA = [];
                    ATB = [];
                    ATA = BlockedATA;
                    ATB = BlockedATB;
                    diffGoSignalTime_ms_DyadicRewarded = [];
                    diffGoSignalTime_ms_DyadicRewarded = BlockeddiffGoSignalTime_ms_DyadicRewarded;

                end

                if size(ColorChoice,1)>2
                    ColorChoice = ColorChoice';
                end

                switch ActionTimingMeasure
                    case 'RT'
                        %% RT
                        diffRT_AB = [];
                        diffRT_AB = RTA - RTB;  % minus means actor A was first, o means simul, positive means Actor A was second
                    case 'AT'
                        %% RT
                        diffRT_AB = [];
                        diffRT_AB = ATA - ATB;  % minus means actor A was first, o means simul, positive means Actor A was second
                    case 'GoSig'
                        diffRT_AB = [];
                        diffRT_AB = diffGoSignalTime_ms_DyadicRewarded;

                end
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
                        tmp_AgoB = diffRT_AB < (- AT_ToleranceThreshold);
                        tmp_BgoA = diffRT_AB > ( AT_ToleranceThreshold);
                        % tmp_ABgo = (diffRT_AB > 0) & (diffRT_AB < RT_ToleranceThreshold);
                        tmp_ABgo = diffRT_AB == 0;
                        DiifAT = []
                        DiifAT = ATA - ATB;
                        GoSimul_AgoB = DiifAT < (- SimulGoSig_DividingThreshold);
                        GoSimul_BgoA = DiifAT > ( SimulGoSig_DividingThreshold);
                        GoSimul_ABgo = ~GoSimul_AgoB & ~GoSimul_BgoA;
                        tmp_AgoB(GoSimul_AgoB == 1) = 1;  %adding up trials to A faster B based on when Go signal was simul and A was faster than B based on AT
                        tmp_BgoA(GoSimul_BgoA == 1) = 1;
                        tmp_ABgo = GoSimul_ABgo;

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
                %%
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

                %% here you determine if there are at least 'MinimumSameColor'
                %% for example at least 3 same choice should be before the switch and 3 same choice should be after the switch otherwise switch is not valid
                ANotValidSwitchID_SelfOther = [];
                BNotValidSwitchID_SelfOther = [];
                SelfOther_NotValidSwitchId = cell(1,2);
                for Ac = 1 : 2
                    str = sprintf('%c_SelfToOther', 'A' + (Ac-1));
                    c = 1;
                    for i_SelfOther = 1 : numel(eval(str))
                        DATA = [];
                        DATA = ColorChoice(Ac,:);
                        SwitchVec = [];
                        SwitchVec = eval(str);
                        SwitchChoice = 0;
                        BeforeIdx = SwitchVec(i_SelfOther)-BeforeAfter_Length;
                        AfterIdx =  SwitchVec(i_SelfOther)+BeforeAfter_Length;

                        BeforeSwitchVec =  sum(DATA(BeforeIdx:(BeforeIdx+WindowAroundSwitch)) == not(SwitchChoice)) >= MinimumSameColor;
                        AfterSwitchVec = sum(DATA(SwitchVec(i_SelfOther)+1:AfterIdx) == SwitchChoice) >= MinimumSameColor;
                        if not(BeforeSwitchVec&AfterSwitchVec)
                            SelfOther_NotValidSwitchId{Ac}(c) = SwitchVec(i_SelfOther);
                            c = c+1;
                        end
                    end
                end

                ANotValidSwitchID_SelfOther =  SelfOther_NotValidSwitchId{1};
                BNotValidSwitchID_SelfOther = SelfOther_NotValidSwitchId{2};
                %%
                ANotValidSwitchID_OtherSelf = [];
                BNotValidSwitchID_OtherSelf = [];
                OtherSelf_NotValidSwitchId = cell(1,2);
                for Ac = 1 : 2
                    str = sprintf('%c_OtherToSelf', 'A' + (Ac-1));
                    c = 1;
                    for i_OtherSelf = 1 : numel(eval(str))
                        DATA = [];
                        DATA = ColorChoice(Ac,:);
                        SwitchVec = [];
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


                for AC = 1 : 2
                    for Turn = 1 :3
                        squeezedMeanSelfOther = (squeeze(MeanSelfOther(Turn,:,AC,idata)));
                        squeezedMeanOtherSelf = (squeeze(MeanOtherSelf(Turn,:,AC,idata)));
                        squeezedAtSwitch_MeanSelfOther= (squeeze(AtSwitch_MeanSelfOther(Turn,:,AC,idata)));
                        squeezedAtSwitch_MeanOtherSelf = (squeeze(AtSwitc_MeanOtherSelf(Turn,:,AC,idata)));

                        CrossSqueezedMeanSelfOther = (squeeze(CrossMeanSelfOther(Turn,:,AC,idata)));
                        CrossSqueezedMeanOtherSelf = (squeeze(CrossMeanOtherSelf(Turn,:,AC,idata)));


                        CrossSqueezedAtSwitchMeanSelfOther = (squeeze(CrossAtSwitch_MeanSelfOther(Turn,:,AC,idata)));
                        CrossSqueezedAtSwitchMeanOtherSelf = (squeeze(CrossAtSwitc_MeanOtherSelf(Turn,:,AC,idata)));

                        MeanOverSessSelfOther(Turn,:,AC) = (squeezedMeanSelfOther);
                        MeanOverSessOtherSelf(Turn,:,AC) = (squeezedMeanOtherSelf);
                        MeanOverSessAtSwitch_MeanSelfOther(Turn,:,AC) = (squeezedAtSwitch_MeanSelfOther);
                        MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,AC) = (squeezedAtSwitch_MeanOtherSelf);

                        CrossMeanOverSessSelfOther(Turn,:,AC) = (CrossSqueezedMeanSelfOther);
                        CrossMeanOverSessOtherSelf(Turn,:,AC) = (CrossSqueezedMeanOtherSelf);
                        CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,AC) = (CrossSqueezedAtSwitchMeanSelfOther);
                        CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,AC) = (CrossSqueezedAtSwitchMeanOtherSelf);



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

                if ii == 1
                    SubTypeTrialString = [];
                    SubTypeTrialString = " Shuffled";
                else
                    SubTypeTrialString = [];
                    SubTypeTrialString = " Blocked";
                end
                SubTypeTrialString_AllSess{idata} = SubTypeTrialString;


            end

        end

    end
else
    for idata = 1 : length(MergedData)
        SubTypeTrialString_AllSess{idata} = "";
        ColorChoice = [];
        ATA = [];
        ATB = [];
        diffGoSignalTime_ms_AllTrials = [];
        diffGoSignalTime_ms_DyadicRewarded = [];

        BeforeShedding = MergedData{idata};
        if length(BeforeShedding)>1
            for i_struct = 1 : length(BeforeShedding)
                TransientData = [];
                if i_struct == 1
                    TransientData = BeforeShedding{i_struct};
                    RewardedANDJointTrialId = find(...
                        TransientData.FullPerTrialStruct.TrialIsRewarded ...
                        & TransientData.FullPerTrialStruct.TrialIsJoint ...
                        & (TransientData.FullPerTrialStruct.NumChoiceTargetsPerTrial == 2)...
                        );

                    DyadicTrialRewardedIdx = intersect(RewardedANDJointTrialId, TransientData.TrialSets.ByTrialSubType.Dyadic);

                    SemiSoloTrialRewardedIdx = intersect(RewardedANDJointTrialId, TransientData.TrialSets.ByTrialSubType.SemiSolo);


                    % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)

                    WholeTrialsChoiceVectorA = TransientData.FullPerTrialStruct.PreferableTargetSelected_A;
                    WholeTrialsChoiceVectorB = TransientData.FullPerTrialStruct.PreferableTargetSelected_B;

                    ColorChoice(1,:) = WholeTrialsChoiceVectorA(DyadicTrialRewardedIdx); %own colour = 1
                    ColorChoice(2,:) = WholeTrialsChoiceVectorB(DyadicTrialRewardedIdx); %own colour = 1

                    % RTA = TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
                    % RTB = TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);


                    % TransientATA = [];
                    % TransientATB = [];
                    %
                    % TransientATA = [ATA;TransientData.FullPerTrialStruct.A_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx)];
                    % TransientATB = [ATB;TransientData.FullPerTrialStruct.B_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx)];


                    diffGoSignalTime_ms_AllTrials = TransientData.FullPerTrialStruct.A_GoSignalTime - TransientData.FullPerTrialStruct.B_GoSignalTime;
                    diffGoSignalTime_ms_DyadicRewarded = diffGoSignalTime_ms_AllTrials(DyadicTrialRewardedIdx);




                end
                if i_struct > 1

                    TransientData = BeforeShedding{i_struct};

                    RewardedANDJointTrialId = find(...
                        TransientData.FullPerTrialStruct.TrialIsRewarded ...
                        & TransientData.FullPerTrialStruct.TrialIsJoint ...
                        & (TransientData.FullPerTrialStruct.NumChoiceTargetsPerTrial == 2)...
                        );

                    DyadicTrialRewardedIdx = intersect(RewardedANDJointTrialId, TransientData.TrialSets.ByTrialSubType.Dyadic);

                    SemiSoloTrialRewardedIdx = intersect(RewardedANDJointTrialId, TransientData.TrialSets.ByTrialSubType.SemiSolo);

                    % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)

                    WholeTrialsChoiceVectorA = TransientData.FullPerTrialStruct.PreferableTargetSelected_A;
                    WholeTrialsChoiceVectorB = TransientData.FullPerTrialStruct.PreferableTargetSelected_B;


                    TransientsColorChoiceA = [];
                    TransientsColorChoiceA = [ColorChoice(1,:),WholeTrialsChoiceVectorA'];

                    TransientsColorChoiceB = [];
                    TransientsColorChoiceB = [ColorChoice(2,:),WholeTrialsChoiceVectorB'];

                    ColorChoice = [];

                    ColorChoice(1,:) = TransientsColorChoiceA; %own colour = 1
                    ColorChoice(2,:) = TransientsColorChoiceB; %own colour = 1

                    %
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


                    Transient_DiffGoSig = [];


                    Transient_DiffGoSig = TransientData.FullPerTrialStruct.A_GoSignalTime - TransientData.FullPerTrialStruct.B_GoSignalTime;
                    Transient_DiffGoSig = Transient_DiffGoSig(DyadicTrialRewardedIdx);


                    diffGoSignalTime_ms_DyadicRewarded = [diffGoSignalTime_ms_DyadicRewarded;Transient_DiffGoSig];




                end


            end

        end




        if isscalar(BeforeShedding)

            TransientData = BeforeShedding{1};
            % RewardedANDdyadicTrialId = intersect(TransientData.TrialSets.All(logical(TransientData.FullPerTrialStruct. ...
            %     TrialIsRewarded)), TransientData.TrialSets.All(logical(TransientData.FullPerTrialStruct. ...
            %     TrialIsJoint)));

            RewardedANDJointTrialId = find(...
                TransientData.FullPerTrialStruct.TrialIsRewarded ...
                & TransientData.FullPerTrialStruct.TrialIsJoint ...
                & (TransientData.FullPerTrialStruct.NumChoiceTargetsPerTrial == 2)...
                );

            DyadicTrialRewardedIdx = intersect(RewardedANDJointTrialId, TransientData.TrialSets.ByTrialSubType.Dyadic);

            SemiSoloTrialRewardedIdx = intersect(RewardedANDJointTrialId, TransientData.TrialSets.ByTrialSubType.SemiSolo);

            WholeTrialsChoiceVectorA = TransientData.FullPerTrialStruct.PreferableTargetSelected_A;
            WholeTrialsChoiceVectorB = TransientData.FullPerTrialStruct.PreferableTargetSelected_B;
            ColorChoice = [];

            ColorChoice(1,:) = WholeTrialsChoiceVectorA(DyadicTrialRewardedIdx); %own colour = 1
            ColorChoice(2,:) = WholeTrialsChoiceVectorB(DyadicTrialRewardedIdx); %own colour = 1




            % Coordinated_trial_ldx = A_ColorChoice | B_ColorChoice;


            % RTA = [];
            % RTB = [];
            %
            % RTA = TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
            % RTB = TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);

            diffGoSignalTime_ms_AllTrials = [];
            diffGoSignalTime_ms_DyadicRewarded = [];
            diffGoSignalTime_ms_AllTrials = TransientData.FullPerTrialStruct.A_GoSignalTime - TransientData.FullPerTrialStruct.B_GoSignalTime;
            diffGoSignalTime_ms_DyadicRewarded = diffGoSignalTime_ms_AllTrials(DyadicTrialRewardedIdx);




        end

        if size(ColorChoice,1)>2
            ColorChoice = ColorChoice';
        end

        %% RT

        %% finding turns ids
        switch ActionTimingMeasure
            case 'AT'
                diffAT_AB = [];
                diffAT_AB = ATA - ATB;  % minus means actor A was first, o means simul, positive means Actor A was second

                ATurnIdx = [];
                ATurnIdx = nan(length(diffAT_AB),3);  %first column is actor A first, Second column is actor A/B simul, third column is Actor A second,
                tmp_AgoB = diffAT_AB < (- TimeRange_ToleranceThreshold);
                tmp_BgoA = diffAT_AB > ( TimeRange_ToleranceThreshold);
                tmp_ABgo = ~tmp_AgoB & ~tmp_BgoA;
            case 'GoSig'
                diffAT_AB = [];
                diffAT_AB = diffGoSignalTime_ms_DyadicRewarded;
                ATurnIdx = [];
                ATurnIdx = nan(length(diffAT_AB),3);  %first column is actor A first, Second column is actor A/B simul, third column is Actor A second,
                tmp_AgoB = diffAT_AB < (- TimeRange_ToleranceThreshold);
                tmp_BgoA = diffAT_AB > ( TimeRange_ToleranceThreshold);
                % tmp_ABgo = (diffRT_AB > 0) & (diffRT_AB < RT_ToleranceThreshold);

                tmp_ABgo = diffAT_AB == 0;
                % AfasterB_WithinSimulGo =    % 100 MS THRESHOLD
                % BfasterA_WithinSimulGo =
                % ABsimulAT_WithinSimulGo =


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
        SelfOther_NotValidSwitchId = cell(1,2);
        for Ac = 1 : 2
            str = sprintf('%c_SelfToOther', 'A' + (Ac-1));
            c = 1;
            for i_SelfOther = 1 : numel(eval(str))
                DATA = [];
                DATA = ColorChoice(Ac,:);
                SwitchVec = [];
                SwitchVec = eval(str);
                SwitchChoice = 0;
                BeforeIdx = SwitchVec(i_SelfOther)-BeforeAfter_Length;
                AfterIdx =  SwitchVec(i_SelfOther)+BeforeAfter_Length;

                BeforeSwitchVec =  sum(DATA(BeforeIdx:(BeforeIdx+WindowAroundSwitch)) == not(SwitchChoice)) >= MinimumSameColor;
                AfterSwitchVec = sum(DATA(SwitchVec(i_SelfOther)+1:AfterIdx) == SwitchChoice) >= MinimumSameColor;
                if not(BeforeSwitchVec&AfterSwitchVec)
                    SelfOther_NotValidSwitchId{Ac}(c) = SwitchVec(i_SelfOther);
                    c = c+1;
                end
            end
        end

        ANotValidSwitchID_SelfOther =  SelfOther_NotValidSwitchId{1};
        BNotValidSwitchID_SelfOther = SelfOther_NotValidSwitchId{2};
        %%
        ANotValidSwitchID_OtherSelf = [];
        BNotValidSwitchID_OtherSelf = [];
        OtherSelf_NotValidSwitchId = cell(1,2);
        for Ac = 1 : 2
            str = sprintf('%c_OtherToSelf', 'A' + (Ac-1));
            c = 1;
            for i_OtherSelf = 1 : numel(eval(str))
                DATA = [];
                DATA = ColorChoice(Ac,:);
                SwitchVec = [];
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


        A_AllTurn_NonTurn_ReplacedNan = nan(length(diffAT_AB),3); %1st column: first, 2d column: simul...
        B_AllTurn_NonTurn_ReplacedNan = nan(length(diffAT_AB),3);

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
end
%% If session is not dyadic, fill in the result with NaN, then for plotting function it wont produce error
if ~isempty(SemiSoloTrialRewardedIdx) && contains(scriptName,'SingleSess')
    % NaN_Filled = repmat({nan(1, (BeforeAfter_Length*2)+1}, 2, 3);   %2 for 2 players, 3 for 3 timing condition
     NaN_Filled = nan(1, (BeforeAfter_Length*2)+1);
    [SingleSess_SelfOther{idata}{:,:}] = deal(NaN_Filled);
    [SingleSess_OtherSelf{idata}{:,:}] = deal(NaN_Filled);
    [SingleSess_AtSwitchSelfother{idata}{:,:}] = deal(NaN_Filled);
    [SingleSess_CrossSelfOther{idata}{:,:}] = deal(NaN_Filled);
    [SingleSess_AtSwitchCrossSelfother{idata}{:,:}] = deal(NaN_Filled);
    [SingleSess_AtSwitchOtherSelf{idata}{:,:}] = deal(NaN_Filled);
    [SingleSess_CrossOtherSelf{idata}{:,:}] = deal(NaN_Filled);
    [SingleSess_AtSwitchCrossOtherSelf{idata}{:,:}] = deal(NaN_Filled);

    SelfOtherSwitchNum(:,:,idata) = nan(3,2);
    OtherSelfSwitchNum(:,:,idata) = nan(3,2);
    CrossSelfOtherSwitchNum(:,:,idata) = nan(3,2);
    CrossOtherSelfSwitchNum(:,:,idata) = nan(3,2);
    AtSwitch_SelfOther_SwitchNum(:,:,idata) = nan(3,2);
    AtSwitch_OtherSelf_SwitchNum(:,:,idata) = nan(3,2);
    CrossAtSwitch_SelfOther_SwitchNum(:,:,idata) = nan(3,2);
    CrossAtSwitch_OtherSelf_SwitchNum(:,:,idata) = nan(3,2);

    SEM_NaN_Filled = nan(3, (BeforeAfter_Length*2)+1, 2);

    CrossAtSwitch_SEM_OverSess_SelfOther(:,:,:,idata) = SEM_NaN_Filled;
    CrossAtSwitch_SEM_OverSess_OtherSelf(:,:,:,idata) = SEM_NaN_Filled;
    SEM_OverSessAtSwitch_SelfOther(:,:,:,idata) = SEM_NaN_Filled;
    SEM_OverSessAtSwitch_OtherSelf(:,:,:,idata) = SEM_NaN_Filled;
    CrossSEM_OverSess_SelfOther(:,:,:,idata) = SEM_NaN_Filled;
    CrossSEM_OverSess_OtherSelf(:,:,:,idata) = SEM_NaN_Filled;

    SubTypeTrialString_AllSess{idata} = "SemiSolo!";

end


%% Fill in the results: choices before and after switch
Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.WholeSess_Selfother = WholeSess_SelfOther;
Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.WholeSess_OtherSelf = WholeSess_OtherSelf;

Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.WholeSess_AtSwitchSelfother = WholeSess_AtSwitchSelfother;
Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.WholeSess_CrossSelfOther = WholeSess_CrossSelfOther;
Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.WholeSess_AtSwitchCrossSelfother = WholeSess_AtSwitchCrossSelfother;
Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.WholeSess_AtSwitchOtherSelf = WholeSess_AtSwitchOtherSelf;
Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.WholeSess_CrossOtherSelf = WholeSess_CrossOtherSelf;
Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.WholeSess_AtSwitchCrossOtherSelf = WholeSess_AtSwitchCrossOtherSelf;
%% switch num

Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.SelfOtherSwitchNum =  SelfOtherSwitchNum;
Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.OtherSelfSwitchNum =  OtherSelfSwitchNum;

Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.CrossSelfOtherSwitchNum =  CrossSelfOtherSwitchNum;
Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.CrossOtherSelfSwitchNum =  CrossOtherSelfSwitchNum;

Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.AtSwitch_SelfOther_SwitchNum =  AtSwitch_SelfOther_SwitchNum;
Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.AtSwitch_OtherSelf_SwitchNum =  AtSwitch_OtherSelf_SwitchNum;

Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.CrossAtSwitch_SelfOther_SwitchNum =  CrossAtSwitch_SelfOther_SwitchNum;
Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.CrossAtSwitch_OtherSelf_SwitchNum =  CrossAtSwitch_OtherSelf_SwitchNum;
%% sem over switches for each session

Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.CrossAtSwitch_SEM_OverSess_SelfOther = CrossAtSwitch_SEM_OverSess_SelfOther;

Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.CrossAtSwitch_SEM_OverSess_OtherSelf = CrossAtSwitch_SEM_OverSess_OtherSelf;

Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.SEM_OverSessAtSwitch_SelfOther = SEM_OverSessAtSwitch_SelfOther;

Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.SEM_OverSessAtSwitch_OtherSelf = SEM_OverSessAtSwitch_OtherSelf;

Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.CrossSEM_OverSess_SelfOther = CrossSEM_OverSess_SelfOther;

Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.CrossSEM_OverSess_OtherSelf = CrossSEM_OverSess_OtherSelf;

Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.SEM_OverSess_SelfOther = SEM_OverSess_SelfOther;

Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.SEM_OverSess_OtherSelf = SEM_OverSess_OtherSelf;
%% saving single sess choice
Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.SubTypeTrialString = SubTypeTrialString_AllSess;
if contains(scriptName,'SingleSess') || contains(scriptName,'OnlyLasts')

    Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.Selfother_SingleSess = SingleSess_SelfOther;
    Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.OtherSelf_SingleSess = SingleSess_OtherSelf;

    Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.AtSwitchSelfother_SingleSess = SingleSess_AtSwitchSelfother;
    Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.CrossSelfOther_SingleSess = SingleSess_CrossSelfOther;
    Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.AtSwitchCrossSelfother_SingleSess = SingleSess_AtSwitchCrossSelfother;
    Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.AtSwitchOtherSelf_SingleSess = SingleSess_AtSwitchOtherSelf;
    Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.CrossOtherSelf_SingleSess = SingleSess_CrossOtherSelf;
    Results_CoreProcessing3of5ChoiceDynamic_GoSigDataSet.AtSwitchCrossOtherSelf_SingleSess = SingleSess_AtSwitchCrossOtherSelf;
end








