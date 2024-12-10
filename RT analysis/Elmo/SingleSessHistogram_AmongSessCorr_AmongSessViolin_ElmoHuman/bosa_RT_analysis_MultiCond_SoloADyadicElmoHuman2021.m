function [ranovatbl,D,Mean_RTDyadic_SoloADyadicSessions,SD_RTDyadic_SoloADyadicSessions ] = bosa_RT_analysis_MultiCond_SoloADyadicElmoHuman2021
ColorFor_Dyadicplots = [0 153 153]./255;
ColorFor_SoloAplots = [128,0,128]./255;

 %run('ElmoBHuman2023EphysDyadicSoloB_FullPath'); 
 run('ElmoA_Human2021EphysDyadicSoloB_FullPath'); 

                      
bins = [0:25:1000]; %% Bin width for RT distribution
% FullSessPath = ElmoB_Human2023EphysFullSessionPath;
FullSessPath = ElmoA_Human2021EphysFullSessionPath
for SessNum = 1 : numel(FullSessPath)

    load(char(FullSessPath{SessNum}), 'report_struct');
    report_struct_list(SessNum) = {report_struct};
    Pat4FieldName = digitsPattern; %pattern to detect 6 digit number, the goal is to remove '.' from the months names
        FullNme = FullSessPath{SessNum};
        NeededVar = extract(FullNme,Pat4FieldName);
        Sessions_SoloADyadic_Name{SessNum} = NeededVar{8};
        Sessions_SoloADyadic_FullPath{SessNum} = FullNme;
    

end

WholeTrials = 0;
WholeSessNum = numel(FullSessPath);

%% Going through SolobDyadic and extracting mean RT and SD RT

Mean_RTDyadic_SoloADyadicSessions = nan(numel(FullSessPath),3);  %initializng the mran RT matrix, 3 columns for 3 timings
SD_RTDyadic_SoloADyadicSessions  = nan(numel(FullSessPath),3); % the same for Standard deviation

Mean_RTSoloA_SoloADyadicSessions = nan(numel(FullSessPath),3);  %initializng the mran RT matrix, 3 columns for 3 timings
SD_RTSoloA_SoloADyadicSessions  = nan(numel(FullSessPath),3); % the same for Standard deviation




for SessSolo =  1 : numel(FullSessPath)
   
    %load(char(FullSessionPath{ID}));
    report_struct = report_struct_list{SessSolo};
    loadedDATA = array2table(report_struct.data,'VariableNames',report_struct.header);
    if SessSolo == 16
       loadedDATA.A_TrialSubTypeENUM_idx(508) = 1; % we found out on trial 508 of session 20210608 the idx is wrong
    end
    Rewarded_Aborted  = report_struct.unique_lists.A_OutcomeENUM(loadedDATA.A_OutcomeENUM_idx); % this vector shows which trial was aborted, which was successful,
    Trial_TaskType_All = report_struct.unique_lists.A_TrialSubTypeENUM(loadedDATA.A_TrialSubTypeENUM_idx); % this vector shows trial type based on task.
    WholeTrials = WholeTrials+numel(Rewarded_Aborted);
    Actor_A = string(report_struct.unique_lists.A_Name);
    Actor_B = "Human";


    diffGoSignalTime_ms_AllTrials = loadedDATA.A_GoSignalTime_ms - loadedDATA.B_GoSignalTime_ms;
    RewardedID = find(strcmp(Rewarded_Aborted,'REWARD')); % indices of rewarded trials

    RT_B_ms_AllTrials  = loadedDATA.B_InitialFixationReleaseTime_ms - loadedDATA.B_GoSignalTime_ms;
    RT_B_ms_Rewarded  = RT_B_ms_AllTrials(RewardedID);

    RT_A_ms_AllTrials  = loadedDATA.A_InitialFixationReleaseTime_ms - loadedDATA.A_GoSignalTime_ms;
    RT_A_ms_Rewarded  = RT_A_ms_AllTrials(RewardedID);

    DyadicID_All = find(strcmp(Trial_TaskType_All,'Dyadic'));
    Dyadic_AND_RewardedID = intersect(DyadicID_All,RewardedID); 


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
    SoloBID_All = find(strcmp(Trial_TaskType_All,'SoloB'));
    SoloB_AND_RewardedID = intersect(SoloBID_All,RewardedID);

    SoloAID_All = find(strcmp(Trial_TaskType_All,'SoloA'));
    SoloA_AND_RewardedID = intersect(SoloAID_All,RewardedID);
