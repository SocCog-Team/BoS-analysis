% cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes\Simulations related to VBA fitting'
%%
clear
clc



%%
% cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes\VBA_AllFunctions'


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

% fitting binary data
options.sources.type = 1; %Sahra: by default VBA assumes that data is continious, otherwise you have to specify data type by this line of code
% sources.type = 1 means data is binary under binomial assumption, for
% multinomial variables, for example if we have 4 type of colours, put this
% option as 2, but here in this data we have binomia, 1 = prefered colour 0
% = antiprefered colour


% Normally, the expected first observation is g(x1), ie. after
% a first iteratition x1 = f(x0, u0). The skipf flag will prevent this evolution
% and thus set x1 = x0
% By default, options.skipf is a zero-valued matrix, whose length is the number of time samples.
% Setting any of its value to one effectively asks VBA to replace the corresponding states transition by the identity mapping.
% invert model

% Sahra: now we defined all needed inputs for the main function that
% applies
% VBA,
%namely VBA_NLStateSpaceModel.m, It works as follows:
%[posterior,out] = VBA_NLStateSpaceModel(y,u,f_fname,g_fname,dim,options)


%inputs
%%

%history of theaborted trials????
transformChoiceToFeedback = @(x) (x == 1) + 1; %0 maps to 1, and 1 maps to 2


%%
DeltaTime = 10:10:300;
RewardMat = [1,2];
nTrials = 100
FixedHighProb_AfterLearning = 0.5:0.1:1;
Contingency = repelem(max(RewardMat),1,nTrials)

SubjectChoice = nan(numel(DeltaTime),nTrials,numel(FixedHighProb_AfterLearning));

for LearningLevel = 1 % : numel(FixedHighProb_AfterLearning)
    ChoiceProb = 0.9; % FixedHighProb_AfterLearning(LearningLevel);

    for DELTAt = 1 % : numel(DeltaTime)
        DELTATIME = 50;
        % AccumulativeChoice = nTrials-DELTATIME;
        % ChoiceProb =(AccumulativeChoice/nTrials)/2; %with this logic, a fast
        % learner, also is a good learner and a slow learner, is not a good
        % learner, as subjects learn value 2 exists, at the same time still
        % randomness in his choices are high
        
        A = nan(1,nTrials);
        A(1:DELTATIME) = binornd(1,0.5,[1,DELTATIME]);
        A(DELTATIME+1:end) = binornd(1,ChoiceProb,[1,nTrials-DELTATIME]);
        SubjectChoice(DELTAt,:,LearningLevel) = A;
    end
end
n_t = nTrials;
options.skipf = [1 zeros(1,n_t-1)];
PHI_DeltaT = nan(numel(FixedHighProb_AfterLearning),numel(DELTATIME));
Theta_DeltaT = nan(numel(FixedHighProb_AfterLearning),numel(DELTATIME));

for LearningLevel = 1 %: numel(FixedHighProb_AfterLearning)
    for T = 1 %: numel(DeltaTime)
        close all
        choices = SubjectChoice(T,:,LearningLevel);
        feedbacks = arrayfun(transformChoiceToFeedback, choices);
        y = choices;
        PrevChoice = [nan,choices(1:end-1)];
        PrevFeedback = [nan,feedbacks(1:end-1)];
        u = [PrevChoice;PrevFeedback];
        [posterior,out] = VBA_NLStateSpaceModel(y, u, f_fname, g_fname, dim, options);
        PHI_DeltaT(LearningLevel,T) = exp(posterior.muPhi);
        Theta_DeltaT(LearningLevel,T) = VBA_sigmoid(posterior.muTheta);
        R2VAL(LearningLevel,T) = out.fit.R2
        display(LearningLevel)
    end
end
PHI_DeltaT
Theta_DeltaT


%% save variables and figures
% cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes\Simulations related to VBA fitting'

%% Theta figure
figure('Position',[81.80000000000001,91.4,975.2,682.4000000000001])
for LearningLevel = 1 : numel(FixedHighProb_AfterLearning)
    subplot(2,3,LearningLevel)
    for T = 1 : numel(DeltaTime)
        scatter(DeltaTime(T),Theta_DeltaT(LearningLevel,T),(R2VAL(LearningLevel,T)+1)*30,[153 0 153]./255,'filled','MarkerFaceAlpha',R2VAL(LearningLevel,T),'MarkerEdgeColor','flat')
        ylim([0 0.6])
        hold on
    end
    title(sprintf('learning level =  %.1f\n',FixedHighProb_AfterLearning(LearningLevel)))
end
sgtitle('learning rate fitted by VBA')
xlabel('time of learning, number of trials')
ylabel('fitted value')
%% R2 distribution as a function of learning speed
figure('Position',[81.80000000000001,91.4,975.2,682.4000000000001])
for LearningLevel = 1 : numel(FixedHighProb_AfterLearning)
    subplot(2,3,LearningLevel)
    for T = 1 : numel(DeltaTime)
        scatter(DeltaTime(T),R2VAL(LearningLevel,T),50,'k','filled')
        ylim([0 1])
        hold on
    end
        title(sprintf('learning level =  %.1f\n',FixedHighProb_AfterLearning(LearningLevel)))

end
sgtitle('R2 from VBA')
xlabel('time of learning, number of trials')
ylabel('R2 value')
%% Phi figure
figure('Position',[81.80000000000001,91.4,975.2,682.4000000000001])
for LearningLevel = 1 : numel(FixedHighProb_AfterLearning)
    subplot(2,3,LearningLevel)
    for T = 1 : numel(DeltaTime)
        scatter(DeltaTime(T),PHI_DeltaT(LearningLevel,T),(R2VAL(LearningLevel,T)+1)*30,[76 0 153]./255,'filled','MarkerFaceAlpha',R2VAL(LearningLevel,T),'MarkerEdgeColor','flat')
        hold on
        ylim([0 6])
    end
    title(sprintf('learning level = %.1f\n',FixedHighProb_AfterLearning(LearningLevel)))

end
xlabel('time of learning, number of trials')
ylabel('fitted value')
sgtitle('learning rate fitted by VBA')

cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes'