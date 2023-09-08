function [loadedDATA, report_struct,STAT_BETWEEN_SUBJ, STAT_WITHIN_SUBJ_A] = bosa_RT_analysis_one_session(DataFileName)

% STAT_BETWEEN_SUBJ % A vs B
% STAT_WITHIN_SUBJ_A
% STAT_WITHIN_SUBJ_B

% A colour is always red
% as sanity check look at the paper, figure 4, histogram of RT should be
% accordance with AT of that figure

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
% figure, plot(RewadValues_All(SoloA_AND_RewardedID),'o');  % this is a sanity check: if the SoloA_AND_RewardedID vector is extracted correctly, all values should be 2
SemiSolo_AND_RewardedID = intersect(SemiSoloID_All,RewardedID);
% figure, plot(RewadValues_All(SemiSolo_AND_RewardedID),'o') ; % this is a sanity check: if the SemiSolo_AND_RewardedID vector is extracted correctly, all values should be either 1 or 2

diffGoSignalTime_ms_AllTrials = loadedDATA.A_GoSignalTime_ms - loadedDATA.B_GoSignalTime_ms; % negative means actor A is first 
% initiation of each trial is by "Go signal", if we seperate Go signal time
% of each subject from each other, it will be clear who was the first
% actor, % pay attention this vector is all trials (aborted and rewarded)
diffGoSignalTime_ms_SemiSolo_AND_Rewarded = diffGoSignalTime_ms_AllTrials(SemiSolo_AND_RewardedID);
diffGoSignalTime_ms_Rewarded = diffGoSignalTime_ms_AllTrials(RewardedID); 
% figure, histogram(diffGoSignalTime_ms_Rewarded,100); % this is a sanity check: diffGoSignalTime_ms_Rewarded if is extracted correctly should have a bell shape histogram with mean around zero

RT_A_ms_AllTrials  = loadedDATA.A_InitialFixationReleaseTime_ms - loadedDATA.A_GoSignalTime_ms;
RT_B_ms_AllTrials  = loadedDATA.B_InitialFixationReleaseTime_ms - loadedDATA.B_GoSignalTime_ms;

RT_A_ms_Rewarded  = RT_A_ms_AllTrials(RewardedID);
RT_B_ms_Rewarded  = RT_B_ms_AllTrials(RewardedID);

RT_A_ms_Rewarded_AND_SemiSolo  = RT_A_ms_AllTrials(SemiSolo_AND_RewardedID);
RT_B_ms_Rewarded_AND_SemiSolo  = RT_B_ms_AllTrials(SemiSolo_AND_RewardedID);
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


Turn_ActorA_First_All_ID = find(diffGoSignalTime_ms_AllTrials<0);  % Indices of trials that actor A was the first (among all trials).
Turn_ActorA_First_Rewarded_ID = intersect(Turn_ActorA_First_All_ID,RewardedID);% Indices of trials that actor A was the first (Rewarded trials).
Turn_ActorA_First_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorA_First_All_ID,SemiSolo_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).
Turn_ActorA_First_Rewarded_AND_Solo_ID = intersect(Turn_ActorA_First_All_ID,SoloA_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).


Turn_ActorA_Second_All_ID = find(diffGoSignalTime_ms_AllTrials>0); % Indices of trials that actor A was the second (among all trials).
Turn_ActorA_Second_Rewarded_ID = intersect(Turn_ActorA_Second_All_ID,RewardedID); % Indices of trials that actor A was the second (Rewarded trials).
Turn_ActorA_Second_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorA_Second_All_ID,SemiSolo_AND_RewardedID); % Indices of trials that actor A was the second (Rewarded trials in SemiSolo).
Turn_ActorA_Second_Rewarded_AND_Solo_ID = intersect(Turn_ActorA_Second_All_ID,SoloA_AND_RewardedID); % Indices of trials that actor A was the second (Rewarded trials in SemiSolo).

