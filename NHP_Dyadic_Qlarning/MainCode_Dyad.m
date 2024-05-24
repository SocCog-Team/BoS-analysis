% importing data
cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes\NHP_Dyadic_Qlarning'
%%
close all
clear
clc
% run('NHPdyad_MagnusACuriusB_fullPath.m')
run('NHPdyad_MagnusAFlaffusB_fullPath.m')

CoordinationChoiceFunction = @(x) (x == 4 | x == 3 ) * 1 + (x == 2 | x == 1) * 0;
% CoordinationChoiceFunction = @(x) (x == 4 | x == 3 | x == 2) * 1 + (x == 1) * 0;
% CoordinationChoiceFunction = @(x) (x == 4 ) * 1 + (x == 3 | x == 2 | x == 1) * 0;

MAINDATAreport_struct_listA = cell([1, numel(NHP_DyadicA)]);


for SessNum = 1 : numel(NHP_DyadicA)
    load(char(NHP_DyadicA{SessNum}), 'report_struct');
    MAINDATAreport_struct_listA(SessNum) = {report_struct};
end



coor_aPHI = nan(1,numel(NHP_DyadicA))
coor_aTHETA = nan(1,numel(NHP_DyadicA))
coor_aR2VAL = nan(1,numel(NHP_DyadicA))
coor_aPerf = nan(1,numel(NHP_DyadicA))

col_aPHI = nan(1,numel(NHP_DyadicA))
col_aTHETA = nan(1,numel(NHP_DyadicA))
col_aR2VAL = nan(1,numel(NHP_DyadicA))
col_aPerf = nan(1,numel(NHP_DyadicA))

coor_bPHI = nan(1,numel(NHP_DyadicA))
coor_bTHETA = nan(1,numel(NHP_DyadicA))
coor_bR2VAL = nan(1,numel(NHP_DyadicA))
coor_bPerf = nan(1,numel(NHP_DyadicA))

col_bPHI = nan(1,numel(NHP_DyadicA))
col_bTHETA = nan(1,numel(NHP_DyadicA))
col_bR2VAL = nan(1,numel(NHP_DyadicA))
col_bPerf = nan(1,numel(NHP_DyadicA))


SessDateAll_DyadA = nan(1,numel(NHP_DyadicA))

TrialNumsA = nan(1,numel(NHP_DyadicA))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
report_struct = MAINDATAreport_struct_listA{1};

Actor_A = string(report_struct.unique_lists.A_Name);
Actor_B = string(report_struct.unique_lists.B_Name);




