function CrossEntLOSS = CrossEntropy(choice,calchoice)
YLOGP = choice.*(log(calchoice));
CompleY = 1-calchoice;
LOGComplProb = log(1 - calchoice);
CrossEntLOSS = mean(-(YLOGP + (CompleY.*LOGComplProb)));