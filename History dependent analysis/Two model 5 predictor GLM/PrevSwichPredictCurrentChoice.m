
% here imoprt the data:
close all,  clear,   clc
%%
%cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes\Clean_DATA_Seb\NHP'
%run('HPHP_fullPath.m');
% VBA_Path = fullfile('C:', 'Users', 'zahra', 'OneDrive', 'Documents', 'PostDoc_DPZ', 'Zahra codes', 'VBA_AllFunctions');
% addpath(VBA_Path)
starting_dir = fullfile('C:', 'Users', 'zahra', 'OneDrive', 'Documents', 'PostDoc_DPZ', 'Zahra codes', 'Clean_DATA_Seb', 'NHP');
% addpath(starting_dir)
% rmpath(starting_dir)

InsideFold = dir(starting_dir);
AllFolders = {InsideFold.name};
str = AllFolders;
num = regexp(str, '\w+', 'match');
emptyCells = cellfun('isempty', num);
AllFolders = str(~emptyCells);
Actors = {'A','B'};
NaiveConditionString = 'Naiv'
AllConfConditionString = 'Confederate';
trainedName = 'Trained';
ConfTrainedString = 'ConfederateTrained'
NaiveIdx = contains(AllFolders,NaiveConditionString)
ConditionIndex = contains(AllFolders, AllConfConditionString); %filter out Naive folders
NOTtrainedIdx = ~contains(AllFolders, trainedName); %filter out only confederate 
ConfTrainedTogetherConditionIndex = xor(ConditionIndex,NOTtrainedIdx);
ConfTrainedTogetherConditionIndex = ConfTrainedTogetherConditionIndex & (~NaiveIdx);
%ConditionIndex = ConditionIndex(NOTtrainedIdx);
ConditionIndex = ConfTrainedTogetherConditionIndex
ConditionFoldersName = AllFolders(ConditionIndex);

RT_ToleranceThreshold = 100;
LW = 3 %Line Width
LinkFunction = 'probit'
FirstCol = [255,20,147]./255
SimCol = [216,191,216]./255
SecCol = [127,255,212]./255


