% A colour is always red
% as sanity check look at the paper, figure 4, histogram of RT should be
% accordance with AT of that figure
function [loadedDATA, report_struct] = bosa_ZahraVersion_Behavioral_DataAnalysis(DataFilePath)
% report structure is whole information (headers and string information) from each session
% loadedDATA is data of each session in table format
% unique list contains most of the string information (name of the
% subjects, trial type based on the task,...)

% cd 'C:\Users\zahra\Documents\SCP_DATA\SCP-CTRL-01\SESSIONLOGS\2023'; % year directory
% cd(strcat("23",answer)) %opening date folder
load(DataFilePath);
loadedDATA = array2table(report_struct.data,'VariableNames',report_struct.header); % converts data which is structure to table
Rewarded_Aborted  = report_struct.unique_lists.A_OutcomeENUM(loadedDATA.A_OutcomeENUM_idx); % this vector shows which trial was aborted, which was successful,
% if you use a cellarray.a vector, you create repetiton of cell member
% and vector is used as index( I learned it from Igor!) 
% example C = cell(1,3) C{1} = 'a' C{2} = 'b' C{3} = 'c'  C([1 2 1 2 2 3
% 3]) = {'a'}
%       {'b'}
%       {'a'}
%       {'b'}
%       {'b'}
%       {'c'}
%       {'c'}
Trial_TaskType_All = report_struct.unique_lists.A_TrialSubTypeENUM(loadedDATA.A_TrialSubTypeENUM_idx); % this vector shows trial type based on task.
RewardedCount = sum(strcmp(Rewarded_Aborted,'REWARD')); %it gives you number of rewarded trials: ( I learned it from Igor!) strcmp compares two string and the output is one logical(1 or 0)
% becarfeul that strcmp is letter sensitive and it compares the whole
% strings (not letter by letter, if you want to compare strings letter by
% letter use: txt = ["This" "is a" "string" "array" "."];
%%pat = lettersPattern;
%contains(txt,pat)
%% AS A SANITY CHECK, COMPARE RewardedCount with what is reported in the excel file (number of rewarded trials) for that session)
RewardedID = find(strcmp(Rewarded_Aborted,'REWARD')); % indices of rewarded trials
SoloAID_All = find(strcmp(Trial_TaskType_All,'SoloA')); % Be careful! This vector contains all trial IDs that presumably were SoloA, (rewarded "AND" SoloA is in TaskType_AND_Rewarded vector)
SemiSoloID_All = find(strcmp(Trial_TaskType_All,'SemiSolo'));

RewadValues_All = loadedDATA.A_NumberRewardPulsesDelivered_HIT;
% RewadValues = loadedDATA.A_NumberRewardPulsesDelivered_HIT(RewardedID); % this: loadedDATA.A_NumberRewardPulsesDelivered_HIT cotains
% reward values on each trials, 0 means trial was aborted, 1 means 1 from
% the payoff matrix and 2 means 2 from the payoff matrix, it is filtered by
% RewardedID because we only want rewarded values on rewarded trials.
TaskType_Rewarded = Trial_TaskType_All(RewardedID);

SoloA_AND_RewardedID = intersect(SoloAID_All,RewardedID); % I learned it from Igor!,insted of "AND rule filter" simply use builtin function "intersect"
figure, plot(RewadValues_All(SoloA_AND_RewardedID),'o');  % this is a sanity check: if the SoloA_AND_RewardedID vector is extracted correctly, all values should be 2
SemiSolo_AND_RewardedID = intersect(SemiSoloID_All,RewardedID);
figure, plot(RewadValues_All(SemiSolo_AND_RewardedID),'o') ; % this is a sanity check: if the SemiSolo_AND_RewardedID vector is extracted correctly, all values should be either 1 or 2

diffGoSignalTime_ms_AllTrials = loadedDATA.A_GoSignalTime_ms - loadedDATA.B_GoSignalTime_ms; % negative means actor A is first 
% initiation of each trial is by "Go signal", if we seperate Go signal time
% of each subject from each other, it will be clear who was the first
% actor, % pay attention this vector is all trials (aborted and rewarded)
diffGoSignalTime_ms_SemiSolo_AND_Rewarded = diffGoSignalTime_ms_AllTrials(SemiSolo_AND_RewardedID);
diffGoSignalTime_ms_Rewarded = diffGoSignalTime_ms_AllTrials(RewardedID); 
figure, histogram(diffGoSignalTime_ms_Rewarded,100); % this is a sanity check: diffGoSignalTime_ms_Rewarded if is extracted correctly should have a bell shape histogram with mean around zero

RT_A_ms_AllTrials  = loadedDATA.A_InitialFixationReleaseTime_ms - loadedDATA.A_GoSignalTime_ms;
RT_B_ms_AllTrials  = loadedDATA.B_InitialFixationReleaseTime_ms - loadedDATA.B_GoSignalTime_ms;

RT_A_ms_Rewarded  = RT_A_ms_AllTrials(RewardedID);
RT_B_ms_Rewarded  = RT_B_ms_AllTrials(RewardedID);

RT_A_ms_Rewarded_AND_SemiSolo  = RT_A_ms_AllTrials(SemiSolo_AND_RewardedID);
RT_B_ms_Rewarded_AND_SemiSolo  = RT_B_ms_AllTrials(SemiSolo_AND_RewardedID);
figure, histogram(RT_A_ms_Rewarded_AND_SemiSolo-RT_B_ms_Rewarded_AND_SemiSolo,50); %sanity check: This shouldnt be like figure4 paper?(with shorter tails because here we look at RT, not AT)
%% it is like that because it is a mixture of solo and semi-solo task.
Actor_A = string(report_struct.unique_lists.A_Name);
Actor_B = string(report_struct.unique_lists.B_Name);
%% Who was first?

