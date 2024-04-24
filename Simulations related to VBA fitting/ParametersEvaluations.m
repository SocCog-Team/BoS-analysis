cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes\Simulations related to VBA fitting'
%%
clear
clc
nTrials = 450;


% RewardRate = ((sum(reward))/DeltaTime)/max(RewardMat)
% DeltaTime = (sum(reward) / ((RewardRate)*max(RewardMat))   sum(reward) is
% the same AccumulativeReward

%RewardProb = (sum(reward))/DeltaTime
%By reward prob, I create reward vector ( vector that subject recives
%reward upon his choices) and then I convert reward vector to choice
%vector: 1 from reward vector is o in choice vector, 2 in reward vector is
%1 in choice vector

%RewardRate = 1 % becareful that minimum reward rate is o.5 and max is 1 because worst subject always selects 1 from RewardMat and best subjects
%always selects 2 from RewardMat, subjects with different delta times to
%reach rewarerate = 1 have different learning rates at the end

%%
cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes\VBA_AllFunctions'

RandomnessInChoice = 0:0.1:1;
WorstSubject = zeros(1,nTrials);
BestSubject = ones(1,nTrials);
%%

%%
choices = WorstSubject; % choice vector of Agent A or B,  1 = preferred colour  0 = non prefered colour,
    % 1
    %history of theaborted trials????
transformChoiceToFeedback = @(x) (x == 1) + 1; %0 maps to 1, and 1 maps to 2
feedbacks = arrayfun(transformChoiceToFeedback, choices);
    if size(choices,1) > 1
        choices = choices';
    end
    if size(feedbacks,1) > 1
        feedbacks = feedbacks';
    end
    PrevChoice = [nan,choices(1:end-1)];
    PrevFeedback = [nan,feedbacks(1:end-1)];

    %inputs
    y = choices; % vector of the choices should contains information about actor's choice and simultaneously
    % his partner choice, Igor suggested to have choice vector the same as
    % reward vector: 4 means when actor chose his own AND partner followed
    % 3 means anti prefered by actor but followed the partner
    % 2 means actor chose prefered but not followed by the partner
    %1 means actor chose anti prefered and not followed by the partner

    %important thing about choice vector is that



    % important thing about reward vector is that rewards value should be between 0 and 1 so reward
    % vector is devided by 4 ti rescale it between 0 and 1
    u = [PrevChoice;PrevFeedback];

    %specify model:

    f_fname = @f_Qlearning; % evolution function (Q-learning)
    g_fname = @g_QLearning; % observation function (softmax mapping)

    % provide dimensions:

    % n : number of hidden states,
    %Sahra: we want to look at the effect of history of choice (only previous
    %choice) on current choice through RL. Because sequence of choices is
    %current-1 and current trials, number of hidden states is 2

    %Sahra: What are hidden states in our data?
    %Hidden state in Q-learning is the value that each action bears in Agent's
    %mind. In our data, this value can be approximated from reward value,
    %pevious action consequence upon the model that consider learning rate and
    %volatility in behavior due to random noise

    NumHiddenStates = 2;
    dim = struct('n',NumHiddenStates,'n_theta',1,'n_phi',1), %theta is the evolution parameter, the same alpha or learning rate
    %phi is obsrevation parameter,
    %the same tau or inverse
    %tempreture

    % defining priors: not defining priors mean toolbox uses the default
    % priors,priors structure is filled in with defaults (typically, i.i.d. zero-mean and unit-variance Gaussian densities

    %here we left all priors to be default except for initial state:
    options.priors.muX0 = (repelem(.5,NumHiddenStates))';  %Sahra: why this contains two 0.5?  % prior mean on x0 (obs params)
    options.priors.SigmaX0 = 0.1 * eye(NumHiddenStates);    % prior covariance on x0 (obs params)


    % here define options for the simulation:
    % number of trials
    n_t = numel(choices);

    % fitting binary data
    options.sources.type = 1; %Sahra: by default VBA assumes that data is continious, otherwise you have to specify data type by this line of code
    % sources.type = 1 means data is binary under binomial assumption, for
    % multinomial variables, for example if we have 4 type of colours, put this
    % option as 2, but here in this data we have binomia, 1 = prefered colour 0
    % = antiprefered colour


    % Normally, the expected first observation is g(x1), ie. after
    % a first iteratition x1 = f(x0, u0). The skipf flag will prevent this evolution
    % and thus set x1 = x0
    options.skipf = [1 zeros(1,n_t-1)]; %sahra: it means that initial condition is a identity map of time stamp,
    % By default, options.skipf is a zero-valued matrix, whose length is the number of time samples.
    % Setting any of its value to one effectively asks VBA to replace the corresponding states transition by the identity mapping.
    % invert model

    % Sahra: now we defined all needed inputs for the main function that
    % applies
    % VBA,
    %namely VBA_NLStateSpaceModel.m, It works as follows:
    %[posterior,out] = VBA_NLStateSpaceModel(y,u,f_fname,g_fname,dim,options)

    [posterior] = VBA_NLStateSpaceModel(y, u, f_fname, g_fname, dim, options);
    PHI_WorstSubj = exp(posterior.muPhi);
    THETA_WorstSubj = VBA_sigmoid(posterior.muTheta);
%% BestSubject:
    choices = BestSubject;
    feedbacks = arrayfun(transformChoiceToFeedback, choices);
    y = choices;
    PrevChoice = [nan,choices(1:end-1)];
    PrevFeedback = [nan,feedbacks(1:end-1)];
    u = [PrevChoice;PrevFeedback];
    [posterior] = VBA_NLStateSpaceModel(y, u, f_fname, g_fname, dim, options);
    PHI_BestSubj = exp(posterior.muPhi);
    THETA_BestSubj = VBA_sigmoid(posterior.muTheta);
    %inputs
    %%
SampleSize = 100;
PHI_RandomSubj = nan(1,SampleSize);
THETA_RandomSubj = nan(1,SampleSize);
% simulation for random suject
for SAMPLE = 1 : SampleSize
    close all
    RandomSubject = binornd(1,0.5,[1,nTrials]);
    choices = RandomSubject; % choice vector of Agent A or B,  1 = preferred colour  0 = non prefered colour,
    % 1
    %history of theaborted trials????
    transformChoiceToFeedback = @(x) (x == 1) + 1; %0 maps to 1, and 1 maps to 2
    feedbacks = arrayfun(transformChoiceToFeedback, choices);
    if size(choices,1) > 1
        choices = choices';
    end
    if size(feedbacks,1) > 1
        feedbacks = feedbacks';
    end
    PrevChoice = [nan,choices(1:end-1)];
    PrevFeedback = [nan,feedbacks(1:end-1)];

    %inputs
    y = choices; % vector of the choices should contains information about actor's choice and simultaneously
    % his partner choice, Igor suggested to have choice vector the same as
    % reward vector: 4 means when actor chose his own AND partner followed
    % 3 means anti prefered by actor but followed the partner
    % 2 means actor chose prefered but not followed by the partner
    %1 means actor chose anti prefered and not followed by the partner

    %important thing about choice vector is that



    % important thing about reward vector is that rewards value should be between 0 and 1 so reward
    % vector is devided by 4 ti rescale it between 0 and 1
    u = [PrevChoice;PrevFeedback];

    %specify model:

    f_fname = @f_Qlearning; % evolution function (Q-learning)
    g_fname = @g_QLearning; % observation function (softmax mapping)

    % provide dimensions:

    % n : number of hidden states,
    %Sahra: we want to look at the effect of history of choice (only previous
    %choice) on current choice through RL. Because sequence of choices is
    %current-1 and current trials, number of hidden states is 2

    %Sahra: What are hidden states in our data?
    %Hidden state in Q-learning is the value that each action bears in Agent's
    %mind. In our data, this value can be approximated from reward value,
    %pevious action consequence upon the model that consider learning rate and
    %volatility in behavior due to random noise

    NumHiddenStates = 2;
    dim = struct('n',NumHiddenStates,'n_theta',1,'n_phi',1), %theta is the evolution parameter, the same alpha or learning rate
    %phi is obsrevation parameter,
    %the same tau or inverse
    %tempreture

    % defining priors: not defining priors mean toolbox uses the default
    % priors,priors structure is filled in with defaults (typically, i.i.d. zero-mean and unit-variance Gaussian densities

    %here we left all priors to be default except for initial state:
    options.priors.muX0 = (repelem(.5,NumHiddenStates))';  %Sahra: why this contains two 0.5?  % prior mean on x0 (obs params)
    options.priors.SigmaX0 = 0.1 * eye(NumHiddenStates);    % prior covariance on x0 (obs params)


    % here define options for the simulation:
    % number of trials
    n_t = numel(choices);

    % fitting binary data
    options.sources.type = 1; %Sahra: by default VBA assumes that data is continious, otherwise you have to specify data type by this line of code
    % sources.type = 1 means data is binary under binomial assumption, for
    % multinomial variables, for example if we have 4 type of colours, put this
    % option as 2, but here in this data we have binomia, 1 = prefered colour 0
    % = antiprefered colour


    % Normally, the expected first observation is g(x1), ie. after
    % a first iteratition x1 = f(x0, u0). The skipf flag will prevent this evolution
    % and thus set x1 = x0
    options.skipf = [1 zeros(1,n_t-1)]; %sahra: it means that initial condition is a identity map of time stamp,
    % By default, options.skipf is a zero-valued matrix, whose length is the number of time samples.
    % Setting any of its value to one effectively asks VBA to replace the corresponding states transition by the identity mapping.
    % invert model

    % Sahra: now we defined all needed inputs for the main function that
    % applies
    % VBA,
    %namely VBA_NLStateSpaceModel.m, It works as follows:
    %[posterior,out] = VBA_NLStateSpaceModel(y,u,f_fname,g_fname,dim,options)

    [posterior] = VBA_NLStateSpaceModel(y, u, f_fname, g_fname, dim, options);

    PHI_RandomSubj(1,SAMPLE) = exp(posterior.muPhi);
    THETA_RandomSubj(1,SAMPLE) = VBA_sigmoid(posterior.muTheta);
    display(SAMPLE)
end
figure,
scatter(0,THETA_BestSubj,'green','filled')
hold on
scatter(0,THETA_WorstSubj,'red','filled')
scatter(1:SampleSize,THETA_RandomSubj,'filled')
xlabel('sample number')
ylabel('\theta parameetr value')
legend('Optimal subject','worst subject','random subject')
%%
figure,
scatter(0,PHI_BestSubj,'green','filled')
hold on
scatter(0,PHI_WorstSubj,'red','filled')
scatter(1:SampleSize,PHI_RandomSubj,'filled')
xlabel('sample number')
ylabel('\phi parameter value')
legend('Optimal subject','worst subject','random subject')

%%
DeltaTime = 10:10:300;
RewardMat = [1,2];
nTrials = 450
SubjectChoice = nan(numel(DeltaTime),nTrials);
FixedHighProb_AfterLearning = 0.9

for DELTAt = 1 : numel(DeltaTime)
    DELTATIME = DeltaTime(DELTAt)
    % AccumulativeChoice = nTrials-DELTATIME;
    % ChoiceProb =(AccumulativeChoice/nTrials)/2; %with this logic, a fast
    % learner, also is a good learner and a slow learner, is not a good
    % learner, as subjects learn value 2 exists, at the same time still
    % randomness in his choices are high

    ChoiceProb = FixedHighProb_AfterLearning;
    A = nan(1,nTrials);
    A(1:DELTATIME) = binornd(1,0.5,[1,DELTATIME]);
    A(DELTATIME+1:end) = binornd(1,ChoiceProb,[1,nTrials-DELTATIME]);
    SubjectChoice(DELTAt,:) = A;
end
n_t = nTrials;
options.skipf = [1 zeros(1,n_t-1)];
PHI_DeltaT = nan(1,numel(DELTATIME));
Theta_DeltaT = nan(1,numel(DELTATIME));

for T = 1 : numel(DeltaTime)
    close all
    choices = SubjectChoice(T,:);
    feedbacks = arrayfun(transformChoiceToFeedback, choices);
    y = choices;
    PrevChoice = [nan,choices(1:end-1)];
    PrevFeedback = [nan,feedbacks(1:end-1)];
    u = [PrevChoice;PrevFeedback];
    [posterior] = VBA_NLStateSpaceModel(y, u, f_fname, g_fname, dim, options);
    PHI_DeltaT(T) = exp(posterior.muPhi);
    Theta_DeltaT(T) = VBA_sigmoid(posterior.muTheta);
    display(T)
end
figure,
scatter(DeltaTime,Theta_DeltaT,'filled')
xlabel('\Delta time needed to adopt maximum reward, (in number of trial)')
ylabel('\Theta parameter value')
figure,
scatter(DeltaTime,PHI_DeltaT,'filled')
xlabel('\Delta time needed to adopt maximum reward, (in number of trial)')
ylabel('\Phi parameter value')
figure(2)
title('number of trials is 450!')
figure(3)
title('number of trials is 450!')
%% subject with sigmoid learning pattern: probability of choice,
%comes from a logistic distribution, for comparision between subjects
%we keep the sigma fixed among subjects but mu (time of learning) differ

MU = nTrials/2
SIGMA = nTrials/4

for M = 1 : numel(MU)
    ProbCenter = MU(M)
    % AccumulativeChoice = nTrials-DELTATIME;
    % ChoiceProb =(AccumulativeChoice/nTrials)/2; %with this logic, a fast
    % learner, also is a good learner and a slow learner, is not a good
    % learner, as subjects learn value 2 exists, at the same time still
    % randomness in his choices are high
    R = random('Logistic',ProbCenter,SIGMA)
    SigmoidChoiceProb = pdf("Logistic",R,ProbCenter,SIGMA);
    A = nan(1,nTrials);
    A(1:ProbCenter) = binornd(1,0.5,[1,ProbCenter]);
    A(ProbCenter+1:end) = binornd(1,SigmoidChoiceProb,[1,nTrials-ProbCenter]);
    SigmoidSubjectChoice(M,:) = A;
end
%% save variables and figures
cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes\Simulations related to VBA fitting'

save('PHI_RandomSubj','PHI_RandomSubj')
save('THETA_RandomSubj','THETA_RandomSubj')

save('PHI_DeltaT','PHI_DeltaT')
save('Theta_DeltaT','Theta_DeltaT')

%sanity check
figure
tiledlayout('flow')
for SubjNum = 1 : numel(DeltaTime)
    nexttile
    scatter(1:nTrials,SubjectChoice(SubjNum,:),'|')
    yticks([0 1])
    title(sprintf('DeltaT = %d trials',DeltaTime(SubjNum)))
end
    yticklabels({'choice for value 1','choice for value 2'})

figure
tiledlayout('flow')
for SubjNum = 1 : numel(MU)
    nexttile
    scatter(1:nTrials,SigmoidSubjectChoice(SubjNum,:),'|')
    yticks([0 1])
    title(sprintf('DeltaT = %d trials',DeltaTime(SubjNum)))
end
    yticklabels({'choice for value 1','choice for value 2'})