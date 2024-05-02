clear
clc
%%

SamplingNumber = 500;

R2VAL = nan(1,SamplingNumber);

parfor SampleNum = 1 : SamplingNumber
    options = struct();
    f_fname = @f_Qlearning; % evolution function (Q-learning)
    g_fname = @g_QLearning; % observation function (softmax mapping)

    % Create the feedback rule for the simulation
    % =========================================================================

    % define which action should be rewarded at each trial (contingencies)
    % -------------------------------------------------------------------------
    % probability of a positive reward following a 'correct' action
    probRewardGood = 100/100;
    % draw 25 random feedbacks
    contBloc = +(rand(1,450) < probRewardGood);
    % create 6 blocs with reversals
    contingencies = [contBloc] ;

    % create feedback structure for the simulation with VBA
    % -------------------------------------------------------------------------
    % feedback function. Return 1 if action follow contingencies.
    h_feedback = @(yt,t,in) +(yt == contingencies(t));
    % feedback structure for the VBA
    fb = struct( ...
        'h_fname', h_feedback, ... % feedback function
        'indy', 1, ... % where to store simulated choice
        'indfb', 2, ... % where to store simulated feedback
        'inH', struct() ...
        );

    % Simulate choices for the given feedback rule
    % =========================================================================

    % define parameteters of the simulated agent
    % -------------------------------------------------------------------------
    % learning rate
    theta = VBA_sigmoid(0.65,'inverse',true); % 0.65, once sigm transformed
    % inverse temperature
    phi = log(2.5); % will be exp transformed
    % initial state
    x0 = [.5; .5];

    % options for the simulation
    % -------------------------------------------------------------------------
    % number of trials
    n_t = numel(contingencies);
    % fitting binary data
    options.sources.type = 1;
    % Normally, the expected first observation (choice) is g(x1), ie. after
    % a first iteratition x1 = f(x0). The skipf flag will prevent this evolution
    % and thus set x1 = x0
    options.skipf = [1 zeros(1,n_t)];

    % simulate choices
    % -------------------------------------------------------------------------
    [y,x,x0,eta,e,u] = VBA_simulate ( ...
        n_t+1, ... number of trials
        f_fname, ... evolution function
        g_fname, ... observation function
        theta, ... evolution parameters (learning rate)
        phi, ... observation parameters,
        nan(2,n_t), ... dummy inputs
        Inf, Inf, ... deterministic evolution and observation
        options, ... options
        x0, ... initial state
        fb ... feedback rule
        );

    % plot simulated choices
    % -------------------------------------------------------------------------
    % =========================================================================
    choices = u(1,2:end);
    feedbacks = u(2,2:end);

    [posterior, out]=demo_Qlearning(choices, feedbacks);
    close all
    R2VAL(SampleNum) = out.fit.R2
    disp(SampleNum)
end

MeanPoint = mean(R2VAL)*100;
UpperBound = prctile(R2VAL, 2.5)*100;
LowerBound = prctile(R2VAL, 97.5)*100;
figure,
plot(1:SamplingNumber,repelem(MeanPoint,1,SamplingNumber),'b')
hold on
plot(1:SamplingNumber,repelem(UpperBound,1,SamplingNumber),'r')
plot(1:SamplingNumber,repelem(LowerBound,1,SamplingNumber),'r')

x_values = 1:SamplingNumber; % Example range

% Create y values (you can set them to any constant values, like the bounds)
y_lower = LowerBound * ones(size(x_values));
y_upper = UpperBound * ones(size(x_values));

% Plot the shaded area
fill([x_values, fliplr(x_values)], [y_lower, fliplr(y_upper)], 'm', 'FaceAlpha', 0.3, 'EdgeAlpha', 0);
%%
ylabel('R2%')
xlabel('Sampling number')
