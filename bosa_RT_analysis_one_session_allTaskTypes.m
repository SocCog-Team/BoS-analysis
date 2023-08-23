function [Statitical_Results] = bosa_RT_analysis_one_session_allTaskTypes(DataFileName)

% DataFilePath = '20230623T124557.A_Curius.B_Elmo.SCP_01.triallog.v017.mat'
load(DataFileName);
loadedDATA = array2table(report_struct.data,'VariableNames',report_struct.header); % converts data which is structure to table

%% 1) Defining variables:

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
%% replace SoloARewardAB with SoloA
Solo_A_ID_ALL = strfind(Trial_TaskType_All,'SoloARewardAB');
Solo_A_ID_ALL = cellfun(@(x) ~isempty(x) && x == 1, Solo_A_ID_ALL);
Solo_A_ID_ALL = find(Solo_A_ID_ALL);
Trial_TaskType_All(Solo_A_ID_ALL) = {'SoloA'};
%% replace SoloBRewardAB with SoloB
Solo_B_ID_ALL = strfind(Trial_TaskType_All,'SoloBRewardAB');
Solo_B_ID_ALL = cellfun(@(x) ~isempty(x) && x == 1, Solo_B_ID_ALL);
Solo_B_ID_ALL = find(Solo_B_ID_ALL);
Trial_TaskType_All(Solo_B_ID_ALL) = {'SoloB'};
%%
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
DyadicID_All = find(strcmp(Trial_TaskType_All,'Dyadic'));
SoloBID_All = find(strcmp(Trial_TaskType_All,'SoloB'));
%%
% RewadValues_All = loadedDATA.A_NumberRewardPulsesDelivered_HIT;
% RewadValues = loadedDATA.A_NumberRewardPulsesDelivered_HIT(RewardedID); % this: loadedDATA.A_NumberRewardPulsesDelivered_HIT cotains
% reward values on each trials, 0 means trial was aborted, 1 means 1 from
% the payoff matrix and 2 means 2 from the payoff matrix, it is filtered by
% RewardedID because we only want rewarded values on rewarded trials.


SoloA_AND_RewardedID = intersect(SoloAID_All,RewardedID); % I learned it from Igor!,insted of "AND rule filter" simply use builtin function "intersect"
% figure, plot(RewadValues_All(SoloA_AND_RewardedID),'o');  % this is a sanity check: if the SoloA_AND_RewardedID vector is extracted correctly, all values should be 2
SemiSolo_AND_RewardedID = intersect(SemiSoloID_All,RewardedID);
Dyadic_AND_RewardedID = intersect(DyadicID_All,RewardedID);
% figure, plot(RewadValues_All(SemiSolo_AND_RewardedID),'o') ; % this is a sanity check: if the SemiSolo_AND_RewardedID vector is extracted correctly, all values should be either 1 or 2
SoloB_AND_RewardedID = intersect(SoloBID_All,RewardedID);

diffGoSignalTime_ms_AllTrials = loadedDATA.A_GoSignalTime_ms - loadedDATA.B_GoSignalTime_ms; % negative means actor A is first 
% initiation of each trial is by "Go signal", if we seperate Go signal time
% of each subject from each other, it will be clear who was the first
% actor, % pay attention this vector is all trials (aborted and rewarded)
% diffGoSignalTime_ms_SemiSolo_AND_Rewarded = diffGoSignalTime_ms_AllTrials(SemiSolo_AND_RewardedID);
% diffGoSignalTime_ms_Rewarded = diffGoSignalTime_ms_AllTrials(RewardedID); 
% figure, histogram(diffGoSignalTime_ms_Rewarded,100); % this is a sanity check: diffGoSignalTime_ms_Rewarded if is extracted correctly should have a bell shape histogram with mean around zero

RT_A_ms_AllTrials  = loadedDATA.A_InitialFixationReleaseTime_ms - loadedDATA.A_GoSignalTime_ms;
RT_B_ms_AllTrials  = loadedDATA.B_InitialFixationReleaseTime_ms - loadedDATA.B_GoSignalTime_ms;

%% Excluding trials for Actor A when B was on Solo and vice versa
if isempty(SemiSoloID_All)
TrialsBelong_ActorA_ID_All = union(SoloAID_All,DyadicID_All);
TrialsBelong_ActorB_ID_All = union(SoloBID_All,DyadicID_All);
end


if isempty(DyadicID_All)
TrialsBelong_ActorA_ID_All = union(SoloAID_All,SemiSoloID_All);
TrialsBelong_ActorB_ID_All = union(SoloBID_All,SemiSoloID_All);
end

TrialsBelong_ActorA_ID_Reward = intersect(TrialsBelong_ActorA_ID_All,RewardedID);
TrialsBelong_ActorB_ID_Reward = intersect(TrialsBelong_ActorB_ID_All,RewardedID);

RT_A_ms_Rewarded  = RT_A_ms_AllTrials(TrialsBelong_ActorA_ID_Reward);
RT_B_ms_Rewarded  = RT_B_ms_AllTrials(TrialsBelong_ActorA_ID_Reward);

TaskType_Rewarded_A = Trial_TaskType_All(TrialsBelong_ActorA_ID_Reward);
TaskType_Rewarded_B = Trial_TaskType_All(TrialsBelong_ActorB_ID_Reward);

% RT_A_ms_Rewarded_AND_SemiSolo  = RT_A_ms_AllTrials(SemiSolo_AND_RewardedID);
% RT_B_ms_Rewarded_AND_SemiSolo  = RT_B_ms_AllTrials(SemiSolo_AND_RewardedID);
% figure, histogram(RT_A_ms_Rewarded_AND_SemiSolo-RT_B_ms_Rewarded_AND_SemiSolo,50); %sanity check: This shouldnt be like figure4 paper?(with shorter tails because here we look at RT, not AT)
%% it is like that because it is a mixture of solo and semi-solo task.
Actor_A = string(report_struct.unique_lists.A_Name);
Actor_B = string(report_struct.unique_lists.B_Name);
%% Who was first?