%% Actor B

    Turn_ActorB_Categ = {'first','second','simultaneously'}; % defining turn of actor in categorical data, later we will use this for plotting
    Turn_ActorB_Simul_All_ID = find(diffGoSignalTime_ms_AllTrials == 0); % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
    Turn_ActorB_Simul_Rewarded_ID = intersect(Turn_ActorB_Simul_All_ID,RewardedID); % Indices of trials that actor A and B acted simultaneously AND rewarded.
    Turn_ActorB_Simul_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorB_Simul_All_ID,Dyadic_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).
    Turn_ActorB_Simul_Rewarded_AND_SoloB_ID = intersect(Turn_ActorB_Simul_All_ID,SoloB_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).




    Turn_ActorB_First_All_ID = find(diffGoSignalTime_ms_AllTrials>0);  % Indices of trials that actor A was the first (among all trials).
    Turn_ActorB_First_Rewarded_ID = intersect(Turn_ActorB_First_All_ID,RewardedID);% Indices of trials that actor A was the first (Rewarded trials).
    Turn_ActorB_First_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorB_First_All_ID,Dyadic_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).
    Turn_ActorB_First_Rewarded_AND_SoloB_ID = intersect(Turn_ActorB_First_All_ID,SoloB_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).



    Turn_ActorB_Second_All_ID = find(diffGoSignalTime_ms_AllTrials<0); % Indices of trials that actor A was the second (among all trials).
    Turn_ActorB_Second_Rewarded_ID = intersect(Turn_ActorB_Second_All_ID,RewardedID); % Indices of trials that actor A was the second (Rewarded trials).
    Turn_ActorB_Second_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorB_Second_All_ID,Dyadic_AND_RewardedID); % Indices of trials that actor A was the second (Rewarded trials in SemiSolo)
    Turn_ActorB_Second_Rewarded_AND_SoloB_ID = intersect(Turn_ActorB_Second_All_ID,SoloB_AND_RewardedID); % Indices of trials that actor A was the second (Rewarded trials in SemiSolo)

%% Actor A:
Turn_ActorA_Categ = {'first','second','simultaneously'}; % defining turn of actor in categorical data, later we will use this for plotting
Turn_ActorA_Simul_All_ID = find(diffGoSignalTime_ms_AllTrials == 0); % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
Turn_ActorA_Simul_Rewarded_ID = intersect(Turn_ActorA_Simul_All_ID,RewardedID); % Indices of trials that actor A and B acted simultaneously AND rewarded.
Turn_ActorA_Simul_Rewarded_AND_SoloA_ID = intersect(Turn_ActorA_Simul_All_ID,SoloA_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).
Turn_ActorA_Simul_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_Simul_All_ID,Dyadic_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in Dyadic).



Turn_ActorA_First_All_ID = find(diffGoSignalTime_ms_AllTrials<0);  % Indices of trials that actor A was the first (among all trials).
Turn_ActorA_First_Rewarded_ID = intersect(Turn_ActorA_First_All_ID,RewardedID);% Indices of trials that actor A was the first (Rewarded trials).
Turn_ActorA_First_Rewarded_AND_SoloA_ID = intersect(Turn_ActorA_First_All_ID,SoloA_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).
Turn_ActorA_First_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_First_All_ID,Dyadic_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in Dyadic).



