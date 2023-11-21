function [] = bosa_ChoiceDynamicTiming_analysis_singleSession_DyadicAllCuriusHuman

%%% This scripts collect the trials for cjoice dynamic based on three
%%% timing conditions.
run('DyadicCurius_ALL_Sessions_FullPath.m');      
report_struct_list = cell([1, numel(Session_Dyadic_ALL_FullPath)]);
for SessNum = 1 : numel(Session_Dyadic_ALL_FullPath)

    load(char(Session_Dyadic_ALL_FullPath{SessNum}), 'report_struct');
    report_struct_list(SessNum) = {report_struct};
    

end

for SessSolo =  1 : numel(Session_Dyadic_ALL_FullPath)
    ID = SessSolo;
    report_struct = report_struct_list{ID};
    SESSIONDATE = report_struct.LoggingInfo.SessionDate



loadedDATA = array2table(report_struct.data,'VariableNames',report_struct.header);
Rewarded_Aborted  = report_struct.unique_lists.A_OutcomeENUM(loadedDATA.A_OutcomeENUM_idx); % this vector shows which trial was aborted, which was successful,
Trial_TaskType_All = report_struct.unique_lists.A_TrialSubTypeENUM(loadedDATA.A_TrialSubTypeENUM_idx); % this vector shows trial type based on task.
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
choice_combination_color_string = char(PreferableTargetSelected_A);
choice_combination_color_string(SameTargetA) = 'R';
choice_combination_color_string(SameTargetB) = 'B';
choice_combination_color_string(DiffOwnTarget) = 'M';
choice_combination_color_string(DiffOtherTarget) = 'G';
choice_combination_color_string = choice_combination_color_string';
% value and side choices per side/agent
A_target_color_choice_string = char(PreferableTargetSelected_A);
A_target_color_choice_string(logical(PreferableTargetSelected_A)) = 'R';	% A's preferred color is Red
A_target_color_choice_string(logical(NonPreferableTargetSelected_A)) = 'B';	% A's non-preferred color is Blue
A_target_color_choice_string = A_target_color_choice_string';
B_target_color_choice_string = char(PreferableTargetSelected_A);
B_target_color_choice_string(logical(NonPreferableTargetSelected_B)) = 'R';	% B's non-preferred color is Red
B_target_color_choice_string(logical(PreferableTargetSelected_B)) = 'B';	% B's preferred color is Bue/Yellow
B_target_color_choice_string = B_target_color_choice_string';
% for left/right also give objective and subjective
SubjectiveLeftTargetSelected_A = zeros([NumTrials, 1]);
SubjectiveLeftTargetSelected_A(A_LeftChoiceIdx) = 1;
SubjectiveLeftTargetSelected_B = zeros([NumTrials, 1]);
SubjectiveLeftTargetSelected_B(B_LeftChoiceIdx) = 1;
SubjectiveRightTargetSelected_A = zeros([NumTrials, 1]);
SubjectiveRightTargetSelected_A(A_LeftChoiceIdx) = 1;
SubjectiveRightTargetSelected_B = zeros([NumTrials, 1]);
SubjectiveRightTargetSelected_B(B_LeftChoiceIdx) = 1;
% these are objective sides
LeftTargetSelected_A = zeros([NumTrials, 1]);
LeftTargetSelected_A(SideA_ChoiceScreenFromALeft) = 1;
LeftTargetSelected_B = zeros([NumTrials, 1]);
LeftTargetSelected_B(SideB_ChoiceScreenFromALeft) = 1;
RightTargetSelected_A = zeros([NumTrials, 1]);
RightTargetSelected_A(SideA_ChoiceScreenFromARight) = 1;
RightTargetSelected_B = zeros([NumTrials, 1]);
RightTargetSelected_B(SideB_ChoiceScreenFromARight) = 1;
A_objective_side_choice_string = char(PreferableTargetSelected_A);
A_objective_side_choice_string(logical(RightTargetSelected_A)) = 'R';	% A's preferred color is Red
A_objective_side_choice_string(logical(LeftTargetSelected_A)) = 'L';	% A's non-preferred color is Blue
A_objective_side_choice_string = A_objective_side_choice_string';
B_objective_side_choice_string = char(PreferableTargetSelected_A);
B_objective_side_choice_string(logical(RightTargetSelected_B)) = 'R';	% B's non-preferred color is Red
B_objective_side_choice_string(logical(LeftTargetSelected_B)) = 'L';	% B's preferred color is Bue/Yellow
B_objective_side_choice_string = B_objective_side_choice_string';
% get vectors for side/value choices
%PreferableNoneNonpreferableSelected_A = zeros([NumTrials, 1]) + PreferableTargetSelected_A - NonPreferableTargetSelected_A;
%PreferableNoneNonpreferableSelected_B = zeros([NumTrials, 1]) + PreferableTargetSelected_B - NonPreferableTargetSelected_B;
RightNoneLeftSelected_A = zeros([NumTrials, 1]) + RightTargetSelected_A - LeftTargetSelected_A;
RightNoneLeftSelected_B = zeros([NumTrials, 1]) + RightTargetSelected_B - LeftTargetSelected_B;
SubjectiveRightNoneLeftSelected_A = zeros([NumTrials, 1]) + SubjectiveRightTargetSelected_A - SubjectiveLeftTargetSelected_A;
SubjectiveRightNoneLeftSelected_B = zeros([NumTrials, 1]) + SubjectiveRightTargetSelected_B - SubjectiveLeftTargetSelected_B;
A_left = LeftTargetSelected_A;
B_left = LeftTargetSelected_B;
A_right = RightTargetSelected_A;
B_right = RightTargetSelected_B;
A_left_B_left = A_left & B_left;
A_right_B_right = A_right & B_right;
A_left_B_right = A_left & B_right;
A_right_B_left = A_right & B_left;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% whether the same target position was touched
TmpSameYIdx = find(report_struct.data(:, report_struct.cn.A_TouchSelectedTargetPosition_Y) == report_struct.data(:, report_struct.cn.B_TouchSelectedTargetPosition_Y));
TmpSameXIdX = find(report_struct.data(:, report_struct.cn.A_TouchSelectedTargetPosition_X) == report_struct.data(:, report_struct.cn.B_TouchSelectedTargetPosition_X));
TmpSameIdx = intersect(TmpSameXIdX, TmpSameYIdx);
% target was actually shown?
% was the final touch target visible:
SideA_TouchTargetVisible = find(report_struct.data(:, report_struct.cn.A_TargetOnsetTime_ms) > 0);
SideB_TouchTargetVisible = find(report_struct.data(:, report_struct.cn.A_TargetOnsetTime_ms) > 0);
TouchTargetVisible = union(SideA_TouchTargetVisible, SideB_TouchTargetVisible);
TmpSameIdx = intersect(TmpSameIdx, SideA_TouchTargetVisible);
TmpSameIdx = intersect(TmpSameIdx, SideB_TouchTargetVisible);
% only report if both subjects made a choice
TmpSameIdx = intersect(TmpSameIdx, find(report_struct.data(:, report_struct.cn.A_TargetTouchTime_ms) > 0.0));
TmpSameIdx = intersect(TmpSameIdx, find(report_struct.data(:, report_struct.cn.B_TargetTouchTime_ms) > 0.0));
% only report real joint trials
% note all three should be identical...
SideA_SameTarget = intersect(TmpSameIdx, SideA_DualSubjectJointTrials);
SideB_SameTarget = intersect(TmpSameIdx, SideB_DualSubjectJointTrials);
ByChoice_SameTarget = intersect(SideA_SameTarget, SideB_SameTarget);
SameTargetSelected_A = zeros([NumTrials, 1]);
SameTargetSelected_A(SideA_SameTarget) = 1;
SameTargetSelected_B = zeros([NumTrials, 1]);
SameTargetSelected_B(SideB_SameTarget) = 1;
%% Zahra: The most important vector is: DualJoint AND rewarded, because from this vector we want to
%% create a vector that contains choice information (own prefered colour, other colour)
%% so needed vectors are  1) A_target_color_choice_string, B_target_color_choice_string which contains colour choice for ALL trials
%% 2) The vector ''Rewarded_DualSubjectJointTrials'' contains the information about trials which subjects acted jointly and rewarded.
Actor_A = report_struct.unique_lists.A_Name{1}
% Actor_B = report_struct.unique_lists.B_Name
Actor_B = 'Human'
A_ColorChoiceString_Filtered_JointRewarded = A_target_color_choice_string(Rewarded_DualSubjectJointTrials);
B_ColorChoiceString_Filtered_JointRewarded = B_target_color_choice_string(Rewarded_DualSubjectJointTrials);
%%
FirstSwitchPointID = 1;
SecondSwitchPointID = [];
RedStringLenght = zeros(1,100)
BlueStringLenght = zeros(1,100)
for RunningWindow = 1 : numel(A_ColorChoiceString_Filtered_JointRewarded)-1
    if A_ColorChoiceString_Filtered_JointRewarded(RunningWindow) ~= A_ColorChoiceString_Filtered_JointRewarded(RunningWindow+1)
        SecondSwitchPointID = RunningWindow+1;
        if  A_ColorChoiceString_Filtered_JointRewarded(RunningWindow) == 'R'
            RedStringLenght(SecondSwitchPointID-FirstSwitchPointID) = RedStringLenght(SecondSwitchPointID-FirstSwitchPointID)+1;
        end
        if  A_ColorChoiceString_Filtered_JointRewarded(RunningWindow) == 'B'
            BlueStringLenght(SecondSwitchPointID-FirstSwitchPointID) = BlueStringLenght(SecondSwitchPointID-FirstSwitchPointID)+1;
        end
        FirstSwitchPointID = SecondSwitchPointID;
    end