parfor SessSolo =  1 : numel(NHP_DyadicA)
    ID = SessSolo;
    report_struct = MAINDATAreport_struct_listA{ID};
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

    DyadicID_All = find(strcmp(Trial_TaskType_All,'Dyadic'));


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

    % how about solo trials
    A_selects_A = PreferableTargetSelected_A;
    B_selects_B = PreferableTargetSelected_B;
    A_selects_B = NonPreferableTargetSelected_A;
    B_selects_A = NonPreferableTargetSelected_B;
    SameTargetA = A_selects_A & B_selects_A;
    SameTargetB = A_selects_B & B_selects_B;
    DiffOwnTarget = A_selects_A & B_selects_B;
    DiffOtherTarget = A_selects_B & B_selects_A;
    A_changed_target_ldx = [0; diff(PreferableTargetSelected_A)];
    B_changed_target_ldx = [0; diff(PreferableTargetSelected_B)];
    AorB_changed_target_from_last_trial = abs(A_changed_target_ldx) + abs(B_changed_target_ldx);
    AorB_changed_target_from_last_trial_idx = find(AorB_changed_target_from_last_trial);
    % now create a string with our color representations of the 4 choice
    % combinations
    A_choice_combination_color_string = nan(1,numel(PreferableTargetSelected_A));
    A_choice_combination_color_string(SameTargetA) = 4;
    A_choice_combination_color_string(SameTargetB) = 3;
    A_choice_combination_color_string(DiffOwnTarget) = 2;
    A_choice_combination_color_string(DiffOtherTarget) = 1;

    B_choice_combination_color_string = nan(1,numel(PreferableTargetSelected_B));
    B_choice_combination_color_string(SameTargetB) = 4;
    B_choice_combination_color_string(SameTargetA) = 3;
    B_choice_combination_color_string(DiffOwnTarget) = 2;
    B_choice_combination_color_string(DiffOtherTarget) = 1;

    RewardedDyadic_ID = intersect(RewardedID,DyadicID_All)

    AVectorRewarded = A_choice_combination_color_string(RewardedDyadic_ID)
    AChoiceVector = PreferableTargetSelected_A(RewardedDyadic_ID)

    BVectorRewarded = B_choice_combination_color_string(RewardedDyadic_ID)
    BChoiceVector = PreferableTargetSelected_B(RewardedDyadic_ID)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Fitting Q learning with VBA toolbox
    cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes\VBA_AllFunctions'

    % Achoices = double(~AChoiceVector); % choice vector of Agent A or B,  1 = preferred colour  0 = non prefered colour,
    % Bchoices = double(~BChoiceVector);
    if size(AChoiceVector,1)>1
        AChoiceVector = AChoiceVector'
    end

    if size(BChoiceVector,1)>1
        BChoiceVector = BChoiceVector'
    end

    Col_Achoices = AChoiceVector; % choice vector of Agent A or B,  1 = preferred colour  0 = non prefered colour,
    Col_Bchoices = BChoiceVector;

    Coor_Achoices = CoordinationChoiceFunction(AVectorRewarded)
    Coor_Bchoices = CoordinationChoiceFunction(BVectorRewarded)

    TrialNumsA(SessSolo) = numel(Col_Achoices);
    Afeedbacks = AVectorRewarded
    Bfeedbacks = BVectorRewarded

    % 1
    %history of theaborted trials????


    if size(Afeedbacks,1)>1
        Afeedbacks = Afeedbacks'
    end



    if size(Bfeedbacks,1)>1
        Bfeedbacks = Bfeedbacks'
    end


    % inputs


    [coor_a_posterior, coor_a_out]=demo_Qlearning(Coor_Achoices, Afeedbacks)
    [col_a_posterior, col_a_out]=demo_Qlearning(Col_Achoices, Afeedbacks)


    coor_aPHI(SessSolo) = exp(coor_a_posterior.muPhi)
    coor_aTHETA(SessSolo) = VBA_sigmoid(coor_a_posterior.muTheta)
    coor_aR2VAL(SessSolo) = coor_a_out.fit.R2
    coor_aPerf(SessSolo) = mean(Coor_Achoices)

    col_aPHI(SessSolo) = exp(col_a_posterior.muPhi)
    col_aTHETA(SessSolo) = VBA_sigmoid(col_a_posterior.muTheta)
    col_aR2VAL(SessSolo) = col_a_out.fit.R2
    col_aPerf(SessSolo) = mean(Col_Achoices)





    SessDateAll_DyadA(SessSolo) = str2num(SESSIONDATE)





    [coor_b_posterior, coor_b_out]=demo_Qlearning(Coor_Bchoices, Bfeedbacks)
    [col_b_posterior, col_b_out]=demo_Qlearning(Col_Bchoices, Bfeedbacks)


    coor_bPHI(SessSolo) = exp(coor_b_posterior.muPhi)
    coor_bTHETA(SessSolo) = VBA_sigmoid(coor_b_posterior.muTheta)
    coor_bR2VAL(SessSolo) = coor_b_out.fit.R2
    coor_bPerf(SessSolo) = mean(Coor_Bchoices)

    col_bPHI(SessSolo) = exp(col_b_posterior.muPhi)
    col_bTHETA(SessSolo) = VBA_sigmoid(col_b_posterior.muTheta)
    col_bR2VAL(SessSolo) = col_b_out.fit.R2
    col_bPerf(SessSolo) = mean(Col_Bchoices)

end


AllSessinsDates = [SessDateAll_DyadA];
TrialNums = [TrialNumsA];

Acolor = [255 0 127]./255
Bcolor = [0 0 204]./255

figure('Position',[488,49.800000000000004,571.4000000000001,732.8000000000001])
subplot(3,2,1)
for DOT = 1 : numel(AllSessinsDates)
    scatter(DOT,coor_aTHETA(DOT),(coor_aR2VAL(DOT)+1)*30,Acolor,'filled','MarkerFaceAlpha',coor_aR2VAL(DOT),'MarkerEdgeColor','flat')
    hold on
    scatter(DOT,coor_bTHETA(DOT),(coor_bR2VAL(DOT)+1)*30,Bcolor,'filled','MarkerFaceAlpha',coor_bR2VAL(DOT),'MarkerEdgeColor','flat')

end
legend(Actor_A,Actor_B,'Position',[0.398589855674866 0.949565265815407 0.157913166902312 0.0432587345094139])
ylabel('learning rate')

subplot(3,2,2)
for DOT = 1 : numel(AllSessinsDates)
    scatter(DOT,coor_aPHI(DOT),(coor_aR2VAL(DOT)+1)*30,Acolor,'filled','MarkerFaceAlpha',coor_aR2VAL(DOT),'MarkerEdgeColor','flat')
    hold on
    scatter(DOT,coor_bPHI(DOT),(coor_bR2VAL(DOT)+1)*30,Bcolor,'filled','MarkerFaceAlpha',coor_bR2VAL(DOT),'MarkerEdgeColor','flat')

end
ylabel('inverse behavioral tempreture')

