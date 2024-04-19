close all, clear, clc
%% Simulating subjects:
% In coordination game, because reward vector is dependent to both
% acotr's and opponent's action, we can not simulate actor and opponent
%independently, so first we create a reward vector wherein:
%1) players are fast learners and after 70 trials learn to coordinate
%2) players are slow learner and aftter 140 trials start to coordinate

% what is probability of maximum reward? Arbitrarily we can define that as
% to be 8/10 it means probabilioty of appearing 3 is 4/10, 4 is 4/10 and prob of
%apearing 1 is 1/10, 2 is 1/10
TrialNum = 450
MaximizingAfter = 300;
OpponentRewardVector = nan(1,TrialNum);
FirsPartOpponentRewardVector(1:MaximizingAfter) = randi([1,4],[1 MaximizingAfter]); %first 70 trials are random playing

ProbabilityOfMaxRerward = 0.9  %probability of having 3 or 4
SecondPartOpponentRewardVector = nan(1,TrialNum-MaximizingAfter)
Filter = logical(binornd(1,ProbabilityOfMaxRerward,[1,numel(SecondPartOpponentRewardVector)]))
SecondPartOpponentRewardVector(Filter) = randi([3,4],1,numel(SecondPartOpponentRewardVector(Filter)))
SecondPartOpponentRewardVector(isnan(SecondPartOpponentRewardVector)) = randi([1,2],1,numel(SecondPartOpponentRewardVector(isnan(SecondPartOpponentRewardVector))))

OpponentRewardVector = [FirsPartOpponentRewardVector,SecondPartOpponentRewardVector]
figure,
scatter(1:TrialNum,OpponentRewardVector,'|')
title('opponent"s reward profile')
yticks([1:4])
%% Convert reward vector to choice vector for the opponent: non prefered colour (1 or 3 would be 0)
% mapping_functionOpponent = @(x) ~(x == 3 || x == 1);
% OpponentChoices = double(arrayfun(mapping_functionOpponent, OpponentRewardVector));
% 
% mapping_functionSubject = @(x) ~(x == 4 || x == 1);
% SubjectChoices = double(arrayfun(mapping_functionSubject, OpponentRewardVector));

% Define the conversion function
conversion_function = @(x) (x == 3) * 4 + (x == 4) * 3 + (x == 1 | x == 2) * x;

% Apply the conversion function to the original vector using arrayfun
SubjectRewardVector = arrayfun(conversion_function, OpponentRewardVector);


%
cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes\VBA_AllFunctions'

K = 0; % depth of k-ToM's recursive beliefs
% payoffTable = cat(3,[1,0;0,1],[0,1;1,0]); % game payoff matrix (here: hide-and-seek)
payoffTable = nan(2,2,2);
payoffTable(:,:,1) = [1,2;3,4];
payoffTable(:,:,2) = [1,2;4,3];
role = 1;  % subject's 'role' (here: 1=seeker, 2=hider)
%last number could be either 0 or 1, 1 means partial forgetting:
%- diluteP: flag for partial "forgetting" effect on opponent's level (0:
%   no forgetting, 1: partial forgetting)
[options,dim] = prepare_kToM(K,payoffTable,role,0);
% Sahra: the agent may partially
% "forget" about her opponent's sophistication level from a trial to the
% next. This effectively dilutes the belief P(k') towards the corresponding
% max-entropic distribution (only if inF.diluteP=1).
% run inversion
f_fname = @f_kToM; % k-ToM model evolution function
g_fname = @g_kToM; % k-ToM model observation function
% y = SubjectChoices; % sequence of choice data 
y = SubjectRewardVector;

u = [zeros(2,1),[OpponentRewardVector(1:end-1);SubjectRewardVector(1:end-1)]]; % sequence of players' actions (at the previous trial)
options.skipf = [1,zeros(1,size(y,2)-1)];  % skip 1st trial (no learning until trial #2)
% options.binomial = 1; % inform VBA about binomial data
% options.sources.type = 1
[posterior,out] = VBA_NLStateSpaceModel(y,u,f_fname,g_fname,dim,options)

hf = unwrapKTOM(posterior.muX,options.inG);

displayResults(posterior,out,y,posterior.muX(:,:),posterior.muX0,posterior.muTheta,posterior.muPhi,[],[])