Turn_ActorA_Second_All_ID = find(diffGoSignalTime_ms_AllTrials>0); % Indices of trials that actor A was the second (among all trials).
Turn_ActorA_Second_Rewarded_ID = intersect(Turn_ActorA_Second_All_ID,RewardedID); % Indices of trials that actor A was the second (Rewarded trials).
Turn_ActorA_Second_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_Second_All_ID,Dyadic_AND_RewardedID);
Turn_ActorA_Second_Rewarded_AND_SoloA_ID = intersect(Turn_ActorA_Second_All_ID,SoloA_AND_RewardedID); % Indices of trials that actor A was the second (Rewarded trials in SemiSolo).



 %% calculating mean RT

 %%First Dyadic
    RTDyadic_FIRST = RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Dyadic_ID);
    if sum(RTDyadic_FIRST<0)>0
        RTDyadic_FIRST(RTDyadic_FIRST<0) = [];
    end
    Mean_RTDyadic_SoloADyadicSessions(SessSolo,1) = mean(RTDyadic_FIRST,'omitnan');
    SD_RTDyadic_SoloADyadicSessions(SessSolo,1) = std(RTDyadic_FIRST,'omitnan');

 %%First Solo A
    RTSoloA_FIRST = RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_SoloA_ID);
    if sum(RTSoloA_FIRST<0)>0
        RTSoloA_FIRST(RTSoloA_FIRST<0) = [];
    end
    Mean_RTSoloA_SoloADyadicSessions(SessSolo,1) = mean(RTSoloA_FIRST,'omitnan');
    SD_RTSoloA_SoloADyadicSessions(SessSolo,1) = std(RTSoloA_FIRST,'omitnan');

   %%Simul Dyadic

    RT_SIM = RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Dyadic_ID);
    if sum(RT_SIM<0)>0
        RT_SIM(RT_SIM<0) = [];
    end
    Mean_RTDyadic_SoloADyadicSessions(SessSolo,2) = mean(RT_SIM,'omitnan');
    SD_RTDyadic_SoloADyadicSessions(SessSolo,2) = std(RT_SIM);

    %%Simul Solo A
     RT_SIMSoloA = RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_SoloA_ID);
    if sum(RT_SIMSoloA<0)>0
        RT_SIMSoloA(RT_SIMSoloA<0) = [];
    end
    Mean_RTSoloA_SoloADyadicSessions(SessSolo,2) = mean(RT_SIMSoloA,'omitnan');
    SD_RTSoloA_SoloADyadicSessions(SessSolo,2) = std(RT_SIMSoloA);



    %%Second Dyadic
    RT_SECOND = RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Dyadic_ID);
    if sum(RT_SECOND<0)>0
        RT_SECOND(RT_SECOND<0) = [];
    end
    Mean_RTDyadic_SoloADyadicSessions(SessSolo,3) = mean(RT_SECOND,'omitnan');
    SD_RTDyadic_SoloADyadicSessions(SessSolo,3) = std(RT_SECOND);
    %%Second SoloA

     RTSoloA_SECOND = RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_SoloA_ID);
    if sum(RTSoloA_SECOND<0)>0
        RTSoloA_SECOND(RTSoloA_SECOND<0) = [];
    end
    Mean_RTSoloA_SoloADyadicSessions(SessSolo,3) = mean(RTSoloA_SECOND,'omitnan');
    SD_RTSoloA_SoloADyadicSessions(SessSolo,3) = std(RTSoloA_SECOND);
%% RT histograms
figure
sh(1) = subplot(2,3,1);
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
ylabel('% of trials');
subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Dyadic_ID)))); ...
    strcat(sprintf(Actor_B),':','trial number =',string(numel(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_Dyadic_ID))))};
subtitle(subtitletxt);
% pbaspect([1 1 1])
%%
sh(2) = subplot(2,3,2);
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
ylabel('% of trials');
subtitletxt = {strcat(sprintf(Actor_A),' and ',sprintf(Actor_B),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Dyadic_ID))))};
subtitle(subtitletxt);
% pbaspect([1 1 1])
%%
sh(3) = subplot(2,3,3);
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
ylabel('% of trials');
subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Dyadic_ID))));strcat(sprintf(Actor_B),':','trial number =', ...
    string(numel(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_Dyadic_ID))))};
subtitle(subtitletxt);
% pbaspect([1 1 1])
%% from here, we look at the "Solo" condition

sh(4) = subplot(2,3,4);
histogram(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_SoloA_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
hold on
plot(mean(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_SoloA_ID)),-0.005,"^",'Color','r')

histogram(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_SoloB_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','b','FaceAlpha',0.1) % Igor said it is better to show y-axis as percent instead of count,
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
plot(mean(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_SoloB_ID)),-0.005,"^",'Color','b')
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend(sprintf(Actor_A),'',sprintf(Actor_B),''); % for the legend, name of Actor_A is printed
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_SoloA_ID))));...
    strcat(sprintf(Actor_B),':','trial number =',string(numel(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_SoloB_ID))))};
