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


                                      %% counter to see if the code evaluates all sessions


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
    c = 1;
    for SessNum = 1 : numel(FullSessionPath)
    load(char(FullSessionPath{SessNum}))

    loadedDATA = array2table(report_struct.data,'VariableNames',report_struct.header);
    Rewarded_Aborted  = report_struct.unique_lists.A_OutcomeENUM(loadedDATA.A_OutcomeENUM_idx); % this vector shows which trial was aborted, which was successful,
    Trial_TaskType_All = report_struct.unique_lists.A_TrialSubTypeENUM(loadedDATA.A_TrialSubTypeENUM_idx); % this vector shows trial type based on task.
    SessionTaskType = unique(Trial_TaskType_All);
    %% Extracting the index of sessions with pure SoloA
    
    if sum(matches(SessionTaskType,"SoloA")) == numel(SessionTaskType)
       Sessions_SoloA_ID(c) = SessNum;
       Actor_A{c} = string(report_struct.unique_lists.A_Name);
       c = c+1;
    end
    end

    %% Going through SoloA and extracting mean RT and SD RT
    Mean_RT_SoloASessions = nan(numel(Sessions_SoloA_ID),3);  %initializng the mran RT matrix, 3 columns for 3 timings
    SD_RT_SoloASessions  = nan(numel(Sessions_SoloA_ID),3); % the same for Standard deviation



    for SessSolo = 1 : numel(Sessions_SoloA_ID)
        ID = Sessions_SoloA_ID(SessSolo);
        load(char(FullSessionPath{ID}));
        loadedDATA = array2table(report_struct.data,'VariableNames',report_struct.header);
        Rewarded_Aborted  = report_struct.unique_lists.A_OutcomeENUM(loadedDATA.A_OutcomeENUM_idx); % this vector shows which trial was aborted, which was successful,
 
        Statitical_Results = struct;
        diffGoSignalTime_ms_AllTrials = loadedDATA.A_GoSignalTime_ms - loadedDATA.B_GoSignalTime_ms;
        RewardedID = find(strcmp(Rewarded_Aborted,'REWARD')); % indices of rewarded trials
        RT_A_ms_AllTrials  = loadedDATA.A_InitialFixationReleaseTime_ms - loadedDATA.A_GoSignalTime_ms;
        RT_A_ms_Rewarded  = RT_A_ms_AllTrials(RewardedID);
        
        Turn_ActorA_Categ = {'first','second','simultaneously'}; % defining turn of actor in categorical data, later we will use this for plotting
        Turn_ActorA_Simul_All_ID = find(diffGoSignalTime_ms_AllTrials == 0); % Indices of trials that actor A and B acted simultaneously, attention! it is extracted from all trials, not rewarded.
        Turn_ActorA_Simul_Rewarded_ID = intersect(Turn_ActorA_Simul_All_ID,RewardedID); % Indices of trials that actor A and B acted simultaneously AND rewarded.



        Turn_ActorA_First_All_ID = find(diffGoSignalTime_ms_AllTrials<0);  % Indices of trials that actor A was the first (among all trials).
        Turn_ActorA_First_Rewarded_ID = intersect(Turn_ActorA_First_All_ID,RewardedID);% Indices of trials that actor A was the first (Rewarded trials).



        Turn_ActorA_Second_All_ID = find(diffGoSignalTime_ms_AllTrials>0); % Indices of trials that actor A was the second (among all trials).
        Turn_ActorA_Second_Rewarded_ID = intersect(Turn_ActorA_Second_All_ID,RewardedID); % Indices of trials that actor A was the second (Rewarded trials).

        %% plottig


        figure
         sh(1) = subplot(3,3,1,'replace');
         sh(2) = subplot(3,3,2,'replace');
         sh(3) = subplot(3,3,3,'replace');
         sh(4) = subplot(3,3,4,'replace');
         sh(5) = subplot(3,3,5,'replace');
         sh(6) = subplot(3,3,6,'replace');
  
         sh(7) = subplot(3,3,7);
                 histogram(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r');
                 hold on
                 plot(mean(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_ID)),-0.005,"^",'Color','r')
                 ytix = get(gca, 'YTick');
                set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
                xlabel('reaction time(ms), bin width = 50 ms');
                ylabel('% of trials');
                subtitletxt = {strcat('trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_ID))))};
                subtitle(subtitletxt);

                Mean_RT_SoloASessions(SessSolo,1) = mean(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_ID));
                SD_RT_SoloASessions(SessSolo,1) = std(RT_A_ms_AllTrials(Turn_ActorA_First_Rewarded_ID));


        sh(8) = subplot(3,3,8);
                histogram(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
                hold on
                plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_ID)),-0.005,"^",'Color','r')
                ytix = get(gca, 'YTick');
                set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
                xlabel('reaction time(ms), bin width = 50 ms');
                ylabel('% of trials');
                subtitletxt = {strcat('trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_ID))))};
                subtitle(subtitletxt);
                title('nominally simultaneously')

                Mean_RT_SoloASessions(SessSolo,2) = mean(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_ID));
                SD_RT_SoloASessions(SessSolo,2) = std(RT_A_ms_AllTrials(Turn_ActorA_Simul_Rewarded_ID));


        sh(9) = subplot(3,3,9);
                histogram(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_ID),bins,'DisplayStyle','bar','Normalization','probability','FaceColor','r') % Igor said it is better to show y-axis as percent instead of count,
                hold on
                plot(mean(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_ID)),-0.005,"^",'Color','r')
                ytix = get(gca, 'YTick');
                set(gca, 'YTick',ytix, 'YTickLabel',ytix*100);
                xlabel('reaction time(ms), bin width = 50 ms');
                ylabel('% of trials');
                subtitletxt = {strcat('trial number =',string(numel(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_ID))))};
                subtitle(subtitletxt);
                set(sh(:),'Xlim',[0 1000]);

                set(sh(:),'Ylim',[-0.01 0.25]);

                Mean_RT_SoloASessions(SessSolo,3) = mean(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_ID));
                SD_RT_SoloASessions(SessSolo,3) = std(RT_A_ms_AllTrials(Turn_ActorA_Second_Rewarded_ID));


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

                Pat4FieldName = digitsPattern; %pattern to detect 6 digit number, the goal is to remove '.' from the months names
                fieldname = FullSessionPath{SessSolo};
                NeededName = extract(fieldname,Pat4FieldName);
                FName = strcat('Session: ',NeededName{8})
                FName = strtrim(FName);
                sgtitle({sprintf(Actor_A{SessSolo}),'SOLO',sprintf(FName)})
       
    end


figure
for S = 1 : numel(Sessions_SoloA_ID)
    plot(1:3,Mean_RT_SoloASessions(S,:),'o-')
    hold on
    xticks([1 2 3])
    xlim([0 4])
    xticklabels(["First","Simul","Second"])
end
title('Mean RT across sessions, among three timing')
figure
for S = 1 : numel(Sessions_SoloA_ID)
    plot(1:3,SD_RT_SoloASessions(S,:),'o-')
    hold on
    xticks([1 2 3])
    xlim([0 4])
    xticklabels(["First","Simul","Second"])
end
title('SD of RT across sessions, among three timing')

%% Repeated measure anova  with one within factor timing


RESPONSE = Mean_RT_SoloASessions;
Timing = {'First', 'Simul', 'Second'};

% Create a table with the data and variable names
t = table(RESPONSE(:, 1), RESPONSE(:, 2), RESPONSE(:, 3), 'VariableNames', Timing);

% Define the within-subject factors as separate columns
PREDICTORS = table({'First'; 'Simul'; 'Second'}, 'VariableNames', {'Timing'});

% Perform the repeated measures ANOVA
rm = fitrm(t, 'First,Simul,Second~1', 'WithinDesign', PREDICTORS)
ranovaResults = ranova(rm)








