function [AllSessions_Statitical_Results,Mean_RTDyadic_SoloADyadicSessions,SD_RTDyadic_SoloADyadicSessions LineSlopeDyadic] = bosa_RT_analysis_multiple_sessions_SOLOADyadic_DyadicFocus

run('SoloADyadicSessionsDyadicFocus_FullPath.m');               %% run the script to have the path for each session data
 
AllSessions_Statitical_Results = struct();   %% 2] Initializing structure for final statistical results of all sessions
                      
bins = [0:25:1000];                         %% Bin width for RT distribution


                                      %% counter to see if the code evaluates all sessions
c = 1;
report_struct_list = cell([1, numel(Session_SoloADyadic_DyadicFocusFullPath)]);
for SessNum = 1 : numel(Session_SoloADyadic_DyadicFocusFullPath)

    load(char(Session_SoloADyadic_DyadicFocusFullPath{SessNum}), 'report_struct');
    report_struct_list(SessNum) = {report_struct};
    

end

%% Going through SoloADyadic and extracting mean RT and SD RT
Mean_RTDyadic_SoloADyadicSessions = nan(numel(Session_SoloADyadic_DyadicFocusFullPath),3);  %initializng the mran RT matrix, 3 columns for 3 timings
SD_RTDyadic_SoloADyadicSessions  = nan(numel(Session_SoloADyadic_DyadicFocusFullPath),3); % the same for Standard deviation



for SessSolo =  1 : numel(Session_SoloADyadic_DyadicFocusFullPath)
    ID = SessSolo;

    %load(char(FullSessionPath{ID}));
    report_struct = report_struct_list{ID};
    loadedDATA = array2table(report_struct.data,'VariableNames',report_struct.header);
    Rewarded_Aborted  = report_struct.unique_lists.A_OutcomeENUM(loadedDATA.A_OutcomeENUM_idx); % this vector shows which trial was aborted, which was successful,
    Trial_TaskType_All = report_struct.unique_lists.A_TrialSubTypeENUM(loadedDATA.A_TrialSubTypeENUM_idx); % this vector shows trial type based on task.

    diffGoSignalTime_ms_AllTrials = loadedDATA.A_GoSignalTime_ms - loadedDATA.B_GoSignalTime_ms;
    RewardedID = find(strcmp(Rewarded_Aborted,'REWARD')); % indices of rewarded trials
    RT_A_ms_AllTrials  = loadedDATA.A_InitialFixationReleaseTime_ms - loadedDATA.A_GoSignalTime_ms;
    RT_A_ms_Rewarded  = RT_A_ms_AllTrials(RewardedID);
    DyadicID_All = find(strcmp(Trial_TaskType_All,'Dyadic'));
    Dyadic_AND_RewardedID = intersect(DyadicID_All,RewardedID); % I learned it from Igor!,insted of "AND rule filter" simply use builtin function "intersect"


    Turn_ActorA_Categ = {'first','second','simultaneously'}; % defining turn of actor in categorical data, later we will use this for plotting
    Turn_ActorA_Simul_All_ID = find(diffGoSignalTime_ms_AllTrials == 0); % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
    Turn_ActorA_Simul_Rewarded_ID = intersect(Turn_ActorA_Simul_All_ID,RewardedID); % Indices of trials that actor A and B acted simultaneously AND rewarded.
    Turn_ActorA_Simul_Rewarded_AND_Syadic_ID = intersect(Turn_ActorA_Simul_All_ID,Dyadic_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).




    Turn_ActorA_First_All_ID = find(diffGoSignalTime_ms_AllTrials<0);  % Indices of trials that actor A was the first (among all trials).
    Turn_ActorA_First_Rewarded_ID = intersect(Turn_ActorA_First_All_ID,RewardedID);% Indices of trials that actor A was the first (Rewarded trials).
    Turn_ActorA_First_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_First_All_ID,Dyadic_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).



    Turn_ActorA_Second_All_ID = find(diffGoSignalTime_ms_AllTrials>0); % Indices of trials that actor A was the second (among all trials).
    Turn_ActorA_Second_Rewarded_ID = intersect(Turn_ActorA_Second_All_ID,RewardedID); % Indices of trials that actor A was the second (Rewarded trials).
    Turn_ActorA_Second_Rewarded_AND_Solo_ID = intersect(Turn_ActorA_Second_All_ID,Dyadic_AND_RewardedID); % Indices of trials that actor A was the second (Rewarded trials in SemiSolo)

 %% calculating mean RT
    RT_FIRST = RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Dyadic_ID);
    if sum(RT_FIRST<0)>0
        RT_FIRST(RT_FIRST<0) = [];
    end
    Mean_RTDyadic_SoloADyadicSessions(SessSolo,1) = mean(RT_FIRST,'omitnan');
    SD_RTDyadic_SoloADyadicSessions(SessSolo,1) = std(RT_FIRST,'omitnan');

    
    
    RT_SIM = RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Syadic_ID);
    if sum(RT_SIM<0)>0
        RT_SIM(RT_SIM<0) = [];
    end
    Mean_RTDyadic_SoloADyadicSessions(SessSolo,2) = mean(RT_SIM,'omitnan');
    SD_RTDyadic_SoloADyadicSessions(SessSolo,2) = std(RT_SIM);
    

    RT_SECOND = RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID);
    if sum(RT_SECOND<0)>0
        RT_SECOND(RT_SECOND<0) = [];
    end
    Mean_RTDyadic_SoloADyadicSessions(SessSolo,3) = mean(RT_SECOND,'omitnan');
    SD_RTDyadic_SoloADyadicSessions(SessSolo,3) = std(RT_SECOND);