%% Actor B: Pay attention that diffGoSignalTime_ms_AllTrials negative means actor A is first, so actor B is second (line 82, should be more than zero and line 85 should be less than zero)
Turn_ActorB_Simul_All_ID = Turn_ActorA_Simul_All_ID; % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
Turn_ActorB_Simul_Rewarded_ID = intersect(Turn_ActorB_Simul_All_ID,RewardedID); % Indices of trials that actor A and B acted simultaneously AND rewarded.
Turn_ActorB_Simul_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorB_Simul_All_ID,SemiSolo_AND_RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
Turn_ActorB_Simul_Rewarded_AND_Solo_ID = intersect(Turn_ActorB_Simul_All_ID,SoloA_AND_RewardedID);% Indices of trials that actor B was the first (Rewarded trials).

Turn_ActorB_First_All_ID = find(diffGoSignalTime_ms_AllTrials>0);  % Indices of trials that actor B was the first (among all trials).
Turn_ActorB_First_Rewarded_ID = intersect(Turn_ActorB_First_All_ID,RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
Turn_ActorB_First_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorB_First_All_ID,SemiSolo_AND_RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
Turn_ActorB_First_Rewarded_AND_Solo_ID = intersect(Turn_ActorB_First_All_ID,SoloA_AND_RewardedID);% Indices of trials that actor B was the first (Rewarded trials).

Turn_ActorB_Second_All_ID = find(diffGoSignalTime_ms_AllTrials<0); % Indices of trials that actor B was the second (among all trials).
Turn_ActorB_Second_Rewarded_ID = intersect(Turn_ActorB_Second_All_ID,RewardedID); % Indices of trials that actor B was the second (Rewarded trials).
Turn_ActorB_Second_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorB_Second_All_ID,SemiSolo_AND_RewardedID); % Indices of trials that actor B was the second (Rewarded trials).
Turn_ActorB_Second_Rewarded_AND_Solo_ID = intersect(Turn_ActorB_Second_All_ID,SoloA_AND_RewardedID); % Indices of trials that actor B was the second (Rewarded trials).


%% Main plot1 : We want to look at RT histograms when A was first vs when A was Second

bins = [0:25:1000];

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
%% showing all combinations of RTs in one 
figure
sh(1) = subplot(2,3,1);
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
[h_Monk1_Hum2,p_Monk1_Hum2,ci_Monk1_Hum2,stat_Monk1_Hum2] = ttest(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_SemiSolo_ID),RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_SemiSolo_ID));
% pbaspect([1 1 1])
%%
sh(2) = subplot(2,3,2);
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
[h_Simul,p_Simul,ci_Simul,stat_Simul] = ttest(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_SemiSolo_ID),RT_B_ms_AllTrials(Turn_ActorB_Simul_Rewarded_AND_SemiSolo_ID));
% pbaspect([1 1 1])
%%
sh(3) = subplot(2,3,3);
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
[h_Monk2_Hum1,p_Monk2_Hum1,ci_Monk2_Hum1,stat_Monk2_Hum1] = ttest(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_SemiSolo_ID),RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_SemiSolo_ID));
% pbaspect([1 1 1])
%% from here, we look at the "Solo" condition
sh(4) = subplot(2,3,4);
histogram(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
hold on
plot(mean(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','r')
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend('Curius',''); % for the legend, name of Actor_A is printed
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
[h_Solo_vs_SemiSolo_First,p_Solo_vs_SemiSolo_First,ci_Solo_vs_SemiSolo_First,stat_Solo_vs_SemiSolo_First] = ttest2(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Solo_ID),RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_SemiSolo_ID),'Vartype','unequal');
% pbaspect([1 1 1])
%%
sh(5) = subplot(2,3,5);
histogram(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
hold on
plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','r')
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend('Curius',''); % for the legend, name of Actor_A is printed
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
[h_Solo_vs_SemiSolo_Simul,p_Solo_vs_SemiSolo_Simul,ci_Solo_vs_SemiSolo_Simul,stat_Solo_vs_SemiSolo_Simul] = ttest2(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Solo_ID),RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_SemiSolo_ID),'Vartype','unequal');
% pbaspect([1 1 1])
%%
sh(6) = subplot(2,3,6);
histogram(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
hold on
plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','r')
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend('Curius',''); 
[h_Solo_vs_SemiSolo_Second,p_Solo_vs_SemiSolo_Second,ci_Solo_vs_SemiSolo_Second,stat_Solo_vs_SemiSolo_Second] = ttest2(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID),RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_SemiSolo_ID),'Vartype','unequal');
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
% pbaspect([1 1 1])
set(sh(:),'Xlim',[0 1000]);
% ig_set_axes_equal_lim(sh,'Ylim');
set(sh(:),'Ylim',[-0.01 0.25]);
% set(sh(:),'DataAspectRatio',[1 1 1])
sgtitle('Upper plots: Semi-solo task, Lower plots: solo task')