%split into 3 categories: simultaneous, A first, B first
%% Actor A:
Turn_ActorA_Categ = {'first','second','simultaneously'}; % defining turn of actor in categorical data, later we will use this for plotting
Turn_ActorA_Simul_All_ID = find(diffGoSignalTime_ms_AllTrials == 0); % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
Turn_ActorA_Simul_Rewarded_ID = intersect(Turn_ActorA_Simul_All_ID,RewardedID); % Indices of trials that actor A and B acted simultaneously AND rewarded.
Turn_ActorA_Simul_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorA_Simul_All_ID,SemiSolo_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).
Turn_ActorA_Simul_Rewarded_AND_Solo_ID = intersect(Turn_ActorA_Simul_All_ID,SoloA_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).
Turn_ActorA_Simul_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_Simul_All_ID,Dyadic_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in Dyadic).



Turn_ActorA_First_All_ID = find(diffGoSignalTime_ms_AllTrials<0);  % Indices of trials that actor A was the first (among all trials).
Turn_ActorA_First_Rewarded_ID = intersect(Turn_ActorA_First_All_ID,TrialsBelong_ActorA_ID_Reward);% Indices of trials that actor A was the first (Rewarded trials).
Turn_ActorA_First_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorA_First_All_ID,SemiSolo_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).
Turn_ActorA_First_Rewarded_AND_Solo_ID = intersect(Turn_ActorA_First_All_ID,SoloA_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).
Turn_ActorA_First_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_First_All_ID,Dyadic_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in Dyadic).



Turn_ActorA_Second_All_ID = find(diffGoSignalTime_ms_AllTrials>0); % Indices of trials that actor A was the second (among all trials).
Turn_ActorA_Second_Rewarded_ID = intersect(Turn_ActorA_Second_All_ID,RewardedID); % Indices of trials that actor A was the second (Rewarded trials).
Turn_ActorA_Second_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorA_Second_All_ID,SemiSolo_AND_RewardedID); % Indices of trials that actor A was the second (Rewarded trials in SemiSolo).
Turn_ActorA_Second_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_Second_All_ID,Dyadic_AND_RewardedID);
Turn_ActorA_Second_Rewarded_AND_Solo_ID = intersect(Turn_ActorA_Second_All_ID,SoloA_AND_RewardedID); % Indices of trials that actor A was the second (Rewarded trials in SemiSolo).

%% Actor B: Pay attention that diffGoSignalTime_ms_AllTrials negative means actor A is first, so actor B is second (line 82, should be more than zero and line 85 should be less than zero)
Turn_ActorB_Simul_All_ID = Turn_ActorA_Simul_All_ID; % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
Turn_ActorB_Simul_Rewarded_ID = intersect(Turn_ActorB_Simul_All_ID,RewardedID); % Indices of trials that actor A and B acted simultaneously AND rewarded.
Turn_ActorB_Simul_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorB_Simul_All_ID,SemiSolo_AND_RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
Turn_ActorB_Simul_Rewarded_AND_Solo_ID = intersect(Turn_ActorB_Simul_All_ID,SoloB_AND_RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
Turn_ActorB_Simul_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorB_Simul_All_ID,Dyadic_AND_RewardedID);

Turn_ActorB_First_All_ID = find(diffGoSignalTime_ms_AllTrials>0);  % Indices of trials that actor B was the first (among all trials).
Turn_ActorB_First_Rewarded_ID = intersect(Turn_ActorB_First_All_ID,RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
Turn_ActorB_First_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorB_First_All_ID,SemiSolo_AND_RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
Turn_ActorB_First_Rewarded_AND_Solo_ID = intersect(Turn_ActorB_First_All_ID,SoloB_AND_RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
Turn_ActorB_First_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorB_First_All_ID,Dyadic_AND_RewardedID);

Turn_ActorB_Second_All_ID = find(diffGoSignalTime_ms_AllTrials<0); % Indices of trials that actor B was the second (among all trials).
Turn_ActorB_Second_Rewarded_ID = intersect(Turn_ActorB_Second_All_ID,RewardedID); % Indices of trials that actor B was the second (Rewarded trials).
Turn_ActorB_Second_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorB_Second_All_ID,SemiSolo_AND_RewardedID); % Indices of trials that actor B was the second (Rewarded trials).
Turn_ActorB_Second_Rewarded_AND_Solo_ID = intersect(Turn_ActorB_Second_All_ID,SoloB_AND_RewardedID); % Indices of trials that actor B was the second (Rewarded trials).
Turn_ActorB_Second_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorB_Second_All_ID,Dyadic_AND_RewardedID);

bins = [0:25:1000];

%% 2) Plotting: 
% Main plot1 : We want to look at RT histograms when A was first vs when A was Second
% use ig_hist2per, from https://github.com/igorkagan/Igtools
% A first vs A second
% [N,edges] = histcounts(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_ID),50); %count in each bin
% yscaled = (N./length(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_ID))).*100; %y-axis instead of count, should be in percent
% figure, histogram(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_SemiSolo_ID),bins,'DisplayStyle','bar','Normalization','probability') % Igor said it is better to show y-axis as percent instead of count,
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
% hold on
% histogram(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_SemiSolo_ID),bins,'Normalization','probability','FaceAlpha',0.1);
% ytix = get(gca, 'YTick');
% set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
% legend(strcat(sprintf(Actor_A),'',' was first!',''),strcat(sprintf(Actor_A),' was second!')); % for the legend, name of Actor_A is printed
% xlabel('reaction time(ms), bin width = 50 ms');
% ylabel('% of trials');
%% DEFINING IF CONDITIONS TO SEPERATE SESSIONS BASED ON TASK TYPE:


%% if there is no Dyadic within the session
if isempty(DyadicID_All)
figure
sh(1) = subplot(3,3,1,'replace');
sh(2) = subplot(3,3,2,'replace');
sh(3) = subplot(3,3,3,'replace');
sh(4) = subplot(3,3,4);
histogram(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_SemiSolo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
hold on
plot(mean(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_SemiSolo_ID)),-0.005,"^",'Color','r')
histogram(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_SemiSolo_ID),bins,'Normalization','probability','FaceColor','b','FaceAlpha',0.1);
plot(mean(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_SemiSolo_ID)),-0.005,"^",'Color','b')
ytix = get(gca, 'YTick');
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend(strcat(sprintf(Actor_A),' was first'),'','Actor B was second',''); % for the legend, name of Actor_A is printed
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_SemiSolo_ID)))); ...
    strcat('Actor B:','trial number =',string(numel(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_SemiSolo_ID))))};
