function [p_valueGranger, LikelihoodRatioStatisticGranger,BestLag] = GrangerCausalityBinary(Y, X)
%Author: Zahra Yousefi Darani, 2024,

%  This function evaluates granger causality for binary data.
% In cognitive neuroscience, binary behavioral data can be collected from
% different behavioral paradigms. As an examaple, in 2AFC, binary behaviral
% data is: 1 = choice for one option, 0 = choice for alternative option.
% In game theory paradigms, 1 is preferred option for the subject, 0 is
% preferred option for the partner/competitor

% inputs:
% Y - binary vector representing responses (observations)
% X - binary vector represnting predictor that grang-causes the responses
% lag - number of previous data points from Y and X used in granger
% causality, for example if responses,Y, are grang-caused by X value in
% previous trial or previous step in time, lag = 1

% Outputs:
%    p_valueGranger - P-value of the likelihood ratio test
%    statisticGranger - Likelihood ratio test statistic
%    BestLag - how many trials in the past of X, are best predictors
%    of Y? 1? 2? 3? ... BestLag tells about this. it is calculated
%    based on minimum p-value, so p-value is based on:

%    Null Hypothesis (H0):
%    The lagged values of X, do not provide any additional
%    predictive information about Y beyond the information already contained in the lagged values of
%    Y. In other words, X does not Granger-cause Y.

% Alternative Hypothesis (H1):
% The lagged values of X do provide additional predictive information about Y,
%  meaning X Granger-causes Y.

% p-value:
% This is the probability of observing a test statistic as extreme as,
% or more extreme than, the one obtained, assuming that the null hypothesis is true.



%% Define a maximum for the history we want to look back at:
MaxLag = 5  % you can change it by your default assumption. For example if you assume your system bears a longterm memory, you have to incresase MaxLag.
PVAL = nan(1,MaxLag);
LR_EachLag = nan(1,MaxLag);
%% Properties for GLMM fitting
LinkFunction = 'logit';
DataDist = 'Binomial';
FittingMethod = 'Laplace';
%%
% Ensure input vectors are column vectors
Y = Y(:);
X = X(:);

% Check stationarity using the Augmented Dickey-Fuller test
if adftest(Y) == 0
    error('Series Y is not stationary. Please transform the data to make it stationary.');
end
if adftest(X) == 0
    error('Series X is not stationary. Please transform the data to make it stationary.');
end

% Create lagged variables
for lag = 1 : MaxLag

    X_lag = []
    Y_lag = []

    X_lag = lagmatrix(Y, 1:lag);
    Y_lag = lagmatrix(X, 1:lag);


    %% creating name for predictors
    SelfPredcitstring = 'SelfPredict_%dFromN';  % name for previous trail as predictor, (from vector of observations, Y)
    % because previous trial of Y, is used to predict current trial of Y, the
    % name of string is chosen as 'SelfPredict

    OtherPredcitstring = 'OtherPredict_%dFromN';  % name for previous trail as predictor, (from vector of potential predictor, X)
    % because previous trial of X, is used to predict current trial of Y, the
    % name of string is chosen as 'OtherPredict'

    %% based on how we defined lag, name for variables in table are creating here.
    % for example if lag = 2, then we will have varibale names as:
    % SelfPredict_1FromN, SelfPredict_2FromN, OtherPredict_1FromN, OtherPredict_2FromN
    SelfHistString = {};
    OtherHistString = {};
    for i = 1 : lag
        SelfHistString{i}= sprintf(SelfPredcitstring,i);
        OtherHistString{i}= sprintf(OtherPredcitstring,i);
    end

    VarNamesSelfHistModel = {};
    VarNamesOtherHistModel = {};

    VarNamesSelfHistModel = ['Trials',SelfHistString,'CurrentObservation'];
    VarNamesOtherHistModel = ['Trials',SelfHistString,OtherHistString,'CurrentObservation'];
    %% creating formula for GLMM data

    NeededString1 = [];
    NeededString2 = [];
    for i = 1 : lag
        NeededString1 = strcat(NeededString1,' + ',SelfHistString{i});
        NeededString2 = strcat(NeededString2,' + ',OtherHistString{i});
    end

    WholePredctorsString = '';
    WholePredctorsString = strcat(NeededString1,NeededString2);

    SelfHistModelString = '';
    OtherHistModelString = '';

    SelfHistModelString = strcat('CurrentObservation ~ 1 ',NeededString1,' + (1|Trials)');  % Model1 that regresses Y on its past values.
    OtherHistModelString = strcat('CurrentObservation ~ 1 ',WholePredctorsString,' + (1|Trials)'); % Model2 that regresses Y on its past values and past values of X

    %% creaing table for GLMM fitting
    TrialsVector = [];
    TrialsVector = (1 : length(Y))';

    % organizing data in a table for the model that regress Y based on y
    % previous values
    data_modelSelfHist = [];
    data_modelSelfHist = array2table([TrialsVector,Y_lag,Y],'VariableNames',VarNamesSelfHistModel);

    % model that predicts Y based on Y own previous value
    SelfHistory_Model = fitglme(data_modelSelfHist,sprintf(SelfHistModelString),'Distribution',DataDist,'Link',LinkFunction,'FitMethod',FittingMethod);


    % organizing data in a table for the model that regress Y based on Y and X
    % previous values
    data_modelOtherHist = [];
    data_modelOtherHist = array2table([TrialsVector,Y_lag,X_lag,Y],'VariableNames',VarNamesOtherHistModel);

    % model that predicts Y based on Y own previous value and X previous
    % values
    
    OtherHistory_Model = fitglme(data_modelOtherHist,sprintf(OtherHistModelString),'Distribution',DataDist,'Link',LinkFunction,'FitMethod',FittingMethod);

    %% Looking through statistics of the two models

    % Extract log likelihoods
    log_SelfHistModel = [];
    log_OtherHistModel = [];

    log_SelfHistModel = SelfHistory_Model.LogLikelihood;
    log_OtherHistModel = OtherHistory_Model.LogLikelihood;

    % Compute likelihood ratio test statistic
    LR_statistic = [];
    LR_statistic = 2 * (log_OtherHistModel - log_SelfHistModel);
    LR_EachLag(lag) = LR_statistic;

    % Degrees of freedom is the number of additional parameters in model 2
    % (other history model)
    df = [];
    df = lag;

    % Compute the p-value from chi-squared distribution
    p_value = [];
    p_value = 1 - chi2cdf(LR_statistic, df);
    PVAL(lag) = p_value;
end
[MIN_P MinIndex] = min(PVAL);
BestLag = MinIndex;
p_valueGranger = MIN_P;
LikelihoodRatioStatisticGranger = LR_EachLag(MinIndex);





