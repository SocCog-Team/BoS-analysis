
%% Handling Non-Stationary Data

% Differencing A and B to make them stationary
A_diff = diff(A);
B_diff = diff(B);

% Since differencing reduces the length of the series by 1
% Adjust the lag appropriately
[p_value, LR_statistic] = granger_causality_binary(A_diff, B_diff, lag);

if p_value < 0.05
    disp('The lagged partner''s choice significantly predicts the current own choice.');
else
    disp('The lagged partner''s choice does not significantly predict the current own choice.');
end