end
%% Just a sanity check to look at the trials based on choice color for actor A: (look if the number inside RedStringLenght and RedStringLenght make sense)
% figure(1), hold on
% for n = 1 : numel(A_ColorChoiceString_Filtered_JointRewarded)
%     if A_ColorChoiceString_Filtered_JointRewarded(n) == 'R'
%         plot(n,1,'|r')
%     end
%     if A_ColorChoiceString_Filtered_JointRewarded(n) == 'B'
%         plot(n,0,'|b')
%     end
% end
%%
% 1) The first step is to look at human vector and find the transison
% point
% switch points ID:
AllHumanTransition = find(diff(B_ColorChoiceString_Filtered_JointRewarded) ~= 0)+1
% Transition from B to R: diff is 16
BtoR_HumanTransition = find(diff(B_ColorChoiceString_Filtered_JointRewarded)> 0)+1
% Transition from R to B: diff is -16
RtoB_HumanTransition = find(diff(B_ColorChoiceString_Filtered_JointRewarded)< 0)+1
BeforeAfter_Length = 5;
ThresholdForValidSwitch = BeforeAfter_Length;
LenghtBeforeSwitch = diff(AllHumanTransition)
NotValidSwitchID_All_ID = find(LenghtBeforeSwitch<ThresholdForValidSwitch)+1
NotValidSwitchID_BR = intersect(BtoR_HumanTransition,AllHumanTransition(NotValidSwitchID_All_ID))
NotValidSwitchID_RB = intersect(RtoB_HumanTransition,AllHumanTransition(NotValidSwitchID_All_ID))
if AllHumanTransition(1)-BeforeAfter_Length< 0
    NotValidSwitchID_All_ID = [1,NotValidSwitchID_All_ID]
end
if AllHumanTransition(end)+BeforeAfter_Length> numel(B_ColorChoiceString_Filtered_JointRewarded)
    NotValidSwitchID_All_ID(end+1) = numel(AllHumanTransition)
end
BtoR_HumanTransition = setdiff(BtoR_HumanTransition,AllHumanTransition(NotValidSwitchID_All_ID))
RtoB_HumanTransition = setdiff(RtoB_HumanTransition,AllHumanTransition(NotValidSwitchID_All_ID))
AllHumanTransition(NotValidSwitchID_All_ID) = [];