subtitle(subtitletxt);
% pbaspect([1 1 1])
%%
sh(5) = subplot(2,3,5);
histogram(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_SoloA_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
hold on
plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_SoloA_ID)),-0.005,"^",'Color','r')

histogram(RT_B_ms_AllTrials(Turn_ActorB_Simul_Rewarded_AND_SoloB_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','b','FaceAlpha',0.1) % Igor said it is better to show y-axis as percent instead of count,
plot(mean(RT_B_ms_AllTrials(Turn_ActorB_Simul_Rewarded_AND_SoloB_ID)),-0.005,"^",'Color','b')
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend(sprintf(Actor_A),'',sprintf(Actor_B),''); % for the legend, name of Actor_A is printed
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_SoloA_ID))));...
    strcat(sprintf(Actor_B),':','trial number =',string(numel(RT_B_ms_AllTrials(Turn_ActorB_Simul_Rewarded_AND_SoloB_ID))))};
subtitle(subtitletxt);
title('nominally simultaneously')
% pbaspect([1 1 1])
%%
sh(6) = subplot(2,3,6);
histogram(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_SoloA_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
hold on
plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_SoloA_ID)),-0.005,"^",'Color','r')

histogram(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_SoloB_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','b','FaceAlpha',0.1) % Igor said it is better to show y-axis as percent instead of count,
plot(mean(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_SoloB_ID)),-0.005,"^",'Color','b')
% if you set 'Normalization' to probability and then multiply it by 100,
% this works same as "ig_hist2per function"
set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
legend(sprintf(Actor_A),'',sprintf(Actor_B),''); % for the legend, name of Actor_A is printed
xlabel('reaction time(ms), bin width = 50 ms');
ylabel('% of trials');
subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_SoloA_ID))));...
    strcat(sprintf(Actor_B),':','trial number =',string(numel(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_SoloB_ID))))};
subtitle(subtitletxt);
% pbaspect([1 1 1])
set(sh(:),'Xlim',[0 1000]);
% ig_set_axes_equal_lim(sh,'Ylim');
set(sh(:),'Ylim',[-0.01 0.3]);
% set(sh(:),'DataAspectRatio',[1 1 1])
annotation('textbox',...
    [0.0442291666666667 0.780777537796975 0.0474375 0.0377969762418982],...
    'String','Dyadic',...
    'FitBoxToText','off');

annotation('textbox',...
    [0.0442291666666667 0.197624190064795 0.0474375 0.0377969762418982],...
    'String',{'SoloA'},...
    'FitBoxToText','off');

sgtitle('Session with  Dyadic and SoloA , (ELmoA vs HumanB)')
TX = Sessions_SoloADyadic_Name{SessSolo}
annotation('textbox',...
    [0.491104166666664 0.892008639308845 0.04275 0.0367170626349878],...
    'String',TX,...
    'FitBoxToText','on');
figSingleSess = gcf;
newWidth =1000;
newHeight = 800;
% Change the size of the figure using the 'Position' property
set(gcf, 'Position', [100, 100, newWidth, newHeight])
SingleSessFileName = strcat(TX,'.jpg')
saveas(figSingleSess, SingleSessFileName, 'jpg')

end
% fig0 = gcf;
%% plottig

figure
for S = 1 : size(Mean_RTDyadic_SoloADyadicSessions,1)
    plot(1:3,Mean_RTDyadic_SoloADyadicSessions(S,:),'o-','MarkerFaceColor',ColorFor_Dyadicplots,'Color',ColorFor_Dyadicplots)
    hold on
    xticks([1 2 3])
    xlim([0 4])
    xticklabels(["First","Simul","Second"])
end
for S = 1 : size(Mean_RTSoloA_SoloADyadicSessions,1)
    plot(1:3,Mean_RTSoloA_SoloADyadicSessions(S,:),'o-','MarkerFaceColor',ColorFor_SoloAplots,'Color',ColorFor_SoloAplots)
    hold on
    xticks([1 2 3])
    xlim([0 4])
    xticklabels(["First","Simul","Second"])
end
title('Mean RT of Elmo in sessions 2021 with Dyadic and SoloA conditions')
subtitle_Text = strcat('number of trials:'," ",string(WholeTrials),", ",'number of sessions:',string(WholeSessNum))
subtitle(subtitle_Text)
legend('Dyadic','SoloA')
fig1 = gcf;





