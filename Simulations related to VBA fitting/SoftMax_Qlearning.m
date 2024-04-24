function ActionProbA = SoftMax_Qlearning(InverseTempt,QvectorActionA,QvectorActionB)
% becareful! Denuminator of the softmax needs  the Q vector of opposite
% option, so if we are calculating the probability of action of first
% option, Q vector in the denuminator should be for option 2
% so you have to filter the Q vector for action leads to option with value
% 2 ( numerator) and filter the Q vector for action leads to option with value
% 1 ( Denuminator)
Numinator = exp(InverseTempt.*QvectorActionA);
Denominator = sum(exp(InverseTempt.*QvectorActionB));
ActionProbA = Numinator./Denominator;