%% Now you want to look at 5 trials before and after BR switches to count own colour choices for human
BRHuman_BeforSwitch_Choices = cell(numel(BtoR_HumanTransition),BeforeAfter_Length)
BRHuman_AfterSwitch_Choices = cell(numel(BtoR_HumanTransition),BeforeAfter_Length)
BRHuman_AtSwitch_Choices = cell(numel(BtoR_HumanTransition),1)
for SW = 1 : numel(BtoR_HumanTransition)
    A = split(B_ColorChoiceString_Filtered_JointRewarded(BtoR_HumanTransition(SW)-BeforeAfter_Length:BtoR_HumanTransition(SW)-1),'')
    A = A(2:end-1)'
    BRHuman_BeforSwitch_Choices(SW,:) = A;
end
for SW = 1 : numel(BtoR_HumanTransition)
    BRHuman_AtSwitch_Choices(SW) = cellstr(B_ColorChoiceString_Filtered_JointRewarded(BtoR_HumanTransition(SW)));
end
for SW = 1 : numel(BtoR_HumanTransition)
    A = split(B_ColorChoiceString_Filtered_JointRewarded(BtoR_HumanTransition(SW)+1:BtoR_HumanTransition(SW)+BeforeAfter_Length),'')
    A = A(2:end-1)'
    BRHuman_AfterSwitch_Choices(SW,:) = A;
end
% Convert 'B' to 1 and 'R' to 0
OwnChoice_BRHuman_BeforeSwitch = cellfun(@(x) x == 'B', BRHuman_BeforSwitch_Choices);
OwnChoice_BRHuman_AfterSwitch = cellfun(@(x) x == 'B', BRHuman_AfterSwitch_Choices);
OwnChoice_BRHuman_AtSwitch = cellfun(@(x) x == 'B', BRHuman_AtSwitch_Choices);
% Calculate the average vertically
averageOwn_BRHuman_BeforSwitch = mean(OwnChoice_BRHuman_BeforeSwitch, 1);
averageOwn_BRHuman_AfterSwitch = mean(OwnChoice_BRHuman_AfterSwitch, 1);
averageOwn_BRHuman_AtSwitch = mean(OwnChoice_BRHuman_AtSwitch, 1);
averageOwn_BRHumanAll = [averageOwn_BRHuman_BeforSwitch,averageOwn_BRHuman_AtSwitch,averageOwn_BRHuman_AfterSwitch];
figure(1), hold on
plot(1:(2*BeforeAfter_Length)+1,averageOwn_BRHumanAll,'+-b','LineWidth',2)
xline(BeforeAfter_Length+1,'--','Color',[0.5 0.5 0.5])
ylim([-0.1 1.1])
xticks([])
title('transition BR')
subtitle(SESSIONDATE)
%% ATTENTION: THIS IS THE SAME PROCEDURE OF PREVIOUS SECTION BUT FOR RB SWITCHES
RBHuman_BeforSwitch_Choices = cell(numel(RtoB_HumanTransition),BeforeAfter_Length)
RBHuman_AfterSwitch_Choices = cell(numel(RtoB_HumanTransition),BeforeAfter_Length)
RBHuman_AtSwitch_Choices = cell(numel(RtoB_HumanTransition),1)
for SW = 1 : numel(RtoB_HumanTransition)
    A = split(B_ColorChoiceString_Filtered_JointRewarded(RtoB_HumanTransition(SW)-BeforeAfter_Length:RtoB_HumanTransition(SW)-1),'')
    A = A(2:end-1)'
    RBHuman_BeforSwitch_Choices(SW,:) = A;
end
for SW = 1 : numel(RtoB_HumanTransition)
    RBHuman_AtSwitch_Choices(SW) = cellstr(B_ColorChoiceString_Filtered_JointRewarded(RtoB_HumanTransition(SW)))
end
for SW = 1 : numel(RtoB_HumanTransition)
    A = split(B_ColorChoiceString_Filtered_JointRewarded(RtoB_HumanTransition(SW)+1:RtoB_HumanTransition(SW)+BeforeAfter_Length),'')
    A = A(2:end-1)'
    RBHuman_AfterSwitch_Choices(SW,:) = A;
end
% Convert 'B' to 1 and 'R' to 0
OwnChoice_RBHuman_BeforeSwitch = cellfun(@(x) x == 'B', RBHuman_BeforSwitch_Choices);
OwnChoice_RBHuman_AfterSwitch = cellfun(@(x) x == 'B', RBHuman_AfterSwitch_Choices);
OwnChoice_RBHuman_AtSwitch = cellfun(@(x) x == 'B', RBHuman_AtSwitch_Choices);
% Calculate the average vertically
averageOwn_RBHuman_BeforSwitch = mean(OwnChoice_RBHuman_BeforeSwitch, 1);
averageOwn_RBHuman_AfterSwitch = mean(OwnChoice_RBHuman_AfterSwitch, 1);
averageOwn_RBHuman_AtSwitch = mean(OwnChoice_RBHuman_AtSwitch, 1);
averageOwn_RBHumanAll = [averageOwn_RBHuman_BeforSwitch,averageOwn_RBHuman_AtSwitch,averageOwn_RBHuman_AfterSwitch];
figure(2), hold on
plot(1:(2*BeforeAfter_Length)+1,averageOwn_RBHumanAll,'+-b','LineWidth',2)
xline(BeforeAfter_Length+1,'--','Color',[0.5 0.5 0.5])
ylim([-0.1 1.1])
xticks([])
title('transition RB')
%%
%% Now you want to look at 5 trials before and after BR switches to cound own colour choices for MONKEY
BRMonkey_BeforSwitch_Choices = cell(numel(BtoR_HumanTransition),BeforeAfter_Length)
BRMonkey_AfterSwitch_Choices = cell(numel(BtoR_HumanTransition),BeforeAfter_Length)
BRMonkey_AtSwitch_Choices = cell(numel(BtoR_HumanTransition),1)
for SW = 1 : numel(BtoR_HumanTransition)
    A = split(A_ColorChoiceString_Filtered_JointRewarded(BtoR_HumanTransition(SW)-BeforeAfter_Length:BtoR_HumanTransition(SW)-1),'')
    A = A(2:end-1)'
    BRMonkey_BeforSwitch_Choices(SW,:) = A;