end


    %% plottig

figure
for S = 1 : numel(Session_SoloADyadic_DyadicFocusFullPath)
    plot(1:3,Mean_RTDyadic_SoloADyadicSessions(S,:),'o-')
    hold on
    xticks([1 2 3])
    xlim([0 4])
    xticklabels(["First","Simul","Second"])
end
title('Mean RT in Dyadic across sessions with Dyadic and SoloA')
%% Fitting a line to mean of the mean RTs with confidence bounds

X = repmat([1,2,3],size(Mean_RTDyadic_SoloADyadicSessions,1),1);
Y0 = Mean_RTDyadic_SoloADyadicSessions;
[p,S] = polyfit(X,Y0,1)
x1 = linspace(0,4,100)
y1 = polyval(p,x1)
hold on
plot(linspace(0,4,100),y1+mean(std(Y0)),'LineWidth',6)
LineSlopeDyadic = p;
%% Showing variance
figure
for S = 1 : numel(Session_SoloADyadic_DyadicFocusFullPath)
    plot(1:3,SD_RTDyadic_SoloADyadicSessions(S,:),'o-')
    hold on
    xticks([1 2 3])
    xlim([0 4])
    xticklabels(["First","Simul","Second"])
end
title('SD of RT ain Dyadic across sessions with Dyadic and SoloA')

%% Repeated measure anova  with one within factor timing


RESPONSE = Mean_RTDyadic_SoloADyadicSessions;
Timing = {'First', 'Simul', 'Second'};

% Create a table with the data and variable names
t = table(RESPONSE(:, 1), RESPONSE(:, 2), RESPONSE(:, 3), 'VariableNames', Timing);

% Define the within-subject factors as separate columns
PREDICTORS = table({'First'; 'Simul'; 'Second'}, 'VariableNames', {'Timing'});

% Perform the repeated measures ANOVA
rm = fitrm(t, 'First,Simul,Second~1', 'WithinDesign', PREDICTORS)
ranovaResults = ranova(rm)

AllSessions_Statitical_Results.Dyadic_timing_SoloADyadic = ranovaResults;

%% Plotting violin plots for Mean_RTSoloA_SoloASessions
figure
% Y1 = Mean_RTDyadic_SoloADyadicSessions(:,1);
% Y2 = Mean_RTDyadic_SoloADyadicSessions(:,2);
% Y3 = Mean_RTDyadic_SoloADyadicSessions(:,3);
% [f1,xi1,bw1] = ksdensity(Y1)
% [f2,xi2,bw2] = ksdensity(Y2)
% [f2,xi3,bw3] = ksdensity(Y3)
Y = Mean_RTDyadic_SoloADyadicSessions;
% V = violin(Y,'xlabel',{'First','Simult','Second'},'facecolor',[1 1 0;0 1 0;.3 .3 .3;0 0.3 0.1],'edgecolor','b',...
% 'bw',[bw1,bw2,bw3],...
% 'mc','k',...
% 'medc','r--')
CatName = cell({"First","Simult","Second"})
violinplot(Y,CatName)
ylabel('mean RT(ms)','FontSize',14)
ylim([min(min(Y))-70  max(max(Y))+70])
title('Dyadic among sessions with only SoloA')