subtitle(subtitletxt);
% pbaspect([1 1 1])
%%
sh(5) = subplot(3,3,5);
histogram(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_SemiSolo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
hold on
plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_SemiSolo_ID)),-0.005,"^",'Color','r')
histogram(RT_B_ms_AllTrials(Turn_ActorB_Simul_Rewarded_AND_SemiSolo_ID),bins,'Normalization','probability','FaceAlpha',0.1,'FaceColor','b');
plot(mean(RT_B_ms_AllTrials(Turn_ActorB_Simul_Rewarded_AND_SemiSolo_ID)),-0.005,"^",'Color','b')
ytix = get(gca, 'YTick');
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend(sprintf(Actor_A),'','Actor B',''); % for the legend, name of Actor_A is printed
title ('simultaneously')
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
subtitletxt = {strcat(sprintf(Actor_A),' and Actor B:','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_SemiSolo_ID))))};
subtitle(subtitletxt);
% pbaspect([1 1 1])
%%
sh(6) = subplot(3,3,6);
histogram(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_SemiSolo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
hold on
plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_SemiSolo_ID)),-0.005,"^",'Color','r')
histogram(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_SemiSolo_ID),bins,'Normalization','probability','FaceAlpha',0.1,'FaceColor','b');
plot(mean(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_SemiSolo_ID)),-0.005,"^",'Color','b')
ytix = get(gca, 'YTick');
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend(strcat(sprintf(Actor_A),' was second'),'','Actor B was first',''); % for the legend, name of Actor_A is printed
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_SemiSolo_ID))));strcat('Actor B:','trial number =', ...
    string(numel(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_SemiSolo_ID))))};
subtitle(subtitletxt);
% pbaspect([1 1 1])
%% from here, we look at the "Solo" condition
sh(7) = subplot(3,3,7);
histogram(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
hold on
plot(mean(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','r')
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend('Curius',''); % for the legend, name of Actor_A is printed
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Solo_ID))))};
subtitle(subtitletxt);
% pbaspect([1 1 1])
%%
sh(8) = subplot(3,3,8);
histogram(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
hold on
plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','r')
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend('Curius',''); % for the legend, name of Actor_A is printed
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Solo_ID))))};
subtitle(subtitletxt);
title('nominally simultaneously')
% pbaspect([1 1 1])
%%
sh(9) = subplot(3,3,9);
histogram(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
hold on
plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','r')

% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend('Curius',''); 
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID))))};
subtitle(subtitletxt);
% pbaspect([1 1 1])
set(sh(:),'Xlim',[0 1000]);
% ig_set_axes_equal_lim(sh,'Ylim');
set(sh(:),'Ylim',[-0.01 0.25]);

% set(sh(:),'DataAspectRatio',[1 1 1])
annotation('textbox',...
    [0.0442291666666667 0.780777537796975 0.0474375 0.0377969762418982],...
    'String','Dyadic',...
    'FitBoxToText','off');

annotation('textbox',...
    [0.0442291666666667 0.197624190064795 0.0474375 0.0377969762418982],...
    'String',{'Solo'},...
    'FitBoxToText','off');
annotation('textbox',...
    [0.0442291666666667 0.52267818574514 0.0474375 0.0377969762418982],...
    'String',{'Semi-Solo'},...
    'FitBoxToText','off');
sgtitle('Session with only Semi-Solo and Solo')

end
%%

%% if there is no semisolo within the session

if isempty(SemiSoloID_All)
figure
sh(1) = subplot(3,3,1);
histogram(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Dyadic_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
hold on
plot(mean(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Dyadic_ID)),-0.005,"^",'Color','r')
histogram(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_Dyadic_ID),bins,'Normalization','probability','FaceColor','b','FaceAlpha',0.1);
plot(mean(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_Dyadic_ID)),-0.005,"^",'Color','b')
ytix = get(gca, 'YTick');
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend(strcat(sprintf(Actor_A),' was first'),'',strcat(sprintf(Actor_B),' was second','')); % for the legend, name of Actor_A is printed
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Dyadic_ID)))); ...
    strcat('Actor B:','trial number =',string(numel(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_Dyadic_ID))))};
subtitle(subtitletxt);
% pbaspect([1 1 1])
%%
sh(2) = subplot(3,3,2);
histogram(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Dyadic_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
hold on
plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Dyadic_ID)),-0.005,"^",'Color','r')
histogram(RT_B_ms_AllTrials(Turn_ActorB_Simul_Rewarded_AND_Dyadic_ID),bins,'Normalization','probability','FaceAlpha',0.1,'FaceColor','b');
plot(mean(RT_B_ms_AllTrials(Turn_ActorB_Simul_Rewarded_AND_Dyadic_ID)),-0.005,"^",'Color','b')
ytix = get(gca, 'YTick');
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend(sprintf(Actor_A),'',sprintf(Actor_B),''); % for the legend, name of Actor_A is printed
title ('simultaneously')
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
subtitletxt = {strcat(sprintf(Actor_A),' and Actor B:','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Dyadic_ID))))};
subtitle(subtitletxt);
% pbaspect([1 1 1])
%%
sh(3) = subplot(3,3,3);
histogram(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Dyadic_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
hold on
plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Dyadic_ID)),-0.005,"^",'Color','r')
histogram(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_Dyadic_ID),bins,'Normalization','probability','FaceAlpha',0.1,'FaceColor','b');
plot(mean(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_Dyadic_ID)),-0.005,"^",'Color','b')
ytix = get(gca, 'YTick');
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend(strcat(sprintf(Actor_A),' was second '),'',strcat(sprintf(Actor_B),' was first'),''); % for the legend, name of Actor_A is printed
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Dyadic_ID))));strcat('Actor B:','trial number =', ...
    string(numel(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_Dyadic_ID))))};