end
for SW = 1 : numel(BtoR_HumanTransition)
    BRMonkey_AtSwitch_Choices(SW) = cellstr(A_ColorChoiceString_Filtered_JointRewarded(BtoR_HumanTransition(SW)))
end
for SW = 1 : numel(BtoR_HumanTransition)
    A = split(A_ColorChoiceString_Filtered_JointRewarded(BtoR_HumanTransition(SW)+1:BtoR_HumanTransition(SW)+BeforeAfter_Length),'')
    A = A(2:end-1)'
    BRMonkey_AfterSwitch_Choices(SW,:) = A;
end
% Convert 'B' to 1 and 'R' to 0
OwnChoice_BRMonkey_BeforeSwitch = cellfun(@(x) x == 'R', BRMonkey_BeforSwitch_Choices);
OwnChoice_BRMonkey_AfterSwitch = cellfun(@(x) x == 'R', BRMonkey_AfterSwitch_Choices);
OwnChoice_BRMonkey_AtSwitch = cellfun(@(x) x == 'R', BRMonkey_AtSwitch_Choices);
% Calculate the average vertically
averageOwn_BRMonkey_BeforSwitch = mean(OwnChoice_BRMonkey_BeforeSwitch, 1);
averageOwn_BRMonkey_AfterSwitch = mean(OwnChoice_BRMonkey_AfterSwitch, 1);
averageOwn_BRMonkey_AtSwitch = mean(OwnChoice_BRMonkey_AtSwitch, 1);
averageOwn_BRMonkeyAll = [averageOwn_BRMonkey_BeforSwitch,averageOwn_BRMonkey_AtSwitch,averageOwn_BRMonkey_AfterSwitch];
figure(1)
hold on
plot(1:(2*BeforeAfter_Length)+1,averageOwn_BRMonkeyAll,'+-r','LineWidth',2)
xline(BeforeAfter_Length+1,'--','Color',[0.5 0.5 0.5])
ylim([-0.1 1.1])
xticks([])
pbaspect([1 1 1])
title('transition: BR')
fig1 = gcf
%%
%% Now you want to look at 5 trials before and after RB switches to cound own colour choices for MONKEY
RBMonkey_BeforSwitch_Choices = cell(numel(RtoB_HumanTransition),BeforeAfter_Length)
RBMonkey_AfterSwitch_Choices = cell(numel(RtoB_HumanTransition),BeforeAfter_Length)
RBMonkey_AtSwitch_Choices = cell(numel(RtoB_HumanTransition),1)
for SW = 1 : numel(RtoB_HumanTransition)
    A = split(A_ColorChoiceString_Filtered_JointRewarded(RtoB_HumanTransition(SW)-BeforeAfter_Length:RtoB_HumanTransition(SW)-1),'')
    A = A(2:end-1)'
    RBMonkey_BeforSwitch_Choices(SW,:) = A;
end
for SW = 1 : numel(RtoB_HumanTransition)
    RBMonkey_AtSwitch_Choices(SW) = cellstr(A_ColorChoiceString_Filtered_JointRewarded(RtoB_HumanTransition(SW)))
end
for SW = 1 : numel(RtoB_HumanTransition)
    A = split(A_ColorChoiceString_Filtered_JointRewarded(RtoB_HumanTransition(SW)+1:RtoB_HumanTransition(SW)+BeforeAfter_Length),'')
    A = A(2:end-1)'
    RBMonkey_AfterSwitch_Choices(SW,:) = A;
end
% Convert 'B' to 1 and 'R' to 0
OwnChoice_RBMonkey_BeforeSwitch = cellfun(@(x) x == 'R', RBMonkey_BeforSwitch_Choices);
OwnChoice_RBMonkey_AfterSwitch = cellfun(@(x) x == 'R', RBMonkey_AfterSwitch_Choices);
OwnChoice_RBMonkey_AtSwitch = cellfun(@(x) x == 'R', RBMonkey_AtSwitch_Choices);
% Calculate the average vertically
averageOwn_RBMonkey_BeforSwitch = mean(OwnChoice_RBMonkey_BeforeSwitch, 1);
averageOwn_RBMonkey_AfterSwitch = mean(OwnChoice_RBMonkey_AfterSwitch, 1);
averageOwn_RBMonkey_AtSwitch = mean(OwnChoice_RBMonkey_AtSwitch, 1);
averageOwn_RBMonkeyAll = [averageOwn_RBMonkey_BeforSwitch,averageOwn_RBMonkey_AtSwitch,averageOwn_RBMonkey_AfterSwitch];
figure(2)
hold on
plot(1:(2*BeforeAfter_Length)+1,averageOwn_RBMonkeyAll,'+-r','LineWidth',2)
xline(BeforeAfter_Length+1,'--','Color',[0.5 0.5 0.5])
ylim([-0.1 1.1])
xticks([])
pbaspect([1 1 1])
title('transition: RB')
subtitle(SESSIONDATE)

fig2 = gcf
%%
%%% Now is the time to create filter for monkey's turn:
diffGoSignalTime_ms_AllTrials = loadedDATA.A_GoSignalTime_ms - loadedDATA.B_GoSignalTime_ms;
diffGoSignalTime_ms_JointRewarded = diffGoSignalTime_ms_AllTrials(Rewarded_DualSubjectJointTrials)
Turn_ActorA_Categ = {'first','second','simultaneously'}; % defining turn of actor in categorical data, later we will use this for plotting
% Turn_ActorA_Simul_JointRewarded_ID = find(diffGoSignalTime_ms_JointRewarded == 0); % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
Turn_ActorA_First_diffGoSignalTime_ms_JointRewarded_ID = find(diffGoSignalTime_ms_JointRewarded<0);  % Indices of trials that actor A was the first (among all trials).
Turn_ActorA_Second_JointRewarded_ID = find(diffGoSignalTime_ms_JointRewarded>0); % Indices of trials that actor A was the second (among all trials).
%% Sebastian said it is better to look at the Simul data based on the RT when RT MONKEY == RT human ( they never exactly matches, you should consider an interval)
RT_A_ms_AllTrials  = loadedDATA.A_InitialFixationReleaseTime_ms - loadedDATA.A_GoSignalTime_ms;
RT_A_ms_JointRewarded  = RT_A_ms_AllTrials(Rewarded_DualSubjectJointTrials);