% Loop through each folder in ConditionFolders
for fol = 1:length(ConditionFoldersName)


    % Get the folder name
    folderName = fullfile(starting_dir, ConditionFoldersName{fol});

    % Change directory to the folder
    %cd(folderName);
    ConditionFoldersName_dirstruct = dir(fullfile(folderName, '*.mat'));

    valid_ConditionFoldersName_dirstruct = ConditionFoldersName_dirstruct(~[ConditionFoldersName_dirstruct.isdir]);

    valid_matfile_list = {valid_ConditionFoldersName_dirstruct.name};
    for i_matfile = 1 : length(valid_matfile_list)
        cur_valid_matfile = valid_matfile_list{i_matfile};

        cur_session_id = regexprep(regexp(cur_valid_matfile, '\w*\.\w*\.\w*\.\w*\.triallog', 'match'), '^DATA_', '');
        cur_session_id = regexprep(cur_session_id, '.triallog$', '');


        cur_session_id = fn_parse_session_id(cur_session_id);
        if i_matfile == 1
            cur_session_id_struct_arr = cur_session_id;
        else
            cur_session_id_struct_arr = [cur_session_id_struct_arr, cur_session_id];
        end
    end

    key_table = strcat({cur_session_id_struct_arr.YYYYMMDD_string}, {cur_session_id_struct_arr.subject_A}, {cur_session_id_struct_arr.subject_B});

    [unique_keys, ~, unique_key_idx] = unique(key_table);
    NotMergedDATA = cell(1,length(valid_matfile_list));
    % if (length(unique_keys) < length(key_table))
    for i_matfile = 1 : length(valid_matfile_list)

        NotMergedDATA{i_matfile} = load(fullfile(folderName, valid_matfile_list{i_matfile}));
    end

    UniqSess = unique(unique_key_idx);
    MergedData = cell(1,numel(UniqSess));
    for WholeSess = 1 : numel(UniqSess)
        SessId = unique_key_idx == UniqSess(WholeSess);
        MergedData{WholeSess} = NotMergedDATA(SessId);

    end
   





    for idata = 1 : length(MergedData)
        ColorChoice = [];
        RTA = [];
        RTB = [];

        BeforeShedding = MergedData{idata};
        if length(BeforeShedding)>1
            for i_struct = 1 : length(BeforeShedding)
                TransientData = [];
                if i_struct == 1
                    TransientData = BeforeShedding{i_struct};
                    RewardedANDdyadicTrialId = find(...
                        TransientData.FullPerTrialStruct.TrialIsRewarded ...
                        & TransientData.FullPerTrialStruct.TrialIsJoint ...
                        & (TransientData.FullPerTrialStruct.NumChoiceTargetsPerTrial == 2)...
                        );

                    % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)

                    ColorChoice(1,:) = TransientData.isOwnChoiceArray(1,:); %own colour = 1
                    ColorChoice(2,:) = TransientData.isOwnChoiceArray(2,:); %own colour = 1

                     RTA = TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
                     RTB = TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);



                end
                if i_struct > 1
                                 
                    TransientData = BeforeShedding{i_struct};

                    RewardedANDdyadicTrialId = find(...
                        TransientData.FullPerTrialStruct.TrialIsRewarded ...
                        & TransientData.FullPerTrialStruct.TrialIsJoint ...
                        & (TransientData.FullPerTrialStruct.NumChoiceTargetsPerTrial == 2)...
                        );

                    % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)
                    TransientsColorChoiceA = [];
                    TransientsColorChoiceA = [ColorChoice(1,:),TransientData.isOwnChoiceArray(1,:)];

                    TransientsColorChoiceB = [];
                    TransientsColorChoiceB = [ColorChoice(2,:),TransientData.isOwnChoiceArray(2,:)];

                    ColorChoice = [];

                    ColorChoice(1,:) = TransientsColorChoiceA; %own colour = 1
                    ColorChoice(2,:) = TransientsColorChoiceB; %own colour = 1


                    TransientRTA = [];
                    TransientRTB = [];

                    TransientRTA = [RTA;TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx)];
                    TransientRTB = [RTB;TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx)];
                  
                    RTA = [];
                    RTB = [];
                    RTA = TransientRTA;
                    RTB = TransientRTB;



                end


            end

        end
    
            
                

        if isscalar(BeforeShedding)

            TransientData = BeforeShedding{1};
            % RewardedANDdyadicTrialId = intersect(TransientData.TrialSets.All(logical(TransientData.FullPerTrialStruct. ...
            %     TrialIsRewarded)), TransientData.TrialSets.All(logical(TransientData.FullPerTrialStruct. ...
            %     TrialIsJoint)));

            RewardedANDdyadicTrialId = find(...
                TransientData.FullPerTrialStruct.TrialIsRewarded ...
                & TransientData.FullPerTrialStruct.TrialIsJoint ...
                & (TransientData.FullPerTrialStruct.NumChoiceTargetsPerTrial == 2)...
                );


            % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)
            ColorChoice = [];
            ColorChoice(1,:) = TransientData.isOwnChoiceArray(1,:); %own colour = 1
            ColorChoice(2,:) = TransientData.isOwnChoiceArray(2,:); %own colour = 1

            % Coordinated_trial_ldx = A_ColorChoice | B_ColorChoice;
              

              RTA = [];
              RTB = [];
              
              RTA = TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
              RTB = TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);



        end

        if size(ColorChoice,1)>2
            ColorChoice = ColorChoice';
        end

        %% RT
             diffRT_AB = [];
            diffRT_AB = RTA - RTB;  % minus means actor A was first, o means simul, positive means Actor A was second

