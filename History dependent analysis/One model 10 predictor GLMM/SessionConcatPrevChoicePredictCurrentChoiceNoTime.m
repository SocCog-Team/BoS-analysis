
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
BeforeAfter_Length = 3;
LW = 3 %Line Width
MS = 14 % marker size

LinkFunction = 'logit'
DataDist = 'Binomial'
FittingMethod = 'Laplace'
        %% creating name for predictors and also x tick labes
        SelfPredcitstring = 'SelfChoice_%dFromN'
        PartnerPredcitstring = 'PartnerChoice_%dFromN'

        for i = 1 : BeforeAfter_Length
            SelfHistString{i}= sprintf(SelfPredcitstring,i);
            PartHistString{i}= sprintf(PartnerPredcitstring,i);
        end

        VarNames = ['Trials',SelfHistString,PartHistString,'CurrentChoice'];
        %% creating table and formula for GLMM data

NeededString1 = []
NeededString2 = []
for i = 1 : BeforeAfter_Length
    NeededString1 = strcat(NeededString1,' + ',SelfHistString{i})
    NeededString2 = strcat(NeededString2,' + ',PartHistString{i})
end
NeededString = strcat(NeededString1,NeededString2);

ChoiceHistModel = strcat('CurrentChoice ~ ',NeededString(3:end),' + (1|Trials)')
%%

SelfHistCol = [255,20,147]./255;
PartnerHistCol = [173,216,230]./255;

convertZeroOne = @(x) (x == 0).*(x+1) + (x == 1).* (x*0); % This will convert 0 to 1 and 1 to 0

