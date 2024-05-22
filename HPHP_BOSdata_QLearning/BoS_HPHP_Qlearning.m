% here imoprt the data:
close all, clear, clc
%%
cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes\HPHP_BOSdata_QLearning\HP-NHP\HumansTransparentData'
%run('HPHP_fullPath.m');


InsideFold = dir;
AllDataName = {InsideFold.name}
str = AllDataName;
num = regexp(str, '\d+', 'match');
emptyCells = cellfun('isempty', num);
AllDataName = str(~emptyCells);
CHOICES = cell(1,numel(AllDataName))
FEEDBACKS = cell(1,numel(AllDataName))

for SubjNum = 1 : numel(AllDataName)
    load(AllDataName{SubjNum})
    %% extract needed vectors

    RewardedANDdyadicTrialId = intersect(TrialSets.All(logical(FullPerTrialStruct. ...
        TrialIsRewarded)),TrialSets.All(logical(FullPerTrialStruct. ...
        TrialIsJoint)));
    % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)

    A_ColorChoice = isOwnChoiceArray(1,:); %own colour = 1
    B_ColorChoice = isOwnChoiceArray(2,:); %own colour = 1

    % Here we define filters for Player AND his patner.
    % The aim of this filtering is to create vectors of choices that not only
    % contains
    %information about Actor's decision but also the joint action with his
    %partner

    % Actors = ["A","B"];
    % N = 1
    % Actor = Actors(N);
    % Partner = setdiff(Actors,Actor);
    % ActorChoiceVector = eval(sprintf('%c_ColorChoice',Actor));
    % PartnerChoiceVector = eval(sprintf('%c_ColorChoice',Partner));
    %
    % ActorPrefered_PartnerAnti = (ActorChoiceVector) & (~PartnerChoiceVector);
    % ActorAnti_PartnerPrefered = (~ActorChoiceVector) & (PartnerChoiceVector);
    % ActorPrefered_PartnerPrefered = (ActorChoiceVector) & (PartnerChoiceVector);
    % ActorAnti_PartnerAnti = (~ActorChoiceVector) & (~PartnerChoiceVector);


    A_RewadVals_RewardedDyadic = FullPerTrialStruct.RewardByTrial_A(RewardedANDdyadicTrialId)
    %sanity check: unique(A_RewadVals_RewardedDyadic)
    B_RewadVals_RewardedDyadic = FullPerTrialStruct.RewardByTrial_B(RewardedANDdyadicTrialId)

       %------------------------------------------------------------------------
    %observations:
    % here define the choice vector
    choices = A_ColorChoice; % choice vector of Agent A or B,  1 = preferred colour  0 = non prefered colour,
    % 1
    %history of theaborted trials????
    feedbacks = A_RewadVals_RewardedDyadic;% reward value vector for each Agent from pay off matrix???
    if size(choices,1) > 1
        choices = choices';
    end
    if size(feedbacks,1) > 1
        feedbacks = feedbacks';
    end
    % PrevChoice = [nan,choices(1:end)];
    % PrevFeedback = [nan,feedbacks(1:end)];
    CHOICES{SubjNum} = choices;
    FEEDBACKS{SubjNum} = feedbacks;
end

PHI = nan(1,numel(AllDataName))
THETA = nan(1,numel(AllDataName))
R2VAL = nan(1,numel(AllDataName))
Perf = nan(1,numel(AllDataName))

cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes\VBA_AllFunctions'

parfor SubjNum = 1 : numel(AllDataName)
        choices = CHOICES{SubjNum};
        feedbacks = FEEDBACKS{SubjNum};
    [posterior, out]=demo_Qlearning(choices, feedbacks)

    PHI(SubjNum) = exp(posterior.muPhi)
    THETA(SubjNum) = VBA_sigmoid(posterior.muTheta)
    R2VAL(SubjNum) = out.fit.R2
    Perf(SubjNum) = mean(choices)
end

SubjAXis = 1:SubjNum
figure
subplot(3,2,1)
scatter(1:SubjNum,PHI,'b')
hold on
scatter(SubjAXis(R2VAL>0),PHI(R2VAL>0),'filled')
xlabel('subject number')
ylabel('inverse behavioral temprature')

subplot(3,2,2)
scatter(1:SubjNum,THETA)
hold on
scatter(SubjAXis(R2VAL>0),THETA(R2VAL>0),'filled')
xlabel('subject number')
ylabel('learning rate')

subplot(3,2,3)
scatter(1:SubjNum,R2VAL)
hold on
scatter(SubjAXis(R2VAL>0),R2VAL(R2VAL>0),'filled')

xlabel('subject number')
ylabel('R2')

subplot(3,2,4)
scatter(1:SubjNum,Perf.*100)
hold on
A = Perf.*100
scatter(SubjAXis(R2VAL>0),A(R2VAL>0),'filled')

xlabel('subject number')
ylabel('performance: percent of higher reward')

subplot(3,2,5)
scatter(THETA,Perf.*100)
hold on
scatter(THETA(R2VAL>0),A(R2VAL>0),'filled')
xlabel('learning rate')
ylabel('performance: percent of higher reward')

subplot(3,2,6)
scatter(THETA,PHI)
hold on
scatter(THETA(R2VAL>0),PHI(R2VAL>0),'filled')
xlabel('learning rate')
ylabel('inverse behavioral temprature')