%% finding turns ids
            ATurnIdx = [];
            ATurnIdx = nan(length(diffRT_AB),3);  %first column is actor A first, Second column is actor A/B simul, third column is Actor A second,
            tmp_AgoB = diffRT_AB < (- RT_ToleranceThreshold);
            tmp_BgoA = diffRT_AB > ( RT_ToleranceThreshold);
            tmp_ABgo = ~tmp_AgoB & ~tmp_BgoA;

            % ATurnIdx(:,1) = diffRT_AB<0;
            % ATurnIdx(:,2) = (diffRT_AB > 0) & (diffRT_AB < RT_ToleranceThreshold);
            % ATurnIdx(:,3) = diffRT_AB>0;

            ATurnIdx(:,1) = tmp_AgoB;
            ATurnIdx(:,2) = tmp_ABgo;
            ATurnIdx(:,3) = tmp_BgoA;


            BTurnIdx = [];
            BTurnIdx = fliplr(ATurnIdx);
            TurnIdx = [];
            TurnIdx(:,:,1) = ATurnIdx;
            TurnIdx(:,:,2) = BTurnIdx;
            %% finding switches ids:
            AswitchesIdx = [];
            BswitchesIdx = [];

            AswitchesIdx = find(abs(diff(ColorChoice(1,:))))+1;
            BswitchesIdx = find(abs(diff(ColorChoice(2,:))))+1;
            
            A_SelfToOther = [];
            A_OtherToSelf = [];
            A_SelfToOther = find(diff(ColorChoice(1,:))<0)+1;
            A_OtherToSelf = find(diff(ColorChoice(1,:))>0)+1;

            B_SelfToOther = [];
            B_OtherToSelf = [];
            B_SelfToOther = find(diff(ColorChoice(2,:))<0)+1;
            B_OtherToSelf = find(diff(ColorChoice(2,:))>0)+1;


            
            BeforeAfter_Length = 5;
            ANotValidSwitchID_All_ID = [];
            BNotValidSwitchID_All_ID = [];

            if sum(AswitchesIdx-(BeforeAfter_Length+1)<= 0) >= 1
                ANotValidSwitchID_All_ID = find(AswitchesIdx-(BeforeAfter_Length+1)<= 0);
            end

            if sum(BswitchesIdx-(BeforeAfter_Length+1)<= 0) >= 1
                BNotValidSwitchID_All_ID = find(BswitchesIdx-(BeforeAfter_Length+1)<= 0);
            end
 
            if sum(AswitchesIdx+(BeforeAfter_Length+1)>= numel(ColorChoice(1,:)))>= 1
                if isempty(ANotValidSwitchID_All_ID)
                    ANotValidSwitchID_All_ID = find(AswitchesIdx+(BeforeAfter_Length+1)>= numel(ColorChoice(1,:)));
                end
                if ~isempty(ANotValidSwitchID_All_ID)
                    ANotValidSwitchID_All_ID = [ANotValidSwitchID_All_ID,find(AswitchesIdx+(BeforeAfter_Length+1)>= numel(ColorChoice(1,:)))];
                end
            end

            if sum(BswitchesIdx+(BeforeAfter_Length+1)>= numel(ColorChoice(2,:)))>= 1
                if isempty(BNotValidSwitchID_All_ID)
                    BNotValidSwitchID_All_ID = find(BswitchesIdx+(BeforeAfter_Length+1)>= numel(ColorChoice(2,:)));
                end
                if ~isempty(BNotValidSwitchID_All_ID)
                    BNotValidSwitchID_All_ID = [BNotValidSwitchID_All_ID,find(BswitchesIdx+(BeforeAfter_Length+1)>= numel(ColorChoice(2,:)))];
                end
            end
            
            ANotValidSwitchID_All_ID = unique(ANotValidSwitchID_All_ID);
            BNotValidSwitchID_All_ID = unique(BNotValidSwitchID_All_ID);

            A_SelfToOther = setdiff(A_SelfToOther,AswitchesIdx(ANotValidSwitchID_All_ID));
            A_OtherToSelf = setdiff(A_OtherToSelf,AswitchesIdx(ANotValidSwitchID_All_ID));

            B_SelfToOther = setdiff(B_SelfToOther,BswitchesIdx(BNotValidSwitchID_All_ID));
            B_OtherToSelf = setdiff(B_OtherToSelf,BswitchesIdx(BNotValidSwitchID_All_ID));

            SelfToOther = {};
            SelfToOther{1} = A_SelfToOther;
            SelfToOther{2} = B_SelfToOther;
            
            OtherToSelf = {};
            OtherToSelf{1} = A_OtherToSelf;
            OtherToSelf{2} = B_OtherToSelf;

            AswitchesIdx(ANotValidSwitchID_All_ID) = [];
            BswitchesIdx(BNotValidSwitchID_All_ID) = [];

 


            

    