%% table to show paird-ttest results:
T_WithinCondition_SemiSolo = table; 
T_WithinCondition_SemiSolo.Stat = {'h';'p';'CI_lower';'CI_upper';'tstat';'df';'sd'}  % h = 1 rejecting the null hypothesis(mean are significantly different)
% T_WithinCondition_SemiSolo.Monkey_First = double(round(vpa(([h_Monk1_Hum2;p_Monk1_Hum2;ci_Monk1_Hum2;stat_Monk1_Hum2.tstat;stat_Monk1_Hum2.df;stat_Monk1_Hum2.sd])),3))
% T_WithinCondition_SemiSolo.Simulataneously = double(round(vpa(([h_Simul;p_Simul;ci_Simul;stat_Simul.tstat;stat_Simul.df;stat_Simul.sd])),3))
% T_WithinCondition_SemiSolo.Monkey_Second = double(round(vpa(([h_Monk2_Hum1;p_Monk2_Hum1;ci_Monk2_Hum1;stat_Monk2_Hum1.tstat;stat_Monk2_Hum1.df;stat_Monk2_Hum1.sd])),3))

T_WithinCondition_SemiSolo.Monkey_First = num2str([h_Monk1_Hum2;p_Monk1_Hum2;ci_Monk1_Hum2;stat_Monk1_Hum2.tstat;stat_Monk1_Hum2.df;stat_Monk1_Hum2.sd],'%0.3f'); %printing the numbers to 5 values after the decimal
T_WithinCondition_SemiSolo.Simulataneously = num2str([h_Simul;p_Simul;ci_Simul;stat_Simul.tstat;stat_Simul.df;stat_Simul.sd],'%0.3f');
T_WithinCondition_SemiSolo.Monkey_Second = num2str([h_Monk2_Hum1;p_Monk2_Hum1;ci_Monk2_Hum1;stat_Monk2_Hum1.tstat;stat_Monk2_Hum1.df;stat_Monk2_Hum1.sd],'%0.3f');

%% table to show non-paird-ttest results:
T_BetweenCondition = table;
T_BetweenCondition.Stat = {'h';'p';'CI_lower';'CI_upper';'tstat';'df';'sd_min';'sd_max'}  % h = 1 rejecting the null hypothesis(mean are significantly different)
% T_BetweenCondition.First = double(round(vpa(([h_Solo_vs_SemiSolo_First;p_Solo_vs_SemiSolo_First;ci_Solo_vs_SemiSolo_First;stat_Solo_vs_SemiSolo_First.tstat;stat_Solo_vs_SemiSolo_First.df;stat_Solo_vs_SemiSolo_First.sd])),3));
% T_BetweenCondition.Simul = double(round(vpa(([h_Solo_vs_SemiSolo_Simul;p_Solo_vs_SemiSolo_Simul;ci_Solo_vs_SemiSolo_Simul;stat_Solo_vs_SemiSolo_Simul.tstat;stat_Solo_vs_SemiSolo_Simul.df;stat_Solo_vs_SemiSolo_Simul.sd])),3));
% T_BetweenCondition.Second = double(round(vpa(([h_Solo_vs_SemiSolo_Second;p_Solo_vs_SemiSolo_Second;ci_Solo_vs_SemiSolo_Second;stat_Solo_vs_SemiSolo_Second.tstat;stat_Solo_vs_SemiSolo_Second.df;stat_Solo_vs_SemiSolo_Second.sd])),3));