subtitle(subtitletxt);
% pbaspect([1 1 1])
%% from here, we look at the "Solo" condition
sh(4) = subplot(3,3,4,'replace');
sh(5) = subplot(3,3,5,'replace');
sh(6) = subplot(3,3,6,'replace');
sh(7) = subplot(3,3,7);
histogram(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
hold on
plot(mean(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','r')

histogram(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','b','FaceAlpha',0.1) % Igor said it is better to show y-axis as percent instead of count,
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
plot(mean(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','b')
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend(sprintf(Actor_A),'',sprintf(Actor_B),''); % for the legend, name of Actor_A is printed
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Solo_ID))));...
    strcat(sprintf(Actor_B),':','trial number =',string(numel(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_Solo_ID))))};
subtitle(subtitletxt);
% pbaspect([1 1 1])
%%
sh(8) = subplot(3,3,8);
histogram(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
hold on
plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','r')

histogram(RT_B_ms_AllTrials(Turn_ActorB_Simul_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','b','FaceAlpha',0.1) % Igor said it is better to show y-axis as percent instead of count,
plot(mean(RT_B_ms_AllTrials(Turn_ActorB_Simul_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','b')
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend(sprintf(Actor_A),'',sprintf(Actor_B),''); % for the legend, name of Actor_A is printed
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Solo_ID))));...
    strcat(sprintf(Actor_B),':','trial number =',string(numel(RT_B_ms_AllTrials(Turn_ActorB_Simul_Rewarded_AND_Solo_ID))))};
subtitle(subtitletxt);
title('nominally simultaneously')
% pbaspect([1 1 1])
%%
sh(9) = subplot(3,3,9);
histogram(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
hold on
plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','r')

histogram(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','b','FaceAlpha',0.1) % Igor said it is better to show y-axis as percent instead of count,
plot(mean(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','b')
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend(sprintf(Actor_A),'',sprintf(Actor_B),''); % for the legend, name of Actor_A is printed
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID))));...
    strcat(sprintf(Actor_B),':','trial number =',string(numel(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_Solo_ID))))};
subtitle(subtitletxt);
% pbaspect([1 1 1])
set(sh(:),'Xlim',[0 1000]);
% ig_set_axes_equal_lim(sh,'Ylim');
set(sh(:),'Ylim',[-0.01 0.25]);
% set(sh(:),'DataAspectRatio',[1 1 1])
annotation('textbox',...
    [0.0442291666666667 0.780777537796975 0.0474375 0.0377969762418982],...
    'String','Dyadic',...
    'FitBoxToText','off');

annotation('textbox',...
    [0.0442291666666667 0.197624190064795 0.0474375 0.0377969762418982],...
    'String',{'Solo'},...
    'FitBoxToText','off');
annotation('textbox',...
    [0.0442291666666667 0.52267818574514 0.0474375 0.0377969762418982],...
    'String',{'Semi-Solo'},...
    'FitBoxToText','off');
sgtitle('Session with only Dyadic and Solo')
end
%% 3) Statistical analysis: Wrapping up the results in a structure for each session

