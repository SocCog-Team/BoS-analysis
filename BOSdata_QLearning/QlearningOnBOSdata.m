% here imoprt the data:




%observations:
% here define the choice vector
choices = % choice vector of Agent A or B,  1 = preferred colour  0 = non prefered colour
feedbacks = % reward value vector for each Agent from pay off matrix???
if size(choices,1) > 1
    choices = choices';
end
if size(feedbacks,1) > 1
    feedbacks = feedbacks';
end
PrevChoice = [nan,choices(1:end)];
PrevFeedback = [nan,PrevFeedback(1:end)];

%inputs
u = [PrevChoice;PrevFeedback]

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

dim = struct('n',2,'n_theta',1,'n_phi',1), %theta is the evolution parameter, the same alpha or learning rate
                                          %phi is obsrevation parameter,
                                          %the same tau or inverse
                                          %tempreture

% defining priors: not defining priors mean toolbox uses the default
% priors,priors structure is filled in with defaults (typically, i.i.d. zero-mean and unit-variance Gaussian densities

%here we left all priors to be default except for initial state:
options.priors.muX0 = [0.5; 0.5];  %Sahra: why this contains two 0.5?  % prior mean on x0 (obs params)
options.priors.SigmaX0 = 0.1 * eye(2);    % prior covariance on x0 (obs params)


% here define options for the simulation:
% number of trials
n_t = numel(choices);
% fitting binary data
options.sources.type = 1;
% Normally, the expected first observation is g(x1), ie. after
% a first iteratition x1 = f(x0, u0). The skipf flag will prevent this evolution
% and thus set x1 = x0
options.skipf = [1 zeros(1,n_t-1)];

% invert model
[posterior, out] = VBA_NLStateSpaceModel(y, u, f_fname, g_fname, dim, options);

% compare simulated and estimated model variables
displayResults( ...
        posterior, out, choices, ...
        simulation.state, simulation.initial, simulation.evolution, simulation.observation, ...
        Inf, Inf ...
     );