RT_B_ms_AllTrials  = loadedDATA.B_InitialFixationReleaseTime_ms - loadedDATA.B_GoSignalTime_ms;
RT_B_ms_JointRewarded  = RT_B_ms_AllTrials(Rewarded_DualSubjectJointTrials);

ThresholdRT_Diff = 300
SimulRTs = RT_A_ms_JointRewarded-RT_B_ms_JointRewarded<= ThresholdRT_Diff
SimulJointRewarded = diffGoSignalTime_ms_JointRewarded == 0

Turn_ActorA_Simul_JointRewarded_ID = find(SimulJointRewarded(SimulRTs))

%%
InitialVector =  repmat('N', 1, numel(Rewarded_DualSubjectJointTrials)); % we need this, trials dont belong to ''timing filter'' stays NaN
InitialVector(Turn_ActorA_First_diffGoSignalTime_ms_JointRewarded_ID) = A_ColorChoiceString_Filtered_JointRewarded(Turn_ActorA_First_diffGoSignalTime_ms_JointRewarded_ID); %replacing NaN with ''trials belong to correct timing''
MonkFirst_A_ColorChoiceString = InitialVector;
% the same procedure for simul
InitialVector =  repmat('N', 1, numel(Rewarded_DualSubjectJointTrials));
InitialVector(Turn_ActorA_Simul_JointRewarded_ID) = A_ColorChoiceString_Filtered_JointRewarded(Turn_ActorA_Simul_JointRewarded_ID);
MonkSimul_A_ColorChoiceString = InitialVector;
% the same procedure for second
InitialVector =  repmat('N', 1, numel(Rewarded_DualSubjectJointTrials));
InitialVector(Turn_ActorA_Second_JointRewarded_ID) = A_ColorChoiceString_Filtered_JointRewarded(Turn_ActorA_Second_JointRewarded_ID);
MonkSecond_A_ColorChoiceString = InitialVector;
%%
% FIRST Replace characters R = 1  B = 0 N = 9
MonkFirst_A_ColorChoiceString = strrep(MonkFirst_A_ColorChoiceString, 'B', '0');
MonkFirst_A_ColorChoiceString = strrep(MonkFirst_A_ColorChoiceString, 'R', '1');
MonkFirst_A_ColorChoiceString = strrep(MonkFirst_A_ColorChoiceString, 'N', '9');
% Convert char arraay to double vector
% Define anonymous function for conversion
conversionFcn = @(x) str2double(strrep(x, '9', '[NaN]'));
% Use arrayfun to apply the function to each element
MonkFirst_A_ColorChoiceString = arrayfun(conversionFcn, MonkFirst_A_ColorChoiceString);
MonkFirst_A_ColorChoiceNumerical_JointRewarded = MonkFirst_A_ColorChoiceString
%%
% SIMUL Replace characters R = 1  B = 0 N = NaN
MonkSimul_A_ColorChoiceString = strrep(MonkSimul_A_ColorChoiceString, 'B', '0');
MonkSimul_A_ColorChoiceString = strrep(MonkSimul_A_ColorChoiceString, 'R', '1');
MonkSimul_A_ColorChoiceString = strrep(MonkSimul_A_ColorChoiceString, 'N', '9');
% Convert char arraay to double vector
% Define anonymous function for conversion
conversionFcn = @(x) str2double(strrep(x, '9', '[NaN]'));
% Use arrayfun to apply the function to each element
MonkSimul_A_ColorChoiceString = arrayfun(conversionFcn, MonkSimul_A_ColorChoiceString);
MonkSimul_A_ColorChoiceNumerical_JointRewarded = MonkSimul_A_ColorChoiceString
%%
% SECOND: Replace characters R = 1  B = 0 N = NaN
MonkSecond_A_ColorChoiceString = strrep(MonkSecond_A_ColorChoiceString, 'B', '0');
MonkSecond_A_ColorChoiceString = strrep(MonkSecond_A_ColorChoiceString, 'R', '1');
MonkSecond_A_ColorChoiceString = strrep(MonkSecond_A_ColorChoiceString, 'N', '9');
% Convert char arraay to double vector
% Define anonymous function for conversion
conversionFcn = @(x) str2double(strrep(x, '9', '[NaN]'));
% Use arrayfun to apply the function to each element
MonkSecond_A_ColorChoiceString = arrayfun(conversionFcn, MonkSecond_A_ColorChoiceString);
MonkSecond_A_ColorChoiceNumerical_JointRewarded = MonkSecond_A_ColorChoiceString
%%
% FIRST: Seperate the choices for before, at switch  and after the HUMAN switch
% point BR SWITCHES
First_BRMonkey_BeforSwitch_Choices = nan(numel(BtoR_HumanTransition),BeforeAfter_Length)
First_BRMonkey_ATSwitch_Choices = nan(numel(BtoR_HumanTransition),1)
First_BRMonkey_AfterSwitch_Choices = nan(numel(BtoR_HumanTransition),BeforeAfter_Length)
for SW = 1 : numel(BtoR_HumanTransition)
    A = MonkFirst_A_ColorChoiceNumerical_JointRewarded(BtoR_HumanTransition(SW)-BeforeAfter_Length:BtoR_HumanTransition(SW)-1)
    First_BRMonkey_BeforSwitch_Choices(SW,:) = A;
end
for SW = 1 : numel(BtoR_HumanTransition)
    First_BRMonkey_ATSwitch_Choices(SW) = MonkFirst_A_ColorChoiceNumerical_JointRewarded(BtoR_HumanTransition(SW));
end
for SW = 1 : numel(BtoR_HumanTransition)
    A = MonkFirst_A_ColorChoiceNumerical_JointRewarded(BtoR_HumanTransition(SW)+1:BtoR_HumanTransition(SW)+BeforeAfter_Length)
    First_BRMonkey_AfterSwitch_Choices(SW,:) = A;
