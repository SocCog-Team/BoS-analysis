
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

ActionTimingMeasure = 'AT';

RT_ToleranceThreshold = 100;
BeforeAfter_Length = 1;
LW = 2 %Line Width
MS = 14 % marker size
SignificancyMS = 8 %marker size for significancy
MoveMeanWindowLength = 8;
LinkFunction = 'logit'
DataDist = 'Binomial'
FittingMethod = 'Laplace'
%% creating name for predictors and also x tick labes
SelfPredcitstring = 'SelfChoice_%dFromN'
PartnerPredcitstring = 'PartnerChoice_%dFromN'
% ObservedActionString = 'ObservedTrial_%dFromN'

for i = 1 : BeforeAfter_Length
    SelfHistString{i}= sprintf(SelfPredcitstring,i);
    PartHistString{i}= sprintf(PartnerPredcitstring,i);
    % ObservedActionHistString{i} = sprintf(ObservedActionString,i);
end

% VarNames = ['Trials',SelfHistString,PartHistString,ObservedActionHistString,'CurrentChoice'];
VarNames = ['Trials',SelfHistString,PartHistString,'ObservedTrial','CurrentChoice'];

%% creating table and formula for GLMM data

NeededString1 = []
NeededString2 = []
NeededString3 = []

for i = 1 : BeforeAfter_Length
    NeededString1 = strcat(NeededString1,' * ',SelfHistString{i})
    NeededString2 = strcat(NeededString2,' * ',PartHistString{i})
    % NeededString3 = strcat(NeededString3,' * ',ObservedActionHistString{i})

end
% NeededString = strcat(NeededString1,NeededString2,NeededString3);
NeededString = strcat(NeededString1,NeededString2,' +ObservedTrial');


ChoiceHistObservedHistModel = strcat('CurrentChoice ~ ',NeededString(3:end),' + (1|Trials)')
%%

SelfHistCol = [255,20,147]./255;
PartnerHistCol = [173,216,230]./255;
ObservedHistCol = [127,255,212]./255;
InteractPatnerOwnCol = [178 102 255]./255;

convertZeroOne = @(x) (x == 0).*(x+1) + (x == 1).* (x*0); % This will convert 0 to 1 and 1 to 0




