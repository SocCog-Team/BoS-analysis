close all, clear,clc
% for SessionNum = 1 : numel(FullSessionPath)  %% 3] Going through each session's data:
%     load(char(FullSessionPath{SessionNum}))
%     
%     loadedDATA = array2table(report_struct.data,'VariableNames',report_struct.header);
%    if size(loadedDATA,1) < 90
%        C = SessionNum;
%         Pat4FieldName = digitsPattern; %pattern to detect 6 digit number, the goal is to remove '.' from the months names
%         fieldname = FullSessionPath{SessionNum}
%         NeededName = extract(fieldname,Pat4FieldName);
%         FieldName = strcat('Session_',NeededName(7));
%         FieldName = strtrim(FieldName);
%        AllSessions_Statitical_Results.(FieldName{1}) = {'Not enough trials'};
%     end
%     c = c+1;
% end
run('ToBeAnalazedSessions.m')               %% run the script to have the path for each session data
 
AllSessions_Statitical_Results = struct()   %% 2] Initializing structure for final statistical results of all sessions
                      
bins = [0:25:1000];                         %% Bin width for RT distribution


c = 0;                                       %% counter to see if the code evaluates all sessions


%% This part is just a sanity check to show if all sessions, contains enough number of trial (more than 90)
% C shows the session number and within AllSessions_Statitical_Results you can find exact date

% for SessionNum = 1 : numel(FullSessionPath)  %% 3] Going through each session's data:
%     load(char(FullSessionPath{SessionNum}))
%     
%     loadedDATA = array2table(report_struct.data,'VariableNames',report_struct.header);
%    if size(loadedDATA,1) < 90
%        C = SessionNum;
%         Pat4FieldName = digitsPattern; %pattern to detect 6 digit number, the goal is to remove '.' from the months names
%         fieldname = FullSessionPath{SessionNum}
%         NeededName = extract(fieldname,Pat4FieldName);
%         FieldName = strcat('Session_',NeededName(7));
%         FieldName = strtrim(FieldName);
%        AllSessions_Statitical_Results.(FieldName{1}) = {'Not enough trials'};
%     end
%     c = c+1;
% end
%%

% for SessionNum = 1 : numel(FullSessionPath)  %% 3] Going through each session's data:
    SessNum = 88
    load(char(FullSessionPath{SessNum}))

    loadedDATA = array2table(report_struct.data,'VariableNames',report_struct.header);
    Rewarded_Aborted  = report_struct.unique_lists.A_OutcomeENUM(loadedDATA.A_OutcomeENUM_idx); % this vector shows which trial was aborted, which was successful,
    Trial_TaskType_All = report_struct.unique_lists.A_TrialSubTypeENUM(loadedDATA.A_TrialSubTypeENUM_idx); % this vector shows trial type based on task.
    SessionTaskType = unique(Trial_TaskType_All)
    %%























