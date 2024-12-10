function [AllSessions_Statitical_Results,Mean_RTSoloA_SoloA_AllSessions,SD_RTSoloA_SoloA_AllSessions] = bosa_RT_analysis_multiple_sessions_SOLOA_AllCuriusHuman

ColorFor_SoloAplots = [128,0,128]./255;
run('SoloA_ALL_CuriusOnlySoloA_FullPath.m');               %% run the script to have the path for each session data
 
AllSessions_Statitical_Results = struct();   %% 2] Initializing structure for final statistical results of all sessions
                      
bins = [0:25:1000];                         %% Bin width for RT distribution


                                      %% counter to see if the code evaluates all sessions
c = 1;
report_struct_list = cell([1, numel(Session_SoloA_ALL_CuriusHuman_FullPath)]);
for SessNum = 1 : numel(Session_SoloA_ALL_CuriusHuman_FullPath)

    load(char(Session_SoloA_ALL_CuriusHuman_FullPath{SessNum}), 'report_struct');
    report_struct_list(SessNum) = {report_struct};
    

end

%% Going through SoloADyadic and extracting mean RT and SD RT
Mean_RTSoloA_SoloA_AllSessions = nan(numel(Session_SoloA_ALL_CuriusHuman_FullPath),3);  %initializng the mran RT matrix, 3 columns for 3 timings
SD_RTSoloA_SoloA_AllSessions  = nan(numel(Session_SoloA_ALL_CuriusHuman_FullPath),3); % the same for Standard deviation
WholeTrials = 0;
WholeSessNum = numel(Session_SoloA_ALL_CuriusHuman_FullPath);


for SessSolo =  1 : numel(Session_SoloA_ALL_CuriusHuman_FullPath)
    ID = SessSolo;

    %load(char(FullSessionPath{ID}));
    report_struct = report_struct_list{ID};
    loadedDATA = array2table(report_struct.data,'VariableNames',report_struct.header);
    Rewarded_Aborted  = report_struct.unique_lists.A_OutcomeENUM(loadedDATA.A_OutcomeENUM_idx); % this vector shows which trial was aborted, which was successful,
    Trial_TaskType_All = report_struct.unique_lists.A_TrialSubTypeENUM(loadedDATA.A_TrialSubTypeENUM_idx); % this vector shows trial type based on task.
    WholeTrials = WholeTrials+numel(Rewarded_Aborted);


    diffGoSignalTime_ms_AllTrials = loadedDATA.A_GoSignalTime_ms - loadedDATA.B_GoSignalTime_ms;
    RewardedID = find(strcmp(Rewarded_Aborted,'REWARD')); % indices of rewarded trials
    RT_A_ms_AllTrials  = loadedDATA.A_InitialFixationReleaseTime_ms - loadedDATA.A_GoSignalTime_ms;
    RT_A_ms_Rewarded  = RT_A_ms_AllTrials(RewardedID);
    SoloAID_All = find(strcmp(Trial_TaskType_All,'SoloA'));
    SoloA_AND_RewardedID = intersect(SoloAID_All,RewardedID); % I learned it from Igor!,insted of "AND rule filter" simply use builtin function "intersect"


    Turn_ActorA_Categ = {'first','second','simultaneously'}; % defining turn of actor in categorical data, later we will use this for plotting
    Turn_ActorA_Simul_All_ID = find(diffGoSignalTime_ms_AllTrials == 0); % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
    Turn_ActorA_Simul_Rewarded_ID = intersect(Turn_ActorA_Simul_All_ID,RewardedID); % Indices of trials that actor A and B acted simultaneously AND rewarded.
    Turn_ActorA_Simul_Rewarded_AND_Solo_ID = intersect(Turn_ActorA_Simul_All_ID,SoloA_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).




    Turn_ActorA_First_All_ID = find(diffGoSignalTime_ms_AllTrials<0);  % Indices of trials that actor A was the first (among all trials).
    Turn_ActorA_First_Rewarded_ID = intersect(Turn_ActorA_First_All_ID,RewardedID);% Indices of trials that actor A was the first (Rewarded trials).
    Turn_ActorA_First_Rewarded_AND_Solo_ID = intersect(Turn_ActorA_First_All_ID,SoloA_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).



    Turn_ActorA_Second_All_ID = find(diffGoSignalTime_ms_AllTrials>0); % Indices of trials that actor A was the second (among all trials).
    Turn_ActorA_Second_Rewarded_ID = intersect(Turn_ActorA_Second_All_ID,RewardedID); % Indices of trials that actor A was the second (Rewarded trials).
    Turn_ActorA_Second_Rewarded_AND_Solo_ID = intersect(Turn_ActorA_Second_All_ID,SoloA_AND_RewardedID); % Indices of trials that actor A was the second (Rewarded trials in SemiSolo)

 %% calculating mean RT
    RT_FIRST = RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Solo_ID);
    if sum(RT_FIRST<0)>0
        RT_FIRST(RT_FIRST<0) = [];
    end
    Mean_RTSoloA_SoloA_AllSessions(SessSolo,1) = mean(RT_FIRST,'omitnan');
    SD_RTSoloA_SoloA_AllSessions(SessSolo,1) = std(RT_FIRST,'omitnan');

    
    
    RT_SIM = RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Solo_ID);
    if sum(RT_SIM<0)>0
        RT_SIM(RT_SIM<0) = [];
    end
    Mean_RTSoloA_SoloA_AllSessions(SessSolo,2) = mean(RT_SIM,'omitnan');
    SD_RTSoloA_SoloA_AllSessions(SessSolo,2) = std(RT_SIM);
    

    RT_SECOND = RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID);
    if sum(RT_SECOND<0)>0
        RT_SECOND(RT_SECOND<0) = [];
    end
    Mean_RTSoloA_SoloA_AllSessions(SessSolo,3) = mean(RT_SECOND,'omitnan');
    SD_RTSoloA_SoloA_AllSessions(SessSolo,3) = std(RT_SECOND);



