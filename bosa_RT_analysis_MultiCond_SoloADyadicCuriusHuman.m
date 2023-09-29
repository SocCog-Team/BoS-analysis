function [AllSessions_Statitical_Results,Mean_RTDyadic_SoloADyadicSessions,SD_RTDyadic_SoloADyadicSessions ] = bosa_RT_analysis_MultiCond_SoloADyadicCuriusHuman
ColorFor_Dyadicplots = [0 153 153]./255;
ColorFor_SoloAplots = [128,0,128]./255;

run('MultiCondSoloADyadicSessions_FullPath');               %% run the script to have the path for each session data
 
AllSessions_Statitical_Results = struct();   %% 2] Initializing structure for final statistical results of all sessions
                      
bins = [0:25:1000];                         %% Bin width for RT distribution


                                      %% counter to see if the code evaluates all sessions

report_struct_list = cell([1, numel(SessionsMultiCond_SoloADyadic_FullPath)]);
for SessNum = 1 : numel(SessionsMultiCond_SoloADyadic_FullPath)

    load(char(SessionsMultiCond_SoloADyadic_FullPath{SessNum}), 'report_struct');
    report_struct_list(SessNum) = {report_struct};
    Pat4FieldName = digitsPattern; %pattern to detect 6 digit number, the goal is to remove '.' from the months names
        FullNme = SessionsMultiCond_SoloADyadic_FullPath{SessNum};
        NeededVar = extract(FullNme,Pat4FieldName);
        Sessions_SoloADyadic_Name{SessNum} = NeededVar{8};
        Sessions_SoloADyadic_FullPath{SessNum} = FullNme;
    

end

WholeTrials = 0;
WholeSessNum = numel(SessionsMultiCond_SoloADyadic_FullPath);

%% Going through SoloADyadic and extracting mean RT and SD RT

Mean_RTDyadic_SoloADyadicSessions = nan(numel(SessionsMultiCond_SoloADyadic_FullPath),3);  %initializng the mran RT matrix, 3 columns for 3 timings
SD_RTDyadic_SoloADyadicSessions  = nan(numel(SessionsMultiCond_SoloADyadic_FullPath),3); % the same for Standard deviation

Mean_RTSoloA_SoloADyadicSessions = nan(numel(SessionsMultiCond_SoloADyadic_FullPath),3);  %initializng the mran RT matrix, 3 columns for 3 timings
SD_RTSoloA_SoloADyadicSessions  = nan(numel(SessionsMultiCond_SoloADyadic_FullPath),3); % the same for Standard deviation




for SessSolo =  1 : numel(SessionsMultiCond_SoloADyadic_FullPath)
   
    %load(char(FullSessionPath{ID}));
    report_struct = report_struct_list{SessSolo};
    loadedDATA = array2table(report_struct.data,'VariableNames',report_struct.header);
    Rewarded_Aborted  = report_struct.unique_lists.A_OutcomeENUM(loadedDATA.A_OutcomeENUM_idx); % this vector shows which trial was aborted, which was successful,
    Trial_TaskType_All = report_struct.unique_lists.A_TrialSubTypeENUM(loadedDATA.A_TrialSubTypeENUM_idx); % this vector shows trial type based on task.
    WholeTrials = WholeTrials+numel(Rewarded_Aborted);


    diffGoSignalTime_ms_AllTrials = loadedDATA.A_GoSignalTime_ms - loadedDATA.B_GoSignalTime_ms;
    RewardedID = find(strcmp(Rewarded_Aborted,'REWARD')); % indices of rewarded trials
    RT_A_ms_AllTrials  = loadedDATA.A_InitialFixationReleaseTime_ms - loadedDATA.A_GoSignalTime_ms;
    RT_A_ms_Rewarded  = RT_A_ms_AllTrials(RewardedID);
    DyadicID_All = find(strcmp(Trial_TaskType_All,'Dyadic'));
    Dyadic_AND_RewardedID = intersect(DyadicID_All,RewardedID); % I learned it from Igor!,insted of "AND rule filter" simply use builtin function "intersect"

    SoloAID_All = find(strcmp(Trial_TaskType_All,'SoloA'));
    SoloA_AND_RewardedID = intersect(SoloAID_All,RewardedID);


    Turn_ActorA_Categ = {'first','second','simultaneously'}; % defining turn of actor in categorical data, later we will use this for plotting
    Turn_ActorA_Simul_All_ID = find(diffGoSignalTime_ms_AllTrials == 0); % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
    Turn_ActorA_Simul_Rewarded_ID = intersect(Turn_ActorA_Simul_All_ID,RewardedID); % Indices of trials that actor A and B acted simultaneously AND rewarded.
    Turn_ActorA_Simul_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_Simul_All_ID,Dyadic_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).
    Turn_ActorA_Simul_Rewarded_AND_SoloA_ID = intersect(Turn_ActorA_Simul_All_ID,SoloA_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).




    Turn_ActorA_First_All_ID = find(diffGoSignalTime_ms_AllTrials<0);  % Indices of trials that actor A was the first (among all trials).
    Turn_ActorA_First_Rewarded_ID = intersect(Turn_ActorA_First_All_ID,RewardedID);% Indices of trials that actor A was the first (Rewarded trials).
    Turn_ActorA_First_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_First_All_ID,Dyadic_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).
    Turn_ActorA_First_Rewarded_AND_SoloA_ID = intersect(Turn_ActorA_First_All_ID,SoloA_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).



    Turn_ActorA_Second_All_ID = find(diffGoSignalTime_ms_AllTrials>0); % Indices of trials that actor A was the second (among all trials).
    Turn_ActorA_Second_Rewarded_ID = intersect(Turn_ActorA_Second_All_ID,RewardedID); % Indices of trials that actor A was the second (Rewarded trials).
    Turn_ActorA_Second_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_Second_All_ID,Dyadic_AND_RewardedID); % Indices of trials that actor A was the second (Rewarded trials in SemiSolo)
    Turn_ActorA_Second_Rewarded_AND_SoloA_ID = intersect(Turn_ActorA_Second_All_ID,SoloA_AND_RewardedID); % Indices of trials that actor A was the second (Rewarded trials in SemiSolo)

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