Statitical_Results = struct;
Statitical_Results.WithinTaskType_WithinSubj = struct;
Statitical_Results.WithinTaskType_BetwSubj = struct;
Statitical_Results.BetwTaskType_WithinSubj = struct;
Statitical_Results.FactorAnalysis_WithinSubj = struct;
%%
if isempty(DyadicID_All)
    % non-paird-ttest (within subject between tasktype)
   [h_ActorA1_ActorB2,p_ActorA1_ActorB2,ci_ActorA1_ActorB2,stat_ActorA1_ActorB2] = ttest(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_SemiSolo_ID),RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_SemiSolo_ID));
   [h_Simul,p_Simul,ci_Simul,stat_Simul] = ttest(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_SemiSolo_ID),RT_B_ms_AllTrials(Turn_ActorB_Simul_Rewarded_AND_SemiSolo_ID));
   [h_ActorA2_ActorB1,p_ActorA2_ActorB1,ci_ActorA2_ActorB1,stat_ActorA2_ActorB1] = ttest(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_SemiSolo_ID),RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_SemiSolo_ID));
   [h_Solo_vs_SemiSolo_Simul_ActorA,p_Solo_vs_SemiSolo_Simul_ActorA,ci_Solo_vs_SemiSolo_Simul_ActorA,stat_Solo_vs_SemiSolo_Simul_ActorA] = ttest2(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Solo_ID),RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_SemiSolo_ID),'Vartype','unequal');
   [h_Solo_vs_SemiSolo_First_ActorA,p_Solo_vs_SemiSolo_First_ActorA,ci_Solo_vs_SemiSolo_First_ActorA,stat_Solo_vs_SemiSolo_First_ActorA] = ttest2(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Solo_ID),RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_SemiSolo_ID),'Vartype','unequal');
   [h_Solo_vs_SemiSolo_Second_ActorA,p_Solo_vs_SemiSolo_Second_ActorA,ci_Solo_vs_SemiSolo_Second_ActorA,stat_Solo_vs_SemiSolo_Second_ActorA] = ttest2(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID),RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_SemiSolo_ID),'Vartype','unequal');

   %% table to show non-paird-ttest results (within subject between tasktype):
   SoloVsSemiSolo_T_BetweenCondition_A = table;
   SoloVsSemiSolo_T_BetweenCondition_A.Stat = {'h';'p';'CI_lower';'CI_upper';'tstat';'df';'sd_min';'sd_max'};  % h = 1 rejecting the null hypothesis(mean are significantly different)
   % T_BetweenCondition.First = double(round(vpa(([h_Solo_vs_SemiSolo_First;p_Solo_vs_SemiSolo_First;ci_Solo_vs_SemiSolo_First;stat_Solo_vs_SemiSolo_First.tstat;stat_Solo_vs_SemiSolo_First.df;stat_Solo_vs_SemiSolo_First.sd])),3));
   % T_BetweenCondition.Simul = double(round(vpa(([h_Solo_vs_SemiSolo_Simul;p_Solo_vs_SemiSolo_Simul;ci_Solo_vs_SemiSolo_Simul;stat_Solo_vs_SemiSolo_Simul.tstat;stat_Solo_vs_SemiSolo_Simul.df;stat_Solo_vs_SemiSolo_Simul.sd])),3));
   % T_BetweenCondition.Second = double(round(vpa(([h_Solo_vs_SemiSolo_Second;p_Solo_vs_SemiSolo_Second;ci_Solo_vs_SemiSolo_Second;stat_Solo_vs_SemiSolo_Second.tstat;stat_Solo_vs_SemiSolo_Second.df;stat_Solo_vs_SemiSolo_Second.sd])),3));
  
   SoloVsSemiSolo_T_BetweenCondition_A.First = num2str([h_Solo_vs_SemiSolo_First_ActorA;p_Solo_vs_SemiSolo_First_ActorA;ci_Solo_vs_SemiSolo_First_ActorA;stat_Solo_vs_SemiSolo_First_ActorA.tstat;stat_Solo_vs_SemiSolo_First_ActorA.df;stat_Solo_vs_SemiSolo_First_ActorA.sd],'%0.3f');
   SoloVsSemiSolo_T_BetweenCondition_A.Simul = num2str([h_Solo_vs_SemiSolo_Simul_ActorA;p_Solo_vs_SemiSolo_Simul_ActorA;ci_Solo_vs_SemiSolo_Simul_ActorA;stat_Solo_vs_SemiSolo_Simul_ActorA.tstat;stat_Solo_vs_SemiSolo_Simul_ActorA.df;stat_Solo_vs_SemiSolo_Simul_ActorA.sd],'%0.3f');
   SoloVsSemiSolo_T_BetweenCondition_A.Second = num2str([h_Solo_vs_SemiSolo_Second_ActorA;p_Solo_vs_SemiSolo_Second_ActorA;ci_Solo_vs_SemiSolo_Second_ActorA;stat_Solo_vs_SemiSolo_Second_ActorA.tstat;stat_Solo_vs_SemiSolo_Second_ActorA.df;stat_Solo_vs_SemiSolo_Second_ActorA.sd],'%0.3f');
   Statitical_Results.BetwTaskType_WithinSubj.Solo_vs_SemiSolo.ActorA.TTest = SoloVsSemiSolo_T_BetweenCondition_A;

   % non-paird-ttest (within subject within condition)
   [h_SemiSolo_ActorA1_vs_ActorA2,p_SemiSolo_ActorA1_vs_ActorA2,ci_SemiSolo_ActorA1_vs_ActorA2,stat_SemiSolo_ActorA1_vs_ActorA2] = ttest2(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_SemiSolo_ID),RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_SemiSolo_ID));
   [h_SemiSolo_ActorA1_vs_Simul,p_SemiSolo_ActorA1_vs_Simul,ci_SemiSolo_ActorA1_vs_Simul,stat_SemiSolo_ActorA1_vs_Simul] = ttest2(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_SemiSolo_ID),RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_SemiSolo_ID));
   [h_SemiSolo_ActorA2_vs_Simul,p_SemiSolo_ActorA2_vs_Simul,ci_SemiSolo_ActorA2_vs_Simul,stat_SemiSolo_ActorA2_vs_Simul] = ttest2(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_SemiSolo_ID),RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_SemiSolo_ID));

    %% table to show non-paird-ttest results (within subject within tasktype):
   SemiSolo_T_WithinSubj_A = table;
   SemiSolo_T_WithinSubj_A.Stat = {'h';'p';'CI_lower';'CI_upper';'tstat';'df';'sd'};  % h = 1 rejecting the null hypothesis(mean are significantly different)
   % T_BetweenCondition.First = double(round(vpa(([h_Solo_vs_SemiSolo_First;p_Solo_vs_SemiSolo_First;ci_Solo_vs_SemiSolo_First;stat_Solo_vs_SemiSolo_First.tstat;stat_Solo_vs_SemiSolo_First.df;stat_Solo_vs_SemiSolo_First.sd])),3));
   % T_BetweenCondition.Simul = double(round(vpa(([h_Solo_vs_SemiSolo_Simul;p_Solo_vs_SemiSolo_Simul;ci_Solo_vs_SemiSolo_Simul;stat_Solo_vs_SemiSolo_Simul.tstat;stat_Solo_vs_SemiSolo_Simul.df;stat_Solo_vs_SemiSolo_Simul.sd])),3));
   % T_BetweenCondition.Second = double(round(vpa(([h_Solo_vs_SemiSolo_Second;p_Solo_vs_SemiSolo_Second;ci_Solo_vs_SemiSolo_Second;stat_Solo_vs_SemiSolo_Second.tstat;stat_Solo_vs_SemiSolo_Second.df;stat_Solo_vs_SemiSolo_Second.sd])),3));
  
 
   SemiSolo_T_WithinSubj_A.FirstvsSecond = num2str([h_SemiSolo_ActorA1_vs_ActorA2;p_SemiSolo_ActorA1_vs_ActorA2;ci_SemiSolo_ActorA1_vs_ActorA2;stat_SemiSolo_ActorA1_vs_ActorA2.tstat;stat_SemiSolo_ActorA1_vs_ActorA2.df;stat_SemiSolo_ActorA1_vs_ActorA2.sd],'%0.3f');
   SemiSolo_T_WithinSubj_A.FirstvsSimul = num2str([h_SemiSolo_ActorA1_vs_Simul;p_SemiSolo_ActorA1_vs_Simul;ci_SemiSolo_ActorA1_vs_Simul;stat_SemiSolo_ActorA1_vs_Simul.tstat;stat_SemiSolo_ActorA1_vs_Simul.df;stat_SemiSolo_ActorA1_vs_Simul.sd],'%0.3f');
   SemiSolo_T_WithinSubj_A.SecondvsSimul = num2str([h_SemiSolo_ActorA2_vs_Simul;p_SemiSolo_ActorA2_vs_Simul;ci_SemiSolo_ActorA2_vs_Simul;stat_SemiSolo_ActorA2_vs_Simul.tstat;stat_SemiSolo_ActorA2_vs_Simul.df;stat_SemiSolo_ActorA2_vs_Simul.sd],'%0.3f');
   Statitical_Results.WithinTaskType_WithinSubj.SemiSolo.ActorA.TTest = SemiSolo_T_WithinSubj_A;

   
   %% table to show paird-ttest results: (within tasktype, between the subject)
   T_WithinCondition_BetwSubj_SemiSolo = table; 
   T_WithinCondition_BetwSubj_SemiSolo.Stat = {'h';'p';'CI_lower';'CI_upper';'tstat';'df';'sd'};  % h = 1 rejecting the null hypothesis(mean are significantly different)
   % T_WithinCondition_SemiSolo.Monkey_First = double(round(vpa(([h_Monk1_Hum2;p_Monk1_Hum2;ci_Monk1_Hum2;stat_Monk1_Hum2.tstat;stat_Monk1_Hum2.df;stat_Monk1_Hum2.sd])),3))
   % T_WithinCondition_SemiSolo.Simulataneously = double(round(vpa(([h_Simul;p_Simul;ci_Simul;stat_Simul.tstat;stat_Simul.df;stat_Simul.sd])),3))
   % T_WithinCondition_SemiSolo.Monkey_Second = double(round(vpa(([h_Monk2_Hum1;p_Monk2_Hum1;ci_Monk2_Hum1;stat_Monk2_Hum1.tstat;stat_Monk2_Hum1.df;stat_Monk2_Hum1.sd])),3))

   T_WithinCondition_BetwSubj_SemiSolo.ActorA_First = num2str([h_ActorA1_ActorB2;p_ActorA1_ActorB2;ci_ActorA1_ActorB2;stat_ActorA1_ActorB2.tstat;stat_ActorA1_ActorB2.df;stat_ActorA1_ActorB2.sd],'%0.3f'); %printing the numbers to 5 values after the decimal
   T_WithinCondition_BetwSubj_SemiSolo.Simulataneously = num2str([h_Simul;p_Simul;ci_Simul;stat_Simul.tstat;stat_Simul.df;stat_Simul.sd],'%0.3f');
   T_WithinCondition_BetwSubj_SemiSolo.ActorA_Second = num2str([h_ActorA2_ActorB1;p_ActorA2_ActorB1;ci_ActorA2_ActorB1;stat_ActorA2_ActorB1.tstat;stat_ActorA2_ActorB1.df;stat_ActorA2_ActorB1.sd],'%0.3f');
   Statitical_Results.WithinTaskType_BetwSubj.SemiSolo.TTest = T_WithinCondition_BetwSubj_SemiSolo;

   %% performing   2 way ANOVA for two factors affecting the RT of A (B): Timing and Task type
   figure;
   ResponseVariable_A = RT_A_ms_Rewarded;
   TaskType_A = TaskType_Rewarded_A'; 
   Timing_A = strings(size(diffGoSignalTime_ms_AllTrials,1),1); % intializing timing vector with nan
   Timing_A(Turn_ActorA_Simul_All_ID) = repelem({'Simul'},length(Turn_ActorA_Simul_All_ID));
   Timing_A(Turn_ActorA_First_All_ID) = repelem({'First'},length(Turn_ActorA_First_All_ID));
   Timing_A(Turn_ActorA_Second_All_ID) = repelem({'Second'},length(Turn_ActorA_Second_All_ID));

   Timing_A_Rewarded = Timing_A(TrialsBelong_ActorA_ID_Reward);  % Timing vector is from all trials, we need only rewarded
   [p_Anova_ActorA,tbl_Anova_ActorA,stats_Anova_ActorA,terms_Anova_ActorA] = anovan(ResponseVariable_A,{Timing_A_Rewarded,TaskType_A},'model',2,'varnames',{'Timing','TaskType'});
   [c_multcomp_ActorA,m_multcomp_ActorA,h_multcomp_ActorA,gnames_multcomp_ActorA] = multcompare(stats_Anova_ActorA,'Dimension',[1 2],'Ctype','bonferroni');

   Statitical_Results.FactorAnalysis_WithinSubj.SoloSemiSolo.TwoAnova.ActorA.p = p_Anova_ActorA;
   Statitical_Results.FactorAnalysis_WithinSubj.SoloSemiSolo.TwoAnova.ActorA.tbl = tbl_Anova_ActorA;
   Statitical_Results.FactorAnalysis_WithinSubj.SoloSemiSolo.TwoAnova.ActorA.stats = stats_Anova_ActorA;
   Statitical_Results.FactorAnalysis_WithinSubj.SoloSemiSolo.TwoAnova.ActorA.terms = terms_Anova_ActorA;

   Statitical_Results.FactorAnalysis_WithinSubj.SoloSemiSolo.MultiComp.ActorA.c = c_multcomp_ActorA;
   Statitical_Results.FactorAnalysis_WithinSubj.SoloSemiSolo.MultiComp.ActorA.m = m_multcomp_ActorA;
   Statitical_Results.FactorAnalysis_WithinSubj.SoloSemiSolo.MultiComp.ActorA.h = h_multcomp_ActorA;
   Statitical_Results.FactorAnalysis_WithinSubj.SoloSemiSolo.MultiComp.ActorA.gnames = gnames_multcomp_ActorA;
  
