%%% Now is the time to create filter for monkey's turn:
diffGoSignalTime_ms_AllTrials = loadedDATA.A_GoSignalTime_ms - loadedDATA.B_GoSignalTime_ms;
diffGoSignalTime_ms_DyadicShuffled_JointRewarded = diffGoSignalTime_ms_AllTrials(Dyadic_AND_Blocked_Rewarded_DualSubjectJointTrials)
Turn_ActorA_Categ = {'first','second','simultaneously'}; % defining turn of actor in categorical data, later we will use this for plotting
Turn_ActorA_Simul_JointRewarded_ID = find(diffGoSignalTime_ms_DyadicShuffled_JointRewarded == 0); % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
Turn_ActorA_First_diffGoSignalTime_ms_JointRewarded_ID = find(diffGoSignalTime_ms_DyadicShuffled_JointRewarded<0);  % Indices of trials that actor A was the first (among all trials).
Turn_ActorA_Second_JointRewarded_ID = find(diffGoSignalTime_ms_DyadicShuffled_JointRewarded>0); % Indices of trials that actor A was the second (among all trials).