%     if sum(contains(SessionTaskType,["Dyadic","SoloB"])) == 2
%         RewardedID = find(strcmp(Rewarded_Aborted,'REWARD')); % indices of rewarded trials
%         DyadicID_All = find(strcmp(Trial_TaskType_All,'Dyadic'));
%         SoloBID_All = find(strcmp(Trial_TaskType_All,'SoloB'));
%         
%         
%         Dyadic_AND_RewardedID = intersect(DyadicID_All,RewardedID);
%         SoloB_AND_RewardedID = intersect(SoloBID_All,RewardedID);
%         
%         diffGoSignalTime_ms_AllTrials = loadedDATA.A_GoSignalTime_ms - loadedDATA.B_GoSignalTime_ms; % negative means actor A is first 
%         
%         
%         RT_A_ms_AllTrials  = loadedDATA.A_InitialFixationReleaseTime_ms - loadedDATA.A_GoSignalTime_ms;
%         RT_B_ms_AllTrials  = loadedDATA.B_InitialFixationReleaseTime_ms - loadedDATA.B_GoSignalTime_ms;
% 
%         Actor_A = string(report_struct.unique_lists.A_Name);
%         Actor_B = string(report_struct.unique_lists.B_Name);
% 
%         if numel(Actor_A)>1
%            Actor_A = "human";
%         end
% 
%         %% Actor A:
%         Turn_ActorA_Categ = {'first','second','simultaneously'}; % defining turn of actor in categorical data, later we will use this for plotting
%         Turn_ActorA_Simul_All_ID = find(diffGoSignalTime_ms_AllTrials == 0); % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
%         Turn_ActorA_Simul_Rewarded_ID = intersect(Turn_ActorA_Simul_All_ID,RewardedID); % Indices of trials that actor A and B acted simultaneously AND rewarded.
%         Turn_ActorA_Simul_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_Simul_All_ID,Dyadic_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in Dyadic).
%         
%         
%         
%         Turn_ActorA_First_All_ID = find(diffGoSignalTime_ms_AllTrials<0);  % Indices of trials that actor A was the first (among all trials).
%         Turn_ActorA_First_Rewarded_ID = intersect(Turn_ActorA_First_All_ID,RewardedID);% Indices of trials that actor A was the first (Rewarded trials).
%         Turn_ActorA_First_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_First_All_ID,Dyadic_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in Dyadic).
%         
%         
%         
%         Turn_ActorA_Second_All_ID = find(diffGoSignalTime_ms_AllTrials>0); % Indices of trials that actor A was the second (among all trials).
%         Turn_ActorA_Second_Rewarded_ID = intersect(Turn_ActorA_Second_All_ID,RewardedID); % Indices of trials that actor A was the second (Rewarded trials).
%         Turn_ActorA_Second_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_Second_All_ID,Dyadic_AND_RewardedID);
%         
%         %% Actor B: Pay attention that diffGoSignalTime_ms_AllTrials negative means actor A is first, so actor B is second (line 82, should be more than zero and line 85 should be less than zero)
%         Turn_ActorB_Simul_All_ID = Turn_ActorA_Simul_All_ID; % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
%         Turn_ActorB_Simul_Rewarded_ID = intersect(Turn_ActorB_Simul_All_ID,RewardedID); % Indices of trials that actor A and B acted simultaneously AND rewarded.
%         Turn_ActorB_Simul_Rewarded_AND_Solo_ID = intersect(Turn_ActorB_Simul_All_ID,SoloB_AND_RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
%         Turn_ActorB_Simul_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorB_Simul_All_ID,Dyadic_AND_RewardedID);
%         
%         Turn_ActorB_First_All_ID = find(diffGoSignalTime_ms_AllTrials>0);  % Indices of trials that actor B was the first (among all trials).
%         Turn_ActorB_First_Rewarded_ID = intersect(Turn_ActorB_First_All_ID,RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
%         Turn_ActorB_First_Rewarded_AND_Solo_ID = intersect(Turn_ActorB_First_All_ID,SoloB_AND_RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
%         Turn_ActorB_First_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorB_First_All_ID,Dyadic_AND_RewardedID);
%         
%         Turn_ActorB_Second_All_ID = find(diffGoSignalTime_ms_AllTrials<0); % Indices of trials that actor B was the second (among all trials).
%         Turn_ActorB_Second_Rewarded_ID = intersect(Turn_ActorB_Second_All_ID,RewardedID); % Indices of trials that actor B was the second (Rewarded trials).
%         Turn_ActorB_Second_Rewarded_AND_Solo_ID = intersect(Turn_ActorB_Second_All_ID,SoloB_AND_RewardedID); % Indices of trials that actor B was the second (Rewarded trials).
%         Turn_ActorB_Second_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorB_Second_All_ID,Dyadic_AND_RewardedID);
% 
%         %% 2) Plotting: 
%         figure
%         sh(1) = subplot(3,3,1);
%         histogram(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Dyadic_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
%         % if you set 'Normalization' to probability and then multiply it by 100,
%         % this works same as "ig_hist2per function"
%         hold on
%         plot(mean(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Dyadic_ID)),-0.005,"^",'Color','r')
%         histogram(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_Dyadic_ID),bins,'Normalization','probability','FaceColor','b','FaceAlpha',0.1);
%         plot(mean(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_Dyadic_ID)),-0.005,"^",'Color','b')
%         ytix = get(gca, 'YTick');
%         set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
%         legend(strcat(sprintf(Actor_A),' was first'),'',strcat(sprintf(Actor_B),' was second','')); % for the legend, name of Actor_A is printed
%         xlabel('reaction time(ms), bin width = 50 ms');
%         ylabel('% of trials');
%         subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Dyadic_ID)))); ...
%             strcat(sprintf(Actor_B),' :','trial number =',string(numel(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_Dyadic_ID))))};
%         subtitle(subtitletxt);
%         % pbaspect([1 1 1])
%         %%
%         sh(2) = subplot(3,3,2);
%         histogram(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Dyadic_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
%         % if you set 'Normalization' to probability and then multiply it by 100,
%         % this works same as "ig_hist2per function"
%         hold on
%         plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Dyadic_ID)),-0.005,"^",'Color','r')
%         histogram(RT_B_ms_AllTrials(Turn_ActorB_Simul_Rewarded_AND_Dyadic_ID),bins,'Normalization','probability','FaceAlpha',0.1,'FaceColor','b');
%         plot(mean(RT_B_ms_AllTrials(Turn_ActorB_Simul_Rewarded_AND_Dyadic_ID)),-0.005,"^",'Color','b')
%         ytix = get(gca, 'YTick');
%         set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
%         legend(sprintf(Actor_A),'',sprintf(Actor_B),''); % for the legend, name of Actor_A is printed
%         title ('simultaneously')
%         xlabel('reaction time(ms), bin width = 50 ms');
%         ylabel('% of trials');
%         subtitletxt = {strcat(sprintf(Actor_A),' and', sprintf(Actor_B),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Dyadic_ID))))};
%         subtitle(subtitletxt);
%         % pbaspect([1 1 1])
%         %%
%         sh(3) = subplot(3,3,3);
%         histogram(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Dyadic_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
%         % if you set 'Normalization' to probability and then multiply it by 100,
%         % this works same as "ig_hist2per function"
%         hold on
%         plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Dyadic_ID)),-0.005,"^",'Color','r')
%         histogram(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_Dyadic_ID),bins,'Normalization','probability','FaceAlpha',0.1,'FaceColor','b');
%         plot(mean(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_Dyadic_ID)),-0.005,"^",'Color','b')
%         ytix = get(gca, 'YTick');
%         set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
%         legend(strcat(sprintf(Actor_A),' was second '),'',strcat(sprintf(Actor_B),' was first'),''); % for the legend, name of Actor_A is printed
%         xlabel('reaction time(ms), bin width = 50 ms');
%         ylabel('% of trials');
%         subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Dyadic_ID))));strcat('Actor B:','trial number =', ...
%             string(numel(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_Dyadic_ID))))};
%         subtitle(subtitletxt);
%         % pbaspect([1 1 1])
%         %% from here, we look at the "Solo" condition
%         sh(4) = subplot(3,3,4,'replace');
%         sh(5) = subplot(3,3,5,'replace');
%         sh(6) = subplot(3,3,6,'replace');
%         sh(7) = subplot(3,3,7);
%         histogram(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
%         % if you set 'Normalization' to probability and then multiply it by 100,
%         % this works same as "ig_hist2per function"
%         hold on
%         plot(mean(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','r')
%         
% %         histogram(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','b','FaceAlpha',0.1) % Igor said it is better to show y-axis as percent instead of count,
%         % if you set 'Normalization' to probability and then multiply it by 100,
%         % this works same as "ig_hist2per function"
% %         plot(mean(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','b')
%         set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
%         legend(sprintf(Actor_A),''); % for the legend, name of Actor_A is printed
%         xlabel('reaction time(ms), bin width = 50 ms');
%         ylabel('% of trials');
%         subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Solo_ID))));...
%             strcat(sprintf(Actor_B),':','passive observer')};
%         subtitle(subtitletxt);
%         % pbaspect([1 1 1])
%         %%
%         sh(8) = subplot(3,3,8);
%         histogram(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
%         hold on
%         plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','r')
%         
% %         histogram(RT_B_ms_AllTrials(Turn_ActorB_Simul_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','b','FaceAlpha',0.1) % Igor said it is better to show y-axis as percent instead of count,
% %         plot(mean(RT_B_ms_AllTrials(Turn_ActorB_Simul_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','b')
%         % if you set 'Normalization' to probability and then multiply it by 100,
%         % this works same as "ig_hist2per function"
%         set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
%         legend(sprintf(Actor_A),''); % for the legend, name of Actor_A is printed
%         xlabel('reaction time(ms), bin width = 50 ms');
%         ylabel('% of trials');
%         subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Solo_ID))));...
%             strcat(sprintf(Actor_B),':','passive observer')};
%         subtitle(subtitletxt);
%         title('nominally simultaneously')
%         % pbaspect([1 1 1])
%         %%
%         sh(9) = subplot(3,3,9);
%         histogram(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
%         hold on
%         plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','r')
%         
% %         histogram(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','b','FaceAlpha',0.1) % Igor said it is better to show y-axis as percent instead of count,
% %         plot(mean(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','b')
%         % if you set 'Normalization' to probability and then multiply it by 100,
%         % this works same as "ig_hist2per function"
%         set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
%         legend(sprintf(Actor_A),''); % for the legend, name of Actor_A is printed
%         xlabel('reaction time(ms), bin width = 50 ms');
%         ylabel('% of trials');
%         subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID))));...
%             strcat(sprintf(Actor_B),':','passive observer')};
%         subtitle(subtitletxt);
%         % pbaspect([1 1 1])
%         set(sh(:),'Xlim',[0 1000]);
%         % ig_set_axes_equal_lim(sh,'Ylim');
%         set(sh(:),'Ylim',[-0.01 0.25]);
%         % set(sh(:),'DataAspectRatio',[1 1 1])
%         annotation('textbox',...
%             [0.0442291666666667 0.780777537796975 0.0474375 0.0377969762418982],...
%             'String','Dyadic',...
%             'FitBoxToText','off');
%         
%         annotation('textbox',...
%             [0.0442291666666667 0.197624190064795 0.0474375 0.0377969762418982],...
%             'String',{'Solo'},...
%             'FitBoxToText','off');
%         annotation('textbox',...
%             [0.0442291666666667 0.52267818574514 0.0474375 0.0377969762418982],...
%             'String',{'Semi-Solo'},...
%             'FitBoxToText','off');
%         sgtitle('Session with only Dyadic and SoloA')




















if sum(contains(SessionTaskType,["Dyadic","SoloA","SoloB"])) == 3
   RewardedID = find(strcmp(Rewarded_Aborted,'REWARD')); % indices of rewarded trials
   SoloAID_All = find(strcmp(Trial_TaskType_All,'SoloA')); % Be careful! This vector contains all trial IDs that presumably were SoloA, (rewarded "AND" SoloA is in TaskType_AND_Rewarded vector)
   DyadicID_All = find(strcmp(Trial_TaskType_All,'Dyadic'));
   SoloBID_All = find(strcmp(Trial_TaskType_All,'SoloB'));


   SoloA_AND_RewardedID = intersect(SoloAID_All,RewardedID); % I learned it from Igor!,insted of "AND rule filter" simply use builtin function "intersect"
   Dyadic_AND_RewardedID = intersect(DyadicID_All,RewardedID);
   SoloB_AND_RewardedID = intersect(SoloBID_All,RewardedID);

   diffGoSignalTime_ms_AllTrials = loadedDATA.A_GoSignalTime_ms - loadedDATA.B_GoSignalTime_ms; % negative means actor A is first 

   RT_A_ms_AllTrials  = loadedDATA.A_InitialFixationReleaseTime_ms - loadedDATA.A_GoSignalTime_ms;
   RT_B_ms_AllTrials  = loadedDATA.B_InitialFixationReleaseTime_ms - loadedDATA.B_GoSignalTime_ms;

   TrialsBelong_ActorA_ID_All = union(SoloAID_All,DyadicID_All);
   TrialsBelong_ActorB_ID_All = union(SoloBID_All,DyadicID_All);

   TrialsBelong_ActorA_ID_Reward = intersect(TrialsBelong_ActorA_ID_All,RewardedID);
   TrialsBelong_ActorB_ID_Reward = intersect(TrialsBelong_ActorB_ID_All,RewardedID);

   RT_A_ms_Rewarded  = RT_A_ms_AllTrials(TrialsBelong_ActorA_ID_Reward);
   RT_B_ms_Rewarded  = RT_B_ms_AllTrials(TrialsBelong_ActorA_ID_Reward);

   TaskType_Rewarded_A = Trial_TaskType_All(TrialsBelong_ActorA_ID_Reward);
   TaskType_Rewarded_B = Trial_TaskType_All(TrialsBelong_ActorB_ID_Reward);

   Actor_A = string(report_struct.unique_lists.A_Name);
   Actor_B = string(report_struct.unique_lists.B_Name);

   %% Actor A:
    Turn_ActorA_Categ = {'first','second','simultaneously'}; % defining turn of actor in categorical data, later we will use this for plotting
    Turn_ActorA_Simul_All_ID = find(diffGoSignalTime_ms_AllTrials == 0); % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
    Turn_ActorA_Simul_Rewarded_ID = intersect(Turn_ActorA_Simul_All_ID,RewardedID); % Indices of trials that actor A and B acted simultaneously AND rewarded.
    Turn_ActorA_Simul_Rewarded_AND_Solo_ID = intersect(Turn_ActorA_Simul_All_ID,SoloA_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).
    Turn_ActorA_Simul_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_Simul_All_ID,Dyadic_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in Dyadic).
    
    
    
    Turn_ActorA_First_All_ID = find(diffGoSignalTime_ms_AllTrials<0);  % Indices of trials that actor A was the first (among all trials).
    Turn_ActorA_First_Rewarded_ID = intersect(Turn_ActorA_First_All_ID,TrialsBelong_ActorA_ID_Reward);% Indices of trials that actor A was the first (Rewarded trials).
    Turn_ActorA_First_Rewarded_AND_Solo_ID = intersect(Turn_ActorA_First_All_ID,SoloA_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).
    Turn_ActorA_First_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_First_All_ID,Dyadic_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in Dyadic).
    
    
    
    Turn_ActorA_Second_All_ID = find(diffGoSignalTime_ms_AllTrials>0); % Indices of trials that actor A was the second (among all trials).
    Turn_ActorA_Second_Rewarded_ID = intersect(Turn_ActorA_Second_All_ID,RewardedID); % Indices of trials that actor A was the second (Rewarded trials).
    Turn_ActorA_Second_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_Second_All_ID,Dyadic_AND_RewardedID);
    Turn_ActorA_Second_Rewarded_AND_Solo_ID = intersect(Turn_ActorA_Second_All_ID,SoloA_AND_RewardedID); % Indices of trials that actor A was the second (Rewarded trials in SemiSolo).
    
    %% Actor B: Pay attention that diffGoSignalTime_ms_AllTrials negative means actor A is first, so actor B is second (line 82, should be more than zero and line 85 should be less than zero)
    Turn_ActorB_Simul_All_ID = Turn_ActorA_Simul_All_ID; % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
    Turn_ActorB_Simul_Rewarded_ID = intersect(Turn_ActorB_Simul_All_ID,RewardedID); % Indices of trials that actor A and B acted simultaneously AND rewarded.
    Turn_ActorB_Simul_Rewarded_AND_Solo_ID = intersect(Turn_ActorB_Simul_All_ID,SoloB_AND_RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
    Turn_ActorB_Simul_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorB_Simul_All_ID,Dyadic_AND_RewardedID);
    
    Turn_ActorB_First_All_ID = find(diffGoSignalTime_ms_AllTrials>0);  % Indices of trials that actor B was the first (among all trials).
    Turn_ActorB_First_Rewarded_ID = intersect(Turn_ActorB_First_All_ID,RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
    Turn_ActorB_First_Rewarded_AND_Solo_ID = intersect(Turn_ActorB_First_All_ID,SoloB_AND_RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
    Turn_ActorB_First_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorB_First_All_ID,Dyadic_AND_RewardedID);
    
    Turn_ActorB_Second_All_ID = find(diffGoSignalTime_ms_AllTrials<0); % Indices of trials that actor B was the second (among all trials).
    Turn_ActorB_Second_Rewarded_ID = intersect(Turn_ActorB_Second_All_ID,RewardedID); % Indices of trials that actor B was the second (Rewarded trials).
    Turn_ActorB_Second_Rewarded_AND_Solo_ID = intersect(Turn_ActorB_Second_All_ID,SoloB_AND_RewardedID); % Indices of trials that actor B was the second (Rewarded trials).
    Turn_ActorB_Second_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorB_Second_All_ID,Dyadic_AND_RewardedID);

    %% plotting
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
        strcat(sprintf(Actor_B),':','trial number =',string(numel(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_Dyadic_ID))))};
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
    subtitletxt = {strcat(sprintf(Actor_A),' and',sprintf(Actor_B),' :','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Dyadic_ID))))};
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
    subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Dyadic_ID))));strcat(sprintf(Actor_B),' :','trial number =', ...
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
    sgtitle('Session with Dyadic and Solo')
end
    






    if sum(contains(SessionTaskType,["SoloA","SemiSolo"])) == 2
       RewardedID = find(strcmp(Rewarded_Aborted,'REWARD')); % indices of rewarded trials
       SoloAID_All = find(strcmp(Trial_TaskType_All,'SoloA')); % Be careful! This vector contains all trial IDs that presumably were SoloA, (rewarded "AND" SoloA is in TaskType_AND_Rewarded vector)
       SemiSoloID_All = find(strcmp(Trial_TaskType_All,'SemiSolo'));
       SoloA_AND_RewardedID = intersect(SoloAID_All,RewardedID); % I learned it from Igor!,insted of "AND rule filter" simply use builtin function "intersect"
       SemiSolo_AND_RewardedID = intersect(SemiSoloID_All,RewardedID);

       diffGoSignalTime_ms_AllTrials = loadedDATA.A_GoSignalTime_ms - loadedDATA.B_GoSignalTime_ms; % negative means actor A is first 


       RT_A_ms_AllTrials  = loadedDATA.A_InitialFixationReleaseTime_ms - loadedDATA.A_GoSignalTime_ms;
       RT_B_ms_AllTrials  = loadedDATA.B_InitialFixationReleaseTime_ms - loadedDATA.B_GoSignalTime_ms;


        TaskType_Rewarded_A = Trial_TaskType_All(RewardedID);
        TaskType_Rewarded_B = Trial_TaskType_All(RewardedID);

        Actor_A = string(report_struct.unique_lists.A_Name);
        Actor_B = string(report_struct.unique_lists.B_Name);

        if numel(Actor_B)> 1
          Actor_B = "human"
        end

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
        
        Turn_ActorB_First_All_ID = find(diffGoSignalTime_ms_AllTrials>0);  % Indices of trials that actor B was the first (among all trials).
        Turn_ActorB_First_Rewarded_ID = intersect(Turn_ActorB_First_All_ID,RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
        Turn_ActorB_First_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorB_First_All_ID,SemiSolo_AND_RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
        
        Turn_ActorB_Second_All_ID = find(diffGoSignalTime_ms_AllTrials<0); % Indices of trials that actor B was the second (among all trials).
        Turn_ActorB_Second_Rewarded_ID = intersect(Turn_ActorB_Second_All_ID,RewardedID); % Indices of trials that actor B was the second (Rewarded trials).
        Turn_ActorB_Second_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorB_Second_All_ID,SemiSolo_AND_RewardedID); % Indices of trials that actor B was the second (Rewarded trials).

        %% plotting
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
        sgtitle({'Session with only Semi-Solo and Solo',strcat('Actor B: ',sprintf(Actor_B))})



    end





    if sum(contains(SessionTaskType,["Dyadic","SemiSolo"])) == 2
       RewardedID = find(strcmp(Rewarded_Aborted,'REWARD')); 
       SemiSoloID_All = find(strcmp(Trial_TaskType_All,'SemiSolo'));
       DyadicID_All = find(strcmp(Trial_TaskType_All,'Dyadic'));
       SemiSolo_AND_RewardedID = intersect(SemiSoloID_All,RewardedID);
       Dyadic_AND_RewardedID = intersect(DyadicID_All,RewardedID);

       diffGoSignalTime_ms_AllTrials = loadedDATA.A_GoSignalTime_ms - loadedDATA.B_GoSignalTime_ms; 
                        
       RT_A_ms_AllTrials  = loadedDATA.A_InitialFixationReleaseTime_ms - loadedDATA.A_GoSignalTime_ms;
       RT_B_ms_AllTrials  = loadedDATA.B_InitialFixationReleaseTime_ms - loadedDATA.B_GoSignalTime_ms;

       RT_A_ms_Rewarded  = RT_A_ms_AllTrials(RewardedID);
       RT_B_ms_Rewarded  = RT_B_ms_AllTrials(RewardedID);
                        
       TaskType_Rewarded_A = Trial_TaskType_All(RewardedID);
       TaskType_Rewarded_B = Trial_TaskType_All(RewardedID);

       Actor_A = string(report_struct.unique_lists.A_Name);
       Actor_B = string(report_struct.unique_lists.B_Name);
       if numel(Actor_B)> 1
          Actor_B = "human"
       end
       %% Actor A:

        Turn_ActorA_Categ = {'first','second','simultaneously'}; % defining turn of actor in categorical data, later we will use this for plotting
        Turn_ActorA_Simul_All_ID = find(diffGoSignalTime_ms_AllTrials == 0); % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
        Turn_ActorA_Simul_Rewarded_ID = intersect(Turn_ActorA_Simul_All_ID,RewardedID); % Indices of trials that actor A and B acted simultaneously AND rewarded.
        Turn_ActorA_Simul_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorA_Simul_All_ID,SemiSolo_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).
        Turn_ActorA_Simul_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_Simul_All_ID,Dyadic_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in Dyadic).
                        
                        
                        
        Turn_ActorA_First_All_ID = find(diffGoSignalTime_ms_AllTrials<0);  % Indices of trials that actor A was the first (among all trials).
        Turn_ActorA_First_Rewarded_ID = intersect(Turn_ActorA_First_All_ID,RewardedID);% Indices of trials that actor A was the first (Rewarded trials).
        Turn_ActorA_First_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorA_First_All_ID,SemiSolo_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).
        Turn_ActorA_First_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_First_All_ID,Dyadic_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in Dyadic).
        
                        
                        
        Turn_ActorA_Second_All_ID = find(diffGoSignalTime_ms_AllTrials>0); % Indices of trials that actor A was the second (among all trials).
        Turn_ActorA_Second_Rewarded_ID = intersect(Turn_ActorA_Second_All_ID,RewardedID); % Indices of trials that actor A was the second (Rewarded trials).
        Turn_ActorA_Second_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorA_Second_All_ID,SemiSolo_AND_RewardedID); % Indices of trials that actor A was the second (Rewarded trials in SemiSolo).
        Turn_ActorA_Second_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_Second_All_ID,Dyadic_AND_RewardedID);
                        
        %% Actor B: Pay attention that diffGoSignalTime_ms_AllTrials negative means actor A is first, so actor B is second (line 82, should be more than zero and line 85 should be less than zero)
        Turn_ActorB_Simul_All_ID = Turn_ActorA_Simul_All_ID; % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
        Turn_ActorB_Simul_Rewarded_ID = intersect(Turn_ActorB_Simul_All_ID,RewardedID); % Indices of trials that actor A and B acted simultaneously AND rewarded.
        Turn_ActorB_Simul_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorB_Simul_All_ID,SemiSolo_AND_RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
        Turn_ActorB_Simul_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorB_Simul_All_ID,Dyadic_AND_RewardedID);
        
        Turn_ActorB_First_All_ID = find(diffGoSignalTime_ms_AllTrials>0);  % Indices of trials that actor B was the first (among all trials).
        Turn_ActorB_First_Rewarded_ID = intersect(Turn_ActorB_First_All_ID,RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
        Turn_ActorB_First_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorB_First_All_ID,SemiSolo_AND_RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
        Turn_ActorB_First_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorB_First_All_ID,Dyadic_AND_RewardedID);
        
        Turn_ActorB_Second_All_ID = find(diffGoSignalTime_ms_AllTrials<0); % Indices of trials that actor B was the second (among all trials).
        Turn_ActorB_Second_Rewarded_ID = intersect(Turn_ActorB_Second_All_ID,RewardedID); % Indices of trials that actor B was the second (Rewarded trials).
        Turn_ActorB_Second_Rewarded_AND_SemiSolo_ID = intersect(Turn_ActorB_Second_All_ID,SemiSolo_AND_RewardedID); % Indices of trials that actor B was the second (Rewarded trials).
        Turn_ActorB_Second_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorB_Second_All_ID,Dyadic_AND_RewardedID);
          %% 2) Plotting: 
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
         sh(7) = subplot(3,3,7,'replace');
         sh(8) = subplot(3,3,8,'replace');
         sh(9) = subplot(3,3,9,'replace');
         set(sh(:),'Xlim',[0 1000]);
         % ig_set_axes_equal_lim(sh,'Ylim');
         set(sh(:),'Ylim',[-0.01 0.25]);
                        
                        
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
        sgtitle({'Session with Dyadic and Semi-Solo',strcat('Actor B: ',sprintf(Actor_B))})
      
    end



    if contains(SessionTaskType,"SoloA")
        Statitical_Results = struct;
        RewardedID = find(strcmp(Rewarded_Aborted,'REWARD')); % indices of rewarded trials
        RT_A_ms_AllTrials  = loadedDATA.A_InitialFixationReleaseTime_ms - loadedDATA.A_GoSignalTime_ms;
        Actor_A = string(report_struct.unique_lists.A_Name);
        figure
        histogram(RT_A_ms_AllTrials(RewardedID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
        hold on
        plot(mean(RT_A_ms_AllTrials(RewardedID)),-0.005,"^",'Color','r')
        legend(sprintf(Actor_A),''); % for the legend, name of Actor_A is printed
        xlabel('reaction time(ms), bin width = 50 ms');
        ylabel('% of trials');
        subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(RewardedID))))};
        subtitle(subtitletxt);
        title('SoloA')
        Statitical_Results.Mean_RT = mean(RT_A_ms_AllTrials(RewardedID));
        Statitical_Results.SD_RT = std(RT_A_ms_AllTrials(RewardedID));
        Pat4FieldName = digitsPattern; %pattern to detect 6 digit number, the goal is to remove '.' from the months names
        fieldname = FullSessionPath{SessNum}
        NeededName = extract(fieldname,Pat4FieldName);
        FieldName = strcat('Session_',NeededName(7))
        FieldName = strtrim(FieldName);
       AllSessions_Statitical_Results.(FieldName{1}) = Statitical_Results
    end
    %%


    if sum(matches(SessionTaskType,["Dyadic","SoloA"])) == 2 || sum(matches(SessionTaskType,["SoloA","Dyadic"])) == 2
       RT_A_ms_AllTrials  = loadedDATA.A_InitialFixationReleaseTime_ms - loadedDATA.A_GoSignalTime_ms;
       TYPES = unique(Trial_TaskType_All);  % be careful that some sessions contains only one trial with dyadic and one hundred with Solo, this piece of code, ganna exclude the task types less than 50 trials
                for TaskTypeNum = 1 : numel(TYPES)
                    TaskTypeIDs{TaskTypeNum} = find(cellfun(@(x) ischar(x) && contains(x, TYPES(TaskTypeNum)), Trial_TaskType_All));
                    TaksTypeNUMBERS(TaskTypeNum) = numel(TaskTypeIDs{TaskTypeNum});
                end
                 if sum(TaksTypeNUMBERS< 50)>0
                   Rewarded_Aborted(TaskTypeIDs{TaksTypeNUMBERS< 50}) = [];
                   RT_A_ms_AllTrials(TaskTypeIDs{TaksTypeNUMBERS< 50}) = [];
                   Trial_TaskType_All(TaskTypeIDs{TaksTypeNUMBERS< 50}) = [];
                  
                   TYPES = unique(Trial_TaskType_All);
                 end
                 if matches(TYPES,"SoloA")
                     Statitical_Results = struct;
                    RewardedID = find(strcmp(Rewarded_Aborted,'REWARD')); % indices of rewarded trials
                    Actor_A = string(report_struct.unique_lists.A_Name);
                    figure
                    histogram(RT_A_ms_AllTrials(RewardedID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
                    hold on
                    plot(mean(RT_A_ms_AllTrials(RewardedID)),-0.005,"^",'Color','r')
                    legend(sprintf(Actor_A),''); % for the legend, name of Actor_A is printed
                    xlabel('reaction time(ms), bin width = 50 ms');
                    ylabel('% of trials');
                    subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(RewardedID))))};
                    subtitle(subtitletxt);
                    title('SoloA')
                    Statitical_Results.Mean_RT = mean(RT_A_ms_AllTrials(RewardedID));
                    Statitical_Results.SD_RT = std(RT_A_ms_AllTrials(RewardedID));
                    Pat4FieldName = digitsPattern; %pattern to detect 6 digit number, the goal is to remove '.' from the months names
                    fieldname = FullSessionPath{SessNum}
                    NeededName = extract(fieldname,Pat4FieldName);
                    FieldName = strcat('Session_',NeededName(7))
                    FieldName = strtrim(FieldName);
                   AllSessions_Statitical_Results.(FieldName{1}) = Statitical_Results
                 end
                 if sum(TaksTypeNUMBERS< 50) == 0
                    RewardedID = find(strcmp(Rewarded_Aborted,'REWARD')); % indices of rewarded trials
                    SoloAID_All = find(strcmp(Trial_TaskType_All,'SoloA')); % Be careful! This vector contains all trial IDs that presumably were SoloA, (rewarded "AND" SoloA is in TaskType_AND_Rewarded vector)
                    DyadicID_All = find(strcmp(Trial_TaskType_All,'Dyadic'));
                    %%
                    SoloA_AND_RewardedID = intersect(SoloAID_All,RewardedID); 
                    Dyadic_AND_RewardedID = intersect(DyadicID_All,RewardedID);
                    
                    diffGoSignalTime_ms_AllTrials = loadedDATA.A_GoSignalTime_ms - loadedDATA.B_GoSignalTime_ms; % negative means actor A is first 
                   
                    RT_A_ms_AllTrials  = loadedDATA.A_InitialFixationReleaseTime_ms - loadedDATA.A_GoSignalTime_ms;
                    RT_B_ms_AllTrials  = loadedDATA.B_InitialFixationReleaseTime_ms - loadedDATA.B_GoSignalTime_ms;
            
                    
                    RT_A_ms_Rewarded  = RT_A_ms_AllTrials(RewardedID);
                    RT_B_ms_Rewarded  = RT_B_ms_AllTrials(RewardedID);
                    
                    
                    %% it is like that because it is a mixture of solo and semi-solo task.
                    Actor_A = string(report_struct.unique_lists.A_Name);
                    Actor_B = string(report_struct.unique_lists.B_Name);
                    %% Who was first?
                    
                    %split into 3 categories: simultaneous, A first, B first
                    %% Actor A:
                    Turn_ActorA_Categ = {'first','second','simultaneously'}; % defining turn of actor in categorical data, later we will use this for plotting
                    Turn_ActorA_Simul_All_ID = find(diffGoSignalTime_ms_AllTrials == 0); % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
                    Turn_ActorA_Simul_Rewarded_ID = intersect(Turn_ActorA_Simul_All_ID,RewardedID); % Indices of trials that actor A and B acted simultaneously AND rewarded.
                    Turn_ActorA_Simul_Rewarded_AND_Solo_ID = intersect(Turn_ActorA_Simul_All_ID,SoloA_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).
                    Turn_ActorA_Simul_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_Simul_All_ID,Dyadic_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in Dyadic).
                    
                    
                    
                    Turn_ActorA_First_All_ID = find(diffGoSignalTime_ms_AllTrials<0);  % Indices of trials that actor A was the first (among all trials).
                    Turn_ActorA_First_Rewarded_ID = intersect(Turn_ActorA_First_All_ID,RewardedID);% Indices of trials that actor A was the first (Rewarded trials).
                    Turn_ActorA_First_Rewarded_AND_Solo_ID = intersect(Turn_ActorA_First_All_ID,SoloA_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).
                    Turn_ActorA_First_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_First_All_ID,Dyadic_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in Dyadic).
                    
                    
                    
                    Turn_ActorA_Second_All_ID = find(diffGoSignalTime_ms_AllTrials>0); % Indices of trials that actor A was the second (among all trials).
                    Turn_ActorA_Second_Rewarded_ID = intersect(Turn_ActorA_Second_All_ID,RewardedID); % Indices of trials that actor A was the second (Rewarded trials).
                    Turn_ActorA_Second_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_Second_All_ID,Dyadic_AND_RewardedID);
                    Turn_ActorA_Second_Rewarded_AND_Solo_ID = intersect(Turn_ActorA_Second_All_ID,SoloA_AND_RewardedID); % Indices of trials that actor A was the second (Rewarded trials in SemiSolo).
                    
                    %% Actor B: Pay attention that diffGoSignalTime_ms_AllTrials negative means actor A is first, so actor B is second (line 82, should be more than zero and line 85 should be less than zero)
                    Turn_ActorB_Simul_All_ID = Turn_ActorA_Simul_All_ID; % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
                    Turn_ActorB_Simul_Rewarded_ID = intersect(Turn_ActorB_Simul_All_ID,RewardedID); % Indices of trials that actor A and B acted simultaneously AND rewarded.
                    Turn_ActorB_Simul_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorB_Simul_All_ID,Dyadic_AND_RewardedID);
                    
                    Turn_ActorB_First_All_ID = find(diffGoSignalTime_ms_AllTrials>0);  % Indices of trials that actor B was the first (among all trials).
                    Turn_ActorB_First_Rewarded_ID = intersect(Turn_ActorB_First_All_ID,RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
                    Turn_ActorB_First_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorB_First_All_ID,Dyadic_AND_RewardedID);
                    
                    Turn_ActorB_Second_All_ID = find(diffGoSignalTime_ms_AllTrials<0); % Indices of trials that actor B was the second (among all trials).
                    Turn_ActorB_Second_Rewarded_ID = intersect(Turn_ActorB_Second_All_ID,RewardedID); % Indices of trials that actor B was the second (Rewarded trials).
                    Turn_ActorB_Second_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorB_Second_All_ID,Dyadic_AND_RewardedID);
            
                    %% 2) Plotting: 
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
                    
            %         histogram(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','b','FaceAlpha',0.1) % Igor said it is better to show y-axis as percent instead of count,
                    % if you set 'Normalization' to probability and then multiply it by 100,
                    % this works same as "ig_hist2per function"
            %         plot(mean(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','b')
                    set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
                    legend(sprintf(Actor_A),''); % for the legend, name of Actor_A is printed
                    xlabel('reaction time(ms), bin width = 50 ms');
                    ylabel('% of trials');
                    subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Solo_ID))));...
                        strcat(sprintf(Actor_B),':','passive observer')};
                    subtitle(subtitletxt);
                    % pbaspect([1 1 1])
                    %%
                    sh(8) = subplot(3,3,8);
                    histogram(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
                    hold on
                    plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','r')
                    
            %         histogram(RT_B_ms_AllTrials(Turn_ActorB_Simul_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','b','FaceAlpha',0.1) % Igor said it is better to show y-axis as percent instead of count,
            %         plot(mean(RT_B_ms_AllTrials(Turn_ActorB_Simul_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','b')
                    % if you set 'Normalization' to probability and then multiply it by 100,
                    % this works same as "ig_hist2per function"
                    set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
                    legend(sprintf(Actor_A),''); % for the legend, name of Actor_A is printed
                    xlabel('reaction time(ms), bin width = 50 ms');
                    ylabel('% of trials');
                    subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Solo_ID))));...
                        strcat(sprintf(Actor_B),':','passive observer')};
                    subtitle(subtitletxt);
                    title('nominally simultaneously')
                    % pbaspect([1 1 1])
                    %%
                    sh(9) = subplot(3,3,9);
                    histogram(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
                    hold on
                    plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','r')
                    
            %         histogram(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','b','FaceAlpha',0.1) % Igor said it is better to show y-axis as percent instead of count,
            %         plot(mean(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','b')
                    % if you set 'Normalization' to probability and then multiply it by 100,
                    % this works same as "ig_hist2per function"
                    set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
                    legend(sprintf(Actor_A),''); % for the legend, name of Actor_A is printed
                    xlabel('reaction time(ms), bin width = 50 ms');
                    ylabel('% of trials');
                    subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID))));...
                        strcat(sprintf(Actor_B),':','passive observer')};
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
                    sgtitle('Session with only Dyadic and SoloA')
                    
                               
                  end

    end
                    



    if sum(contains(SessionTaskType,["Dyadic","SoloARewardAB"])) == 2
       %% replace SoloARewardAB with SoloA
        Solo_A_ID_ALL = strfind(Trial_TaskType_All,'SoloARewardAB');
        Solo_A_ID_ALL = cellfun(@(x) ~isempty(x) && x == 1, Solo_A_ID_ALL);
        Solo_A_ID_ALL = find(Solo_A_ID_ALL);
        Trial_TaskType_All(Solo_A_ID_ALL) = {'SoloA'};
        RewardedID = find(strcmp(Rewarded_Aborted,'REWARD')); % indices of rewarded trials
        SoloAID_All = find(strcmp(Trial_TaskType_All,'SoloA')); % Be careful! This vector contains all trial IDs that presumably were SoloA, (rewarded "AND" SoloA is in TaskType_AND_Rewarded vector)
        DyadicID_All = find(strcmp(Trial_TaskType_All,'Dyadic'));
        %%
        SoloA_AND_RewardedID = intersect(SoloAID_All,RewardedID); 
        Dyadic_AND_RewardedID = intersect(DyadicID_All,RewardedID);
        
        diffGoSignalTime_ms_AllTrials = loadedDATA.A_GoSignalTime_ms - loadedDATA.B_GoSignalTime_ms; % negative means actor A is first 
       
        RT_A_ms_AllTrials  = loadedDATA.A_InitialFixationReleaseTime_ms - loadedDATA.A_GoSignalTime_ms;
        RT_B_ms_AllTrials  = loadedDATA.B_InitialFixationReleaseTime_ms - loadedDATA.B_GoSignalTime_ms;

        
        RT_A_ms_Rewarded  = RT_A_ms_AllTrials(RewardedID);
        RT_B_ms_Rewarded  = RT_B_ms_AllTrials(RewardedID);
        
        
        %% it is like that because it is a mixture of solo and semi-solo task.
        Actor_A = string(report_struct.unique_lists.A_Name);
        Actor_B = string(report_struct.unique_lists.B_Name);
        %% Who was first?
        
        %split into 3 categories: simultaneous, A first, B first
        %% Actor A:
        Turn_ActorA_Categ = {'first','second','simultaneously'}; % defining turn of actor in categorical data, later we will use this for plotting
        Turn_ActorA_Simul_All_ID = find(diffGoSignalTime_ms_AllTrials == 0); % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
        Turn_ActorA_Simul_Rewarded_ID = intersect(Turn_ActorA_Simul_All_ID,RewardedID); % Indices of trials that actor A and B acted simultaneously AND rewarded.
        Turn_ActorA_Simul_Rewarded_AND_Solo_ID = intersect(Turn_ActorA_Simul_All_ID,SoloA_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).
        Turn_ActorA_Simul_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_Simul_All_ID,Dyadic_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in Dyadic).
        
        
        
        Turn_ActorA_First_All_ID = find(diffGoSignalTime_ms_AllTrials<0);  % Indices of trials that actor A was the first (among all trials).
        Turn_ActorA_First_Rewarded_ID = intersect(Turn_ActorA_First_All_ID,RewardedID);% Indices of trials that actor A was the first (Rewarded trials).
        Turn_ActorA_First_Rewarded_AND_Solo_ID = intersect(Turn_ActorA_First_All_ID,SoloA_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in SemiSolo).
        Turn_ActorA_First_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_First_All_ID,Dyadic_AND_RewardedID);% Indices of trials that actor A was the first (Rewarded trials in Dyadic).
        
        
        
        Turn_ActorA_Second_All_ID = find(diffGoSignalTime_ms_AllTrials>0); % Indices of trials that actor A was the second (among all trials).
        Turn_ActorA_Second_Rewarded_ID = intersect(Turn_ActorA_Second_All_ID,RewardedID); % Indices of trials that actor A was the second (Rewarded trials).
        Turn_ActorA_Second_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorA_Second_All_ID,Dyadic_AND_RewardedID);
        Turn_ActorA_Second_Rewarded_AND_Solo_ID = intersect(Turn_ActorA_Second_All_ID,SoloA_AND_RewardedID); % Indices of trials that actor A was the second (Rewarded trials in SemiSolo).
        
        %% Actor B: Pay attention that diffGoSignalTime_ms_AllTrials negative means actor A is first, so actor B is second (line 82, should be more than zero and line 85 should be less than zero)
        Turn_ActorB_Simul_All_ID = Turn_ActorA_Simul_All_ID; % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
        Turn_ActorB_Simul_Rewarded_ID = intersect(Turn_ActorB_Simul_All_ID,RewardedID); % Indices of trials that actor A and B acted simultaneously AND rewarded.
        Turn_ActorB_Simul_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorB_Simul_All_ID,Dyadic_AND_RewardedID);
        
        Turn_ActorB_First_All_ID = find(diffGoSignalTime_ms_AllTrials>0);  % Indices of trials that actor B was the first (among all trials).
        Turn_ActorB_First_Rewarded_ID = intersect(Turn_ActorB_First_All_ID,RewardedID);% Indices of trials that actor B was the first (Rewarded trials).
        Turn_ActorB_First_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorB_First_All_ID,Dyadic_AND_RewardedID);
        
        Turn_ActorB_Second_All_ID = find(diffGoSignalTime_ms_AllTrials<0); % Indices of trials that actor B was the second (among all trials).
        Turn_ActorB_Second_Rewarded_ID = intersect(Turn_ActorB_Second_All_ID,RewardedID); % Indices of trials that actor B was the second (Rewarded trials).
        Turn_ActorB_Second_Rewarded_AND_Dyadic_ID = intersect(Turn_ActorB_Second_All_ID,Dyadic_AND_RewardedID);

        %% 2) Plotting: 
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
        