end

if isempty(SemiSoloID_All)
   % non-paird-ttest (within subject between tasktype: Dyadic and Solo)
   [h_ActorA1_ActorB2,p_ActorA1_ActorB2,ci_ActorA1_ActorB2,stat_ActorA1_ActorB2] = ttest(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Dyadic_ID),RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_Dyadic_ID));
   [h_Simul,p_Simul,ci_Simul,stat_Simul] = ttest(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Dyadic_ID),RT_B_ms_AllTrials(Turn_ActorB_Simul_Rewarded_AND_Dyadic_ID));
   [h_ActorA2_ActorB1,p_ActorA2_ActorB1,ci_ActorA2_ActorB1,stat_ActorA2_ActorB1] = ttest(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Dyadic_ID),RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_Dyadic_ID));
   [h_Solo_vs_Dyadic_Simul_ActorA,p_Solo_vs_Dyadic_Simul_ActorA,ci_Solo_vs_Dyadic_Simul_ActorA,stat_Solo_vs_Dyadic_Simul_ActorA] = ttest2(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Solo_ID),RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Dyadic_ID),'Vartype','unequal');
   [h_Solo_vs_Dyadic_First_ActorA,p_Solo_vs_Dyadic_First_ActorA,ci_Solo_vs_Dyadic_First_ActorA,stat_Solo_vs_Dyadic_First_ActorA] = ttest2(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Solo_ID),RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Dyadic_ID),'Vartype','unequal');
   [h_Solo_vs_Dyadic_Second_ActorA,p_Solo_vs_Dyadic_Second_ActorA,ci_Solo_vs_Dyadic_Second_ActorA,stat_Solo_vs_Dyadic_Second_ActorA] = ttest2(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID),RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Dyadic_ID),'Vartype','unequal');

   %% table to show non-paird-ttest results (within subject between tasktype):
   SoloVsDyadic_T_BetweenTaskTypes_A = table;
   SoloVsDyadic_T_BetweenTaskTypes_A.Stat = {'h';'p';'CI_lower';'CI_upper';'tstat';'df';'sd_min';'sd_max'};  % h = 1 rejecting the null hypothesis(mean are significantly different)
   % T_BetweenCondition.First = double(round(vpa(([h_Solo_vs_SemiSolo_First;p_Solo_vs_SemiSolo_First;ci_Solo_vs_SemiSolo_First;stat_Solo_vs_SemiSolo_First.tstat;stat_Solo_vs_SemiSolo_First.df;stat_Solo_vs_SemiSolo_First.sd])),3));
   % T_BetweenCondition.Simul = double(round(vpa(([h_Solo_vs_SemiSolo_Simul;p_Solo_vs_SemiSolo_Simul;ci_Solo_vs_SemiSolo_Simul;stat_Solo_vs_SemiSolo_Simul.tstat;stat_Solo_vs_SemiSolo_Simul.df;stat_Solo_vs_SemiSolo_Simul.sd])),3));
   % T_BetweenCondition.Second = double(round(vpa(([h_Solo_vs_SemiSolo_Second;p_Solo_vs_SemiSolo_Second;ci_Solo_vs_SemiSolo_Second;stat_Solo_vs_SemiSolo_Second.tstat;stat_Solo_vs_SemiSolo_Second.df;stat_Solo_vs_SemiSolo_Second.sd])),3));
  
   SoloVsDyadic_T_BetweenTaskTypes_A.First = num2str([h_Solo_vs_Dyadic_First_ActorA;p_Solo_vs_Dyadic_First_ActorA;ci_Solo_vs_Dyadic_First_ActorA;stat_Solo_vs_Dyadic_First_ActorA.tstat;stat_Solo_vs_Dyadic_First_ActorA.df;stat_Solo_vs_Dyadic_First_ActorA.sd],'%0.3f');
   SoloVsDyadic_T_BetweenTaskTypes_A.Simul = num2str([h_Solo_vs_Dyadic_Simul_ActorA;p_Solo_vs_Dyadic_Simul_ActorA;ci_Solo_vs_Dyadic_Simul_ActorA;stat_Solo_vs_Dyadic_Simul_ActorA.tstat;stat_Solo_vs_Dyadic_Simul_ActorA.df;stat_Solo_vs_Dyadic_Simul_ActorA.sd],'%0.3f');
   SoloVsDyadic_T_BetweenTaskTypes_A.Second = num2str([h_Solo_vs_Dyadic_Second_ActorA;p_Solo_vs_Dyadic_Second_ActorA;ci_Solo_vs_Dyadic_Second_ActorA;stat_Solo_vs_Dyadic_Second_ActorA.tstat;stat_Solo_vs_Dyadic_Second_ActorA.df;stat_Solo_vs_Dyadic_Second_ActorA.sd],'%0.3f');
   Statitical_Results.BetwTaskType_WithinSubj.Solo_vs_Dyadic.ActorA.TTest = SoloVsDyadic_T_BetweenTaskTypes_A;

   % non-paird-ttest (within subject within TaskType)
   [h_Dyadic_ActorA1_vs_ActorA2,p_Dyadic_ActorA1_vs_ActorA2,ci_Dyadic_ActorA1_vs_ActorA2,stat_Dyadic_ActorA1_vs_ActorA2] = ttest2(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Dyadic_ID),RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Dyadic_ID));
   [h_Dyadic_ActorA1_vs_Simul,p_Dyadic_ActorA1_vs_Simul,ci_Dyadic_ActorA1_vs_Simul,stat_Dyadic_ActorA1_vs_Simul] = ttest2(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Dyadic_ID),RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Dyadic_ID));
   [h_Dyadic_ActorA2_vs_Simul,p_Dyadic_ActorA2_vs_Simul,ci_Dyadic_ActorA2_vs_Simul,stat_Dyadic_ActorA2_vs_Simul] = ttest2(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Dyadic_ID),RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Dyadic_ID));

    %% table to show non-paird-ttest results (within subject within tasktype):
   Dyadic_T_WithinSubj_A = table;
   Dyadic_T_WithinSubj_A.Stat = {'h';'p';'CI_lower';'CI_upper';'tstat';'df';'sd'};  % h = 1 rejecting the null hypothesis(mean are significantly different)
   % T_BetweenCondition.First = double(round(vpa(([h_Solo_vs_SemiSolo_First;p_Solo_vs_SemiSolo_First;ci_Solo_vs_SemiSolo_First;stat_Solo_vs_SemiSolo_First.tstat;stat_Solo_vs_SemiSolo_First.df;stat_Solo_vs_SemiSolo_First.sd])),3));
   % T_BetweenCondition.Simul = double(round(vpa(([h_Solo_vs_SemiSolo_Simul;p_Solo_vs_SemiSolo_Simul;ci_Solo_vs_SemiSolo_Simul;stat_Solo_vs_SemiSolo_Simul.tstat;stat_Solo_vs_SemiSolo_Simul.df;stat_Solo_vs_SemiSolo_Simul.sd])),3));
   % T_BetweenCondition.Second = double(round(vpa(([h_Solo_vs_SemiSolo_Second;p_Solo_vs_SemiSolo_Second;ci_Solo_vs_SemiSolo_Second;stat_Solo_vs_SemiSolo_Second.tstat;stat_Solo_vs_SemiSolo_Second.df;stat_Solo_vs_SemiSolo_Second.sd])),3));
  
 
   Dyadic_T_WithinSubj_A.FirstvsSecond = num2str([h_Dyadic_ActorA1_vs_ActorA2;p_Dyadic_ActorA1_vs_ActorA2;ci_Dyadic_ActorA1_vs_ActorA2;stat_Dyadic_ActorA1_vs_ActorA2.tstat;stat_Dyadic_ActorA1_vs_ActorA2.df;stat_Dyadic_ActorA1_vs_ActorA2.sd],'%0.3f');
   Dyadic_T_WithinSubj_A.FirstvsSimul = num2str([h_Dyadic_ActorA1_vs_Simul;p_Dyadic_ActorA1_vs_Simul;ci_Dyadic_ActorA1_vs_Simul;stat_Dyadic_ActorA1_vs_Simul.tstat;stat_Dyadic_ActorA1_vs_Simul.df;stat_Dyadic_ActorA1_vs_Simul.sd],'%0.3f');
   Dyadic_T_WithinSubj_A.SecondvsSimul = num2str([h_Dyadic_ActorA2_vs_Simul;p_Dyadic_ActorA2_vs_Simul;ci_Dyadic_ActorA2_vs_Simul;stat_Dyadic_ActorA2_vs_Simul.tstat;stat_Dyadic_ActorA2_vs_Simul.df;stat_Dyadic_ActorA2_vs_Simul.sd],'%0.3f');
   Statitical_Results.WithinTaskType_WithinSubj.Dyadic.ActorA.TTest = Dyadic_T_WithinSubj_A;

   
   %% table to show paird-ttest results: (within tasktype, between the subject)
   T_WithinTaskTypes_BetwSubj_Dyadic = table; 
   T_WithinTaskTypes_BetwSubj_Dyadic.Stat = {'h';'p';'CI_lower';'CI_upper';'tstat';'df';'sd'};  % h = 1 rejecting the null hypothesis(mean are significantly different)
   % T_WithinCondition_SemiSolo.Monkey_First = double(round(vpa(([h_Monk1_Hum2;p_Monk1_Hum2;ci_Monk1_Hum2;stat_Monk1_Hum2.tstat;stat_Monk1_Hum2.df;stat_Monk1_Hum2.sd])),3))
   % T_WithinCondition_SemiSolo.Simulataneously = double(round(vpa(([h_Simul;p_Simul;ci_Simul;stat_Simul.tstat;stat_Simul.df;stat_Simul.sd])),3))
   % T_WithinCondition_SemiSolo.Monkey_Second = double(round(vpa(([h_Monk2_Hum1;p_Monk2_Hum1;ci_Monk2_Hum1;stat_Monk2_Hum1.tstat;stat_Monk2_Hum1.df;stat_Monk2_Hum1.sd])),3))

   T_WithinTaskTypes_BetwSubj_Dyadic.ActorA_First = num2str([h_ActorA1_ActorB2;p_ActorA1_ActorB2;ci_ActorA1_ActorB2;stat_ActorA1_ActorB2.tstat;stat_ActorA1_ActorB2.df;stat_ActorA1_ActorB2.sd],'%0.3f'); %printing the numbers to 5 values after the decimal
   T_WithinTaskTypes_BetwSubj_Dyadic.Simulataneously = num2str([h_Simul;p_Simul;ci_Simul;stat_Simul.tstat;stat_Simul.df;stat_Simul.sd],'%0.3f');
   T_WithinTaskTypes_BetwSubj_Dyadic.ActorA_Second = num2str([h_ActorA2_ActorB1;p_ActorA2_ActorB1;ci_ActorA2_ActorB1;stat_ActorA2_ActorB1.tstat;stat_ActorA2_ActorB1.df;stat_ActorA2_ActorB1.sd],'%0.3f');
   Statitical_Results.WithinTaskType_BetwSubj.Dyadic.TTest = T_WithinTaskTypes_BetwSubj_Dyadic;

   %% performing   2 way ANOVA for two factors affecting the RT of A (B): Timing and Task type
   figure;
   ResponseVariable_A = RT_A_ms_Rewarded;
   TaskType_A = TaskType_Rewarded_A'; 
   Timing_A = strings(size(diffGoSignalTime_ms_AllTrials,1),1); % intializing timing vector with nan
   Timing_A(Turn_ActorA_Simul_All_ID) = repelem({'Simul'},length(Turn_ActorA_Simul_All_ID));
   Timing_A(Turn_ActorA_First_All_ID) = repelem({'First'},length(Turn_ActorA_First_All_ID));
   Timing_A(Turn_ActorA_Second_All_ID) = repelem({'Second'},length(Turn_ActorA_Second_All_ID));

   Timing_A_Rewarded = Timing_A(TrialsBelong_ActorA_ID_Reward);  % Timing vector is from all trials, we need only rewarded
   [p_Anova_ActorA,tbl_Anova_ActorA,stats_Anova_ActorA,terms_Anova_ActorA] = anovan(ResponseVariable_A,{Timing_A_Rewarded,TaskType_A},'model',2,'varnames',{'Timing','TaskType'});
   [c_multcomp_ActorA,m_multcomp_ActorA,h_multcomp_ActorA,gnames_multcomp_ActorA] = multcompare(stats_Anova_ActorA,'Dimension',[1 2],'Ctype','bonferroni');

   Statitical_Results.FactorAnalysis_WithinSubj.DyadicSolo.TwoAnova.ActorA.p = p_Anova_ActorA;
   Statitical_Results.FactorAnalysis_WithinSubj.DyadicSolo.TwoAnova.ActorA.tbl = tbl_Anova_ActorA;
   Statitical_Results.FactorAnalysis_WithinSubj.DyadicSolo.TwoAnova.ActorA.stats = stats_Anova_ActorA;
   Statitical_Results.FactorAnalysis_WithinSubj.DyadicSolo.TwoAnova.ActorA.terms = terms_Anova_ActorA;

   Statitical_Results.FactorAnalysis_WithinSubj.DyadicSolo.MultiComp.ActorA.c = c_multcomp_ActorA;
   Statitical_Results.FactorAnalysis_WithinSubj.DyadicSolo.MultiComp.ActorA.m = m_multcomp_ActorA;
   Statitical_Results.FactorAnalysis_WithinSubj.DyadicSolo.MultiComp.ActorA.h = h_multcomp_ActorA;
   Statitical_Results.FactorAnalysis_WithinSubj.DyadicSolo.MultiComp.ActorA.gnames = gnames_multcomp_ActorA;
   

end


