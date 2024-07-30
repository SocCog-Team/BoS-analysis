% function [p_value, LR_statistic] = granger_causality_binary(A, B, lag)
    % granger_causality_binary - Test Granger causality for binary behavioral data
    %
    % Syntax: [p_value, LR_statistic] = granger_causality_binary(A, B, lag)
    %
    % Inputs:
    %    A - Binary vector representing own choices
    %    B - Binary vector representing partner's choices
    %    lag - Number of lags to consider for Granger causality
    %
    % Outputs:
    %    p_value - P-value of the likelihood ratio test
    %    LR_statistic - Likelihood ratio test statistic

    % Ensure input vectors are column vectors
    A = A(:);
    B = B(:);

    % Check stationarity using the Augmented Dickey-Fuller test
    if adftest(A) == 0
        error('Series A is not stationary. Please transform the data to make it stationary.');
    end
    if adftest(B) == 0
        error('Series B is not stationary. Please transform the data to make it stationary.');
    end

    % Create lagged variables
    A_lag = lagmatrix(A, 1:lag);
    B_lag = lagmatrix(B, 1:lag);

    % Remove rows with NaNs (due to lagging)
    % valid_idx = all(~isnan(A_lag), 2) & all(~isnan(B_lag), 2);
    % A = A(valid_idx);
    % A_lag = A_lag(valid_idx, :);
    % B_lag = B_lag(valid_idx, :);

    % Convert to tables for model fitting
    data = table(A, A_lag, B_lag, 'VariableNames', {'A', 'A_lag', 'B_lag'});

    % Model 1: Predicting A from A_lag
    formula1 = 'A ~ A_lag';
    glmm1 = fitglme(data, formula1, 'Distribution', 'Binomial', 'Link', 'logit');

    % Model 2: Predicting A from B_lag
    formula2 = 'A ~ B_lag';
    glmm2 = fitglme(data, formula2, 'Distribution', 'Binomial', 'Link', 'logit');

    % Extract log likelihoods
    logL1 = glmm1.LogLikelihood;
    logL2 = glmm2.LogLikelihood;

    % Compute likelihood ratio test statistic
    LR_statistic = 2 * (logL2 - logL1);

    % Degrees of freedom is the difference in number of parameters
    df = glmm2.NumCoefficients - glmm1.NumCoefficients;

    % Compute p-value
    p_value = 1 - chi2cdf(LR_statistic, df);
end