% Loop through each folder in ConditionFolders
for fol = 1:length(ConditionFoldersName)
    SessConcatChoiceeVector = []

           SelChoiceHistory_PartnerChoiceHistyory_Model = []
            ChoiceHistoryCoefs = []
            ChoiceHistoryGoodnessOfFit = []


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
        HistoryChoicePredictor = []
        ChoiceResponse = []

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
    

            if idata == 1
                SessConcatChoiceeVector = ColorChoice;

            else
                SessConcatChoiceeVector = [SessConcatChoiceeVector,ColorChoice];
            end
    
    end



        for AC = 1 : 2
            Choicevector = SessConcatChoiceeVector(AC,:)';
            HistoryVector = []
            for i = 1 : BeforeAfter_Length
                HistoryVector(:,i) = vertcat(nan(i,1),Choicevector(1:end-i));
            end
            ChoiceResponse(:,AC) = Choicevector;
            HistoryChoicePredictor(:,:,AC) = HistoryVector;

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

            PREDICTORselfChoice = []
            PREDICTORselfChoice = squeeze(HistoryChoicePredictor(:,:,AC));
            RESPONSE = []
            RESPONSE = ChoiceResponse(:,AC); %In both predictor and response, 1 means preferred color
            PREDICTORpartnerChoice = []
            if AC == 1
                PREDICTORpartnerChoice = arrayfun(convertZeroOne,squeeze(HistoryChoicePredictor(:,:,2))); %remember we use NOT here because 1 of partner's choice means 0 of actor's choice
            else
                PREDICTORpartnerChoice = arrayfun(convertZeroOne,squeeze(HistoryChoicePredictor(:,:,1)));
            end

            NeededTable = []
            NeededTable = array2table([TrialsVector,PREDICTORselfChoice,PREDICTORpartnerChoice,RESPONSE],'VariableNames',VarNames);
 
            SelChoiceHistory_PartnerChoiceHistyory_Model = fitglme(NeededTable,sprintf(ChoiceHistModel),'Distribution',DataDist,'Link',LinkFunction,'FitMethod',FittingMethod);
            % [~,~,statsFixed] = fixedEffects(SelChoiceHistory_PartnerChoiceHistyory_Model)
            % [~,~,statsRandom] = randomEffects(SelChoiceHistory_PartnerChoiceHistyory_Model)
            ChoiceHistoryCoefs(:,AC) = double(SelChoiceHistory_PartnerChoiceHistyory_Model.Coefficients(2:end,2));
            ChoiceHistoryGoodnessOfFit(:,AC) = double(SelChoiceHistory_PartnerChoiceHistyory_Model.Coefficients(2:end,6));



        end


    %end
    A_Name = cur_session_id_struct_arr.subject_A;
    B_Name = cur_session_id_struct_arr.subject_B;
    xtickstring = 'trial n-%d'
    for i = 1 : BeforeAfter_Length
        xtickname(i,:)= sprintf(xtickstring,i);
    end

    for AC = 1 : 2
        MeanAcrossSessChoiceHistoryCoefs{AC} = ChoiceHistoryCoefs(:,AC)
        MeanAcrossSessChoiceHistoryGoodnessPval{fol}(AC,:) =   ChoiceHistoryGoodnessOfFit(:,AC)


    end

    figure('Position',[1,49,1536,740.8])
    xaxis = 1:BeforeAfter_Length;


    for AC = 1 : 2
        if AC == 1

            subplot(1,2,AC), hold on

            plot(1:BeforeAfter_Length,MeanAcrossSessChoiceHistoryCoefs{AC}(1:BeforeAfter_Length,:),'o-','Color',SelfHistCol,'LineWidth',LW)
            plot(1:BeforeAfter_Length,MeanAcrossSessChoiceHistoryCoefs{AC}(BeforeAfter_Length+1:end,:),'o-','Color',PartnerHistCol,'LineWidth',LW)
            % ylim([-4 4])
             yaxisSelf = MeanAcrossSessChoiceHistoryCoefs{AC}(1:BeforeAfter_Length);
             StarFilterSelf =   MeanAcrossSessChoiceHistoryGoodnessPval{fol}(AC,1:BeforeAfter_Length)<0.05;
            if sum(StarFilterSelf)~= 0
                plot(xaxis(StarFilterSelf),yaxisSelf(StarFilterSelf),'*k','MarkerSize',MS)
            end
             yaxisOther = MeanAcrossSessChoiceHistoryCoefs{AC}(BeforeAfter_Length+1:end);
             StarFilterOther =   MeanAcrossSessChoiceHistoryGoodnessPval{fol}(AC,BeforeAfter_Length+1:end)<0.05;
            if sum(StarFilterOther)~= 0
                plot(xaxis(StarFilterOther),yaxisOther(StarFilterOther),'*k','MarkerSize',MS)
            end
       

   

            ylabel('GLM Weight')
            xticks(1:5)
            xticklabels(string(xtickname))
            xtickangle(45)
            title(sprintf(A_Name))
        else
            subplot(1,2,AC), hold on
            plot(1:BeforeAfter_Length,MeanAcrossSessChoiceHistoryCoefs{AC}(1:BeforeAfter_Length),'o-','Color',SelfHistCol,'LineWidth',LW)
            plot(1:BeforeAfter_Length,MeanAcrossSessChoiceHistoryCoefs{AC}(BeforeAfter_Length+1:end),'o-','Color',PartnerHistCol,'LineWidth',LW)
            % ylim([-4 4])
             yaxisSelf = MeanAcrossSessChoiceHistoryCoefs{AC}(1:BeforeAfter_Length);
             StarFilterSelf =   MeanAcrossSessChoiceHistoryGoodnessPval{fol}(AC,1:BeforeAfter_Length)<0.05;
            if sum(StarFilterSelf)~= 0
                plot(xaxis(StarFilterSelf),yaxisSelf(StarFilterSelf),'*k','MarkerSize',MS)
            end
             yaxisOther = MeanAcrossSessChoiceHistoryCoefs{AC}(BeforeAfter_Length+1:end);
             StarFilterOther =   MeanAcrossSessChoiceHistoryGoodnessPval{fol}(AC,BeforeAfter_Length+1:end)<0.05;
            if sum(StarFilterOther)~= 0
                plot(xaxis(StarFilterOther),yaxisOther(StarFilterOther),'*k','MarkerSize',MS)
            end
            ylabel('GLM Weight')
            xticks(1:5)
            xticklabels(string(xtickname))
            xtickangle(45)
            title(sprintf(B_Name))



        end



        legend('Self Choice History','Partner Choice History','Position',[0.151562051244831 0.915136787512047 0.111848960208396 0.0715442780027125])
        sgtitle(strcat(A_Name,'-',B_Name,'-Current Choice, Choice History'))


    end
    filename = []
    filename = strcat(A_Name,'-',B_Name,'-Current Choice, Choice History.jpg');
    ax = gcf;
    exportgraphics(ax,sprintf(filename),'Resolution',600)

end






%
% rmpath(VBA_Path)
%