end
First_BRMonkey_ALL_Choices = [First_BRMonkey_BeforSwitch_Choices,First_BRMonkey_BeforSwitch_Choices,First_BRMonkey_AfterSwitch_Choices];
% Calculate the average vertically:
FIRST_averageOwn_BRMonkey_BeforSwitch = mean(First_BRMonkey_BeforSwitch_Choices, 1,'omitnan');
FIRST_averageOwn_BRMonkey_AfterSwitch = mean(First_BRMonkey_AfterSwitch_Choices, 1,'omitnan');
FIRST_averageOwn_BRMonkey_AtSwitch = mean(First_BRMonkey_ATSwitch_Choices, 1,'omitnan');
FIRST_averageOwn_BRMonkey = [FIRST_averageOwn_BRMonkey_BeforSwitch FIRST_averageOwn_BRMonkey_AtSwitch FIRST_averageOwn_BRMonkey_AfterSwitch]
% plot the average:
figure(3)
subplot(3,2,1)
plot(1:(2*BeforeAfter_Length)+1,FIRST_averageOwn_BRMonkey,'+-r','LineWidth',2)
xline(BeforeAfter_Length+1,'--','Color',[0.5 0.5 0.5])
hold on
plot(1:(2*BeforeAfter_Length)+1,averageOwn_BRMonkeyAll,'.-','Color',[0.5 0.5 0.5 0.3],'LineWidth',4)
plot(1:(2*BeforeAfter_Length)+1,averageOwn_BRHumanAll,'.-','Color',[0 0 1 0.3],'LineWidth',4)
xlim([0 12])
ylim([-0.1 1.1])
xticks([])
pbaspect([1 1 1])
title('transition: BR')
subtitle(strcat('number of trials: ',string(sum(sum(~isnan(First_BRMonkey_ALL_Choices))))))
%%
% SIMUL: Seperate the choices for before, at switch  and after the HUMAN switch
% point BR SWITCHES
Simul_BRMonkey_BeforSwitch_Choices = nan(numel(BtoR_HumanTransition),BeforeAfter_Length)
Simul_BRMonkey_ATSwitch_Choices = nan(numel(BtoR_HumanTransition),1)
Simul_BRMonkey_AfterSwitch_Choices = nan(numel(BtoR_HumanTransition),BeforeAfter_Length)
for SW = 1 : numel(BtoR_HumanTransition)
    A = MonkSimul_A_ColorChoiceNumerical_JointRewarded(BtoR_HumanTransition(SW)-BeforeAfter_Length:BtoR_HumanTransition(SW)-1)
    Simul_BRMonkey_BeforSwitch_Choices(SW,:) = A;
end
for SW = 1 : numel(BtoR_HumanTransition)
    Simul_BRMonkey_ATSwitch_Choices(SW) = MonkSimul_A_ColorChoiceNumerical_JointRewarded(BtoR_HumanTransition(SW));
end
for SW = 1 : numel(BtoR_HumanTransition)
    A = MonkSimul_A_ColorChoiceNumerical_JointRewarded(BtoR_HumanTransition(SW)+1:BtoR_HumanTransition(SW)+BeforeAfter_Length)
    Simul_BRMonkey_AfterSwitch_Choices(SW,:) = A;
end
Simul_BRMonkey_ALL_Choices = [Simul_BRMonkey_BeforSwitch_Choices,Simul_BRMonkey_ATSwitch_Choices,Simul_BRMonkey_AfterSwitch_Choices]
% Calculate the average vertically:
Simul_averageOwn_BRMonkey_BeforSwitch = mean(Simul_BRMonkey_BeforSwitch_Choices, 1,'omitnan');
Simul_averageOwn_BRMonkey_AfterSwitch = mean(Simul_BRMonkey_AfterSwitch_Choices, 1,'omitnan');
Simul_averageOwn_BRMonkey_AtSwitch = mean(Simul_BRMonkey_ATSwitch_Choices, 1,'omitnan');
Simul_averageOwn_BRMonkey = [Simul_averageOwn_BRMonkey_BeforSwitch Simul_averageOwn_BRMonkey_AtSwitch Simul_averageOwn_BRMonkey_AfterSwitch]
% plot the average:
subplot(3,2,3)
plot(1:(2*BeforeAfter_Length)+1,Simul_averageOwn_BRMonkey,'+-r','LineWidth',2)
xline(BeforeAfter_Length+1,'--','Color',[0.5 0.5 0.5])
hold on
plot(1:(2*BeforeAfter_Length)+1,averageOwn_BRMonkeyAll,'.-','Color',[0.5 0.5 0.5 0.3],'LineWidth',4)
plot(1:(2*BeforeAfter_Length)+1,averageOwn_BRHumanAll,'.-','Color',[0 0 1 0.3],'LineWidth',4)
xlim([0 12])
ylim([-0.1 1.1])
xticks([])
pbaspect([1 1 1])
title('transition: BR')
subtitle(strcat('number of trials: ',string(sum(sum(~isnan(Simul_BRMonkey_ALL_Choices))))))
%%
% SECOND: Seperate the choices for before, at switch  and after the HUMAN switch
% point BR SWITCHES
Second_BRMonkey_BeforSwitch_Choices = nan(numel(BtoR_HumanTransition),BeforeAfter_Length)
Second_BRMonkey_ATSwitch_Choices = nan(numel(BtoR_HumanTransition),1)
Second_BRMonkey_AfterSwitch_Choices = nan(numel(BtoR_HumanTransition),BeforeAfter_Length)
for SW = 1 : numel(BtoR_HumanTransition)
    A = MonkSecond_A_ColorChoiceNumerical_JointRewarded(BtoR_HumanTransition(SW)-BeforeAfter_Length:BtoR_HumanTransition(SW)-1)
    Second_BRMonkey_BeforSwitch_Choices(SW,:) = A;
end
for SW = 1 : numel(BtoR_HumanTransition)
    Second_BRMonkey_ATSwitch_Choices(SW) = MonkSecond_A_ColorChoiceNumerical_JointRewarded(BtoR_HumanTransition(SW));
end
for SW = 1 : numel(BtoR_HumanTransition)
    A = MonkSecond_A_ColorChoiceNumerical_JointRewarded(BtoR_HumanTransition(SW)+1:BtoR_HumanTransition(SW)+BeforeAfter_Length)
    Second_BRMonkey_AfterSwitch_Choices(SW,:) = A;
