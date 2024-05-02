function RampingLearningSimulatedSubjects()

%inputs
%%

%history of theaborted trials????

% transformChoiceToFeedback = @(x) (x == 1) + 1; %0 maps to 1, and 1 maps to 2
FeedbackFunction = @(choices,contingencies) +(choices == (contingencies./2));
% FeedbackFunction = @(x) (x == 1) + 1; %0 maps to 1, and 1 maps to 2
%%
RewardMat = [1,2];
nTrials = 450;

%% Simulating subjects with same ramping rate (0.1) but different learning time

InitialAddedUpRamping = 0.1; %subject improves by adding this probability to high reward probbaility at each step of learning time (DeltaTime)
MaxRampNum = (1-0.5)/InitialAddedUpRamping;
InitialDeltaTime = 10;

Contingency = repelem(max(RewardMat),1,nTrials);
% Contingency = randi(max(RewardMat),1,nTrials)


MaxLearningLoop = (floor((nTrials/6)/10))*10;
DELTATIME_Range = InitialDeltaTime: 10: MaxLearningLoop;
SubjectChoice = nan(numel(DELTATIME_Range),nTrials);

for DT = 1 : numel(DELTATIME_Range)
    DELTATIME = DELTATIME_Range(DT);

    A = [];
    B = [];
    AddedUpRamping = InitialAddedUpRamping;
    A(1:DELTATIME) = binornd(1,0.5,[1,DELTATIME]);

    for RAMP = 1 : MaxRampNum
        B = []
        B = binornd(1,0.5+AddedUpRamping,[1,DELTATIME]);
        A = [A,B];
        AddedUpRamping = AddedUpRamping+InitialAddedUpRamping
    end
    A = [A,ones(1,nTrials-numel(A))]; %after fully learning, subject always choose the best option
    SubjectChoice(DT,:) = A;

end

%% sanity check
figure
subplot(1,2,1)
scatter(1:nTrials,SubjectChoice(1,:),'|b')
hold on
scatter(1:nTrials,SubjectChoice(end,:),'|r')
xlabel('trial number')
ylabel('choice')
yticks([0 1])
subplot(1,2,2)
plot(smooth(SubjectChoice(1,:),50),'b')
hold on
plot(smooth(SubjectChoice(end,:),50),'r')
legend('learning time: after 10 trials','learning time: after 70 trials')
title("subject's choice, smoothed over 50 data points window")
xlabel('trial number')
ylabel('choice')
sgtitle('ramping rate: 0.1')
%% simulating subjects with same learning time but different ramping rate
DELTATIME = 50;
RampingRange = 0.1:0.05:0.5;
for rr = 1: numel(RampingRange)
    AddUp = RampingRange(rr);
    c = 0;
    t = 1;
    ELEMETN = [];
    while c < 1
        ELEMETN(t) = 0.5 + AddUp;
        c = ELEMETN(t)+RampingRange(rr);
        t = t+1;
        AddUp = AddUp+ RampingRange(rr);
    end
    if ELEMETN(end) ~= 1
        ELEMETN(end+1) = 1;
    end
    RampingElements{rr} = ELEMETN;
end


DifferentRamping_SubjectChoice = nan(numel(RampingRange),nTrials);

for RR = 1 : numel(RampingRange)
    A = [];
    B = [];
    AddedUpRamping = RampingElements{RR};
    A(1:DELTATIME) = binornd(1,0.5,[1,DELTATIME]);

    for RAMP = 1 : numel(AddedUpRamping)
        B = [];
        B = binornd(1,AddedUpRamping(RAMP),[1,DELTATIME]);
        A = [A,B];
    end
    A = [A,ones(1,nTrials-numel(A))] %after fully learning, subject always choose the best option
    DifferentRamping_SubjectChoice(RR,:) = A;
end
figure
subplot(1,2,1)
scatter(1:nTrials,DifferentRamping_SubjectChoice(1,:),'|b')
hold on
scatter(1:nTrials,DifferentRamping_SubjectChoice(end,:),'|r')
xlabel('trial number')
ylabel('choice')
yticks([0 1])
subplot(1,2,2)
plot(smooth(DifferentRamping_SubjectChoice(1,:),70),'b')
hold on
plot(smooth(DifferentRamping_SubjectChoice(end,:),70),'r')
xlabel('trial number')
ylabel('choice')
title("subject's choice, smoothed over 50 data points window")
legend('ramping rate = 0.1','ramping rate = 0.3')
sgtitle('learning time: after 50 trials, different ramping rate')