% Loop through each folder in ConditionFolders
for fol = 1 :length(ConditionFoldersName)
     figure('Position',[1,49,1536,740.8])
     CS = 0;
    SessConcatChoiceeVector = []

    SelFChoiceHist_PartnerChoiceHist_ObservedHist_Model = []
    ChoiceHistObservedHistCoefs = []
    ChoiceHisObservedHistGoodnessOfFit = []


    % Get the folder name
    folderName = fullfile(starting_dir, ConditionFoldersName{fol});

    % Change directory to the folder
    %cd(folderName);
    ConditionFoldersName_dirstruct = dir(fullfile(folderName, '*.mat'));

    valid_ConditionFoldersName_dirstruct = ConditionFoldersName_dirstruct(~[ConditionFoldersName_dirstruct.isdir]);

    valid_matfile_list = {valid_ConditionFoldersName_dirstruct.name};
    PlayerA_Name = cell(1,length(valid_matfile_list))
    for i_matfile = 1 : length(valid_matfile_list)
        MatFileName = valid_matfile_list{i_matfile};
        NeededString = extractBetween(MatFileName,'triallog','IC');
        PlayerAName = extractBetween(NeededString,Actors{1},Actors{2})
        PlayerA_Name{i_matfile} = extractBetween(PlayerAName,'.','.')
    end
    %% evaluate if the all mat file inside the current folder, have the same actor A or actor A changed to B in some sessions:
    FirstSessActorA = PlayerA_Name{1}
    FirstSessActorB = extractBetween(valid_matfile_list{1},'triallog','IC')
    FirstSessActorB = extractBetween(FirstSessActorB,Actors{2},'_')
    FirstSessActorB = extractAfter(FirstSessActorB,'.')
    Actor_A_matchesIdx = cellfun(@(x) strcmp(x, FirstSessActorA), PlayerA_Name)
    MatFile_ActorBgotA_IndexNumber = []
    if sum(Actor_A_matchesIdx) ~= length(valid_matfile_list)
        MatFile_ActorBgotA_IndexNumber = find(~Actor_A_matchesIdx)
    end
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
    %% also you have to convert the MatFile_ActorBgotA_IndexNumber to idx of merged data
    if  ~isempty(MatFile_ActorBgotA_IndexNumber)
        MatFile_ActorBgotA_IndexNumber =  unique_key_idx(MatFile_ActorBgotA_IndexNumber)
    end
    %%
    if isempty(MatFile_ActorBgotA_IndexNumber)
        MatFile_ActorBgotA_IndexNumber = 0
    end


    for idata = 1 : length(MergedData)
        clear SelFChoiceHist_PartnerChoiceHist_ObservedHist_Model
        CS = CS+1;

        ColorChoice = [];
        RTA = [];
        RTB = [];
        ATA = [];
        ATB = [];
        HistoryChoicePredictor = []
        ChoiceResponse = []
        ObservedTrials = []

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
                    if ismember(idata,MatFile_ActorBgotA_IndexNumber)
                        ColorChoice(1,:) = TransientData.isOwnChoiceArray(2,:); %own colour = 1
                        ColorChoice(2,:) = TransientData.isOwnChoiceArray(1,:); %own colour = 1

                        RTA = TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
                        RTB = TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);

                        ATA = TransientData.FullPerTrialStruct.B_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx);
                        ATB = TransientData.FullPerTrialStruct.A_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx);
                    else
                        ColorChoice(1,:) = TransientData.isOwnChoiceArray(1,:); %own colour = 1
                        ColorChoice(2,:) = TransientData.isOwnChoiceArray(2,:); %own colour = 1

                        RTA = TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
                        RTB = TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);

                        ATA = TransientData.FullPerTrialStruct.A_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx);
                        ATB = TransientData.FullPerTrialStruct.B_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx);

                    end

                end
                if i_struct > 1

                    TransientData = BeforeShedding{i_struct};

                    RewardedANDdyadicTrialId = find(...
                        TransientData.FullPerTrialStruct.TrialIsRewarded ...
                        & TransientData.FullPerTrialStruct.TrialIsJoint ...
                        & (TransientData.FullPerTrialStruct.NumChoiceTargetsPerTrial == 2)...
                        );
                    if ismember(idata,MatFile_ActorBgotA_IndexNumber)
                        % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)
                        TransientsColorChoiceA = [];
                        TransientsColorChoiceA = [ColorChoice(1,:),TransientData.isOwnChoiceArray(2,:)];

                        TransientsColorChoiceB = [];
                        TransientsColorChoiceB = [ColorChoice(2,:),TransientData.isOwnChoiceArray(1,:)];

                        ColorChoice = [];

                        ColorChoice(1,:) = TransientsColorChoiceA; %own colour = 1
                        ColorChoice(2,:) = TransientsColorChoiceB; %own colour = 1


                        TransientRTA = [];
                        TransientRTB = [];

                        TransientRTA = [RTA;TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx)];
                        TransientRTB = [RTB;TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx)];

                        RTA = [];
                        RTB = [];
                        RTA = TransientRTA;
                        RTB = TransientRTB;

                        TransientATA = [];
                        TransientATB = [];

                        TransientATA = [ATA;TransientData.FullPerTrialStruct.B_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx)];
                        TransientATB = [ATB;TransientData.FullPerTrialStruct.A_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx)];

                        ATA = [];
                        ATB = [];
                        ATA = TransientATA;
                        ATB = TransientATB;
                    else
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

                        TransientATA = [];
                        TransientATB = [];

                        TransientATA = [ATA;TransientData.FullPerTrialStruct.A_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx)];
                        TransientATB = [ATB;TransientData.FullPerTrialStruct.B_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx)];

                        ATA = [];
                        ATB = [];
                        ATA = TransientATA;
                        ATB = TransientATB;
                    end


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

            if ismember(idata,MatFile_ActorBgotA_IndexNumber)
                % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)
                ColorChoice = [];
                ColorChoice(1,:) = TransientData.isOwnChoiceArray(2,:); %own colour = 1
                ColorChoice(2,:) = TransientData.isOwnChoiceArray(1,:); %own colour = 1

                % Coordinated_trial_ldx = A_ColorChoice | B_ColorChoice;


                RTA = [];
                RTB = [];

                RTA = TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
                RTB = TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);

                ATA = [];
                ATB = [];

                ATA = TransientData.FullPerTrialStruct.B_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx);
                ATB = TransientData.FullPerTrialStruct.A_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx);
            else
                % sanity check: isequal(Rewarded_Dyadic_IDs,TrialsInCurrentSetIdx)
                ColorChoice = [];
                ColorChoice(1,:) = TransientData.isOwnChoiceArray(1,:); %own colour = 1
                ColorChoice(2,:) = TransientData.isOwnChoiceArray(2,:); %own colour = 1

                % Coordinated_trial_ldx = A_ColorChoice | B_ColorChoice;


                RTA = [];
                RTB = [];

                RTA = TransientData.FullPerTrialStruct.A_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);
                RTB = TransientData.FullPerTrialStruct.B_InitialTargetReleaseRT(TransientData.TrialsInCurrentSetIdx);

                ATA = [];
                ATB = [];

                ATA = TransientData.FullPerTrialStruct.A_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx);
                ATB = TransientData.FullPerTrialStruct.B_IniTargRel_05MT_RT(TransientData.TrialsInCurrentSetIdx);
            end


        end

        if size(ColorChoice,1)>2
            ColorChoice = ColorChoice';
        end

        switch ActionTimingMeasure
            case 'RT'
                %% RT
                diffRT_AB = [];
                diffRT_AB = RTA - RTB;  % minus means actor A was first, o means simul, positive means Actor A was second
            case 'AT'
                %% RT
                diffRT_AB = [];
                diffRT_AB = ATA - ATB;  % minus means actor A was first, o means simul, positive means Actor A was second
        end
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
        ObservedTrials = []
        ObservedTrials = squeeze(TurnIdx(:,3,:)); %first column belongs to Actor A, second column belongs to Actor B,
        %each row is each trial, 1 means "observed" or when actor ws second, zero
        % means unobserved when actor was first or simultaneosuly taking action



        if idata == 1
            SessConcatChoiceeVector = ColorChoice;
            SessConcatObservTrialsvector = ObservedTrials;

        else
            SessConcatChoiceeVector = [SessConcatChoiceeVector,ColorChoice];
            SessConcatObservTrialsvector = [SessConcatObservTrialsvector;ObservedTrials];
        end

    end

        HistoryChoicePredictor = []
        ChoiceResponse = []
        for AC = 1 : 2
            Choicevector = SessConcatChoiceeVector(AC,:)';
            %Choicevector = ColorChoice(AC,:)';

            HistoryVector = []
            for i = 1 : BeforeAfter_Length
                HistoryVector(:,i) = vertcat(nan(i,1),Choicevector(1:end-i));
            end
            ChoiceResponse(:,AC) = Choicevector;
            HistoryChoicePredictor(:,AC) = HistoryVector;

        end


        %% GLMM fitting: in response array 1 means preferred color, 0 means non preferred color, so be aware that when
        % you use history of partner choices as predictors, 1 in partner
        % choice has to be converted to 0, thats why I wrote the function
        % "convertZeroOne" , to convert history ofb partner choices to
        % actor's point of view
        %%
        TrialsVector = []
        TrialsVector = (1 : size(HistoryVector,1))';


        for AC = 1:2
            PREDICTORobservedAction = [];
            PREDICTORobservedAction = SessConcatObservTrialsvector(:,AC);
            %PREDICTORobservedAction = ObservedTrials(:,AC);
            PREDICTORselfChoice = []
            PREDICTORselfChoice = HistoryChoicePredictor(:,AC);
            RESPONSE = []
            RESPONSE = ChoiceResponse(:,AC); %In both predictor and response, 1 means preferred color
            PREDICTORpartnerChoice = []
            if AC == 1
                PREDICTORpartnerChoice = arrayfun(convertZeroOne,HistoryChoicePredictor(:,2)); %remember we use NOT here because 1 of partner's choice means 0 of actor's choice
            else
                PREDICTORpartnerChoice = arrayfun(convertZeroOne,HistoryChoicePredictor(:,1));
            end

            NeededTable = []
            NeededTable = array2table([TrialsVector,PREDICTORselfChoice,PREDICTORpartnerChoice,PREDICTORobservedAction,RESPONSE],'VariableNames',VarNames);
            try
                SelFChoiceHist_PartnerChoiceHist_ObservedHist_Model = fitglme(NeededTable,sprintf(ChoiceHistObservedHistModel),'Distribution',DataDist,'Link',LinkFunction,'FitMethod',FittingMethod,'DummyVarCoding','effects');
                % [~,~,statsFixed] = fixedEffects(SelChoiceHistory_PartnerChoiceHistyory_Model)
                % [~,~,statsRandom] = randomEffects(SelChoiceHistory_PartnerChoiceHistyory_Model)
                ChoiceHistObservedHistCoefs(:,AC) = double(SelFChoiceHist_PartnerChoiceHist_ObservedHist_Model.Coefficients(2:end,2));
                ChoiceHisObservedHistGoodnessOfFit(:,AC) = double(SelFChoiceHist_PartnerChoiceHist_ObservedHist_Model.Coefficients(2:end,6));
                %ChoiceHisObservedHistGoodnessOfFit_R2 = [];
                % ChoiceHisObservedHistGoodnessOfFit_R2(AC) = SelFChoiceHist_PartnerChoiceHist_ObservedHist_Model.Rsquared.Adjusted;

                PredictedResponses{fol}(:,AC) = predict(SelFChoiceHist_PartnerChoiceHist_ObservedHist_Model);
                RealResp{fol}(:,AC) = RESPONSE;


                PREDICT = []
                PREDICT = predict(SelFChoiceHist_PartnerChoiceHist_ObservedHist_Model);
                PREDICT = binornd(1,PREDICT);
                [r_corrcoff,r_pval] = corr(RESPONSE(2:end),PREDICT(2:end))

                X = movmean(RESPONSE,MoveMeanWindowLength,'omitmissing');
                Y = movmean(PREDICT,MoveMeanWindowLength,'omitmissing');
                [r_smoothed,rp_smoothed] = corr(X(2:end),Y(2:end));
            catch
                CorrMatrix = corr(NeededTable{:,{'SelfChoice_1FromN','PartnerChoice_1FromN','ObservedTrial'}}, 'rows', 'complete');

            end







            %end
            A_Name = cur_session_id_struct_arr.subject_A;
            B_Name = cur_session_id_struct_arr.subject_B;

            AllDates_NotRepeat = unique(key_table)

            extractNumbers = @(str) regexp(str, '[\d.]+', 'match');
            AllDates_NotRepeat = cellfun(extractNumbers, AllDates_NotRepeat, 'UniformOutput', false);
            % xtickstring = 'trial n-%d'
            % for i = 1 : BeforeAfter_Length
            %     xtickname(i,:)= sprintf(xtickstring,i);
            % end
            xtickname ={'trial n','trial n-1'};


            RealBehvColr = [255 51 153]./255
            PredictedBehvColr = [51 255 153]./255
            
            if AC == 1
                ax1 = subplot(1,2,1)
                hold on
            else
                ax1 = subplot(1,2,2)
                hold on
            end

            try PredictedResponses{fol}(:,AC)
                RealBehv = []
                RealBehv = RealResp{fol}(:,AC);
                PredictedBehv= PredictedResponses{fol}(:,AC);
                plot(ax1,movmean(RealBehv,MoveMeanWindowLength),'-','Color',RealBehvColr)
                plot(ax1,movmean(PredictedBehv,MoveMeanWindowLength),'-','Color',PredictedBehvColr)

                xlabel(ax1,'trial number')
                ylabel(ax1,'FCO')
                if AC == 2
                    legend(ax1,'Real data','Predicted data','Position',[0.468737846744143 0.94203683364583 0.0837239595378436 0.0492710593452207])
                end





                % if AC == 1
                %     subtitle(strcat(A_Name,' R2= ',string(ChoiceHisObservedHistGoodnessOfFit_R2(1))))
                % else
                %     subtitle(strcat(B_Name,' R2= ',string(ChoiceHisObservedHistGoodnessOfFit_R2(2))))
                %
                % end


                if AC == 1
                    subtitle(ax1,strcat(FirstSessActorA,' r= ',string(round(r_corrcoff,2)),' p val = ',string(round(r_pval,4)),' smoothed r= ',string(round(r_smoothed,2))))
                else
                    subtitle(ax1,strcat(FirstSessActorB,' r= ',string(round(r_corrcoff,2)),' p val = ',string(round(r_pval,4)),' smoothed r= ',string(round(r_smoothed,2))))

                end

                % create smaller axes in top right, and plot on it
                if AC == 1
                    ax2 = axes('Position',[.4 .8 .1 .1])
                    box(ax2,'on')
                    hold on
                else
                    ax2 = axes('Position',[.8 .8 .1 .1])
                    box(ax2,'on')
                    hold on
                end


                Ydot = ChoiceHistObservedHistCoefs(:,AC);
                StarFilter = ChoiceHisObservedHistGoodnessOfFit(:,AC)<0.05;
                stem(1:4,Ydot)
                plot(ax2,find(StarFilter),Ydot(StarFilter),'*k')

                xticks(ax2,[1:4])
                xticklabels(ax2,{"Self Choice on n-1","Partner Choice on n-1","Observing Partner","interaction between self and partner previous choices"})
                xtickangle(ax2,45)
                xlim(ax2,[0 5])



            catch
                % Extract the upper triangle of the correlation matrix (excluding the diagonal)
                corrValues = [
                    CorrMatrix(1, 2);  % corr(Predictor1, Predictor2)
                    CorrMatrix(1, 3);  % corr(Predictor1, Predictor3)
                    CorrMatrix(2, 3)]; % corr(Predictor2, Predictor3)

                % Define labels for each pair of predictors
                labels = {
                    'Self History vs Partner History',
                    'Self History vs Observing Partner',
                    'Partner History vs Observing Partner'};

                % Create a bar plot

                bar(corrValues);

                % Set the x-axis labels
                set(gca, 'xticklabel', labels,'XTickLabelRotation',45);

                % Add title and labels

                ylabel('Correlation Coefficient');
                xlabel('Predictor Pairs');

                % Display the grid for better visualization
                grid on;
                % SessionDate = string(AllDates_NotRepeat{idata});
                if AC == 1
                    subtitle(strcat(FirstSessActorA,' Model failed due to high Multicollinearity among predictors'))
                else
                    subtitle(strcat(FirstSessActorB,' Model failed due to high Multicollinearity among predictors'))

                end


            end



        end
        SessionDate = string(AllDates_NotRepeat{idata})
        title(ax1,strcat(FirstSessActorA,'-',FirstSessActorB,' Number Of Sessions: ',string(CS)))

        filename = strcat(FirstSessActorA{1},'-',FirstSessActorB{1},'-','SessConCatMonkMonk_FCOglmWeights.pdf')
        ax = gcf;
        exportgraphics(ax,sprintf(filename),'Resolution',600)


  

end












%
% rmpath(VBA_Path)
%