end
%%
Second_BRMonkey_ALL_Choices = [Second_BRMonkey_BeforSwitch_Choices,Second_BRMonkey_ATSwitch_Choices,Second_BRMonkey_AfterSwitch_Choices]
% Calculate the average vertically:
Second_averageOwn_BRMonkey_BeforSwitch = mean(Second_BRMonkey_BeforSwitch_Choices, 1,'omitnan');
Second_averageOwn_BRMonkey_AfterSwitch = mean(Second_BRMonkey_AfterSwitch_Choices, 1,'omitnan');
Second_averageOwn_BRMonkey_AtSwitch = mean(Second_BRMonkey_ATSwitch_Choices, 1,'omitnan');
Second_averageOwn_BRMonkey = [Second_averageOwn_BRMonkey_BeforSwitch Second_averageOwn_BRMonkey_AtSwitch Second_averageOwn_BRMonkey_AfterSwitch]
% plot the average:
subplot(3,2,5)
plot(1:(2*BeforeAfter_Length)+1,Second_averageOwn_BRMonkey,'+-r','LineWidth',2)
xline(BeforeAfter_Length+1,'--','Color',[0.5 0.5 0.5])
hold on
plot(1:(2*BeforeAfter_Length)+1,averageOwn_BRMonkeyAll,'.-','Color',[0.5 0.5 0.5 0.3],'LineWidth',4)
plot(1:(2*BeforeAfter_Length)+1,averageOwn_BRHumanAll,'.-','Color',[0 0 1 0.3],'LineWidth',4)
xlim([0 12])
ylim([-0.1 1.1])
xticks([])
pbaspect([1 1 1])
title('transition: BR')
subtitle(strcat('number of trials: ',string(sum(sum(~isnan(Second_BRMonkey_ALL_Choices))))))
%% Redo the all procedure for RB Human switches:
%%
% FIRST: Seperate the choices for before, at switch  and after the HUMAN switch
% point RB SWITCHES
First_RBMonkey_BeforSwitch_Choices = nan(numel(RtoB_HumanTransition),BeforeAfter_Length)
First_RBMonkey_ATSwitch_Choices = nan(numel(RtoB_HumanTransition),1)
First_RBMonkey_AfterSwitch_Choices = nan(numel(RtoB_HumanTransition),BeforeAfter_Length)
for SW = 1 : numel(RtoB_HumanTransition)
    A = MonkFirst_A_ColorChoiceNumerical_JointRewarded(RtoB_HumanTransition(SW)-BeforeAfter_Length:RtoB_HumanTransition(SW)-1)
    First_RBMonkey_BeforSwitch_Choices(SW,:) = A;
end
for SW = 1 : numel(RtoB_HumanTransition)
    First_RBMonkey_ATSwitch_Choices(SW) = MonkFirst_A_ColorChoiceNumerical_JointRewarded(RtoB_HumanTransition(SW));
end
for SW = 1 : numel(RtoB_HumanTransition)
    A = MonkFirst_A_ColorChoiceNumerical_JointRewarded(RtoB_HumanTransition(SW)+1:RtoB_HumanTransition(SW)+BeforeAfter_Length)
    First_RBMonkey_AfterSwitch_Choices(SW,:) = A;
end
First_RBMonkey_ALL_Choices = [First_RBMonkey_BeforSwitch_Choices,First_RBMonkey_ATSwitch_Choices,First_RBMonkey_AfterSwitch_Choices];
% Calculate the average vertically:
FIRST_averageOwn_RBMonkey_BeforSwitch = mean(First_RBMonkey_BeforSwitch_Choices, 1,'omitnan');
FIRST_averageOwn_RBMonkey_AfterSwitch = mean(First_RBMonkey_AfterSwitch_Choices, 1,'omitnan');
FIRST_averageOwn_RBMonkey_AtSwitch = mean(First_RBMonkey_ATSwitch_Choices, 1,'omitnan');
FIRST_averageOwn_RBMonkey = [FIRST_averageOwn_RBMonkey_BeforSwitch FIRST_averageOwn_RBMonkey_AtSwitch FIRST_averageOwn_RBMonkey_AfterSwitch]
% plot the average:
figure(3)
subplot(3,2,2)
plot(1:(2*BeforeAfter_Length)+1,FIRST_averageOwn_RBMonkey,'+-r','LineWidth',2)
xline(BeforeAfter_Length+1,'--','Color',[0.5 0.5 0.5])
hold on
plot(1:(2*BeforeAfter_Length)+1,averageOwn_RBMonkeyAll,'.-','Color',[0.5 0.5 0.5 0.3],'LineWidth',4)
plot(1:(2*BeforeAfter_Length)+1,averageOwn_RBHumanAll,'.-','Color',[0 0 1 0.3],'LineWidth',4)
xlim([0 12])
ylim([-0.1 1.1])
xticks([])
pbaspect([1 1 1])
title('transition: RB')
subtitle(strcat('number of trials: ',string(sum(sum(~isnan(First_RBMonkey_ALL_Choices))))))
%%
% SIMUL: Seperate the choices for before, at switch  and after the HUMAN switch
% point BR SWITCHES
Simul_RBMonkey_BeforSwitch_Choices = nan(numel(RtoB_HumanTransition),BeforeAfter_Length)
Simul_RBMonkey_ATSwitch_Choices = nan(numel(RtoB_HumanTransition),1)
Simul_RBMonkey_AfterSwitch_Choices = nan(numel(RtoB_HumanTransition),BeforeAfter_Length)
for SW = 1 : numel(RtoB_HumanTransition)
    A = MonkSimul_A_ColorChoiceNumerical_JointRewarded(RtoB_HumanTransition(SW)-BeforeAfter_Length:RtoB_HumanTransition(SW)-1)
    Simul_RBMonkey_BeforSwitch_Choices(SW,:) = A;
end
for SW = 1 : numel(RtoB_HumanTransition)
    Simul_RBMonkey_ATSwitch_Choices(SW) = MonkSimul_A_ColorChoiceNumerical_JointRewarded(RtoB_HumanTransition(SW));