end


    %% plottig

figure
for S = 1 : numel(Session_SoloA_ALL_CuriusHuman_FullPath)
    plot(1:3,Mean_RTSoloA_SoloA_AllSessions(S,:),'o-','MarkerFaceColor',ColorFor_SoloAplots,'Color',ColorFor_SoloAplots)
    hold on
    xticks([1 2 3])
    xlim([0 4])
    ylim([400 700])
    xticklabels(["First","Simul","Second"])
end
title('Mean RT of Monkey, SoloA condition among all sessions')
subtitle_Text = strcat('number of trials:'," ",string(WholeTrials),", ",'number of sessions:',string(WholeSessNum))
subtitle(subtitle_Text)
fig1 = gcf;
% figure
% for S = 1 : numel(Session_SoloADyadic_FullPath)
%     plot(1:3,SD_RTSoloA_SoloA_AllSessions(S,:),'o-')
%     hold on
%     xticks([1 2 3])
%     xlim([0 4])
%     xticklabels(["First","Simul","Second"])
% end
% title('SD of RT across sessions, among three timing')

%% Repeated measure anova  with one within factor timing


RESPONSE = Mean_RTSoloA_SoloA_AllSessions;
Timing = {'First', 'Simul', 'Second'};

% Create a table with the data and variable names
t = table(RESPONSE(:, 1), RESPONSE(:, 2), RESPONSE(:, 3), 'VariableNames', Timing);

% Define the within-subject factors as separate columns
PREDICTORS = table({'First'; 'Simul'; 'Second'}, 'VariableNames', {'Timing'});

% Perform the repeated measures ANOVA
rm = fitrm(t, 'First,Simul,Second~1', 'WithinDesign', PREDICTORS)
[ranovaResults,D] = ranova(rm)

AllSessions_Statitical_Results.SOLOA_timing_SoloADyadic = ranovaResults;

%% Plotting violin plots for Mean_RTSoloA_SoloASessions
figure
Y = Mean_RTSoloA_SoloA_AllSessions;
CatName = cell({"First","Simult","Second"});
violinplot(Y,CatName,'ViolinColor',ColorFor_SoloAplots)
ylabel('mean RT of Monkey(ms)','FontSize',14)
ylim([400 700])
title('SoloA condition among all session')
subtitle(subtitle_Text)
fig2 = gcf;
%% Printing out the figures
% Set the figure properties for high-quality output

fig1.Renderer = 'Painters';  % Set the renderer to painters for vector graphics
fig2.Renderer = 'Painters';  % Set the renderer to painters for vector graphics

% Specify the file name and save as SVG
file1_name = 'SoloACurius_AllSess_MeanRT.pdf';
file2_name = 'SoloACurius_AllSess_ViolinRT.pdf';
% saveas(fig1, file1_name, 'svg');
% saveas(fig2, file2_name, 'svg');

exportgraphics(fig1,sprintf(file1_name),'Resolution',600);

exportgraphics(fig2,sprintf(file2_name),'Resolution',600);