%% defining switching vetors: timed defined all trials (red curve)

          
            A_AllTurn_NonTurn_ReplacedNan = nan(length(diffRT_AB),3); %1st column: first, 2d column: simul... 
            B_AllTurn_NonTurn_ReplacedNan = nan(length(diffRT_AB),3);

            for Turn = 1 : 3
                A_AllTurn_NonTurn_ReplacedNan([logical(BTurnIdx(:,Turn))],Turn) = ones(sum(BTurnIdx(:,Turn)),1);
                B_AllTurn_NonTurn_ReplacedNan([logical(BTurnIdx(:,Turn))],Turn) = ones(sum(BTurnIdx(:,Turn)),1);
            end
            AllTurn_NonTurn_ReplacedNan = [];
            AllTurn_NonTurn_ReplacedNan(:,:,1) = A_AllTurn_NonTurn_ReplacedNan; %first page belongs to actor A
            AllTurn_NonTurn_ReplacedNan(:,:,2) = B_AllTurn_NonTurn_ReplacedNan;
            
            %row: turn number column: mean of before, at, after switch page: actor
           
      
        
              
    
  %% defining switching vetors: At switch timw defined (pink curve)

             for Turn = 1 : 3
                 for AC = 1 : 2
                     if AC == 1
                        SelfToOther_AtSwitch{AC,Turn} = intersect(SelfToOther{AC}',find(BTurnIdx(:,Turn)));
                        OtherToSelf_AtSwitch{AC,Turn} = intersect(OtherToSelf{AC}',find(BTurnIdx(:,Turn)));
                     else
                         SelfToOther_AtSwitch{AC,Turn} = intersect(SelfToOther{AC}',find(BTurnIdx(:,Turn)));
                         OtherToSelf_AtSwitch{AC,Turn} = intersect(OtherToSelf{AC}',find(BTurnIdx(:,Turn)));
                     end
                 end
             end
            %This cell contains idx of swhcites based on actor's turn for example when actor was first and switch happens %first row belong to actor A
            %second row belongs to Actor B %first cell is switches when actor was first, second cell is simul, third cell is second
            %row: turn number column: mean of before, at, after switch page: actor
       

       
            for AC = 1 : 2
                for Turn = 1 : 3
                    NeededSwitchVector = ColorChoice(AC,:)';
                    SwitchTypeSelfOtheridx = SelfToOther_AtSwitch{AC,Turn};
                    SwitchTypeOtherSelfidx = OtherToSelf_AtSwitch{AC,Turn};
                    SelfOther_NeededSwitchVector = nan(numel(SwitchTypeSelfOtheridx),BeforeAfter_Length+1);
                    OtherSelf_NeededSwitchVector = nan(numel(SwitchTypeOtherSelfidx),BeforeAfter_Length+1);
                    SelfOtherDiffTrials = []
                    SelfOtherChoiceAtSwitch = []

                    for i = 1 : numel(SwitchTypeSelfOtheridx)
                        BEG = SwitchTypeSelfOtheridx(i)-BeforeAfter_Length;
                        END = SwitchTypeSelfOtheridx(i);
                        SelfOther_NeededSwitchVector(i,:) = NeededSwitchVector(BEG:END);
                        SelfOtherDiffTrials(i,:) = diff(NeededSwitchVector(BEG:END));
                        SelfOtherChoiceAtSwitch(i) = NeededSwitchVector(SwitchTypeSelfOtheridx(i));

                    end
                    OtherSelfDiffTrials = []
                    OtherSelfChoiceAtSwitch =[]

                    for i = 1 : numel(SwitchTypeOtherSelfidx)
                        BEG = SwitchTypeOtherSelfidx(i)-BeforeAfter_Length;
                        END = SwitchTypeOtherSelfidx(i);
                        OtherSelf_NeededSwitchVector(i,:) = NeededSwitchVector(BEG:END);
                        OtherSelfDiffTrials(i,:) = diff(NeededSwitchVector(BEG:END));
                        OtherSelfChoiceAtSwitch(i) = NeededSwitchVector(SwitchTypeOtherSelfidx(i));

                        
                    end
                    AtSwitch_SelfOtherActor_CategorizedSwitchesPartner{AC,Turn} = SelfOther_NeededSwitchVector;
                    AtSwitch_OtherSelfActor_CategorizedSwitchesPartner{AC,Turn} = OtherSelf_NeededSwitchVector;
                    AtSwitch_Selfother_PrevSwitches{AC,Turn} = abs(SelfOtherDiffTrials);
                    AtSwitch_OtherSelf_PrevSwitches{AC,Turn} = abs(OtherSelfDiffTrials);

                    AtSwitch_SelfOther_CurrentChoice{AC,Turn} = SelfOtherChoiceAtSwitch;
                    AtSwitch_OtherSelf_CurrentChoice{AC,Turn} = OtherSelfChoiceAtSwitch;
                end
            end


            %% cros switches: we want to look at the impact of current switch done by the actor depending on the history of parnter's switches




             %  for Turn = 1 : 3
             %     for AC = 1 : 2
             %         if AC == 1
             %            CrossSelfToOther_AtSwitch{AC,Turn} = intersect(SelfToOther{2}',find(BTurnIdx(:,Turn)));
             %            CrossOtherToSelf_AtSwitch{AC,Turn} = intersect(OtherToSelf{2}',find(BTurnIdx(:,Turn)));
             %         else
             %             CrossSelfToOther_AtSwitch{AC,Turn} = intersect(SelfToOther{1}',find(BTurnIdx(:,Turn)));
             %             CrossOtherToSelf_AtSwitch{AC,Turn} = intersect(OtherToSelf{1}',find(BTurnIdx(:,Turn)));
             %         end
             %     end
             % end

            for AC = 1 : 2
                for Turn = 1 : 3
                        ActorNeededSwitchVector = ColorChoice(AC,:)';
                        if AC == 1
                           PartnerNeededSwitchVector = ColorChoice(2,:)';
                        else
                           PartnerNeededSwitchVector = ColorChoice(1,:)';
                        end
                        SwitchTypeSelfOtheridx = SelfToOther_AtSwitch{AC,Turn};
                        SwitchTypeOtherSelfidx = OtherToSelf_AtSwitch{AC,Turn};
                        % PattnerSwitchTypeSelfOtheridx = CrossSelfToOther_AtSwitch{AC,Turn};
                        % PartnerSwitchTypeOtherSelfidx = CrossOtherToSelf_AtSwitch{AC,Turn};

                        SelfOther_NeededSwitchVector = nan(numel(SwitchTypeSelfOtheridx),BeforeAfter_Length+1);
                        OtherSelf_NeededSwitchVector = nan(numel(SwitchTypeOtherSelfidx),BeforeAfter_Length+1);
    
                        SelfOtherActor_PartnerDiffTrials = []
                        SelfOtherActorChoicAtSwitch_PartnerSwitcHist = []

    
                        for i = 1 : numel(SwitchTypeSelfOtheridx)
                            BEG = SwitchTypeSelfOtheridx(i)-BeforeAfter_Length;
                            END = SwitchTypeSelfOtheridx(i);
                            ActorSelfOther_PartnerNeededSwitchVector(i,:) = PartnerNeededSwitchVector(BEG:END);
                            SelfOtherActor_PartnerDiffTrials(i,:) = diff(PartnerNeededSwitchVector(BEG:END));

                            SelfOtherActorChoicAtSwitch_PartnerSwitcHist(i) = ActorNeededSwitchVector(SwitchTypeSelfOtheridx(i));


                        end

                        OtherSelfActor_PartnerDiffTrials = []
                        OtherSelfActorChoicAtSwitch_PartnerSwitcHist = []

    
                        for i = 1 : numel(SwitchTypeOtherSelfidx)
                            BEG = SwitchTypeOtherSelfidx(i)-BeforeAfter_Length;
                            END = SwitchTypeOtherSelfidx(i);
                            OtherSelf_NeededSwitchVector(i,:) = PartnerNeededSwitchVector(BEG:END);
                            OtherSelfActor_PartnerDiffTrials(i,:) = diff(PartnerNeededSwitchVector(BEG:END));

                            OtherSelfActorChoicAtSwitch_PartnerSwitcHist(i) = ActorNeededSwitchVector(SwitchTypeOtherSelfidx(i));

                        end
                        AtSwitch_SelfOtherActor_CategorizedSwitchesPartner{AC,Turn} = SelfOther_NeededSwitchVector;
                        AtSwitch_OtherSelfActor_CategorizedSwitchesPartner{AC,Turn} = OtherSelf_NeededSwitchVector;
                        AtSwitch_SelfotherActor_PrevSwitchesPartner{AC,Turn} = abs(SelfOtherActor_PartnerDiffTrials);
                        AtSwitch_OtherSelfActor_PrevSwitchesPartner{AC,Turn} = abs(OtherSelfActor_PartnerDiffTrials);

                         ActorAtSwitch_Selfother_CurrentChoice_PartnerSwitchHist{AC,Turn} = SelfOtherActorChoicAtSwitch_PartnerSwitcHist;
                        ActorAtSwitch_OtherSelf_CurrentChoice_PartnerSwitchHist{AC,Turn} = OtherSelfActorChoicAtSwitch_PartnerSwitcHist;


                 end
            end
            %% GLM fitting  responses are always 1 because 1 means switch
            for AC = 1:2
                for Turn = 1: 3
                    PREDICTORselfOther = AtSwitch_Selfother_PrevSwitches{AC,Turn};
                    PREDICTORotherSelf =  AtSwitch_OtherSelf_PrevSwitches{AC,Turn};
                    PREDICTOR_SelfOther_Partnerhist = AtSwitch_SelfotherActor_PrevSwitchesPartner{AC,Turn};
                    PREDICTOR_OtherSelf_PartnerHist =  AtSwitch_OtherSelfActor_PrevSwitchesPartner{AC,Turn};

                   RESPONSEselfOther = categorical(AtSwitch_SelfOther_CurrentChoice{AC,Turn}'); %be carefull that 1 in response means preferred color but 1 in predictor means switch
                    %you have to change responses to categorical to not
                    %create the same meaning of 1 in predictors for
                    %responses
                    RESPONSEOtherSelf = categorical(AtSwitch_OtherSelf_CurrentChoice{AC,Turn}');
                    RESEPONSE_SelfOtherPartnerHist = categorical(ActorAtSwitch_Selfother_CurrentChoice_PartnerSwitchHist{AC,Turn}');
                    RESPONSE_OtherSelfPartnerHist = categorical(ActorAtSwitch_OtherSelf_CurrentChoice_PartnerSwitchHist{AC,Turn}');

                    if size(PREDICTORselfOther,1)>1
                        SelfOtherModel = fitglm(PREDICTORselfOther,categorical(RESPONSEselfOther),'linear','Distribution','binomial','Link',LinkFunction);
                        SelfOtherCoefs{AC}(:,idata,Turn) = table2array(SelfOtherModel.Coefficients(2:end,1));
                    else
                        SelfOtherCoefs{AC}(:,idata,Turn) = nan(BeforeAfter_Length,1);
                    end
                    if size(PREDICTORotherSelf,1)>1
                        OtherSelfModel = fitglm(PREDICTORotherSelf,categorical(RESPONSEOtherSelf),'linear','Distribution','binomial','Link',LinkFunction);
                        OtherSelfCoefs{AC}(:,idata,Turn) = table2array(OtherSelfModel.Coefficients(2:end,1));
                    else
                        OtherSelfCoefs{AC}(:,idata,Turn) = nan(BeforeAfter_Length,1);
                    end
                    if size(PREDICTOR_SelfOther_Partnerhist,1)>1
                        SelfotherActor_PrevSwitchPartnerModel = fitglm(PREDICTOR_SelfOther_Partnerhist,categorical(RESEPONSE_SelfOtherPartnerHist),'linear','Distribution','binomial','Link',LinkFunction);
                        SelfotherActor_PrevSwitchPartnerCoefs{AC}(:,idata,Turn) = table2array(SelfotherActor_PrevSwitchPartnerModel.Coefficients(2:end,1));
                    else
                        SelfotherActor_PrevSwitchPartnerCoefs{AC}(:,idata,Turn) = nan(BeforeAfter_Length,1);
                    end
                    if size(PREDICTOR_OtherSelf_PartnerHist,1)>1
                        OtherSelfActor_PrevSwitchPartnerModel = fitglm(PREDICTOR_OtherSelf_PartnerHist,categorical(RESPONSE_OtherSelfPartnerHist),'linear','Distribution','binomial','Link',LinkFunction);
                        OtherSelfActor_PrevSwitchPartnerCoefs{AC}(:,idata,Turn) = table2array(OtherSelfActor_PrevSwitchPartnerModel.Coefficients(2:end,1));
                    else
                        OtherSelfActor_PrevSwitchPartnerCoefs{AC}(:,idata,Turn) = nan(BeforeAfter_Length,1);
                    end

                end
            end
          
            
    end
    A_Name = cur_session_id_struct_arr.subject_A;
    B_Name = cur_session_id_struct_arr.subject_B;
    xtickstring = 'trial n-%d'
    for i = 1 : BeforeAfter_Length
        xtickname(i,:)= sprintf(xtickstring,i);
    end

      for AC = 1 : 2
                MeanSelfOtherCoefs{AC} = squeeze(mean(SelfOtherCoefs{AC}(:,:,:),2,'omitnan'));
                MeanOtherSelfCoefs{AC} = squeeze(mean(OtherSelfCoefs{AC}(:,:,:),2,'omitnan'));
                MeanSelfOtherActor_PrevSwitchPartnerCoefs{AC} = squeeze(mean(SelfotherActor_PrevSwitchPartnerCoefs{AC}(:,:,:),2,'omitnan'));
                MeanOtherSelfActor_PrevSwitchPartnerCoefs{AC} = squeeze(mean(OtherSelfActor_PrevSwitchPartnerCoefs{AC}(:,:,:),2,'omitnan'));
      end
      figure('Position',[1,49,1536,740.8])
            for AC = 1:2
                if AC == 1
                   subplot(2,4,1), hold on
                   for Turn = 1:3
                       if Turn == 1
                           Col = FirstCol;
                       end
                       if Turn == 2
                           Col = SimCol;
                       end
                       if Turn == 3
                           Col = SecCol;
                       end
                       plot(1:BeforeAfter_Length,flipud(MeanSelfOtherCoefs{AC}(:,Turn)),'o-','Color',Col,'LineWidth',LW)
                   end
                   ylabel('GLM Weight')
                   xticks(1:5)
                   xticklabels(string(xtickname))
                   xtickangle(45)
                   title('SO Actor Switch, actor switch history')
                   subplot(2,4,2), hold on
                   for Turn = 1:3
                       if Turn == 1
                           Col = FirstCol;
                       end
                       if Turn == 2
                           Col = SimCol;
                       end
                       if Turn == 3
                           Col = SecCol;
                       end
                       plot(1:BeforeAfter_Length,flipud(MeanOtherSelfCoefs{AC}(:,Turn)),'o-','Color',Col,'LineWidth',LW)
                   end
                   ylabel('GLM Weight')
                   xticks(1:5)
                   xticklabels(string(xtickname))
                   xtickangle(45)

                   title('OS Actor Switch, actor switch history')
                   subplot(2,4,3), hold on
                   for Turn = 1:3
                       if Turn == 1
                           Col = FirstCol;
                       end
                       if Turn == 2
                           Col = SimCol;
                       end
                       if Turn == 3
                           Col = SecCol;
                       end
                       plot(1:BeforeAfter_Length,flipud(MeanSelfOtherActor_PrevSwitchPartnerCoefs{AC}(:,Turn)),'o-','Color',Col,'LineWidth',LW)
                   end
                   ylabel('GLM Weight')
                   xticks(1:5)
                   xticklabels(string(xtickname))
                   xtickangle(45)

                   title('SO Actor switch, Partner Switch history')
                   subplot(2,4,4), hold on
                   for Turn = 1:3
                       if Turn == 1
                           Col = FirstCol;
                       end
                       if Turn == 2
                           Col = SimCol;
                       end
                       if Turn == 3
                           Col = SecCol;
                       end
                       plot(1:BeforeAfter_Length,flipud(MeanOtherSelfActor_PrevSwitchPartnerCoefs{AC}(:,Turn)),'o-','Color',Col,'LineWidth',LW)
                   end
                   ylabel('GLM Weight')
                   xticks(1:5)
                   xticklabels(string(xtickname))
                   xtickangle(45)

                   title('OS Actor Switch, Partner Switch history')

                else
                    subplot(2,4,5), hold on
                   for Turn = 1:3
                       if Turn == 1
                           Col = FirstCol;
                       end
                       if Turn == 2
                           Col = SimCol;
                       end
                       if Turn == 3
                           Col = SecCol;
                       end
                       plot(1:BeforeAfter_Length,flipud(MeanSelfOtherCoefs{AC}(:,Turn)),'o-','Color',Col,'LineWidth',LW)
                   end
                   ylabel('GLM Weight')
                   xticks(1:5)
                   xticklabels(string(xtickname))
                   xtickangle(45)

                   title('SO Actor Switch, Actor Switch History')
                   subplot(2,4,6), hold on
                   for Turn = 1:3
                       if Turn == 1
                           Col = FirstCol;
                       end
                       if Turn == 2
                           Col = SimCol;
                       end
                       if Turn == 3
                           Col = SecCol;
                       end
                       plot(1:BeforeAfter_Length,flipud(MeanOtherSelfCoefs{AC}(:,Turn)),'o-','Color',Col,'LineWidth',LW)
                   end
                   ylabel('GLM Weight')
                   xticks(1:5)
                   xticklabels(string(xtickname))
                   xtickangle(45)

                   title('OS Actor Switch, Actor Switch History')
                   subplot(2,4,7), hold on
                   for Turn = 1:3
                       if Turn == 1
                           Col = FirstCol;
                       end
                       if Turn == 2
                           Col = SimCol;
                       end
                       if Turn == 3
                           Col = SecCol;
                       end
                       plot(1:BeforeAfter_Length,flipud(MeanSelfOtherActor_PrevSwitchPartnerCoefs{AC}(:,Turn)),'o-','Color',Col,'LineWidth',LW)
                   end
                   ylabel('GLM Weight')
                   xticks(1:5)
                   xticklabels(string(xtickname))
                   xtickangle(45)

                   title('SOActor Switch, Partner Switch History')
                   subplot(2,4,8), hold on
                   for Turn = 1:3
                       if Turn == 1
                           Col = FirstCol;
                       end
                       if Turn == 2
                           Col = SimCol;
                       end
                       if Turn == 3
                           Col = SecCol;
                       end
                       plot(1:BeforeAfter_Length,flipud(MeanOtherSelfActor_PrevSwitchPartnerCoefs{AC}(:,Turn)),'o-','Color',Col,'LineWidth',LW)
                   end
                   ylabel('GLM Weight')
                   xticks(1:5)
                   xticklabels(string(xtickname))
                   xtickangle(45)

                   title('OS Actor Switch, Partner Switch History')
                end

            end

            legend('Bfirst','Bsimul','Bsecond','Position',[0.924999551816042 0.475611949499088 0.0639322923993072 0.0715442780027121])
            sgtitle(strcat(A_Name,'-',B_Name,'-Current Choice, Switch History'))
            annotation('textbox',...
            [0.0400625 0.70950323974082 0.0469166666666667 0.0453563714902788],...
            'String',sprintf(A_Name),...
            'FitBoxToText','off');

            annotation('textbox',...
            [0.0395416666666666 0.258099352051834 0.0469166666666666 0.0453563714902789],...
            'String',sprintf(B_Name),...
            'FitBoxToText','off');
              filename = []
                filename = strcat(A_Name,'-',B_Name,'-Current Choice, TimingSwitch History.jpg');
                ax = gcf;
                exportgraphics(ax,sprintf(filename),'Resolution',600)

end
  





% 
% rmpath(VBA_Path)
% 