subplot(3,2,3)
for DOT = 1 : numel(AllSessinsDates)
    scatter(DOT,coor_aPerf(DOT).*100,30,Acolor,'filled')
    hold on
    scatter(DOT,coor_bPerf(DOT).*100,30,Bcolor,'filled')


end
ylabel("% coordinated trials")
title('performance dynamic')
% xlabel('session number, chronological order')
subplot(3,2,4)

for DOT = 1 : numel(AllSessinsDates)
    scatter(DOT,coor_aR2VAL(DOT),30,Acolor,'filled')
    ylim([0 1])
    hold on
    scatter(DOT,coor_bR2VAL(DOT),30,Bcolor,'filled')

end
ylabel('R2 value')
xlabel('session number, chronological order')
subplot(3,2,5)
scatter( 1 : numel(AllSessinsDates),TrialNums,'k','filled')
xlabel('session number, chronological order')
ylabel('number of trials for each session')


subplot(3,2,6)
scatter( TrialNums,coor_aR2VAL,30,Acolor,'filled')
ylim([0 1])
hold on
scatter( TrialNums,coor_bR2VAL,30,Bcolor,'filled')


ylabel('R2 value')
xlabel('number of trials for each session')
sgtitle('learning by coordination')


%% color learning

figure('Position',[488,49.800000000000004,571.4000000000001,732.8000000000001])
subplot(3,2,1)
for DOT = 1 : numel(AllSessinsDates)
    scatter(DOT,col_aTHETA(DOT),(col_aR2VAL(DOT)+1)*30,Acolor,'filled','MarkerFaceAlpha',col_aR2VAL(DOT),'MarkerEdgeColor','flat')
    hold on
    scatter(DOT,col_bTHETA(DOT),(col_bR2VAL(DOT)+1)*30,Bcolor,'filled','MarkerFaceAlpha',col_bR2VAL(DOT),'MarkerEdgeColor','flat')

end
legend(Actor_A,Actor_B,'Position',[0.398589855674866 0.949565265815407 0.157913166902312 0.0432587345094139])
ylabel('learning rate')

subplot(3,2,2)
for DOT = 1 : numel(AllSessinsDates)
    scatter(DOT,col_aPHI(DOT),(col_aR2VAL(DOT)+1)*30,Acolor,'filled','MarkerFaceAlpha',col_aR2VAL(DOT),'MarkerEdgeColor','flat')
    hold on
    scatter(DOT,col_bPHI(DOT),(col_bR2VAL(DOT)+1)*30,Bcolor,'filled','MarkerFaceAlpha',col_bR2VAL(DOT),'MarkerEdgeColor','flat')

end
ylabel('inverse behavioral tempreture')

subplot(3,2,3)
for DOT = 1 : numel(AllSessinsDates)
    scatter(DOT,col_aPerf(DOT).*100,30,Acolor,'filled')
    hold on
    scatter(DOT,col_bPerf(DOT).*100,30,Bcolor,'filled')


end
ylabel("% coordinated trials")
title('performance dynamic')
% xlabel('session number, chronological order')
subplot(3,2,4)

for DOT = 1 : numel(AllSessinsDates)
    scatter(DOT,col_aR2VAL(DOT),30,Acolor,'filled')
    ylim([0 1])
    hold on
    scatter(DOT,col_bR2VAL(DOT),30,Bcolor,'filled')

end
ylabel('R2 value')
xlabel('session number, chronological order')
subplot(3,2,5)
scatter( 1 : numel(AllSessinsDates),TrialNums,'k','filled')
xlabel('session number, chronological order')
ylabel('number of trials for each session')


subplot(3,2,6)
scatter( TrialNums,col_aR2VAL,30,Acolor,'filled')
ylim([0 1])
hold on
scatter( TrialNums,col_bR2VAL,30,Bcolor,'filled')


ylabel('R2 value')
xlabel('number of trials for each session')
sgtitle('learning by prefered color')



%%% look at the dynamic of performance based on different choice vectors:
%%% choice: preferred non preferred color or choosing partner's color


WindowLength = 5


figure('Position',[488,49.800000000000004,571.4000000000001,732.8000000000001])
subplot(2,1,1)
plot(smooth(col_aPerf,WindowLength),'--','Color',Acolor)
hold on
plot(smooth(coor_aPerf,WindowLength),'Color',Acolor)
title(Actor_A)
subplot(2,1,2)
plot(smooth(col_bPerf,WindowLength),'--','Color',Bcolor)
hold on
plot(smooth(coor_bPerf,WindowLength),'Color',Bcolor)
title(Actor_B)
xlabel('session number,chronologically ordered')
ylabel('smoothed performance ')
legend('prefered color performance','coordinated performance','Position',[0.398589855674866 0.949565265815407 0.157913166902312 0.0432587345094139])