%         histogram(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','b','FaceAlpha',0.1) % Igor said it is better to show y-axis as percent instead of count,
        % if you set 'Normalization' to probability and then multiply it by 100,
        % this works same as "ig_hist2per function"
%         plot(mean(RT_B_ms_AllTrials(Turn_ActorB_Second_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','b')
        set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
        legend(sprintf(Actor_A),''); % for the legend, name of Actor_A is printed
        xlabel('reaction time(ms), bin width = 50 ms');
        ylabel('% of trials');
        subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_AND_Solo_ID))));...
            strcat(sprintf(Actor_B),':','passive observer')};
        subtitle(subtitletxt);
        % pbaspect([1 1 1])
        %%
        sh(8) = subplot(3,3,8);
        histogram(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
        hold on
        plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','r')
        
%         histogram(RT_B_ms_AllTrials(Turn_ActorB_Simul_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','b','FaceAlpha',0.1) % Igor said it is better to show y-axis as percent instead of count,
%         plot(mean(RT_B_ms_AllTrials(Turn_ActorB_Simul_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','b')
        % if you set 'Normalization' to probability and then multiply it by 100,
        % this works same as "ig_hist2per function"
        set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
        legend(sprintf(Actor_A),''); % for the legend, name of Actor_A is printed
        xlabel('reaction time(ms), bin width = 50 ms');
        ylabel('% of trials');
        subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_AND_Solo_ID))));...
            strcat(sprintf(Actor_B),':','passive observer')};
        subtitle(subtitletxt);
        title('nominally simultaneously')
        % pbaspect([1 1 1])
        %%
        sh(9) = subplot(3,3,9);
        histogram(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
        hold on
        plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','r')
        
%         histogram(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_Solo_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','b','FaceAlpha',0.1) % Igor said it is better to show y-axis as percent instead of count,
%         plot(mean(RT_B_ms_AllTrials(Turn_ActorB_First_Rewarded_AND_Solo_ID)),-0.005,"^",'Color','b')
        % if you set 'Normalization' to probability and then multiply it by 100,
        % this works same as "ig_hist2per function"
        set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
        legend(sprintf(Actor_A),''); % for the legend, name of Actor_A is printed
        xlabel('reaction time(ms), bin width = 50 ms');
        ylabel('% of trials');
        subtitletxt = {strcat(sprintf(Actor_A),':','trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_AND_Solo_ID))));...
            strcat(sprintf(Actor_B),':','passive observer')};
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
        sgtitle('Session with only Dyadic and SoloA')

    end