end
for SW = 1 : numel(RtoB_HumanTransition)
    A = MonkSimul_A_ColorChoiceNumerical_JointRewarded(RtoB_HumanTransition(SW)+1:RtoB_HumanTransition(SW)+BeforeAfter_Length)
    Simul_RBMonkey_AfterSwitch_Choices(SW,:) = A;
end
Simul_RBMonkey_ALL_Choices = [Simul_RBMonkey_BeforSwitch_Choices,Simul_RBMonkey_ATSwitch_Choices,Simul_RBMonkey_AfterSwitch_Choices];
% Calculate the average vertically:
Simul_averageOwn_RBMonkey_BeforSwitch = mean(Simul_RBMonkey_BeforSwitch_Choices, 1,'omitnan');
Simul_averageOwn_RBMonkey_AfterSwitch = mean(Simul_RBMonkey_AfterSwitch_Choices, 1,'omitnan');
Simul_averageOwn_RBMonkey_AtSwitch = mean(Simul_RBMonkey_ATSwitch_Choices, 1,'omitnan');
Simul_averageOwn_RBMonkey = [Simul_averageOwn_RBMonkey_BeforSwitch Simul_averageOwn_RBMonkey_AtSwitch Simul_averageOwn_RBMonkey_AfterSwitch]
% plot the average:
subplot(3,2,4)
plot(1:(2*BeforeAfter_Length)+1,Simul_averageOwn_RBMonkey,'+-r','LineWidth',2)
xline(BeforeAfter_Length+1,'--','Color',[0.5 0.5 0.5])
hold on
plot(1:(2*BeforeAfter_Length)+1,averageOwn_RBMonkeyAll,'.-','Color',[0.5 0.5 0.5 0.3],'LineWidth',4)
plot(1:(2*BeforeAfter_Length)+1,averageOwn_RBHumanAll,'.-','Color',[0 0 1 0.3],'LineWidth',4)
xlim([0 12])
ylim([-0.1 1.1])
xticks([])
pbaspect([1 1 1])
title('transition: RB')
subtitle(strcat('number of trials: ',string(sum(sum(~isnan(Simul_RBMonkey_ALL_Choices))))))
%%
% SECOND: Seperate the choices for before, at switch  and after the HUMAN switch
% point RB SWITCHES
Second_RBMonkey_BeforSwitch_Choices = nan(numel(RtoB_HumanTransition),BeforeAfter_Length)
Second_RBMonkey_ATSwitch_Choices = nan(numel(RtoB_HumanTransition),1)
Second_RBMonkey_AfterSwitch_Choices = nan(numel(RtoB_HumanTransition),BeforeAfter_Length)
for SW = 1 : numel(RtoB_HumanTransition)
    A = MonkSecond_A_ColorChoiceNumerical_JointRewarded(RtoB_HumanTransition(SW)-BeforeAfter_Length:RtoB_HumanTransition(SW)-1)
    Second_RBMonkey_BeforSwitch_Choices(SW,:) = A;
end
for SW = 1 : numel(RtoB_HumanTransition)
    Second_RBMonkey_ATSwitch_Choices(SW) = MonkSecond_A_ColorChoiceNumerical_JointRewarded(RtoB_HumanTransition(SW));
end
for SW = 1 : numel(RtoB_HumanTransition)
    A = MonkSecond_A_ColorChoiceNumerical_JointRewarded(RtoB_HumanTransition(SW)+1:RtoB_HumanTransition(SW)+BeforeAfter_Length)
    Second_RBMonkey_AfterSwitch_Choices(SW,:) = A;
end
%%
Second_RBMonkey_ALL_Choices = [Second_RBMonkey_BeforSwitch_Choices,Second_RBMonkey_ATSwitch_Choices,Second_RBMonkey_AfterSwitch_Choices];
% Calculate the average vertically:
Second_averageOwn_RBMonkey_BeforSwitch = mean(Second_RBMonkey_BeforSwitch_Choices, 1,'omitnan');
Second_averageOwn_RBMonkey_AfterSwitch = mean(Second_RBMonkey_AfterSwitch_Choices, 1,'omitnan');
Second_averageOwn_RBMonkey_AtSwitch = mean(Second_RBMonkey_ATSwitch_Choices, 1,'omitnan');
Second_averageOwn_RBMonkey = [Second_averageOwn_RBMonkey_BeforSwitch Second_averageOwn_RBMonkey_AtSwitch Second_averageOwn_RBMonkey_AfterSwitch]
% plot the average:
subplot(3,2,6)
plot(1:(2*BeforeAfter_Length)+1,Second_averageOwn_RBMonkey,'+-r','LineWidth',2)
xline(BeforeAfter_Length+1,'--','Color',[0.5 0.5 0.5])
hold on
plot(1:(2*BeforeAfter_Length)+1,averageOwn_RBMonkeyAll,'.-','Color',[0.5 0.5 0.5 0.3],'LineWidth',4)
plot(1:(2*BeforeAfter_Length)+1,averageOwn_RBHumanAll,'.-','Color',[0 0 1 0.3],'LineWidth',4)
xlim([0 12])
ylim([-0.1 1.1])
xticks([])
pbaspect([1 1 1])
title('transition: RB')
subtitle(strcat('number of trials: ',string(sum(sum(~isnan(Second_RBMonkey_ALL_Choices))))))
fig3 = gcf
%%
% saving the plots
% fig1.Renderer = 'Painters';  % Set the renderer to painters for vector graphics
% fig2.Renderer = 'Painters';  % Set the renderer to painters for vector graphics
% fig3.Rendered = 'Painters';
% Specify the date of the session
% Specify the file name and save as SVG
file1_name = strcat(SESSIONDATE,'_HBR.jpg');
file2_name = strcat(SESSIONDATE,'_HRB.jpg');
file3_name = strcat(SESSIONDATE,'_TIMING.jpg');

saveas(fig1, file1_name, 'jpg');
saveas(fig2, file2_name, 'jpg');
saveas(fig3, file2_name, 'jpg');
clearvars -except report_struct_list SessSolo
close all
end