%split into 3 categories: simultaneous, A first, B first
%% Actor A:
Turn_ActorA_Categ = {'first','second','simultaneously'}; % defining turn of actor in categorical data, later we will use this for plotting
Turn_ActorA_Simul_All_ID = find(diffGoSignalTime_ms_AllTrials == 0); % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
Turn_ActorA_Simul_Rewarded_ID = intersect(Turn_ActorA_Simul_All_ID,RewardedID); % Indices of trials that actor A and B acted simultaneously AND rewarded.

Turn_ActorA_First_All_ID = find(diffGoSignalTime_ms_AllTrials<0);  % Indices of trials that actor A was the first (among all trials).
Turn_ActorA_First_Rewarded_ID = intersect(Turn_ActorA_First_All_ID,RewardedID);% Indices of trials that actor A was the first (Rewarded trials).
Turn_ActorA_First_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorA_First_All_ID,SemiSolo_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).

Turn_ActorA_Second_All_ID = find(diffGoSignalTime_ms_AllTrials>0); % Indices of trials that actor A was the second (among all trials).
Turn_ActorA_Second_Rewarded_ID = intersect(Turn_ActorA_Second_All_ID,RewardedID); % Indices of trials that actor A was the second (Rewarded trials).
Turn_ActorA_Second_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorA_Second_All_ID,SemiSolo_AND_RewardedID); % Indices of trials that actor A was the second (Rewarded trials in SemiSolo).

%% Actor B: Pay attention that diffGoSignalTime_ms_AllTrials negative means actor A is first, so actor B is second (line 82, should be more than zero and line 85 should be less than zero)
Turn_ActorB_Simul_All_ID = Turn_ActorA_Simul_All_ID; % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
Turn_ActorB_Simul_Rewarded_ID = intersect(Turn_ActorB_Simul_All_ID,RewardedID); % Indices of trials that actor A and B acted simultaneously AND rewarded.

Turn_ActorB_First_All_ID = find(diffGoSignalTime_ms_AllTrials>0);  % Indices of trials that actor B was the first (among all trials).
Turn_ActorB_First_Rewarded_ID = intersect(Turn_ActorB_First_All_ID,RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
Turn_ActorB_First_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorB_First_All_ID,SemiSolo_AND_RewardedID);% Indices of trials that actor B was the first (Rewarded trials).

Turn_ActorB_Second_All_ID = find(diffGoSignalTime_ms_AllTrials<0); % Indices of trials that actor B was the second (among all trials).
Turn_ActorB_Second_Rewarded_ID = intersect(Turn_ActorB_Second_All_ID,RewardedID); % Indices of trials that actor B was the second (Rewarded trials).
Turn_ActorB_Second_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorB_Second_All_ID,SemiSolo_AND_RewardedID); % Indices of trials that actor B was the second (Rewarded trials).


%% Main plot1 : We want to look at RT histograms when A was first vs when A was Second
% use ig_hist2per, from https://github.com/igorkagan/Igtools
% A first vs A second
% [N,edges] = histcounts(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_ID),50); %count in each bin
% yscaled = (N./length(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_ID))).*100; %y-axis instead of count, should be in percent
figure, histogram(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_SemiSolo_ID),50,'DisplayStyle','bar','Normalization','probability') % Igor said it is better to show y-axis as percent instead of count,
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
hold on
histogram(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_SemiSolo_ID),50,'Normalization','probability','FaceAlpha',0.1);
ytix = get(gca, 'YTick');
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend(strcat(sprintf(Actor_A),' was first!'),strcat(sprintf(Actor_A),' was second!'),'Location','northeastoutside'); % for the legend, name of Actor_A is printed
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
%% showing all combinations of RTs in one 
figure
subplot(2,2,1)
histogram(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_SemiSolo_ID),50,'DisplayStyle','bar','Normalization','probability') % Igor said it is better to show y-axis as percent instead of count,
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
hold on
histogram(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_SemiSolo_ID),50,'Normalization','probability','FaceAlpha',0.1);
ytix = get(gca, 'YTick')
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend(strcat(sprintf(Actor_A),' was first!'),strcat(sprintf(Actor_A),' was second!'),'Location','northeastoutside'); % for the legend, name of Actor_A is printed
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
%%
subplot(2,2,2)
histogram(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_SemiSolo_ID),50,'DisplayStyle','bar','Normalization','probability') % Igor said it is better to show y-axis as percent instead of count,
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
hold on
histogram(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_SemiSolo_ID),50,'Normalization','probability','FaceAlpha',0.1);
ytix = get(gca, 'YTick')
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend(strcat(sprintf(Actor_A),' was first!'),' Actor B was second!','Location','northeastoutside'); % for the legend, name of Actor_A is printed
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
%%
subplot(2,2,3)
histogram(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_SemiSolo_ID),50,'DisplayStyle','bar','Normalization','probability') % Igor said it is better to show y-axis as percent instead of count,
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
hold on
histogram(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_SemiSolo_ID),50,'Normalization','probability','FaceAlpha',0.1);
ytix = get(gca, 'YTick')
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend('Actor B was first!',strcat(sprintf(Actor_A),' was second!'),'Location','northeastoutside'); % for the legend, name of Actor_A is printed
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
%%
subplot(2,2,4)
histogram(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_SemiSolo_ID),50,'DisplayStyle','bar','Normalization','probability') % Igor said it is better to show y-axis as percent instead of count,
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
hold on
histogram(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_SemiSolo_ID),50,'Normalization','probability','FaceAlpha',0.1);
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend('Actor B was first!',' Actor B was second!','Location','northeastoutside'); % for the legend, name of Actor_A is printed
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
sgtitle('Semi-Solo task')