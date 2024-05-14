% importing data
cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes\NHP_Solo_Qlearning'
%%
% run('NHP_SoloBCurius_fullPath.m');
% run('NHP_SoloACurius_fullPath.m');
% run('NHP_SoloAFlaffus_fullPath');
% run('NHP_SoloBFlaffus_fullPath');
% % run('NHP_SoloAElmo_fullPath'); %performance already got saturated
% run('NHP_SoloBElmo_fullPath')
% run('NHP_SoloALinus_fullPath')
% run('NHP_SoloBLinus_fullPath')
% run('NHP_SoloATesla_fullPath')
% run('NHP_SoloAMagnus_fullPath')

MonkeysName = {'Curius','Flaffus','Elmo','Linus','Tesla','Magnus'}
CONDITION = {'A','B'}
%%
for MONKEY = 1 : numel(MonkeysName)
    if   exist(sprintf('NHP_SoloA%s_fullPath',MonkeysName{MONKEY})) && exist(sprintf('NHP_SoloB%s_fullPath',MonkeysName{MONKEY})) == 2
        run(sprintf('NHP_SoloB%s_fullPath.m',MonkeysName{MONKEY}))
        run(sprintf('NHP_SoloA%s_fullPath.m',MonkeysName{MONKEY}))


        report_struct_listB = cell([1, numel(NHP_SoloB)]);
        report_struct_listA = cell([1, numel(NHP_SoloA)]);

        for SessNum = 1 : numel(NHP_SoloB)
            load(char(NHP_SoloB{SessNum}), 'report_struct');
            report_struct_listB(SessNum) = {report_struct};
        end

        for SessNum = 1 : numel(NHP_SoloA)
            load(char(NHP_SoloA{SessNum}), 'report_struct');
            report_struct_listA(SessNum) = {report_struct};
        end

        %% extraxcting needed vectors: choice vector and reward vector
        bPHI = nan(1,numel(NHP_SoloB))
        bTHETA = nan(1,numel(NHP_SoloB))
        bR2VAL = nan(1,numel(NHP_SoloB))
        bPerf = nan(1,numel(NHP_SoloB))

        aPHI = nan(1,numel(NHP_SoloA))
        aTHETA = nan(1,numel(NHP_SoloA))
        aR2VAL = nan(1,numel(NHP_SoloA))
        aPerf = nan(1,numel(NHP_SoloA))

        SessDateAll_SoloB = nan(1,numel(NHP_SoloB))
        SessDateAll_SoloA = nan(1,numel(NHP_SoloA))

        TrialNumsB = nan(1,numel(NHP_SoloB))
        TrialNumsA = nan(1,numel(NHP_SoloA))
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %SOLOB

        parfor SessSolo =  1 : numel(NHP_SoloB)
            ID = SessSolo;
            report_struct = report_struct_listB{ID};
            SESSIONDATE = report_struct.LoggingInfo.SessionDate;
            % if exist('NHP_SoloB')
            %     % Actor_A = string(report_struct.unique_lists.A_Name);
            %     Actor_B= string(report_struct.unique_lists.B_Name);
            % else
            %     Actor_A = string(report_struct.unique_lists.A_Name);
            % end
            %
            %
            % loadedDATA = array2table(report_struct.data,'VariableNames',report_struct.header);
            % if exist('NHP_SoloB')
            %     Rewarded_Aborted  = report_struct.unique_lists.B_OutcomeENUM(loadedDATA.B_OutcomeENUM_idx); % this vector shows which trial was aborted, which was successful,
            % else
            %     Rewarded_Aborted  = report_struct.unique_lists.A_OutcomeENUM(loadedDATA.A_OutcomeENUM_idx);
            % end

            Actor_B= string(report_struct.unique_lists.B_Name);



            loadedDATA = array2table(report_struct.data,'VariableNames',report_struct.header);


            Rewarded_Aborted  = report_struct.unique_lists.B_OutcomeENUM(loadedDATA.B_OutcomeENUM_idx); % this vector shows which trial was aborted, which was successful,



            if isfield(report_struct.unique_lists, 'A_TrialSubTypeENUM')
                Trial_TaskType_All = report_struct.unique_lists.A_TrialSubTypeENUM(loadedDATA.A_TrialSubTypeENUM_idx); % this vector shows trial type based on task
            else
                complete_SoloA_trial_idx = intersect(find(report_struct.data(:, report_struct.cn.A_InitialFixationTouchTime_ms) ~= 0), find(report_struct.data(:, report_struct.cn.B_InitialFixationTouchTime_ms) == 0)); %Because when time for touching the screen for actor B is zero it means that only Actor A played
                complete_SoloB_trial_idx = intersect(find(report_struct.data(:, report_struct.cn.A_InitialFixationTouchTime_ms) == 0), find(report_struct.data(:, report_struct.cn.B_InitialFixationTouchTime_ms) ~= 0));
                complete_Dyadic_trial_idx = intersect(find(report_struct.data(:, report_struct.cn.A_InitialFixationTouchTime_ms) ~= 0), find(report_struct.data(:, report_struct.cn.B_InitialFixationTouchTime_ms) ~= 0));
                Trial_TaskType_All = cell(size(Rewarded_Aborted));
                Trial_TaskType_All(complete_SoloA_trial_idx) = {'SoloA'};
                Trial_TaskType_All(complete_SoloB_trial_idx) = {'SoloB'};
                Trial_TaskType_All(complete_Dyadic_trial_idx) = {'Dyadic'};
            end

            % Conf Cue randomisation
            % create % confederate's predictability

            % if isfield(report_struct.Enums, 'RandomizationMethodCodes')
            %     RandomizationMethodCodes_list = report_struct.Enums.RandomizationMethodCodes.unique_lists.RandomizationMethodCodes;
            %
            %     ConfChoiceCueRnd_method_A_RandomizationMethodCodes_idx = report_struct.SessionByTrial.data(:, report_struct.SessionByTrial.cn.ConfederateChoiceCueRandomizer_method_A) + 1
            %     ConfChoiceCue_A_rnd_method_by_trial_list = RandomizationMethodCodes_list(ConfChoiceCueRnd_method_A_RandomizationMethodCodes_idx);
            %     ConfChoiceCue_A_invisible_idx = find(report_struct.data(:, report_struct.cn.A_ShowChoiceHint) == 0);
            %     ConfChoiceCue_A_rnd_method_by_trial_list(ConfChoiceCue_A_invisible_idx) = RandomizationMethodCodes_list(1);
            %     ConfChoiceCueRnd_method_B_RandomizationMethodCodes_idx = report_struct.SessionByTrial.data(:, report_struct.SessionByTrial.cn.ConfederateChoiceCueRandomizer_method_B) + 1
            %     ConfChoiceCue_B_rnd_method_by_trial_list = RandomizationMethodCodes_list(ConfChoiceCueRnd_method_B_RandomizationMethodCodes_idx);
            %     ConfChoiceCue_B_invisible_idx = find(report_struct.data(:, report_struct.cn.B_ShowChoiceHint) == 0);
            %     ConfChoiceCue_B_rnd_method_by_trial_list(ConfChoiceCue_B_invisible_idx) = RandomizationMethodCodes_list(1);
            %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %     Trial_ShuffledBlockType_All_A = ConfChoiceCue_A_rnd_method_by_trial_list;
            %     Trial_ShuffledBlockType_All_B = ConfChoiceCue_B_rnd_method_by_trial_list  % Blocked Shuffles are determined based on Actor B (Human)
            %     Trial_ShuffledBlockType_All_B(matches(Trial_ShuffledBlockType_All_B,'BLOCKED_GEN_LIST')) = {'Blocked'};
            %     Trial_ShuffledBlockType_All_B(matches(Trial_ShuffledBlockType_All_B,'RND_GEN_LIST')) = {'Shuffled'};
            %
            %
            %     %numel(unique(Trial_TaskType_All))
            %     DyadicID_All = find(strcmp(Trial_TaskType_All,'Dyadic'));
            %     % ShufledID_All =  find(cellfun(@(x) strcmp(x, 'Shuffled'), Trial_ShuffledBlockType_All_B));
            %     BlockedID_All =  find(cellfun(@(x) strcmp(x, 'Blocked'), Trial_ShuffledBlockType_All_B));
            % else
            %     DyadicID_All= [];
            %     BlockedID_All = [];
            %end

            WholeTrials = numel(Rewarded_Aborted);
            NumTrials = size(report_struct.data, 1);
            RewardedID = find(strcmp(Rewarded_Aborted,'REWARD')); % indices of rewarded trials
            TrialSets_All = (1:1:size(report_struct.data, 1))';
            SideA_ActiveTrials = report_struct.data(:, report_struct.cn.A_IsActive); % this produce the same data: loadedDATA(:,5)
            SideB_ActiveTrials = report_struct.data(:, report_struct.cn.B_IsActive); % this produce the same data: loadedDATA(:,79)
            %Sebastian: % activity (was a side active during a given trial)
            % dual subject activity does not necessarily mean joint trials!
            %Zahra: This IDs show the trials that both actors play, but they can play
            %like SoloA SoloB or Dyadic joint, so dual trials doesnt mean joint trials
            SideA_ActiveTrials = find(SideA_ActiveTrials);
            SideB_ActiveTrials = find(SideB_ActiveTrials);
            %Sebastian: dual subject trials are always identical for both sides...
            DualSubjectTrials = intersect(SideA_ActiveTrials, SideB_ActiveTrials);
            SideA_DualSubjectTrials = DualSubjectTrials;
            SideB_DualSubjectTrials= DualSubjectTrials;
            %Single subject trials: % these contain trials were only one subject performed the task
            SingleSubjectTrials = setdiff(TrialSets_All,DualSubjectTrials);
            SingleSubjectTrials_SideA = setdiff(SideA_ActiveTrials, SideB_ActiveTrials);
            SingleSubjectTrials_SideB = setdiff(SideB_ActiveTrials, SideA_ActiveTrials);
            %Sebastian: try to find all trials a subject was active in
            %Zahra: These are the trials that each subjects, regardless of single, or
            %dual was active in.
            SideA_AllTrials = union(SideA_DualSubjectTrials,SingleSubjectTrials_SideA);
            SideB_AllTrials = union(SideB_DualSubjectTrials,SingleSubjectTrials_SideB);
            AllActiveTrials = union(SideA_AllTrials,SideB_AllTrials);
            %%
            % Sebastian: these are real joint trials when both subject work together:
            % test for touching the initial target: (initiated trials)
            InitiatedTrialsA = find(report_struct.data(:, report_struct.cn.A_InitialFixationTouchTime_ms) > 0);
            InitiatedTrialsB = find(report_struct.data(:, report_struct.cn.B_InitialFixationTouchTime_ms) > 0);
            %%
            % restrict Initited trials to Side:
            SideA_InitiatedTrialsA = intersect(SideA_AllTrials,InitiatedTrialsA);
            SideB_InitiatedTrialsB = intersect(SideB_AllTrials,InitiatedTrialsB);
            DualSubjectJointTrials = intersect(InitiatedTrialsA, InitiatedTrialsB);
            Rewarded_DualSubjectJointTrials = intersect(DualSubjectJointTrials,RewardedID);
            SideA_SoloSubjectTrials = setdiff(InitiatedTrialsA, InitiatedTrialsB);
            SideB_SoloSubjectTrials = setdiff(InitiatedTrialsB, InitiatedTrialsA);
            % Sebastian: joint trials are always for both sides
            SideA_DualSubjectJointTrials = DualSubjectJointTrials;
            SideB_DualSubjectJointTrials = DualSubjectJointTrials;
            % Sebastian: what to do about the dual subject non-joint trials, with two subjects present and active, but only one working?
            DualSubjectSoloTrials = union(SideA_SoloSubjectTrials, SideB_SoloSubjectTrials);
            Rewarded_DualSubjectSoloTrials = intersect(DualSubjectSoloTrials,RewardedID)
            % Sebastian: generate indices for: targetposition, choice position, rewards-payout (target preference)
            % get the choice preference choice is always by side
            %% Zahra: Finding trials by choice side: (left or right)
            EqualPositionSlackPixels = 2;	% how many pixels two position are allowed to differ while still accounted as same, this is required as the is some rounding error in earlier code that produces of by one positions
            A_LeftChoiceIdx = find(report_struct.data(:, report_struct.cn.A_TouchInitialFixationPosition_X) > report_struct.data(:, report_struct.cn.A_TouchSelectedTargetPosition_X));
            A_RightChoiceIdx = find(report_struct.data(:, report_struct.cn.A_TouchInitialFixationPosition_X) < report_struct.data(:, report_struct.cn.A_TouchSelectedTargetPosition_X));
            % remove trials when the side was not playing
            A_LeftChoiceIdx = intersect(A_LeftChoiceIdx,SideA_AllTrials);
            A_RightChoiceIdx = intersect(A_RightChoiceIdx, SideA_AllTrials);
            % allow some slack for improper rounding errors
            SideA_ChoiceCenterX = find(abs(report_struct.data(:, report_struct.cn.A_TouchInitialFixationPosition_X) - report_struct.data(:, report_struct.cn.A_TouchSelectedTargetPosition_X)) <= EqualPositionSlackPixels);
            SideA_ChoiceCenterX = intersect(SideA_ChoiceCenterX, SideA_AllTrials);
            SideA_ChoiceScreenFromALeft = A_LeftChoiceIdx;
            SideA_ChoiceScreenFromARight = A_RightChoiceIdx;
            %% Zahra: same precudre fot Actor B
            B_LeftChoiceIdx = find(report_struct.data(:, report_struct.cn.B_TouchInitialFixationPosition_X) < report_struct.data(:, report_struct.cn.B_TouchSelectedTargetPosition_X));
            B_RightChoiceIdx = find(report_struct.data(:, report_struct.cn.B_TouchInitialFixationPosition_X) > report_struct.data(:, report_struct.cn.B_TouchSelectedTargetPosition_X));
            B_LeftChoiceIdx = intersect(B_LeftChoiceIdx, SideB_AllTrials);
            B_RightChoiceIdx = intersect(B_RightChoiceIdx, SideB_AllTrials);
            % allow some slack for improper rounding errors
            SideB_ChoiceCenterX = find(abs(report_struct.data(:, report_struct.cn.B_TouchInitialFixationPosition_X) - report_struct.data(:, report_struct.cn.B_TouchSelectedTargetPosition_X)) <= EqualPositionSlackPixels);
            SideB_ChoiceCenterX = intersect(SideB_ChoiceCenterX, SideB_AllTrials);
            % for Side B the subjective choice sides are flipped as seen from side A in
            % eventide screen coordinates
            SideB_ChoiceScreenFromALeft = B_RightChoiceIdx;
            SideB_ChoiceScreenFromARight = B_LeftChoiceIdx;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % in this part you define the varibles needed for defining preferred colour
            % vector
            if isfield(report_struct.cn, 'A_RandomizedTargetPosition_Y') && isfield(report_struct.cn, 'A_RandomizedTargetPosition_X')
                A_SelectedTargetEqualsRandomizedTargetTrialIdx = find((abs(report_struct.data(:, report_struct.cn.A_RandomizedTargetPosition_Y) - report_struct.data(:, report_struct.cn.A_TouchSelectedTargetPosition_Y)) <= EqualPositionSlackPixels) & (abs(report_struct.data(:, report_struct.cn.A_RandomizedTargetPosition_X) - report_struct.data(:, report_struct.cn.A_TouchSelectedTargetPosition_X)) <= EqualPositionSlackPixels));
            else
                A_SelectedTargetEqualsRandomizedTargetTrialIdx = [];
            end
            if isfield(report_struct.cn, 'B_RandomizedTargetPosition_Y') && isfield(report_struct.cn, 'B_RandomizedTargetPosition_X')
                B_SelectedTargetEqualsRandomizedTargetTrialIdx = find((abs(report_struct.data(:, report_struct.cn.B_RandomizedTargetPosition_Y) - report_struct.data(:, report_struct.cn.B_TouchSelectedTargetPosition_Y)) <= EqualPositionSlackPixels) & (abs(report_struct.data(:, report_struct.cn.B_RandomizedTargetPosition_X) - report_struct.data(:, report_struct.cn.B_TouchSelectedTargetPosition_X)) <= EqualPositionSlackPixels));
            else
                B_SelectedTargetEqualsRandomizedTargetTrialIdx = [];
            end
            % now only take those trials in which a subject actually touched the target
            A_SelectedTargetEqualsRandomizedTargetTrialIdx = intersect(A_SelectedTargetEqualsRandomizedTargetTrialIdx, find(report_struct.data(:, report_struct.cn.A_TargetTouchTime_ms) > 0.0));
            B_SelectedTargetEqualsRandomizedTargetTrialIdx = intersect(B_SelectedTargetEqualsRandomizedTargetTrialIdx, find(report_struct.data(:, report_struct.cn.B_TargetTouchTime_ms) > 0.0));
            A_SelectedTargetEqualsRandomizedTargetTrialIdx = intersect(A_SelectedTargetEqualsRandomizedTargetTrialIdx, SideA_AllTrials);
            B_SelectedTargetEqualsRandomizedTargetTrialIdx = intersect(B_SelectedTargetEqualsRandomizedTargetTrialIdx, SideB_AllTrials);
            % keep the randomisation information, to allow fake by value analysus for
            % freecgoice trials to compare agains left right and against informed
            % trials
            SideA_ProtoTargetValueHigh = A_SelectedTargetEqualsRandomizedTargetTrialIdx; % here the randomized position equals higher payoff
            SideA_ProtoTargetValueLow = intersect(setdiff(TrialSets_All, A_SelectedTargetEqualsRandomizedTargetTrialIdx), SideA_AllTrials);
            SideB_ProtoTargetValueHigh = intersect(setdiff(TrialSets_All, B_SelectedTargetEqualsRandomizedTargetTrialIdx), SideB_AllTrials);
            SideB_ProtoTargetValueLow = B_SelectedTargetEqualsRandomizedTargetTrialIdx; % here the randomized position equals lower payoff
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% Zahra: Finding trials by choice color (own preferred or other's preferred): (RED or BLUE):
            % get the share of own choices
            PreferableTargetSelected_A = zeros([NumTrials, 1]);
            PreferableTargetSelected_A(SideA_ProtoTargetValueHigh) = 1;
            PreferableTargetSelected_B = zeros([NumTrials, 1]);
            PreferableTargetSelected_B(SideB_ProtoTargetValueHigh) = 1;
            % get the share of own choices
            NonPreferableTargetSelected_A = zeros([NumTrials, 1]);
            NonPreferableTargetSelected_A(SideA_ProtoTargetValueLow) = 1;
            NonPreferableTargetSelected_B = zeros([NumTrials, 1]);
            NonPreferableTargetSelected_B(SideB_ProtoTargetValueLow) = 1;
            % get vectors for side/value choices
            PreferableNoneNonpreferableSelected_A = zeros([NumTrials, 1]) + PreferableTargetSelected_A - NonPreferableTargetSelected_A;
            PreferableNoneNonpreferableSelected_B = zeros([NumTrials, 1]) + PreferableTargetSelected_B - NonPreferableTargetSelected_B;


            %% be careful to not include aborted trials in choice vector:

            % if exist('NHP_SoloB')
            %     ChoiceVectorAll = PreferableTargetSelected_B; % 1 means prefered colr, 0 means anti prefered color
            % else
            %     ChoiceVectorAll = PreferableTargetSelected_A;
            % end

            ChoiceVectorAll = PreferableTargetSelected_B;
            ChoiceVectorRewarded = ChoiceVectorAll(RewardedID)

            RewardValueVectorAll = table2array(loadedDATA(:,"B_NumberRewardPulsesDelivered_HIT"))



            RewardValueVectorRewarded = RewardValueVectorAll(RewardedID)


            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Fitting Q learning with VBA toolbox
            cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes\VBA_AllFunctions'

            choices = ChoiceVectorRewarded; % choice vector of Agent A or B,  1 = preferred colour  0 = non prefered colour,
            TrialNumsB(SessSolo) = numel(choices);

            % 1
            %history of theaborted trials????
            if size(choices,1)>1
                choices = choices'
            end

            feedbacks = RewardValueVectorRewarded;% reward value vector for each Agent from pay off matrix???
            if size(feedbacks,1)>1
                feedbacks = feedbacks'
            end
            [posterior, out]=demo_Qlearning(choices, feedbacks)

            bPHI(SessSolo) = exp(posterior.muPhi)
            bTHETA(SessSolo) = VBA_sigmoid(posterior.muTheta)
            bR2VAL(SessSolo) = out.fit.R2
            bPerf(SessSolo) = mean(choices)
            SessDateAll_SoloB(SessSolo) = str2num(SESSIONDATE)

        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %SOLOA




        parfor SessSolo =  1 : numel(NHP_SoloA)
            ID = SessSolo;
            report_struct = report_struct_listA{ID};
            SESSIONDATE = report_struct.LoggingInfo.SessionDate;
            Actor_A = string(report_struct.unique_lists.A_Name);
            loadedDATA = array2table(report_struct.data,'VariableNames',report_struct.header);
            Rewarded_Aborted  = report_struct.unique_lists.A_OutcomeENUM(loadedDATA.A_OutcomeENUM_idx);
            if isfield(report_struct.unique_lists, 'A_TrialSubTypeENUM')
                Trial_TaskType_All = report_struct.unique_lists.A_TrialSubTypeENUM(loadedDATA.A_TrialSubTypeENUM_idx); % this vector shows trial type based on task
            else
                complete_SoloA_trial_idx = intersect(find(report_struct.data(:, report_struct.cn.A_InitialFixationTouchTime_ms) ~= 0), find(report_struct.data(:, report_struct.cn.B_InitialFixationTouchTime_ms) == 0)); %Because when time for touching the screen for actor B is zero it means that only Actor A played
                complete_SoloB_trial_idx = intersect(find(report_struct.data(:, report_struct.cn.A_InitialFixationTouchTime_ms) == 0), find(report_struct.data(:, report_struct.cn.B_InitialFixationTouchTime_ms) ~= 0));
                complete_Dyadic_trial_idx = intersect(find(report_struct.data(:, report_struct.cn.A_InitialFixationTouchTime_ms) ~= 0), find(report_struct.data(:, report_struct.cn.B_InitialFixationTouchTime_ms) ~= 0));
                Trial_TaskType_All = cell(size(Rewarded_Aborted));
                Trial_TaskType_All(complete_SoloA_trial_idx) = {'SoloA'};
                Trial_TaskType_All(complete_SoloB_trial_idx) = {'SoloB'};
                Trial_TaskType_All(complete_Dyadic_trial_idx) = {'Dyadic'};
            end

            % Conf Cue randomisation
            % create % confederate's predictability

            % if isfield(report_struct.Enums, 'RandomizationMethodCodes')
            %     RandomizationMethodCodes_list = report_struct.Enums.RandomizationMethodCodes.unique_lists.RandomizationMethodCodes;
            %
            %     ConfChoiceCueRnd_method_A_RandomizationMethodCodes_idx = report_struct.SessionByTrial.data(:, report_struct.SessionByTrial.cn.ConfederateChoiceCueRandomizer_method_A) + 1
            %     ConfChoiceCue_A_rnd_method_by_trial_list = RandomizationMethodCodes_list(ConfChoiceCueRnd_method_A_RandomizationMethodCodes_idx);
            %     ConfChoiceCue_A_invisible_idx = find(report_struct.data(:, report_struct.cn.A_ShowChoiceHint) == 0);
            %     ConfChoiceCue_A_rnd_method_by_trial_list(ConfChoiceCue_A_invisible_idx) = RandomizationMethodCodes_list(1);
            %     ConfChoiceCueRnd_method_B_RandomizationMethodCodes_idx = report_struct.SessionByTrial.data(:, report_struct.SessionByTrial.cn.ConfederateChoiceCueRandomizer_method_B) + 1
            %     ConfChoiceCue_B_rnd_method_by_trial_list = RandomizationMethodCodes_list(ConfChoiceCueRnd_method_B_RandomizationMethodCodes_idx);
            %     ConfChoiceCue_B_invisible_idx = find(report_struct.data(:, report_struct.cn.B_ShowChoiceHint) == 0);
            %     ConfChoiceCue_B_rnd_method_by_trial_list(ConfChoiceCue_B_invisible_idx) = RandomizationMethodCodes_list(1);
            %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %     Trial_ShuffledBlockType_All_A = ConfChoiceCue_A_rnd_method_by_trial_list;
            %     Trial_ShuffledBlockType_All_B = ConfChoiceCue_B_rnd_method_by_trial_list  % Blocked Shuffles are determined based on Actor B (Human)
            %     Trial_ShuffledBlockType_All_B(matches(Trial_ShuffledBlockType_All_B,'BLOCKED_GEN_LIST')) = {'Blocked'};
            %     Trial_ShuffledBlockType_All_B(matches(Trial_ShuffledBlockType_All_B,'RND_GEN_LIST')) = {'Shuffled'};
            %
            %
            %     %numel(unique(Trial_TaskType_All))
            %     DyadicID_All = find(strcmp(Trial_TaskType_All,'Dyadic'));
            %     % ShufledID_All =  find(cellfun(@(x) strcmp(x, 'Shuffled'), Trial_ShuffledBlockType_All_B));
            %     BlockedID_All =  find(cellfun(@(x) strcmp(x, 'Blocked'), Trial_ShuffledBlockType_All_B));
            % else
            %     DyadicID_All= [];
            %     BlockedID_All = [];
            % end

            WholeTrials = numel(Rewarded_Aborted);
            NumTrials = size(report_struct.data, 1);
            RewardedID = find(strcmp(Rewarded_Aborted,'REWARD')); % indices of rewarded trials
            TrialSets_All = (1:1:size(report_struct.data, 1))';
            SideA_ActiveTrials = report_struct.data(:, report_struct.cn.A_IsActive); % this produce the same data: loadedDATA(:,5)
            SideB_ActiveTrials = report_struct.data(:, report_struct.cn.B_IsActive); % this produce the same data: loadedDATA(:,79)
            %Sebastian: % activity (was a side active during a given trial)
            % dual subject activity does not necessarily mean joint trials!
            %Zahra: This IDs show the trials that both actors play, but they can play
            %like SoloA SoloB or Dyadic joint, so dual trials doesnt mean joint trials
            SideA_ActiveTrials = find(SideA_ActiveTrials);
            SideB_ActiveTrials = find(SideB_ActiveTrials);
            %Sebastian: dual subject trials are always identical for both sides...
            DualSubjectTrials = intersect(SideA_ActiveTrials, SideB_ActiveTrials);
            SideA_DualSubjectTrials = DualSubjectTrials;
            SideB_DualSubjectTrials= DualSubjectTrials;
            %Single subject trials: % these contain trials were only one subject performed the task
            SingleSubjectTrials = setdiff(TrialSets_All,DualSubjectTrials);
            SingleSubjectTrials_SideA = setdiff(SideA_ActiveTrials, SideB_ActiveTrials);
            SingleSubjectTrials_SideB = setdiff(SideB_ActiveTrials, SideA_ActiveTrials);
            %Sebastian: try to find all trials a subject was active in
            %Zahra: These are the trials that each subjects, regardless of single, or
            %dual was active in.
            SideA_AllTrials = union(SideA_DualSubjectTrials,SingleSubjectTrials_SideA);
            SideB_AllTrials = union(SideB_DualSubjectTrials,SingleSubjectTrials_SideB);
            AllActiveTrials = union(SideA_AllTrials,SideB_AllTrials);
            %%
            % Sebastian: these are real joint trials when both subject work together:
            % test for touching the initial target: (initiated trials)
            InitiatedTrialsA = find(report_struct.data(:, report_struct.cn.A_InitialFixationTouchTime_ms) > 0);
            InitiatedTrialsB = find(report_struct.data(:, report_struct.cn.B_InitialFixationTouchTime_ms) > 0);
            %%
            % restrict Initited trials to Side:
            SideA_InitiatedTrialsA = intersect(SideA_AllTrials,InitiatedTrialsA);
            SideB_InitiatedTrialsB = intersect(SideB_AllTrials,InitiatedTrialsB);
            DualSubjectJointTrials = intersect(InitiatedTrialsA, InitiatedTrialsB);
            Rewarded_DualSubjectJointTrials = intersect(DualSubjectJointTrials,RewardedID);
            SideA_SoloSubjectTrials = setdiff(InitiatedTrialsA, InitiatedTrialsB);
            SideB_SoloSubjectTrials = setdiff(InitiatedTrialsB, InitiatedTrialsA);
            % Sebastian: joint trials are always for both sides
            SideA_DualSubjectJointTrials = DualSubjectJointTrials;
            SideB_DualSubjectJointTrials = DualSubjectJointTrials;
            % Sebastian: what to do about the dual subject non-joint trials, with two subjects present and active, but only one working?
            DualSubjectSoloTrials = union(SideA_SoloSubjectTrials, SideB_SoloSubjectTrials);
            Rewarded_DualSubjectSoloTrials = intersect(DualSubjectSoloTrials,RewardedID)
            % Sebastian: generate indices for: targetposition, choice position, rewards-payout (target preference)
            % get the choice preference choice is always by side
            %% Zahra: Finding trials by choice side: (left or right)
            EqualPositionSlackPixels = 2;	% how many pixels two position are allowed to differ while still accounted as same, this is required as the is some rounding error in earlier code that produces of by one positions
            A_LeftChoiceIdx = find(report_struct.data(:, report_struct.cn.A_TouchInitialFixationPosition_X) > report_struct.data(:, report_struct.cn.A_TouchSelectedTargetPosition_X));
            A_RightChoiceIdx = find(report_struct.data(:, report_struct.cn.A_TouchInitialFixationPosition_X) < report_struct.data(:, report_struct.cn.A_TouchSelectedTargetPosition_X));
            % remove trials when the side was not playing
            A_LeftChoiceIdx = intersect(A_LeftChoiceIdx,SideA_AllTrials);
            A_RightChoiceIdx = intersect(A_RightChoiceIdx, SideA_AllTrials);
            % allow some slack for improper rounding errors
            SideA_ChoiceCenterX = find(abs(report_struct.data(:, report_struct.cn.A_TouchInitialFixationPosition_X) - report_struct.data(:, report_struct.cn.A_TouchSelectedTargetPosition_X)) <= EqualPositionSlackPixels);
            SideA_ChoiceCenterX = intersect(SideA_ChoiceCenterX, SideA_AllTrials);
            SideA_ChoiceScreenFromALeft = A_LeftChoiceIdx;
            SideA_ChoiceScreenFromARight = A_RightChoiceIdx;
            %% Zahra: same precudre fot Actor B
            B_LeftChoiceIdx = find(report_struct.data(:, report_struct.cn.B_TouchInitialFixationPosition_X) < report_struct.data(:, report_struct.cn.B_TouchSelectedTargetPosition_X));
            B_RightChoiceIdx = find(report_struct.data(:, report_struct.cn.B_TouchInitialFixationPosition_X) > report_struct.data(:, report_struct.cn.B_TouchSelectedTargetPosition_X));
            B_LeftChoiceIdx = intersect(B_LeftChoiceIdx, SideB_AllTrials);
            B_RightChoiceIdx = intersect(B_RightChoiceIdx, SideB_AllTrials);
            % allow some slack for improper rounding errors
            SideB_ChoiceCenterX = find(abs(report_struct.data(:, report_struct.cn.B_TouchInitialFixationPosition_X) - report_struct.data(:, report_struct.cn.B_TouchSelectedTargetPosition_X)) <= EqualPositionSlackPixels);
            SideB_ChoiceCenterX = intersect(SideB_ChoiceCenterX, SideB_AllTrials);
            % for Side B the subjective choice sides are flipped as seen from side A in
            % eventide screen coordinates
            SideB_ChoiceScreenFromALeft = B_RightChoiceIdx;
            SideB_ChoiceScreenFromARight = B_LeftChoiceIdx;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % in this part you define the varibles needed for defining preferred colour
            % vector
            if isfield(report_struct.cn, 'A_RandomizedTargetPosition_Y') && isfield(report_struct.cn, 'A_RandomizedTargetPosition_X')
                A_SelectedTargetEqualsRandomizedTargetTrialIdx = find((abs(report_struct.data(:, report_struct.cn.A_RandomizedTargetPosition_Y) - report_struct.data(:, report_struct.cn.A_TouchSelectedTargetPosition_Y)) <= EqualPositionSlackPixels) & (abs(report_struct.data(:, report_struct.cn.A_RandomizedTargetPosition_X) - report_struct.data(:, report_struct.cn.A_TouchSelectedTargetPosition_X)) <= EqualPositionSlackPixels));
            else
                A_SelectedTargetEqualsRandomizedTargetTrialIdx = [];
            end
            if isfield(report_struct.cn, 'B_RandomizedTargetPosition_Y') && isfield(report_struct.cn, 'B_RandomizedTargetPosition_X')
                B_SelectedTargetEqualsRandomizedTargetTrialIdx = find((abs(report_struct.data(:, report_struct.cn.B_RandomizedTargetPosition_Y) - report_struct.data(:, report_struct.cn.B_TouchSelectedTargetPosition_Y)) <= EqualPositionSlackPixels) & (abs(report_struct.data(:, report_struct.cn.B_RandomizedTargetPosition_X) - report_struct.data(:, report_struct.cn.B_TouchSelectedTargetPosition_X)) <= EqualPositionSlackPixels));
            else
                B_SelectedTargetEqualsRandomizedTargetTrialIdx = [];
            end
            % now only take those trials in which a subject actually touched the target
            A_SelectedTargetEqualsRandomizedTargetTrialIdx = intersect(A_SelectedTargetEqualsRandomizedTargetTrialIdx, find(report_struct.data(:, report_struct.cn.A_TargetTouchTime_ms) > 0.0));
            B_SelectedTargetEqualsRandomizedTargetTrialIdx = intersect(B_SelectedTargetEqualsRandomizedTargetTrialIdx, find(report_struct.data(:, report_struct.cn.B_TargetTouchTime_ms) > 0.0));
            A_SelectedTargetEqualsRandomizedTargetTrialIdx = intersect(A_SelectedTargetEqualsRandomizedTargetTrialIdx, SideA_AllTrials);
            B_SelectedTargetEqualsRandomizedTargetTrialIdx = intersect(B_SelectedTargetEqualsRandomizedTargetTrialIdx, SideB_AllTrials);
            % keep the randomisation information, to allow fake by value analysus for
            % freecgoice trials to compare agains left right and against informed
            % trials
            SideA_ProtoTargetValueHigh = A_SelectedTargetEqualsRandomizedTargetTrialIdx; % here the randomized position equals higher payoff
            SideA_ProtoTargetValueLow = intersect(setdiff(TrialSets_All, A_SelectedTargetEqualsRandomizedTargetTrialIdx), SideA_AllTrials);
            SideB_ProtoTargetValueHigh = intersect(setdiff(TrialSets_All, B_SelectedTargetEqualsRandomizedTargetTrialIdx), SideB_AllTrials);
            SideB_ProtoTargetValueLow = B_SelectedTargetEqualsRandomizedTargetTrialIdx; % here the randomized position equals lower payoff
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% Zahra: Finding trials by choice color (own preferred or other's preferred): (RED or BLUE):
            % get the share of own choices
            PreferableTargetSelected_A = zeros([NumTrials, 1]);
            PreferableTargetSelected_A(SideA_ProtoTargetValueHigh) = 1;
            PreferableTargetSelected_B = zeros([NumTrials, 1]);
            PreferableTargetSelected_B(SideB_ProtoTargetValueHigh) = 1;
            % get the share of own choices
            NonPreferableTargetSelected_A = zeros([NumTrials, 1]);
            NonPreferableTargetSelected_A(SideA_ProtoTargetValueLow) = 1;
            NonPreferableTargetSelected_B = zeros([NumTrials, 1]);
            NonPreferableTargetSelected_B(SideB_ProtoTargetValueLow) = 1;
            % get vectors for side/value choices
            PreferableNoneNonpreferableSelected_A = zeros([NumTrials, 1]) + PreferableTargetSelected_A - NonPreferableTargetSelected_A;
            PreferableNoneNonpreferableSelected_B = zeros([NumTrials, 1]) + PreferableTargetSelected_B - NonPreferableTargetSelected_B;


            %% be careful to not include aborted trials in choice vector:

            % if exist('NHP_SoloB')
            %     ChoiceVectorAll = PreferableTargetSelected_B; % 1 means prefered colr, 0 means anti prefered color
            % else
            %     ChoiceVectorAll = PreferableTargetSelected_A;
            % end

            ChoiceVectorAll = PreferableTargetSelected_A;
            ChoiceVectorRewarded = ChoiceVectorAll(RewardedID)

            RewardValueVectorAll = table2array(loadedDATA(:,"A_NumberRewardPulsesDelivered_HIT"))
            RewardValueVectorRewarded = RewardValueVectorAll(RewardedID)

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Fitting Q learning with VBA toolbox
            cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes\VBA_AllFunctions'

            choices = ChoiceVectorRewarded; % choice vector of Agent A or B,  1 = preferred colour  0 = non prefered colour,
            TrialNumsA(SessSolo) = numel(choices);
            % 1
            %history of theaborted trials????
            feedbacks = RewardValueVectorRewarded;% reward value vector for each Agent from pay off matrix???
            if size(choices,1)>1
                choices = choices'
            end

            feedbacks = RewardValueVectorRewarded;% reward value vector for each Agent from pay off matrix???
            if size(feedbacks,1)>1
                feedbacks = feedbacks'
            end
            [posterior, out]=demo_Qlearning(choices, feedbacks)

            aPHI(SessSolo) = exp(posterior.muPhi)
            aTHETA(SessSolo) = VBA_sigmoid(posterior.muTheta)
            aR2VAL(SessSolo) = out.fit.R2
            aPerf(SessSolo) = mean(choices)
            SessDateAll_SoloA(SessSolo) = str2num(SESSIONDATE)

        end
        %% Sanity checks
        sum(SessDateAll_SoloA == sort(SessDateAll_SoloA)) == numel(SessDateAll_SoloA) % are SoloA sessions chronoligcally ordered?
        sum(SessDateAll_SoloB == sort(SessDateAll_SoloB)) == numel(SessDateAll_SoloB) % are SoloB sessions chronoligcally ordered?

        AllSessinsDates = [SessDateAll_SoloB,SessDateAll_SoloA];
        sum(AllSessinsDates == sort(AllSessinsDates)) == numel(AllSessinsDates)
        TrialNums = [TrialNumsB,TrialNumsA];
        %% make the parameters from chronoligcally ordered sessions
        THETA = [bTHETA,aTHETA]
        PHI = [bPHI,aPHI]
        R2VAL = [bR2VAL,aR2VAL]
        Perf = [bPerf,aPerf]

        figure
        subplot(3,2,1)
        for DOT = 1 : numel(AllSessinsDates)
            scatter(DOT,THETA(DOT),(R2VAL(DOT)+1)*30,[153 0 153]./255,'filled','MarkerFaceAlpha',R2VAL(DOT),'MarkerEdgeColor','flat')
            hold on
        end
        ylabel('learning rate')

        subplot(3,2,2)
        for DOT = 1 : numel(AllSessinsDates)
            scatter(DOT,PHI(DOT),(R2VAL(DOT)+1)*30,[76 0 153]./255,'filled','MarkerFaceAlpha',R2VAL(DOT),'MarkerEdgeColor','flat')
            hold on
        end
        ylabel('inverse behavioral tempreture')
        subplot(3,2,3)
        for DOT = 1 : numel(AllSessinsDates)
            scatter(DOT,Perf(DOT)*100,'cyan','filled')
            hold on

        end
        ylabel('performance, percent of higher reward')
        xlabel('session number, chronological order')
        subplot(3,2,4)

        for DOT = 1 : numel(AllSessinsDates)
            scatter(DOT,R2VAL(DOT),'k','filled')
            ylim([0 1])
            hold on
        end

        subplot(3,2,5)
        scatter( 1 : numel(AllSessinsDates),TrialNums,'b','filled')
        ylabel('Session Number')
        xlabel('number of trials for each session')


        subplot(3,2,6)
        scatter( TrialNums,R2VAL,'r','filled')
        ylim([0 1])

        ylabel('R2 value')
        xlabel('number of trials for each session')
        sgtitle(sprintf(MonkeysName{MONKEY}))
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %^%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%if only one of the lists exists:

    BothExists =  exist(sprintf('NHP_SoloA%s_fullPath',MonkeysName{MONKEY})) == 2 && exist(sprintf('NHP_SoloB%s_fullPath',MonkeysName{MONKEY})) == 2
    JustOneExists = ~BothExists

    if   JustOneExists
        for COND = 1 : numel(CONDITION)
            C = CONDITION{COND}
            S = MonkeysName{MONKEY}
            if   exist(sprintf('NHP_Solo%c%s_fullPath',C,S)) == 2
                run(sprintf('NHP_Solo%c%s_fullPath',C,S));
                MainData = eval(sprintf('NHP_Solo%c',C))
                report_struct_list = cell([1, numel(MainData)]);

                for SessNum = 1 : numel(MainData)
                    load(char(MainData{SessNum}), 'report_struct');
                    report_struct_list(SessNum) = {report_struct};
                end

                PHI = nan(1,numel(MainData))
                THETA = nan(1,numel(MainData))
                R2VAL = nan(1,numel(MainData))
                Perf = nan(1,numel(MainData))

                SessDateAll_Solo = nan(1,numel(MainData))
                NumAllSess = numel(MainData)
                TrialNums = nan(1,NumAllSess)

                parfor SessSolo =  1 : numel(MainData)
                    ID = SessSolo;
                    report_struct = report_struct_list{ID};
                    SESSIONDATE = report_struct.LoggingInfo.SessionDate;

                    loadedDATA = array2table(report_struct.data,'VariableNames',report_struct.header);
                    Rewarded_Aborted  = report_struct.unique_lists.A_OutcomeENUM(loadedDATA.A_OutcomeENUM_idx);
                    if isfield(report_struct.unique_lists, 'A_TrialSubTypeENUM')
                        Trial_TaskType_All = report_struct.unique_lists.A_TrialSubTypeENUM(loadedDATA.A_TrialSubTypeENUM_idx); % this vector shows trial type based on task
                    else
                        complete_SoloA_trial_idx = intersect(find(report_struct.data(:, report_struct.cn.A_InitialFixationTouchTime_ms) ~= 0), find(report_struct.data(:, report_struct.cn.B_InitialFixationTouchTime_ms) == 0)); %Because when time for touching the screen for actor B is zero it means that only Actor A played
                        complete_SoloB_trial_idx = intersect(find(report_struct.data(:, report_struct.cn.A_InitialFixationTouchTime_ms) == 0), find(report_struct.data(:, report_struct.cn.B_InitialFixationTouchTime_ms) ~= 0));
                        complete_Dyadic_trial_idx = intersect(find(report_struct.data(:, report_struct.cn.A_InitialFixationTouchTime_ms) ~= 0), find(report_struct.data(:, report_struct.cn.B_InitialFixationTouchTime_ms) ~= 0));
                        Trial_TaskType_All = cell(size(Rewarded_Aborted));
                        Trial_TaskType_All(complete_SoloA_trial_idx) = {'SoloA'};
                        Trial_TaskType_All(complete_SoloB_trial_idx) = {'SoloB'};
                        Trial_TaskType_All(complete_Dyadic_trial_idx) = {'Dyadic'};
                    end



                    WholeTrials = numel(Rewarded_Aborted);
                    NumTrials = size(report_struct.data, 1);
                    RewardedID = find(strcmp(Rewarded_Aborted,'REWARD')); % indices of rewarded trials
                    TrialSets_All = (1:1:size(report_struct.data, 1))';
                    SideA_ActiveTrials = report_struct.data(:, report_struct.cn.A_IsActive); % this produce the same data: loadedDATA(:,5)
                    SideB_ActiveTrials = report_struct.data(:, report_struct.cn.B_IsActive); % this produce the same data: loadedDATA(:,79)
                    %Sebastian: % activity (was a side active during a given trial)
                    % dual subject activity does not necessarily mean joint trials!
                    %Zahra: This IDs show the trials that both actors play, but they can play
                    %like SoloA SoloB or Dyadic joint, so dual trials doesnt mean joint trials
                    SideA_ActiveTrials = find(SideA_ActiveTrials);
                    SideB_ActiveTrials = find(SideB_ActiveTrials);
                    %Sebastian: dual subject trials are always identical for both sides...
                    DualSubjectTrials = intersect(SideA_ActiveTrials, SideB_ActiveTrials);
                    SideA_DualSubjectTrials = DualSubjectTrials;
                    SideB_DualSubjectTrials= DualSubjectTrials;
                    %Single subject trials: % these contain trials were only one subject performed the task
                    SingleSubjectTrials = setdiff(TrialSets_All,DualSubjectTrials);
                    SingleSubjectTrials_SideA = setdiff(SideA_ActiveTrials, SideB_ActiveTrials);
                    SingleSubjectTrials_SideB = setdiff(SideB_ActiveTrials, SideA_ActiveTrials);
                    %Sebastian: try to find all trials a subject was active in
                    %Zahra: These are the trials that each subjects, regardless of single, or
                    %dual was active in.
                    SideA_AllTrials = union(SideA_DualSubjectTrials,SingleSubjectTrials_SideA);
                    SideB_AllTrials = union(SideB_DualSubjectTrials,SingleSubjectTrials_SideB);
                    AllActiveTrials = union(SideA_AllTrials,SideB_AllTrials);
                    %%
                    % Sebastian: these are real joint trials when both subject work together:
                    % test for touching the initial target: (initiated trials)
                    InitiatedTrialsA = find(report_struct.data(:, report_struct.cn.A_InitialFixationTouchTime_ms) > 0);
                    InitiatedTrialsB = find(report_struct.data(:, report_struct.cn.B_InitialFixationTouchTime_ms) > 0);
                    %%
                    % restrict Initited trials to Side:
                    SideA_InitiatedTrialsA = intersect(SideA_AllTrials,InitiatedTrialsA);
                    SideB_InitiatedTrialsB = intersect(SideB_AllTrials,InitiatedTrialsB);
                    DualSubjectJointTrials = intersect(InitiatedTrialsA, InitiatedTrialsB);
                    Rewarded_DualSubjectJointTrials = intersect(DualSubjectJointTrials,RewardedID);
                    SideA_SoloSubjectTrials = setdiff(InitiatedTrialsA, InitiatedTrialsB);
                    SideB_SoloSubjectTrials = setdiff(InitiatedTrialsB, InitiatedTrialsA);
                    % Sebastian: joint trials are always for both sides
                    SideA_DualSubjectJointTrials = DualSubjectJointTrials;
                    SideB_DualSubjectJointTrials = DualSubjectJointTrials;
                    % Sebastian: what to do about the dual subject non-joint trials, with two subjects present and active, but only one working?
                    DualSubjectSoloTrials = union(SideA_SoloSubjectTrials, SideB_SoloSubjectTrials);
                    Rewarded_DualSubjectSoloTrials = intersect(DualSubjectSoloTrials,RewardedID)
                    % Sebastian: generate indices for: targetposition, choice position, rewards-payout (target preference)
                    % get the choice preference choice is always by side
                    %% Zahra: Finding trials by choice side: (left or right)
                    EqualPositionSlackPixels = 2;	% how many pixels two position are allowed to differ while still accounted as same, this is required as the is some rounding error in earlier code that produces of by one positions
                    A_LeftChoiceIdx = find(report_struct.data(:, report_struct.cn.A_TouchInitialFixationPosition_X) > report_struct.data(:, report_struct.cn.A_TouchSelectedTargetPosition_X));
                    A_RightChoiceIdx = find(report_struct.data(:, report_struct.cn.A_TouchInitialFixationPosition_X) < report_struct.data(:, report_struct.cn.A_TouchSelectedTargetPosition_X));
                    % remove trials when the side was not playing
                    A_LeftChoiceIdx = intersect(A_LeftChoiceIdx,SideA_AllTrials);
                    A_RightChoiceIdx = intersect(A_RightChoiceIdx, SideA_AllTrials);
                    % allow some slack for improper rounding errors
                    SideA_ChoiceCenterX = find(abs(report_struct.data(:, report_struct.cn.A_TouchInitialFixationPosition_X) - report_struct.data(:, report_struct.cn.A_TouchSelectedTargetPosition_X)) <= EqualPositionSlackPixels);
                    SideA_ChoiceCenterX = intersect(SideA_ChoiceCenterX, SideA_AllTrials);
                    SideA_ChoiceScreenFromALeft = A_LeftChoiceIdx;
                    SideA_ChoiceScreenFromARight = A_RightChoiceIdx;
                    %% Zahra: same precudre fot Actor B
                    B_LeftChoiceIdx = find(report_struct.data(:, report_struct.cn.B_TouchInitialFixationPosition_X) < report_struct.data(:, report_struct.cn.B_TouchSelectedTargetPosition_X));
                    B_RightChoiceIdx = find(report_struct.data(:, report_struct.cn.B_TouchInitialFixationPosition_X) > report_struct.data(:, report_struct.cn.B_TouchSelectedTargetPosition_X));
                    B_LeftChoiceIdx = intersect(B_LeftChoiceIdx, SideB_AllTrials);
                    B_RightChoiceIdx = intersect(B_RightChoiceIdx, SideB_AllTrials);
                    % allow some slack for improper rounding errors
                    SideB_ChoiceCenterX = find(abs(report_struct.data(:, report_struct.cn.B_TouchInitialFixationPosition_X) - report_struct.data(:, report_struct.cn.B_TouchSelectedTargetPosition_X)) <= EqualPositionSlackPixels);
                    SideB_ChoiceCenterX = intersect(SideB_ChoiceCenterX, SideB_AllTrials);
                    % for Side B the subjective choice sides are flipped as seen from side A in
                    % eventide screen coordinates
                    SideB_ChoiceScreenFromALeft = B_RightChoiceIdx;
                    SideB_ChoiceScreenFromARight = B_LeftChoiceIdx;
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % in this part you define the varibles needed for defining preferred colour
                    % vector
                    if isfield(report_struct.cn, 'A_RandomizedTargetPosition_Y') && isfield(report_struct.cn, 'A_RandomizedTargetPosition_X')
                        A_SelectedTargetEqualsRandomizedTargetTrialIdx = find((abs(report_struct.data(:, report_struct.cn.A_RandomizedTargetPosition_Y) - report_struct.data(:, report_struct.cn.A_TouchSelectedTargetPosition_Y)) <= EqualPositionSlackPixels) & (abs(report_struct.data(:, report_struct.cn.A_RandomizedTargetPosition_X) - report_struct.data(:, report_struct.cn.A_TouchSelectedTargetPosition_X)) <= EqualPositionSlackPixels));
                    else
                        A_SelectedTargetEqualsRandomizedTargetTrialIdx = [];
                    end
                    if isfield(report_struct.cn, 'B_RandomizedTargetPosition_Y') && isfield(report_struct.cn, 'B_RandomizedTargetPosition_X')
                        B_SelectedTargetEqualsRandomizedTargetTrialIdx = find((abs(report_struct.data(:, report_struct.cn.B_RandomizedTargetPosition_Y) - report_struct.data(:, report_struct.cn.B_TouchSelectedTargetPosition_Y)) <= EqualPositionSlackPixels) & (abs(report_struct.data(:, report_struct.cn.B_RandomizedTargetPosition_X) - report_struct.data(:, report_struct.cn.B_TouchSelectedTargetPosition_X)) <= EqualPositionSlackPixels));
                    else
                        B_SelectedTargetEqualsRandomizedTargetTrialIdx = [];
                    end
                    % now only take those trials in which a subject actually touched the target
                    A_SelectedTargetEqualsRandomizedTargetTrialIdx = intersect(A_SelectedTargetEqualsRandomizedTargetTrialIdx, find(report_struct.data(:, report_struct.cn.A_TargetTouchTime_ms) > 0.0));
                    B_SelectedTargetEqualsRandomizedTargetTrialIdx = intersect(B_SelectedTargetEqualsRandomizedTargetTrialIdx, find(report_struct.data(:, report_struct.cn.B_TargetTouchTime_ms) > 0.0));
                    A_SelectedTargetEqualsRandomizedTargetTrialIdx = intersect(A_SelectedTargetEqualsRandomizedTargetTrialIdx, SideA_AllTrials);
                    B_SelectedTargetEqualsRandomizedTargetTrialIdx = intersect(B_SelectedTargetEqualsRandomizedTargetTrialIdx, SideB_AllTrials);
                    % keep the randomisation information, to allow fake by value analysus for
                    % freecgoice trials to compare agains left right and against informed
                    % trials
                    SideA_ProtoTargetValueHigh = A_SelectedTargetEqualsRandomizedTargetTrialIdx; % here the randomized position equals higher payoff
                    SideA_ProtoTargetValueLow = intersect(setdiff(TrialSets_All, A_SelectedTargetEqualsRandomizedTargetTrialIdx), SideA_AllTrials);
                    SideB_ProtoTargetValueHigh = intersect(setdiff(TrialSets_All, B_SelectedTargetEqualsRandomizedTargetTrialIdx), SideB_AllTrials);
                    SideB_ProtoTargetValueLow = B_SelectedTargetEqualsRandomizedTargetTrialIdx; % here the randomized position equals lower payoff
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %% Zahra: Finding trials by choice color (own preferred or other's preferred): (RED or BLUE):
                    % get the share of own choices
                    PreferableTargetSelected_A = zeros([NumTrials, 1]);
                    PreferableTargetSelected_A(SideA_ProtoTargetValueHigh) = 1;
                    PreferableTargetSelected_B = zeros([NumTrials, 1]);
                    PreferableTargetSelected_B(SideB_ProtoTargetValueHigh) = 1;
                    % get the share of own choices
                    NonPreferableTargetSelected_A = zeros([NumTrials, 1]);
                    NonPreferableTargetSelected_A(SideA_ProtoTargetValueLow) = 1;
                    NonPreferableTargetSelected_B = zeros([NumTrials, 1]);
                    NonPreferableTargetSelected_B(SideB_ProtoTargetValueLow) = 1;
                    % get vectors for side/value choices
                    PreferableNoneNonpreferableSelected_A = zeros([NumTrials, 1]) + PreferableTargetSelected_A - NonPreferableTargetSelected_A;
                    PreferableNoneNonpreferableSelected_B = zeros([NumTrials, 1]) + PreferableTargetSelected_B - NonPreferableTargetSelected_B;


                    %% be careful to not include aborted trials in choice vector:

                    % if exist('NHP_SoloB')
                    %     ChoiceVectorAll = PreferableTargetSelected_B; % 1 means prefered colr, 0 means anti prefered color
                    % else
                    %     ChoiceVectorAll = PreferableTargetSelected_A;
                    % end

                    ChoiceVectorAll = PreferableTargetSelected_A;
                    ChoiceVectorRewarded = ChoiceVectorAll(RewardedID)

                    RewardValueVectorAll = table2array(loadedDATA(:,"A_NumberRewardPulsesDelivered_HIT"))
                    RewardValueVectorRewarded = RewardValueVectorAll(RewardedID)

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Fitting Q learning with VBA toolbox
                    cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes\VBA_AllFunctions'

                    choices = ChoiceVectorRewarded; % choice vector of Agent A or B,  1 = preferred colour  0 = non prefered colour,
                    TrialNums(SessSolo) = numel(choices);
                    % 1
                    %history of theaborted trials????
                    feedbacks = RewardValueVectorRewarded;% reward value vector for each Agent from pay off matrix???
                    if size(choices,1)>1
                        choices = choices'
                    end

                    feedbacks = RewardValueVectorRewarded;% reward value vector for each Agent from pay off matrix???
                    if size(feedbacks,1)>1
                        feedbacks = feedbacks'
                    end
                    [posterior, out]=demo_Qlearning(choices, feedbacks)

                    PHI(SessSolo) = exp(posterior.muPhi)
                    THETA(SessSolo) = VBA_sigmoid(posterior.muTheta)
                    R2VAL(SessSolo) = out.fit.R2
                    Perf(SessSolo) = mean(choices)
                    SessDateAll_Solo(SessSolo) = str2num(SESSIONDATE)

                end


                AllSessinsDates = [SessDateAll_Solo];
                sum(AllSessinsDates == sort(AllSessinsDates)) == numel(AllSessinsDates)

                %%

                figure
                subplot(3,2,1)
                for DOT = 1 : numel(AllSessinsDates)
                    scatter(DOT,THETA(DOT),(R2VAL(DOT)+1)*30,[153 0 153]./255,'filled','MarkerFaceAlpha',R2VAL(DOT),'MarkerEdgeColor','flat')
                    hold on
                end
                ylabel('learning rate')

                subplot(3,2,2)
                for DOT = 1 : numel(AllSessinsDates)
                    scatter(DOT,PHI(DOT),(R2VAL(DOT)+1)*30,[76 0 153]./255,'filled','MarkerFaceAlpha',R2VAL(DOT),'MarkerEdgeColor','flat')
                    hold on
                end
                ylabel('inverse behavioral tempreture')
                subplot(3,2,3)
                for DOT = 1 : numel(AllSessinsDates)
                    scatter(DOT,Perf(DOT)*100,'cyan','filled')
                    hold on

                end
                ylabel('performance, percent of higher reward')
                xlabel('session number, chronological order')
                subplot(3,2,4)

                for DOT = 1 : numel(AllSessinsDates)
                    scatter(DOT,R2VAL(DOT),'k','filled')
                    ylim([0 1])
                    hold on
                end
                ylabel('R2 value')
                xlabel('session number, chronological order')
                sgtitle(sprintf(MonkeysName{MONKEY}))

                subplot(3,2,5)
                scatter( 1 : numel(AllSessinsDates),TrialNums,'b','filled')
                ylabel('Session Number')
                xlabel('number of trials for each session')

                subplot(3,2,6)
                scatter( TrialNums,R2VAL,'r','filled')

                ylim([0 1])
                ylabel('R2 value')
                xlabel('number of trials for each session')
                sgtitle(sprintf(MonkeysName{MONKEY}))


            end

        end
    end

end




