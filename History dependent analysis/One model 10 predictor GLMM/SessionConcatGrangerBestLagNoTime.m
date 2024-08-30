
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
            
            Y = RESPONSE;
            if AC == 1
               X = ChoiceResponse(:,2);
            else
               X = ChoiceResponse(:,1);
            end
            [p_valueGranger, LikelihoodRatioStatisticGranger,BestLag] = GrangerCausalityBinary(Y, X)
            PVal_EachSubj(AC,fol) = p_valueGranger;
            BESTLAG_EachSubj(AC,fol) = BestLag;

                %end
            A_Name = cur_session_id_struct_arr.subject_A;
            B_Name = cur_session_id_struct_arr.subject_B;
            if AC == 1
                PairName{fol}{AC} = A_Name;
            else
                PairName{fol}{AC} = B_Name;
            end




            %%NeededTable = []
            %%NeededTable = array2table([TrialsVector,PREDICTORselfChoice,PREDICTORpartnerChoice,RESPONSE],'VariableNames',VarNames);
 
            %%SelChoiceHistory_PartnerChoiceHistyory_Model = fitglme(NeededTable,sprintf(ChoiceHistModel),'Distribution',DataDist,'Link',LinkFunction,'FitMethod',FittingMethod);
            % [~,~,statsFixed] = fixedEffects(SelChoiceHistory_PartnerChoiceHistyory_Model)
            % [~,~,statsRandom] = randomEffects(SelChoiceHistory_PartnerChoiceHistyory_Model)

            %%ChoiceHistoryCoefs(:,AC) = double(SelChoiceHistory_PartnerChoiceHistyory_Model.Coefficients(2:end,2));
            %%ChoiceHistoryGoodnessOfFit(:,AC) = double(SelChoiceHistory_PartnerChoiceHistyory_Model.Coefficients(2:end,6));



        end
end
figure('Position',[488,105.8,749,556.2])
XtickString = {};
a = 0
Col1 = [255,127,80]./255;
Col2 = [0,250,154]./255;
Col3 = [255,105,180]./255;
Col4 = [106,90,205]./255;
MonkeyPair_ColorMap = vertcat(Col1,Col2,Col3,Col4);
XTICK = [];
for fol = 1 : length(ConditionFoldersName)
    for AC = 1 : 2
        if AC == 1
            x = fol+a;
        else
            x = fol+a+1;
        end
        subplot(1,2,1)
        plot(x,PVal_EachSubj(AC,fol),'o','MarkerFaceColor',MonkeyPair_ColorMap(fol,:),'MarkerSize',MS)
        hold on
        XtickString = [XtickString,PairName{fol}{AC}]
        subplot(1,2,2)
        plot(x,BESTLAG_EachSubj(AC,fol),'o','MarkerFaceColor',MonkeyPair_ColorMap(fol,:),'MarkerSize',MS)
        hold on
        XTICK = [XTICK,x]

    end
    a = a + 3;
end
subplot(1,2,1)
ylabel('P value from log likelihood ratio test')
yline(0.05,'--r')
xticks(XTICK)
xticklabels(XtickString)


subplot(1,2,2)
xticks(XTICK)
xticklabels(XtickString)
ylabel('Best lag from trial n')
sgtitle("partner's choice Granger causes monkey's choice'")


 
    filename = []
    filename = 'GrangerCausePVal_BestLag.jpg';
    ax = gcf;
    exportgraphics(ax,sprintf(filename),'Resolution',600)








%
% rmpath(VBA_Path)
%
