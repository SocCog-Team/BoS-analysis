
%%Example Usage

X = binornd(1,0.5,[1,1000])
Y = binornd(1,0.5,[1,1000])
lag = 3;  % Use 1 lag for simplicity

[p_value, LR_statistic] = granger_causality_binary(A, B, lag);

if p_value < 0.05
    disp('The lagged partner''s choice significantly predicts the current own choice.');
else
    disp('The lagged partner''s choice does not significantly predict the current own choice.');
end