T_BetweenCondition.First = num2str([h_Solo_vs_SemiSolo_First;p_Solo_vs_SemiSolo_First;ci_Solo_vs_SemiSolo_First;stat_Solo_vs_SemiSolo_First.tstat;stat_Solo_vs_SemiSolo_First.df;stat_Solo_vs_SemiSolo_First.sd],'%0.3f');
T_BetweenCondition.Simul = num2str([h_Solo_vs_SemiSolo_Simul;p_Solo_vs_SemiSolo_Simul;ci_Solo_vs_SemiSolo_Simul;stat_Solo_vs_SemiSolo_Simul.tstat;stat_Solo_vs_SemiSolo_Simul.df;stat_Solo_vs_SemiSolo_Simul.sd],'%0.3f');
T_BetweenCondition.Second = num2str([h_Solo_vs_SemiSolo_Second;p_Solo_vs_SemiSolo_Second;ci_Solo_vs_SemiSolo_Second;stat_Solo_vs_SemiSolo_Second.tstat;stat_Solo_vs_SemiSolo_Second.df;stat_Solo_vs_SemiSolo_Second.sd],'%0.3f');
%% Export as Excel file
excelFile_WithinCond = 'PairedTtest_RT_ActorSturn.xlsx';
writetable(T_WithinCondition_SemiSolo, excelFile_WithinCond);
excelFile_BetwCond = 'SemiSolo_vs_Solo_Ttest_RT_ActorSturn.xlsx';
writetable(T_BetweenCondition, excelFile_BetwCond);

%% reporting the statistics of t-test on the plot, p val, t and df
for st = 1 : 6
    if st < 4
        subtitletext{1} = strcat('p = ',table2array(T_WithinCondition_SemiSolo(2,st+1)));
        subtitletext{2} = strcat(sprintf('t(%d) = ',str2num(table2array(T_WithinCondition_SemiSolo(6,st+1)))),table2array(T_WithinCondition_SemiSolo(5,st+1)));
        subtitle(sh(st),char(subtitletext{1},subtitletext{2}))
    end
    if st > 3
        subtitletext{1} = strcat('p = ',table2array(T_BetweenCondition(2,st-2)));
        subtitletext{2} = strcat(sprintf('t(%0.2f) = ',str2num(table2array(T_BetweenCondition(6,st-2)))),table2array(T_BetweenCondition(5,st-2)));
        subtitle(sh(st),char(subtitletext{1},subtitletext{2}))
    end
end

%%
%% performing   2 way ANOVA for two factors affecting the RT of A: Timing and Task type
figure;
ResponseVariable_A = RT_A_ms_Rewarded;
TaskType_A = TaskType_Rewarded; 
Timing_A = strings(size(diffGoSignalTime_ms_AllTrials,1),1); % intializing timing vector with nan
Timing_A(Turn_ActorA_Simul_All_ID) = repelem({'Simul'},length(Turn_ActorA_Simul_All_ID));
Timing_A(Turn_ActorA_First_All_ID) = repelem({'First'},length(Turn_ActorA_First_All_ID));
Timing_A(Turn_ActorA_Second_All_ID) = repelem({'Second'},length(Turn_ActorA_Second_All_ID));

Timing_A_Rewarded = Timing_A(RewardedID);  % Timing vector is from all trials, we need only rewarded
[p,tbl,stats,terms] = anovan(ResponseVariable_A,{Timing_A_Rewarded,TaskType_A},'model',2,'varnames',{'Timing','TaskType'});
[c,m,h,gnames] = multcompare(stats,'Dimension',[1 2],'Ctype','bonferroni');

%% Creating structure to wrap up the statistical results

STAT_WITHIN_SUBJ_A.multcompareTest.c = c;
STAT_WITHIN_SUBJ_A.multcompareTest.m = m;
STAT_WITHIN_SUBJ_A.multcompareTest.h = h;
STAT_WITHIN_SUBJ_A.multcompareTest.gnames = gnames;

STAT_WITHIN_SUBJ_A.anovan.p = p;
STAT_WITHIN_SUBJ_A.anovan.tbl = tbl;
STAT_WITHIN_SUBJ_A.anovan.stats = stats;
STAT_WITHIN_SUBJ_A.anovan.terms = terms;
STAT_WITHIN_SUBJ_A.ttest_Solo_VS_SemiSolo = T_BetweenCondition;


STAT_BETWEEN_SUBJ.ttest.WithinCondition_SemiSolo = T_WithinCondition_SemiSolo;





% ...