%% Plotting violin plots for Mean_RTSoloA_DyadicSessions
figure

YDyadic = Mean_RTDyadic_SoloADyadicSessions;

CatName = cell({"First","Simult","Second"})
violinplot(YDyadic,CatName,'ViolinColor',ColorFor_Dyadicplots)
hold on
YSoloA = Mean_RTSoloA_SoloADyadicSessions
violinplot(YSoloA,CatName,'ViolinColor',ColorFor_SoloAplots)
ylabel('mean RT(ms)','FontSize',14)
title('RT of Elmo among sessions 2021 with Dyadic and SoloA','magenta: dyadic, blue: SoloA')
subtitle(subtitle_Text)
% fig2 = gcf;

% Repeated measure anova  with two  factor timing and task


Y = [Mean_RTDyadic_SoloADyadicSessions Mean_RTSoloA_SoloADyadicSessions];

between = table(Y(:,1),Y(:,2),Y(:,3),Y(:,4),Y(:,5),Y(:,6),...
'VariableNames',{'first_dyad', 'simul_dyad', 'second_dyad', 'first_solo', 'simul_solo', 'second_solo',});

within = table(['1'	'2'	'3'	'1'	'2'	'3']',['1' '1' '1' '2' '2' '2']','VariableNames',{'Timing','Task'}); 

rm = fitrm(between,'first_dyad,simul_dyad,second_dyad,first_solo,simul_solo,second_solo ~ 1','WithinDesign',within);
[ranovatbl,D] = ranova(rm,'WithinModel','Timing*Task')

fig2 = gcf;
%% Printing out the figures
% Set the figure properties for high-quality output

% fig0.Renderer = 'Painters';  % Set the renderer to painters for vector graphics
fig1.Renderer = 'Painters';  % Set the renderer to painters for vector graphics
fig2.Renderer = 'Painters';  % Set the renderer to painters for vector graphics

% Specify the file name and save as SVG
% file0_name = 'ElmoA_Curius_DyadicSolo_RTHist.svg';
file1_name = 'ElmoA2021_HumanB_DyadicSolo_MeanRT.svg';
file2_name = 'ElmoA2021_HumanB_DyadicSolo_ViolinPlot.svg';

% saveas(fig0, file0_name, 'svg');

% saveas(fig1, file1_name, 'svg');
% saveas(fig2, file2_name, 'svg');

%% Scatter plot: 
% x-axis: mean RT of Elmo at each session at each timing (first,...) at SOLOA
% Y-axis: mean RT of Elmo at each session at each timing (first,...) at
% DYADIC
figure;
for Timing = 1 : 3
    SZ = corrcoef(Mean_RTSoloA_SoloADyadicSessions(Timing,:),Mean_RTDyadic_SoloADyadicSessions(Timing,:));
    SZ_EACH = (SZ(2)*100);
    sz_each(Timing) = SZ(2);
    if Timing == 1
       C = [102 0 204]./255;
    end
    if Timing == 2
       C = [255 51 255]./255;
    end
    if Timing == 3
       C = [255 153 204]./255;
    end
    scatter(Mean_RTSoloA_SoloADyadicSessions(:,Timing),Mean_RTDyadic_SoloADyadicSessions(:,Timing),SZ_EACH,C,'filled')
    hold on
end

plot(250:800,250:800,'--','color',[0.5 0.5 0.5])
legend('first','simult','second','criterion line: x = y','Position',[0.624166662511372 0.140555551922511 0.265357147012438 0.165476194109235])
subtitle('Pearson correlation coefficioent: first = 0.45, simul = 0.49, second = 0.57')
xlabel('RT of Elmo in SoloA condition among sessions with SoloA and Dyadic,(ms)')
ylabel('RT of Elmo in Dyadic condition among sessions with SoloA and Dyadic,(ms)')

% ElmoMean_RTDyadic_SoloADyadicSessions = Mean_RTDyadic_SoloADyadicSessions;
% ElmoMean_RTSoloA_SoloADyadicSessions = Mean_RTSoloA_SoloADyadicSessions;

% save('ELMO_DyadicRT','ElmoMean_RTDyadic_SoloADyadicSessions')
% save('ELMO_SoloART','ElmoMean_RTSoloA_SoloADyadicSessions')





