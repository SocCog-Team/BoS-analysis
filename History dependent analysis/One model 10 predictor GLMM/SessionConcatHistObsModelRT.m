
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
BeforeAfter_Length = 1;
LW = 2 %Line Width
MS = 14 % marker size
SignificancyMS = 8 %marker size for significancy

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


    figure('Position',[1,49,1536,740.8])
    tiledlayout('flow')

% Loop through each folder in ConditionFolders
for fol = 1:length(ConditionFoldersName)
    nexttile, hold on
    SessConcatChoiceeVector = []

           SelfChoiceHist_PartnerChoiceHist_ObservedHist_Model = []
            ChoiceHistObservedHistCoefs = []
            ChoiceHisObservedHistGoodnessOfFit_pval = []


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
            
            PREDICTORobservedAction = [];
            PREDICTORobservedAction = SessConcatObservTrialsvector(:,AC);
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
            NeededTable = array2table([TrialsVector,PREDICTORselfChoice,PREDICTORpartnerChoice,PREDICTORobservedAction,RESPONSE],'VariableNames',VarNames);
 
            SelfChoiceHist_PartnerChoiceHist_ObservedHist_Model = fitglme(NeededTable,sprintf(ChoiceHistObservedHistModel),'Distribution',DataDist,'Link',LinkFunction,'FitMethod',FittingMethod,'DummyVarCoding','effects');
            % [~,~,statsFixed] = fixedEffects(SelChoiceHistory_PartnerChoiceHistyory_Model)
            % [~,~,statsRandom] = randomEffects(SelChoiceHistory_PartnerChoiceHistyory_Model)
            ChoiceHistObservedHistCoefs(:,AC) = double(SelfChoiceHist_PartnerChoiceHist_ObservedHist_Model.Coefficients(2:end,2));
            ChoiceHisObservedHistGoodnessOfFit_pval(:,AC) = double(SelfChoiceHist_PartnerChoiceHist_ObservedHist_Model.Coefficients(2:end,6));
            ChoiceHisObservedHistGoodnessOfFit_R2(AC) = SelfChoiceHist_PartnerChoiceHist_ObservedHist_Model.Rsquared.Ordinary;




        end


    %end
    A_Name = cur_session_id_struct_arr.subject_A;
    B_Name = cur_session_id_struct_arr.subject_B;
    % xtickstring = 'trial n-%d'
    % for i = 1 : BeforeAfter_Length
    %     xtickname(i,:)= sprintf(xtickstring,i);
    % end
    xtickname ={'trial n','trial n-1'};
    for AC = 1 : 2
        MeanAcrossSessChoiceHistoryCoefs{AC} = ChoiceHistObservedHistCoefs(:,AC)
        MeanAcrossSessChoiceHistoryGoodnessPval{fol}(AC,:) =   ChoiceHisObservedHistGoodnessOfFit_pval(:,AC);
        MeanAcrossSessChoiceHistoryGoodnessR2{fol}(AC) =   ChoiceHisObservedHistGoodnessOfFit_R2(AC);



    end

    


    for AC = 1 : 2
        if AC == 1


            plot(2,MeanAcrossSessChoiceHistoryCoefs{AC}(1:BeforeAfter_Length,:),'diamond-','Color',SelfHistCol,'MarkerSize',MS,'LineWidth',LW)
            plot(2,MeanAcrossSessChoiceHistoryCoefs{AC}(BeforeAfter_Length+1:BeforeAfter_Length+BeforeAfter_Length,:),'diamond-','Color',PartnerHistCol,'MarkerSize',MS,'LineWidth',LW)
            plot(1,MeanAcrossSessChoiceHistoryCoefs{AC}((2*BeforeAfter_Length)+1,:),'diamond-','Color',ObservedHistCol,'MarkerSize',MS,'LineWidth',LW)
            plot(2,MeanAcrossSessChoiceHistoryCoefs{AC}((2*BeforeAfter_Length)+2,:),'diamond-','Color',InteractPatnerOwnCol,'MarkerSize',MS,'LineWidth',LW)

            

            % ylim([-4 4])
             yaxisSelf = MeanAcrossSessChoiceHistoryCoefs{AC}(1);
             StarFilterSelf =   MeanAcrossSessChoiceHistoryGoodnessPval{fol}(AC,1)<0.05;
            if sum(StarFilterSelf)~= 0
                plot(2,yaxisSelf(StarFilterSelf),'*k','MarkerSize',SignificancyMS)
            end
             yaxisOther = MeanAcrossSessChoiceHistoryCoefs{AC}(2);
             StarFilterOther =   MeanAcrossSessChoiceHistoryGoodnessPval{fol}(AC,2)<0.05;
            if sum(StarFilterOther)~= 0
                plot(2,yaxisOther(StarFilterOther),'*k','MarkerSize',SignificancyMS)
            end
             yaxisObserved = MeanAcrossSessChoiceHistoryCoefs{AC}(3);
             StarFilterObserved =   MeanAcrossSessChoiceHistoryGoodnessPval{fol}(AC,3)<0.05;
            if sum(StarFilterObserved)~= 0
                plot(1,yaxisObserved(StarFilterObserved),'*k','MarkerSize',SignificancyMS)
            end
            yaxisINTERACT = MeanAcrossSessChoiceHistoryCoefs{AC}(4);
             StarFilterINTERACT =   MeanAcrossSessChoiceHistoryGoodnessPval{fol}(AC,4)<0.05;
            if sum(StarFilterINTERACT)~= 0
                plot(2,yaxisINTERACT(StarFilterINTERACT),'*k','MarkerSize',SignificancyMS)
            end
       

   

     
        else
            plot(2,MeanAcrossSessChoiceHistoryCoefs{AC}(1:BeforeAfter_Length,:),'s','Color',SelfHistCol,'MarkerSize',MS+1,'LineWidth',LW)
            
            plot(2,MeanAcrossSessChoiceHistoryCoefs{AC}(BeforeAfter_Length+1:BeforeAfter_Length+BeforeAfter_Length,:),'s','Color',PartnerHistCol,'MarkerSize',MS,'LineWidth',LW)
            
            plot(1,MeanAcrossSessChoiceHistoryCoefs{AC}((2*BeforeAfter_Length)+1,:),'s','Color',ObservedHistCol,'MarkerSize',MS,'LineWidth',LW)
            plot(2,MeanAcrossSessChoiceHistoryCoefs{AC}((2*BeforeAfter_Length)+2,:),'s','Color',InteractPatnerOwnCol,'MarkerSize',MS,'LineWidth',LW)

            

            % ylim([-4 4])
             yaxisSelf = MeanAcrossSessChoiceHistoryCoefs{AC}(1);
             StarFilterSelf =   MeanAcrossSessChoiceHistoryGoodnessPval{fol}(AC,1)<0.05;
            if sum(StarFilterSelf)~= 0
                plot(2,yaxisSelf(StarFilterSelf),'*k','MarkerSize',SignificancyMS)
            end
             yaxisOther = MeanAcrossSessChoiceHistoryCoefs{AC}(2);
             StarFilterOther =   MeanAcrossSessChoiceHistoryGoodnessPval{fol}(AC,2)<0.05;
            if sum(StarFilterOther)~= 0
                plot(2,yaxisOther(StarFilterOther),'*k','MarkerSize',SignificancyMS)
            end
             yaxisObserved = MeanAcrossSessChoiceHistoryCoefs{AC}(3);
             StarFilterObserved =   MeanAcrossSessChoiceHistoryGoodnessPval{fol}(AC,3)<0.05;
            if sum(StarFilterObserved)~= 0
                plot(1,yaxisObserved(StarFilterObserved),'*k','MarkerSize',SignificancyMS)
            end
            yaxisINTERACT = MeanAcrossSessChoiceHistoryCoefs{AC}(4);
             StarFilterINTERACT =   MeanAcrossSessChoiceHistoryGoodnessPval{fol}(AC,4)<0.05;
            if sum(StarFilterINTERACT)~= 0
                plot(2,yaxisINTERACT(StarFilterINTERACT),'*k','MarkerSize',SignificancyMS)
            end
       
            ylabel('GLM Weight')
            xticks(1:2)
            xticklabels(string(xtickname))
            xtickangle(45)
            xlim([0 3])



        end



        title(strcat(A_Name,'-',B_Name,' pair'))
        subtitle(strcat('R2= ',string(round(MeanAcrossSessChoiceHistoryGoodnessR2{fol}(1),1)),' ,',string(round(MeanAcrossSessChoiceHistoryGoodnessR2{fol}(2),1))))
        % ylim([-20 20])


    end

end
        legend('Self Choice History','Partner Choice History',"Obsrved partner's choice","interaction between partner's choice history and self choice history",'Position',[0.357421869523823 0.472113028897752 0.262890630476177 0.0938174966602038]);
        annotation('rectangle', [0.4025625 0.973002159827214 0.00837500000000002 0.016198704103668],'Color','k')
        annotation('rectangle',[0.40646875 0.935745140388768 0.00837500000000002 0.0172786177105768],'Rotation',45);
        annotation('textbox',[0.422744791666666 0.973002159827211 0.0427083341963589 0.029157667386596],'String',{'Actor A'},'FitBoxToText','on');
        annotation('textbox',[0.422223958333333 0.940334773218137 0.0542083333333339 0.0248380129589589],'String',{'Actor B'},'FitBoxToText','on');

        filename = 'ChoiceHistObservedActModel_MonkeyMonkey.jpg';
        ax = gcf;
         exportgraphics(ax,sprintf(filename),'Resolution',600)













%
% rmpath(VBA_Path)
%