%% fitting for fixed ramping rate but different learning time

PHI_DeltaT = nan(numel(numel(DELTATIME_Range)),1);
Theta_DeltaT = nan(numel(numel(DELTATIME_Range)),1);
R2VAL = nan(1,numel(DELTATIME_Range));

parfor T = 1 : numel(DELTATIME_Range)
    choices = SubjectChoice(T,:);
    feedbacks = arrayfun(FeedbackFunction,choices,Contingency);
    % feedbacks = arrayfun(FeedbackFunction,Contingency);

    [posterior, out]=demo_Qlearning(choices, feedbacks);
    PHI_DeltaT(T) = exp(posterior.muPhi);
    Theta_DeltaT(T) = VBA_sigmoid(posterior.muTheta);
    R2VAL(T) = out.fit.R2;
    disp(T)
end

%% plotting

%% Theta figure
figure
subplot(1,3,1)
for T = 1 : numel(DELTATIME_Range)
    scatter(DELTATIME_Range(T),Theta_DeltaT(T),(R2VAL(T)+1)*30,[153 0 153]./255,'filled','MarkerFaceAlpha',R2VAL(T),'MarkerEdgeColor','flat')
    ylim([0 0.6])
    hold on
end
ylabel('parameter value')
xlabel('learning time in number of trials')
title('fitted learning rate')
subplot(1,3,2)
for T = 1 : numel(DELTATIME_Range)
    scatter(DELTATIME_Range(T),PHI_DeltaT(T),(R2VAL(T)+1)*30,[76 0 153]./255,'filled','MarkerFaceAlpha',R2VAL(T),'MarkerEdgeColor','flat')
    hold on
end
xlabel('learning time in number of trials')
title('fitted behavioral tempreture')
subplot(1,3,3)
for T = 1 : numel(DELTATIME_Range)
    scatter(DELTATIME_Range(T),R2VAL(T),50,'k','filled')
    ylim([0 1])
    hold on
end
xlabel('learning time in number of trials')
title('goodness of fit')
sgtitle('fixed ramping rate: 0.1')

%% fitting for different ramping rate
PHI_DiffRamping = nan(numel(RampingRange),1);
Theta_DiffRamping = nan(numel(RampingRange),1);
R2VAL_DiffRamping = nan(numel(RampingRange),1);


parfor RR = 1 : numel(RampingRange)
    choices = DifferentRamping_SubjectChoice(RR,:);
    feedbacks = arrayfun(FeedbackFunction,choices,Contingency);
    % feedbacks = arrayfun(FeedbackFunction,Contingency);

    [posterior, out]=demo_Qlearning(choices, feedbacks);
    PHI_DiffRamping(RR) = exp(posterior.muPhi);
    Theta_DiffRamping(RR) = VBA_sigmoid(posterior.muTheta);
    R2VAL_DiffRamping(RR) = out.fit.R2;
    disp(RR)
end

%% plotting

%% Theta figure
figure
subplot(1,3,1)
for RR = 1 : numel(RampingRange)
    scatter(RampingRange(RR),Theta_DiffRamping(RR),(R2VAL_DiffRamping(RR)+1)*30,[153 0 153]./255,'filled','MarkerFaceAlpha',R2VAL_DiffRamping(RR),'MarkerEdgeColor','flat')
    ylim([0 0.6])
    hold on
end
ylabel('parameter value')
xlabel('ramping rate')
title('fitted learning rate')
subplot(1,3,2)
for RR = 1 : numel(RampingRange)
    scatter(RampingRange(RR), PHI_DiffRamping(RR),(R2VAL_DiffRamping(RR)+1)*30,[76 0 153]./255,'filled','MarkerFaceAlpha',R2VAL_DiffRamping(RR),'MarkerEdgeColor','flat')
    hold on
end
xlabel('ramping rate')
title('fitted behavioral tempreture')
subplot(1,3,3)
for RR = 1 : numel(RampingRange)
    scatter(RampingRange(RR),R2VAL_DiffRamping(RR),50,'k','filled')
    ylim([0 1])
    hold on
end
xlabel('ramping rate')
title('goodness of fit')
sgtitle('fixed learning time: 50 trials')