end

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
    ylim([400 700])
end
title('Mean RT of monkey in sessions with Dyadic and SoloA conditions','magenta: dyadic, blue: SoloA')
subtitle_Text = strcat('number of trials:'," ",string(WholeTrials),", ",'number of sessions:',string(WholeSessNum))
subtitle(subtitle_Text)
fig1 = gcf;

% %% Showing variance
% 
% figure
% for S = 1 : size(Mean_RTDyadic_SoloADyadicSessions,1)
%     plot(1:3,SD_RTDyadic_SoloADyadicSessions(S,:),'o-','MarkerFaceColor',ColorFor_Dyadicplots,'Color',ColorFor_Dyadicplots)
%     hold on
%     xticks([1 2 3])
%     xlim([0 4])
%     xticklabels(["First","Simul","Second"])
% end
% for S = 1 : size(Mean_RTSoloA_SoloADyadicSessions,1)
%     plot(1:3,SD_RTSoloA_SoloADyadicSessions(S,:),'o-','MarkerFaceColor',ColorFor_SoloAplots,'Color',ColorFor_SoloAplots)
%     hold on
%     xticks([1 2 3])
%     xlim([0 4])
%     xticklabels(["First","Simul","Second"])
% end
% title('SD od RT in sessions with Dyadic and SoloA')
% subtitle('magenta: dyadic, blue: SoloA')




%% Plotting violin plots for Mean_RTSoloA_SoloASessions
figure
% Y1 = Mean_RTDyadic_SoloADyadicSessions(:,1);
% Y2 = Mean_RTDyadic_SoloADyadicSessions(:,2);
% Y3 = Mean_RTDyadic_SoloADyadicSessions(:,3);
% [f1,xi1,bw1] = ksdensity(Y1)
% [f2,xi2,bw2] = ksdensity(Y2)
% [f2,xi3,bw3] = ksdensity(Y3)
YDyadic = Mean_RTDyadic_SoloADyadicSessions;
% V = violin(Y,'xlabel',{'First','Simult','Second'},'facecolor',[1 1 0;0 1 0;.3 .3 .3;0 0.3 0.1],'edgecolor','b',...
% 'bw',[bw1,bw2,bw3],...
% 'mc','k',...
% 'medc','r--')
CatName = cell({"First","Simult","Second"})
violinplot(YDyadic,CatName,'ViolinColor',ColorFor_Dyadicplots)
hold on
YSoloA = Mean_RTSoloA_SoloADyadicSessions
violinplot(YSoloA,CatName,'ViolinColor',ColorFor_SoloAplots)
ylabel('mean RT(ms)','FontSize',14)
ylim([400 700])
title('RT of monkey among sessions with Dyadic and SoloA','magenta: dyadic, blue: SoloA')
subtitle(subtitle_Text)
fig2 = gcf;
    
%% Repeated measure anova  with two  factor timing and task
% %Example from Mathwork
% % t = table(species,meas(:,1),meas(:,2),meas(:,3),meas(:,4),...
% % 'VariableNames',{'species','meas1','meas2','meas3','meas4'});
% % Meas = table([1 2 3 4]','VariableNames',{'Measurements'});
% %rm = fitrm(t,'meas1-meas4~species','WithinDesign',Meas)
% 
% RESPONSEDyadic = Mean_RTDyadic_SoloADyadicSessions'; % Data for Task 1
% RESPONSESoloA = Mean_RTSoloA_SoloADyadicSessions'; % Data for Task 2

Y = [Mean_RTDyadic_SoloADyadicSessions Mean_RTSoloA_SoloADyadicSessions];

between = table(Y(:,1),Y(:,2),Y(:,3),Y(:,4),Y(:,5),Y(:,6),...
'VariableNames',{'first_dyad', 'simul_dyad', 'second_dyad', 'first_solo', 'simul_solo', 'second_solo',});

within = table(['1'	'2'	'3'	'1'	'2'	'3']',['1' '1' '1' '2' '2' '2']','VariableNames',{'Timing','Task'}); 

rm = fitrm(between,'first_dyad,simul_dyad,second_dyad,first_solo,simul_solo,second_solo ~ 1','WithinDesign',within);
[ranovatbl,D] = ranova(rm,'WithinModel','Timing*Task')

%% Printing out the figures
% Set the figure properties for high-quality output

fig1.Renderer = 'Painters';  % Set the renderer to painters for vector graphics
fig2.Renderer = 'Painters';  % Set the renderer to painters for vector graphics

% Specify the file name and save as SVG
file1_name = 'MultiCondDyadicSoloCurius_AllSess_MeanRT.svg';
file2_name = 'MultiCondDyadicSoloCurius_AllSess_ViolinRT.svg';
% saveas(fig1, file1_name, 'svg');
% saveas(fig2, file2_name, 'svg');






