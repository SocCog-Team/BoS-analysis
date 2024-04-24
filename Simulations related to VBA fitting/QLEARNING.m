function Q = QLEARNING(PrevQ,LearningRate,reward)
Q = PrevQ + (LearningRate*(reward-PrevQ));