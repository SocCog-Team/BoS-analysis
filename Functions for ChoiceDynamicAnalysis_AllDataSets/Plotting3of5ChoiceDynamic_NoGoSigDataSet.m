function Plotting3of5ChoiceDynamic_NoGoSigDataSet(WhatOnYaxis,TimeMeasuredBehv,scriptName,ACTORA,ACTORB,FirstSessActorA,FirstSessActorB,SessionDate,MergedData,Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet)


Str2Vars(Results_CoreProcessing3of5ChoiceDynamic_NoGoSigDataSet)
alpha = 0.05;
BeforeAfter_Length = 5;

calcSEM = @(data) std(data,1,'omitnan') / sqrt(size(data,1));

ActorAcolor = [204 0 102]./255;
ActorBcolor = [0 0 204]./255;
ActorBAtSwitchCol = [204 255 229]./255;
ActorAatSwitchCol = [255 204 229]./255;

MainLineWidth = 1;
CI_Lines_LineWidth = 1;
DashedLine_LineWidth = CI_Lines_LineWidth;

CI_LINE_Color = [1 1 1 0];

Valid_Max_FCO = 1; %this is the valid value for maximum FCO, Later we ganna use this to clip CI in case of ver low sample size
%bc when sample size is too law for example only 2 switches, then CI can
%go more than 1 from t distribution so we have to clip CI (in case of using
%Baysian approach to calcualet CI this wont happen but bc here we simply
%use t dist, we can get values more than 1)
Valid_Min_FCO = 0;
%% when this function saves the final plots, based on what is on the y axis, it puts a name for the file to be saved:
switch WhatOnYaxis
    case 'TimeBehavior'
        ExtentionOfFileName = '_AT_onY';

    case 'ChoiceDynamic'
        ExtentionOfFileName = '_FCO_onY';

end

switch WhatOnYaxis
    case 'TimeBehavior'
        YlimRange = [0,1100];
        switch TimeMeasuredBehv
            case 'AT'
                Ylabel = "AT, ms";
            case 'RT'
                Ylabel = "RT, ms";
        end
    case 'ChoiceDynamic'
        YlimRange = [-0.2,1.2];
        Ylabel = "FCO"
end




%% plotting for single sess scripts
LASTsessBeAvr = 4;
if contains(scriptName,'SingleSess' ) || contains(scriptName,'OnlyLasts')

    if contains(scriptName,'OnlyLasts')
        %% plotting for only 4 last sessions scripts
        GetAverageFromEND = length(MergedData);  %number of last sessions you want to get average
        GetAverageFromBEG = GetAverageFromEND - (LASTsessBeAvr-1);
        GetAverageRange = GetAverageFromBEG : GetAverageFromEND;
    end
    if contains(scriptName,'OnlyLasts')
        clear SEM_OverSess_SelfOther
        clear SEM_OverSess_OtherSelf
        clear SEM_OverSessAtSwitch_SelfOther
        clear SEM_OverSessAtSwitch_OtherSelf

        clear CrossSEM_OverSess_SelfOther
        clear CrossSEM_OverSess_OtherSelf
        clear CrossAtSwitch_SEM_OverSess_SelfOther
        clear CrossAtSwitch_SEM_OverSess_OtherSelf

        clear SelfOtherSwitchNum
        clear OtherSelfSwitchNum
        clear AtSwitch_SelfOther_SwitchNum
        clear AtSwitch_OtherSelf_SwitchNum
        for AC = 1 : 2
            for Turn = 1 :3

                squeezedMeanSelfOther = [];
                squeezedMeanSelfOther = Selfother_SingleSess{GetAverageRange(1)}{AC,Turn};
                for i_avg = 2 :LASTsessBeAvr
                    squeezedMeanSelfOther = [squeezedMeanSelfOther;Selfother_SingleSess{GetAverageRange(i_avg)}{AC,Turn}];
                end
                %%
                squeezedMeanOtherSelf = [];
                squeezedMeanOtherSelf = OtherSelf_SingleSess{GetAverageRange(1)}{AC,Turn};
                for i_avg = 2 :LASTsessBeAvr
                    squeezedMeanOtherSelf = [squeezedMeanOtherSelf;OtherSelf_SingleSess{GetAverageRange(i_avg)}{AC,Turn}];
                end
                %%
                squeezedAtSwitch_MeanSelfOther = [];
                squeezedAtSwitch_MeanSelfOther = AtSwitchSelfother_SingleSess{GetAverageRange(1)}{AC,Turn};
                for i_avg = 2 :LASTsessBeAvr
                    squeezedAtSwitch_MeanSelfOther = [squeezedAtSwitch_MeanSelfOther;AtSwitchSelfother_SingleSess{GetAverageRange(i_avg)}{AC,Turn}];
                end
                %%
                squeezedAtSwitch_MeanOtherSelf = [];
                squeezedAtSwitch_MeanOtherSelf = AtSwitchOtherSelf_SingleSess{GetAverageRange(1)}{AC,Turn};
                for i_avg = 2 :LASTsessBeAvr
                    squeezedAtSwitch_MeanOtherSelf = [squeezedAtSwitch_MeanOtherSelf;AtSwitchOtherSelf_SingleSess{GetAverageRange(i_avg)}{AC,Turn}];
                end
                %%
                squeezedAtSwitch_MeanOtherSelf = []
                squeezedAtSwitch_MeanOtherSelf = AtSwitchOtherSelf_SingleSess{GetAverageRange(1)}{AC,Turn};
                for i_avg = 2 :LASTsessBeAvr
                    squeezedAtSwitch_MeanOtherSelf = [squeezedAtSwitch_MeanOtherSelf;AtSwitchOtherSelf_SingleSess{GetAverageRange(i_avg)}{AC,Turn}];
                end
                %%
                CrossSqueezedMeanSelfOther = []
                CrossSqueezedMeanSelfOther = CrossSelfOther_SingleSess{GetAverageRange(1)}{AC,Turn};
                for i_avg = 2 :LASTsessBeAvr
                    CrossSqueezedMeanSelfOther = [CrossSqueezedMeanSelfOther;CrossSelfOther_SingleSess{GetAverageRange(i_avg)}{AC,Turn}];
                end
                %%
                CrossSqueezedMeanOtherSelf = [];
                CrossSqueezedMeanOtherSelf = CrossOtherSelf_SingleSess{GetAverageRange(1)}{AC,Turn};
                for i_avg = 2 :LASTsessBeAvr
                    CrossSqueezedMeanOtherSelf = [CrossSqueezedMeanOtherSelf;CrossOtherSelf_SingleSess{GetAverageRange(i_avg)}{AC,Turn}];
                end
                %%
                CrossSqueezedAtSwitchMeanSelfOther = [];
                CrossSqueezedAtSwitchMeanSelfOther = AtSwitchCrossSelfother_SingleSess{GetAverageRange(1)}{AC,Turn};
                for i_avg = 2 :LASTsessBeAvr
                    CrossSqueezedAtSwitchMeanSelfOther = [CrossSqueezedAtSwitchMeanSelfOther;AtSwitchCrossSelfother_SingleSess{GetAverageRange(i_avg)}{AC,Turn}];
                end
                %%
                CrossSqueezedAtSwitchMeanOtherSelf = [];
                CrossSqueezedAtSwitchMeanOtherSelf = AtSwitchCrossOtherSelf_SingleSess{GetAverageRange(1)}{AC,Turn};
                for i_avg = 2 :LASTsessBeAvr
                    CrossSqueezedAtSwitchMeanOtherSelf = [CrossSqueezedAtSwitchMeanOtherSelf;AtSwitchCrossOtherSelf_SingleSess{GetAverageRange(i_avg)}{AC,Turn}];
                end


                MeanOverSessSelfOther(Turn,:,AC) = mean(squeezedMeanSelfOther,1,'omitmissing');
                MeanOverSessOtherSelf(Turn,:,AC) = mean(squeezedMeanOtherSelf,1,'omitmissing');
                MeanOverSessAtSwitch_MeanSelfOther(Turn,:,AC) = mean(squeezedAtSwitch_MeanSelfOther,1,'omitmissing');
                MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,AC) = mean(squeezedAtSwitch_MeanOtherSelf,1,'omitmissing');

                CrossMeanOverSessSelfOther(Turn,:,AC) = mean(CrossSqueezedMeanSelfOther,1,'omitmissing');
                CrossMeanOverSessOtherSelf(Turn,:,AC) = mean(CrossSqueezedMeanOtherSelf,1,'omitmissing');
                CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,AC) = mean(CrossSqueezedAtSwitchMeanSelfOther,1,'omitmissing');
                CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,AC) = mean(CrossSqueezedAtSwitchMeanOtherSelf,1,'omitmissing');


                SelfOtherSwitchNum(Turn,AC) = size(squeezedAtSwitch_MeanSelfOther,1);
                OtherSelfSwitchNum(Turn,AC) = size(squeezedAtSwitch_MeanOtherSelf,1);
                AtSwitch_SelfOther_SwitchNum(Turn,AC) = size(squeezedAtSwitch_MeanSelfOther,1);
                AtSwitch_OtherSelf_SwitchNum(Turn,AC) = size(squeezedAtSwitch_MeanOtherSelf,1);




                % SEM_OverSess_SelfOther(Turn,:,AC) = calcSEM(squeezedMeanSelfOther);
                % SEM_OverSess_OtherSelf(Turn,:,AC) = calcSEM(squeezedMeanOtherSelf);
                % SEM_OverSessAtSwitch_SelfOther(Turn,:,AC) = calcSEM(squeezedAtSwitch_MeanSelfOther);
                % SEM_OverSessAtSwitch_OtherSelf(Turn,:,AC) = calcSEM(squeezedAtSwitch_MeanOtherSelf);
                %
                % CrossSEM_OverSess_SelfOther(Turn,:,AC) = calcSEM(CrossSqueezedMeanSelfOther)
                % CrossSEM_OverSess_OtherSelf(Turn,:,AC) = calcSEM(CrossSqueezedMeanOtherSelf)
                % CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,AC) = calcSEM(CrossSqueezedAtSwitchMeanSelfOther)
                % CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,AC) = calcSEM(CrossSqueezedAtSwitchMeanOtherSelf)

                % Anonymous function to check output size of calcSEM
                checkCalcSEM = @(data) (size(calcSEM(data), 2) < 11) * zeros(1, 11) + (size(calcSEM(data), 2) >= 11) * calcSEM(data);

                % Applying the anonymous function to each assignment
                SEM_OverSess_SelfOther(Turn,:,AC) = checkCalcSEM(squeezedMeanSelfOther);
                SEM_OverSess_OtherSelf(Turn,:,AC) = checkCalcSEM(squeezedMeanOtherSelf);
                SEM_OverSessAtSwitch_SelfOther(Turn,:,AC) = checkCalcSEM(squeezedAtSwitch_MeanSelfOther);
                SEM_OverSessAtSwitch_OtherSelf(Turn,:,AC) = checkCalcSEM(squeezedAtSwitch_MeanOtherSelf);

                CrossSEM_OverSess_SelfOther(Turn,:,AC) = checkCalcSEM(CrossSqueezedMeanSelfOther);
                CrossSEM_OverSess_OtherSelf(Turn,:,AC) = checkCalcSEM(CrossSqueezedMeanOtherSelf);
                CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,AC) = checkCalcSEM(CrossSqueezedAtSwitchMeanSelfOther);
                CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,AC) = checkCalcSEM(CrossSqueezedAtSwitchMeanOtherSelf);
            end
        end

        FigName = strcat(FirstSessActorA{1},'-LastSess-',FirstSessActorB{1});
        figure('Name',sprintf(FigName), 'NumberTitle', 'off','Position',[488,49.800000000000004,500.2,732.8000000000001]);
        for Turn = 1 : 3
            if Turn == 1
                clear SP, SP = subplot(3,2,1)
                hold on
                %                 %% red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                DegreeFreddom = AtSwitch_SelfOther_SwitchNum(Turn,1);
                t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
                margin_of_errorAtSwitchSelfOther = t_critical .* SEM_OverSessAtSwitch_SelfOther(Turn,:,1);
                ci_lowerAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) - margin_of_errorAtSwitchSelfOther;
                ci_upperAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) + margin_of_errorAtSwitchSelfOther;
                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) > 0
                        ci_lowerAtSwitchSelfOther(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(ci_upperAtSwitchSelfOther > Valid_Max_FCO) > 0
                        ci_upperAtSwitchSelfOther(ci_upperAtSwitchSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');

                %                 %% blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessSelfOther(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_SelfOther = t_critical .* CrossSEM_OverSess_SelfOther(Turn,:,2);
                Cross_ci_lowerSelfOther = CrossMeanOverSessSelfOther(Turn,:,2) - CrossMarginOfError_SelfOther;
                Cross_ci_upperSelfOther = CrossMeanOverSessSelfOther(Turn,:,2) + CrossMarginOfError_SelfOther;
                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                        Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                        Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],'b', 'FaceAlpha', 0.3,'EdgeColor','none');



                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                %
                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                % %
                %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther(Turn,:,2), fliplr(Cross_ci_upperSelfOther(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                % %                 %% pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2),'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_AtSwitchSelfOther = t_critical .* CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,2);
                Cross_ci_lowerSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) - CrossMarginOfError_AtSwitchSelfOther;
                Cross_ci_upperSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) + CrossMarginOfError_AtSwitchSelfOther;

                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                        Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                        Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                %
                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                %
                % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchSelfOther(Turn,:,2), fliplr(Cross_ci_upperAtSwitchSelfOther(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
                xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);

                pbaspect([1 1 1]);
                ylim([YlimRange(1) YlimRange(2)]);
                set(SP,'XTick', 6);
                set(SP,'XTickLabel', {'switch'});
                set(SP, 'XColor', 'none'); % Make x-axis invisible


                title(strcat(sprintf(FirstSessActorA{1}),' own to other'));
                OveralSwitch = [];
                OveralSwitch = SelfOtherSwitchNum(Turn,1);
                subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                if OveralSwitch == 0
                    % Find and delete all lines
                    hPlots = findobj(gca, 'Type', 'line');

                    % Find and delete all xlines (ConstantLine objects)
                    hXLines = findobj(gca, 'Type', 'ConstantLine');

                    % Find and delete all shaded areas (patch objects)
                    hPatches = findobj(gca, 'Type', 'patch');

                    % Delete all found objects
                    delete([hPlots; hXLines; hPatches]);
                end
                %%
                clear SP, SP = subplot(3,2,2)
                hold on
                %                 %% blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                DegreeFreddom =AtSwitch_OtherSelf_SwitchNum(Turn,1)
                t_critical = tinv(1 - alpha/2, DegreeFreddom - 1)
                margin_of_errorAtSwitchOtherSelf = t_critical .* SEM_OverSessAtSwitch_OtherSelf(Turn,:,1);
                ci_lowerAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) - margin_of_errorAtSwitchOtherSelf;
                ci_upperAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) + margin_of_errorAtSwitchOtherSelf;

                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) > 0
                        ci_lowerAtSwitchOtherSelf(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) > 0
                        ci_upperAtSwitchOtherSelf(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                %
                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                %
                % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerOtherSelf(Turn,:,1), fliplr(ci_upperOtherSelf(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
                %                 %% red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessOtherSelf(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_OtherSelf = t_critical .* CrossSEM_OverSess_OtherSelf(Turn,:,2);
                Cross_ci_lowerOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,2) - CrossMarginOfError_OtherSelf;
                Cross_ci_upperOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,2) + CrossMarginOfError_OtherSelf;


                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                        Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                        Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                %
                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSel(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                % %
                %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf(Turn,:,2), fliplr(Cross_ci_upperOtherSel(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                %                 %% pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2),'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_AtSwitchOtherSelf = t_critical .* CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,2);
                Cross_ci_lowerOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) - CrossMarginOfError_AtSwitchOtherSelf;
                Cross_ci_upperOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) + CrossMarginOfError_AtSwitchOtherSelf;


                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                        Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                        Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                %
                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                %
                % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2), fliplr(Cross_ci_upperAtSwitchOtherSelf(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
                xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);
                pbaspect([1 1 1]);
                ylim([YlimRange(1) YlimRange(2)]);
                ylabel(Ylabel);
                set(SP,'XTick', 6);
                set(SP,'XTickLabel', {'switch'});
                set(SP, 'XColor', 'none'); % Make x-axis invisible


                title(strcat(sprintf(FirstSessActorA{1}),' other to own'));
                OveralSwitch = [];
                OveralSwitch = OtherSelfSwitchNum(Turn,1);
                subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                if OveralSwitch == 0
                    % Find and delete all lines
                    hPlots = findobj(gca, 'Type', 'line');

                    % Find and delete all xlines (ConstantLine objects)
                    hXLines = findobj(gca, 'Type', 'ConstantLine');

                    % Find and delete all shaded areas (patch objects)
                    hPatches = findobj(gca, 'Type', 'patch');

                    % Delete all found objects
                    delete([hPlots; hXLines; hPatches]);
                end


            end
            %%
            if Turn == 2
                clear SP, SP = subplot(3,2,3)
                hold on
                %                 %% blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                DegreeFreddom = AtSwitch_SelfOther_SwitchNum(Turn,1);
                t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
                margin_of_errorAtSwitchSelfOther = t_critical .* SEM_OverSessAtSwitch_SelfOther(Turn,:,1)
                ci_lowerAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) - margin_of_errorAtSwitchSelfOther;
                ci_upperAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) + margin_of_errorAtSwitchSelfOther;
                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) > 0
                        ci_lowerAtSwitchSelfOther(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(ci_upperAtSwitchSelfOther > Valid_Max_FCO) > 0
                        ci_upperAtSwitchSelfOther(ci_upperAtSwitchSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                %
                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                %
                %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerSelfOther(Turn,:,1), fliplr(ci_upperSelfOther(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
                % %                 %% red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessSelfOther(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_SelfOther = t_critical .* CrossSEM_OverSess_SelfOther(Turn,:,2);
                Cross_ci_lowerSelfOther = CrossMeanOverSessSelfOther(Turn,:,2) - CrossMarginOfError_SelfOther;
                Cross_ci_upperSelfOther = CrossMeanOverSessSelfOther(Turn,:,2) + CrossMarginOfError_SelfOther;
                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                        Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                        Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],'b', 'FaceAlpha', 0.3,'EdgeColor','none');


                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                %
                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                % %
                %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther(Turn,:,2), fliplr(Cross_ci_upperSelfOther(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                % %                 %% pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2),'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_AtSwitchSelfOther = t_critical .* CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,2);
                Cross_ci_lowerSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) - CrossMarginOfError_AtSwitchSelfOther;
                Cross_ci_upperSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) + CrossMarginOfError_AtSwitchSelfOther;

                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                        Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                        Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                %
                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                %
                % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchSelfOther(Turn,:,2), fliplr(Cross_ci_upperAtSwitchSelfOther(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
                xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth)
                pbaspect([1 1 1])
                ylim([YlimRange(1) YlimRange(2)]);
                set(SP,'XTick', 6);
                set(SP,'XTickLabel', {'switch'});
                set(SP, 'XColor', 'none'); % Make x-axis invisible


                title(strcat(sprintf(FirstSessActorA{1}),' own to other'));
                OveralSwitch = [];
                OveralSwitch = SelfOtherSwitchNum(Turn,1);
                subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                if OveralSwitch == 0
                    % Find and delete all lines
                    hPlots = findobj(gca, 'Type', 'line');

                    % Find and delete all xlines (ConstantLine objects)
                    hXLines = findobj(gca, 'Type', 'ConstantLine');

                    % Find and delete all shaded areas (patch objects)
                    hPatches = findobj(gca, 'Type', 'patch');

                    % Delete all found objects
                    delete([hPlots; hXLines; hPatches]);
                end
                %%
                clear SP, SP = subplot(3,2,4)
                hold on
                %                 %% blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                DegreeFreddom = AtSwitch_OtherSelf_SwitchNum(Turn,1);
                t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
                margin_of_errorAtSwitchOtherSelf = t_critical .* SEM_OverSessAtSwitch_OtherSelf(Turn,:,1)
                ci_lowerAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) - margin_of_errorAtSwitchOtherSelf;
                ci_upperAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) + margin_of_errorAtSwitchOtherSelf;

                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) > 0
                        ci_lowerAtSwitchOtherSelf(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) > 0
                        ci_upperAtSwitchOtherSelf(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                %
                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                %
                % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerOtherSelf(Turn,:,1), fliplr(ci_upperOtherSelf(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
                %                 %% red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessOtherSelf(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_OtherSelf = t_critical .* CrossSEM_OverSess_OtherSelf(Turn,:,2);
                Cross_ci_lowerOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,2) - CrossMarginOfError_OtherSelf;
                Cross_ci_upperOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,2) + CrossMarginOfError_OtherSelf;

                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                        Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                        Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');



                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                %
                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSel(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                % %
                %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf(Turn,:,2), fliplr(Cross_ci_upperOtherSel(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                %                 %% pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2),'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_AtSwitchOtherSelf = t_critical .*CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,2)
                Cross_ci_lowerOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) - CrossMarginOfError_AtSwitchOtherSelf;
                Cross_ci_upperOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) + CrossMarginOfError_AtSwitchOtherSelf;


                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                        Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                        Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                %
                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                %
                % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2), fliplr(Cross_ci_upperAtSwitchOtherSelf(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
                xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);
                pbaspect([1 1 1]);
                ylim([YlimRange(1) YlimRange(2)]);
                ylabel(Ylabel);
                set(SP,'XTick', 6);
                set(SP,'XTickLabel', {'switch'});
                set(SP, 'XColor', 'none'); % Make x-axis invisible


                title(strcat(sprintf(FirstSessActorA{1}),' other to own'));
                OveralSwitch = []
                OveralSwitch = OtherSelfSwitchNum(Turn,1);
                subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                if OveralSwitch == 0
                    % Find and delete all lines
                    hPlots = findobj(gca, 'Type', 'line');

                    % Find and delete all xlines (ConstantLine objects)
                    hXLines = findobj(gca, 'Type', 'ConstantLine');

                    % Find and delete all shaded areas (patch objects)
                    hPatches = findobj(gca, 'Type', 'patch');

                    % Delete all found objects
                    delete([hPlots; hXLines; hPatches]);
                end



            end
            %%
            if Turn == 3
                clear SP, SP = subplot(3,2,5)
                hold on
                %                 %% blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                DegreeFreddom = AtSwitch_SelfOther_SwitchNum(Turn,1);
                t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
                margin_of_errorAtSwitchSelfOther = t_critical .* SEM_OverSessAtSwitch_SelfOther(Turn,:,1);
                ci_lowerAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) - margin_of_errorAtSwitchSelfOther;
                ci_upperAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) + margin_of_errorAtSwitchSelfOther;
                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) > 0
                        ci_lowerAtSwitchSelfOther(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(ci_upperAtSwitchSelfOther > Valid_Max_FCO) > 0
                        ci_upperAtSwitchSelfOther(ci_upperAtSwitchSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');



                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                %
                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                %
                %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerSelfOther(Turn,:,1), fliplr(ci_upperSelfOther(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
                % %                 %% red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessSelfOther(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_SelfOther = t_critical .* CrossSEM_OverSess_SelfOther(Turn,:,2);
                Cross_ci_lowerSelfOther = CrossMeanOverSessSelfOther(Turn,:,2) - CrossMarginOfError_SelfOther;
                Cross_ci_upperSelfOther = CrossMeanOverSessSelfOther(Turn,:,2) + CrossMarginOfError_SelfOther;

                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                        Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                        Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],'b', 'FaceAlpha', 0.3,'EdgeColor','none');

                %
                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                %
                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                % %
                %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther(Turn,:,2), fliplr(Cross_ci_upperSelfOther(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                %                 %% pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2),'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth)
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_AtSwitchSelfOther = t_critical .* CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,2);
                Cross_ci_lowerSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) - CrossMarginOfError_AtSwitchSelfOther;
                Cross_ci_upperSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) + CrossMarginOfError_AtSwitchSelfOther;

                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                        Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                        Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');

                %
                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                %
                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                %
                % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchSelfOther(Turn,:,2), fliplr(Cross_ci_upperAtSwitchSelfOther(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
                xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);
                pbaspect([1 1 1]);
                ylim([YlimRange(1) YlimRange(2)]);
                set(SP,'XTick', 6);
                set(SP,'XTickLabel', {'switch'});
                % set(SP, 'XColor', 'none'); % Make x-axis invisible


                title(strcat(sprintf(FirstSessActorA{1}),' own to other'));
                OveralSwitch = [];
                OveralSwitch = SelfOtherSwitchNum(Turn,1);
                subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                if OveralSwitch == 0
                    % Find and delete all lines
                    hPlots = findobj(gca, 'Type', 'line');

                    % Find and delete all xlines (ConstantLine objects)
                    hXLines = findobj(gca, 'Type', 'ConstantLine');

                    % Find and delete all shaded areas (patch objects)
                    hPatches = findobj(gca, 'Type', 'patch');

                    % Delete all found objects
                    delete([hPlots; hXLines; hPatches]);
                    H = findobj(gca);
                    set(H,'XTick', 0.5);
                    set(H,'XTickLabel', {'switch'});
                end
                %%
                clear SP, SP = subplot(3,2,6)
                hold on
                %                 %% blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                DegreeFreddom = AtSwitch_OtherSelf_SwitchNum(Turn,1);
                t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
                margin_of_errorAtSwitchOtherSelf = t_critical .* SEM_OverSessAtSwitch_OtherSelf(Turn,:,1);
                ci_lowerAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) - margin_of_errorAtSwitchOtherSelf;
                ci_upperAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) + margin_of_errorAtSwitchOtherSelf;

                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) > 0
                        ci_lowerAtSwitchOtherSelf(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) > 0
                        ci_upperAtSwitchOtherSelf(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                %
                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                %
                % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerOtherSelf(Turn,:,1), fliplr(ci_upperOtherSelf(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
                %                 %% red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessOtherSelf(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_OtherSelf = t_critical .*CrossSEM_OverSess_OtherSelf(Turn,:,2);
                Cross_ci_lowerOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,2) - CrossMarginOfError_OtherSelf;
                Cross_ci_upperOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,2) + CrossMarginOfError_OtherSelf;


                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                        Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                        Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],'b', 'FaceAlpha', 0.3,'EdgeColor','none');


                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                %
                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSel(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                % %
                %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf(Turn,:,2), fliplr(Cross_ci_upperOtherSel(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                %                 %% pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2),'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_AtSwitchOtherSelf = t_critical .* CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,2);
                Cross_ci_lowerOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) - CrossMarginOfError_AtSwitchOtherSelf;
                Cross_ci_upperOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) + CrossMarginOfError_AtSwitchOtherSelf;


                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                        Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                        Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                %
                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                %
                % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2), fliplr(Cross_ci_upperAtSwitchOtherSelf(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
                xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);
                pbaspect([1 1 1]);
                ylim([YlimRange(1) YlimRange(2)]);
                ylabel(Ylabel);
                set(SP,'XTick', 6);
                set(SP,'XTickLabel', {'switch'});
                % set(SP, 'XColor', 'none'); % Make x-axis invisible


                title(strcat(sprintf(FirstSessActorA{1}),' other to own'));
                OveralSwitch = [];
                OveralSwitch = OtherSelfSwitchNum(Turn,1);
                subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                if OveralSwitch == 0
                    % Find and delete all lines
                    hPlots = findobj(gca, 'Type', 'line');

                    % Find and delete all xlines (ConstantLine objects)
                    hXLines = findobj(gca, 'Type', 'ConstantLine');

                    % Find and delete all shaded areas (patch objects)
                    hPatches = findobj(gca, 'Type', 'patch');

                    % Delete all found objects
                    delete([hPlots; hXLines; hPatches]);
                    H = findobj(gca);
                    set(H,'XTick', 0.5);
                    set(H,'XTickLabel', {'switch'});

                end


            end
        end
        annotation('textbox',...
            [0.00679728108756502 0.718340611353712 0.123150739704118 0.103711790393013],...
            'String',{'subject first, switcher second'},...
            'FitBoxToText','off',...
            'EdgeColor','none');

        annotation('textbox',...
            [0.0259896041583367 0.460698689956332 0.0911635345861662 0.031659388646288],...
            'String','simul',...
            'FitBoxToText','off',...
            'EdgeColor','none');

        annotation('textbox',...
            [0.00519792083166733 0.137554585152838 0.116753298680528 0.107432286115798],...
            'String',{'subject','second,','switcher','first'},...
            'FitBoxToText','off',...
            'EdgeColor','none');








        filename = [];
        filename = strcat(FirstSessActorA{1},'-LastSess-',FirstSessActorB{1},ExtentionOfFileName,'.pdf');
        sgtitle(strcat(FirstSessActorA{1},'-',FirstSessActorB{1},'-Last4Sess'));
        ax = gcf;
        exportgraphics(ax,sprintf(filename),'Resolution',600);

        filename2 = [];
        filename2 = strcat(FirstSessActorA{1},'-LastSess-',FirstSessActorB{1},ExtentionOfFileName,'.jpg');
        exportgraphics(ax,sprintf(filename2),'Resolution',600);



        %% other player switches
        %% other player switches
        FigName = strcat(FirstSessActorA{1},'-Bswitch-LastSess-',FirstSessActorB{1});
        figure('Name',sprintf(FigName), 'NumberTitle', 'off','Position',[488,49.800000000000004,500.2,732.8000000000001]);
        for Turn = 1 : 3
            if Turn == 1
                clear SP, SP = subplot(3,2,1)
                hold on
                %                 %% red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                DegreeFreddom = AtSwitch_SelfOther_SwitchNum(Turn,2);
                t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
                margin_of_errorAtSwitchSelfOther = t_critical .* SEM_OverSessAtSwitch_SelfOther(Turn,:,2);
                ci_lowerAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) - margin_of_errorAtSwitchSelfOther;
                ci_upperAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) + margin_of_errorAtSwitchSelfOther;
                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) > 0
                        ci_lowerAtSwitchSelfOther(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(ci_upperAtSwitchSelfOther > Valid_Max_FCO) > 0
                        ci_upperAtSwitchSelfOther(ci_upperAtSwitchSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');

                %                 %% blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessSelfOther(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_SelfOther = t_critical .* CrossSEM_OverSess_SelfOther(Turn,:,1);
                Cross_ci_lowerSelfOther = CrossMeanOverSessSelfOther(Turn,:,1) - CrossMarginOfError_SelfOther;
                Cross_ci_upperSelfOther = CrossMeanOverSessSelfOther(Turn,:,1) + CrossMarginOfError_SelfOther;
                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                        Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                        Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');



                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                %
                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                % %
                %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther(Turn,:,2), fliplr(Cross_ci_upperSelfOther(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                % %                 %% pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1),'o-','Color',ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_AtSwitchSelfOther = t_critical .* CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,1);
                Cross_ci_lowerSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) - CrossMarginOfError_AtSwitchSelfOther;
                Cross_ci_upperSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) + CrossMarginOfError_AtSwitchSelfOther;

                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                        Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                        Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorAatSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');

                xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);
                pbaspect([1 1 1]);
                ylim([YlimRange(1) YlimRange(2)]);
                set(SP,'XTick', 6);
                set(SP,'XTickLabel', {'switch'});
                set(SP, 'XColor', 'none'); % Make x-axis invisible


                title(strcat(sprintf(FirstSessActorB{1}),' own to other'));
                OveralSwitch = [];
                OveralSwitch = SelfOtherSwitchNum(Turn,2);
                subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                if OveralSwitch == 0
                    % Find and delete all lines
                    hPlots = findobj(gca, 'Type', 'line');

                    % Find and delete all xlines (ConstantLine objects)
                    hXLines = findobj(gca, 'Type', 'ConstantLine');

                    % Find and delete all shaded areas (patch objects)
                    hPatches = findobj(gca, 'Type', 'patch');

                    % Delete all found objects
                    delete([hPlots; hXLines; hPatches]);
                end
                %%
                clear SP, SP = subplot(3,2,2)
                hold on
                %                 %% blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                DegreeFreddom = AtSwitch_OtherSelf_SwitchNum(Turn,2);
                t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
                margin_of_errorAtSwitchOtherSelf = t_critical .* SEM_OverSessAtSwitch_OtherSelf(Turn,:,2)
                ci_lowerAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) - margin_of_errorAtSwitchOtherSelf;
                ci_upperAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) + margin_of_errorAtSwitchOtherSelf;

                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) > 0
                        ci_lowerAtSwitchOtherSelf(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) > 0
                        ci_upperAtSwitchOtherSelf(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                %
                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                %
                % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerOtherSelf(Turn,:,1), fliplr(ci_upperOtherSelf(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
                %                 %% red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessOtherSelf(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_OtherSelf = t_critical .* CrossSEM_OverSess_OtherSelf(Turn,:,1);
                Cross_ci_lowerOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,1) - CrossMarginOfError_OtherSelf;
                Cross_ci_upperOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,1) + CrossMarginOfError_OtherSelf;

                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                        Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                        Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end


                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                %
                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSel(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                % %
                %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf(Turn,:,2), fliplr(Cross_ci_upperOtherSel(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                %                 %% pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1),'o-','Color',ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_AtSwitchOtherSelf = t_critical .* CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,1);
                Cross_ci_lowerOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) - CrossMarginOfError_AtSwitchOtherSelf;
                Cross_ci_upperOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) + CrossMarginOfError_AtSwitchOtherSelf;

                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                        Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                        Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorAatSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');
                xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);
                pbaspect([1 1 1]);
                ylim([YlimRange(1) YlimRange(2)]);
                ylabel(Ylabel);
                set(SP,'XTick', 6);
                set(SP,'XTickLabel', {'switch'});
                set(SP, 'XColor', 'none'); % Make x-axis invisible


                title(strcat(sprintf(FirstSessActorB{1}),' other to own'));
                OveralSwitch = [];
                OveralSwitch = OtherSelfSwitchNum(Turn,2);
                subtitle(strcat('(Num : ',string(OveralSwitch),')'));

                if OveralSwitch == 0
                    % Find and delete all lines
                    hPlots = findobj(gca, 'Type', 'line');

                    % Find and delete all xlines (ConstantLine objects)
                    hXLines = findobj(gca, 'Type', 'ConstantLine');

                    % Find and delete all shaded areas (patch objects)
                    hPatches = findobj(gca, 'Type', 'patch');

                    % Delete all found objects
                    delete([hPlots; hXLines; hPatches]);
                end

            end
            %%
            if Turn == 2
                clear SP, SP = subplot(3,2,3)
                hold on
                %                 %% blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                DegreeFreddom = AtSwitch_SelfOther_SwitchNum(Turn,2);
                t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
                margin_of_errorAtSwitchSelfOther = t_critical .* SEM_OverSessAtSwitch_SelfOther(Turn,:,2);
                ci_lowerAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) - margin_of_errorAtSwitchSelfOther;
                ci_upperAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) + margin_of_errorAtSwitchSelfOther;
                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) > 0
                        ci_lowerAtSwitchSelfOther(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(ci_upperAtSwitchSelfOther > Valid_Max_FCO) > 0
                        ci_upperAtSwitchSelfOther(ci_upperAtSwitchSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                %
                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                %
                %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerSelfOther(Turn,:,1), fliplr(ci_upperSelfOther(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
                % %                 %% red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessSelfOther(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_SelfOther = t_critical .* CrossSEM_OverSess_SelfOther(Turn,:,1);
                Cross_ci_lowerSelfOther = CrossMeanOverSessSelfOther(Turn,:,1) - CrossMarginOfError_SelfOther;
                Cross_ci_upperSelfOther = CrossMeanOverSessSelfOther(Turn,:,1) + CrossMarginOfError_SelfOther;

                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                        Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                        Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                %
                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                % %
                %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther(Turn,:,2), fliplr(Cross_ci_upperSelfOther(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                % %                 %% pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1),'o-','Color',ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_AtSwitchSelfOther = t_critical .* CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,1);
                Cross_ci_lowerSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) - CrossMarginOfError_AtSwitchSelfOther;
                Cross_ci_upperSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) + CrossMarginOfError_AtSwitchSelfOther;

                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                        Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                        Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorAatSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                %
                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                %
                % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchSelfOther(Turn,:,2), fliplr(Cross_ci_upperAtSwitchSelfOther(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
                xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);
                pbaspect([1 1 1]);
                ylim([YlimRange(1) YlimRange(2)]);
                set(SP,'XTick', 6);
                set(SP,'XTickLabel', {'switch'});
                set(SP, 'XColor', 'none'); % Make x-axis invisible


                title(strcat(sprintf(FirstSessActorB{1}),' own to other'));
                OveralSwitch = []
                OveralSwitch = SelfOtherSwitchNum(Turn,2);
                subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                if OveralSwitch == 0
                    % Find and delete all lines
                    hPlots = findobj(gca, 'Type', 'line');

                    % Find and delete all xlines (ConstantLine objects)
                    hXLines = findobj(gca, 'Type', 'ConstantLine');

                    % Find and delete all shaded areas (patch objects)
                    hPatches = findobj(gca, 'Type', 'patch');

                    % Delete all found objects
                    delete([hPlots; hXLines; hPatches]);
                end
                %%
                clear SP, SP = subplot(3,2,4)
                hold on
                %                 %% blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                DegreeFreddom = AtSwitch_OtherSelf_SwitchNum(Turn,2);
                t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
                margin_of_errorAtSwitchOtherSelf = t_critical .* SEM_OverSessAtSwitch_OtherSelf(Turn,:,2);
                ci_lowerAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) - margin_of_errorAtSwitchOtherSelf;
                ci_upperAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) + margin_of_errorAtSwitchOtherSelf;

                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) > 0
                        ci_lowerAtSwitchOtherSelf(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) > 0
                        ci_upperAtSwitchOtherSelf(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                %
                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                %
                % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerOtherSelf(Turn,:,1), fliplr(ci_upperOtherSelf(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
                %                 %% red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessOtherSelf(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_OtherSelf = t_critical .* CrossSEM_OverSess_OtherSelf(Turn,:,1);
                Cross_ci_lowerOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,1) - CrossMarginOfError_OtherSelf;
                Cross_ci_upperOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,1) + CrossMarginOfError_OtherSelf;


                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                        Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                        Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');



                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                %
                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSel(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                % %
                %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf(Turn,:,2), fliplr(Cross_ci_upperOtherSel(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                %                 %% pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1),'o-','Color',ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_AtSwitchOtherSelf = t_critical .* CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,1)
                Cross_ci_lowerOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) - CrossMarginOfError_AtSwitchOtherSelf;
                Cross_ci_upperOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) + CrossMarginOfError_AtSwitchOtherSelf;


                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                        Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                        Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorAatSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');
                xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);
                pbaspect([1 1 1]);
                ylim([YlimRange(1) YlimRange(2)]);
                ylabel(Ylabel);
                set(SP,'XTick', 6);
                set(SP,'XTickLabel', {'switch'});
                set(SP, 'XColor', 'none'); % Make x-axis invisible


                title(strcat(sprintf(FirstSessActorB{1}),' other to own'));
                OveralSwitch = [];
                OveralSwitch = OtherSelfSwitchNum(Turn,2);
                subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                if OveralSwitch == 0
                    % Find and delete all lines
                    hPlots = findobj(gca, 'Type', 'line');

                    % Find and delete all xlines (ConstantLine objects)
                    hXLines = findobj(gca, 'Type', 'ConstantLine');

                    % Find and delete all shaded areas (patch objects)
                    hPatches = findobj(gca, 'Type', 'patch');

                    % Delete all found objects
                    delete([hPlots; hXLines; hPatches]);
                end


            end
            %%
            if Turn == 3
                clear SP, SP = subplot(3,2,5)
                hold on
                %                 %% blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                DegreeFreddom = AtSwitch_SelfOther_SwitchNum(Turn,2);
                t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
                margin_of_errorAtSwitchSelfOther = t_critical .* SEM_OverSessAtSwitch_SelfOther(Turn,:,2);
                ci_lowerAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) - margin_of_errorAtSwitchSelfOther;
                ci_upperAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) + margin_of_errorAtSwitchSelfOther;
                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) > 0
                        ci_lowerAtSwitchSelfOther(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(ci_upperAtSwitchSelfOther > Valid_Max_FCO) > 0
                        ci_upperAtSwitchSelfOther(ci_upperAtSwitchSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');



                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                %
                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                %
                %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerSelfOther(Turn,:,1), fliplr(ci_upperSelfOther(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
                % %                 %% red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessSelfOther(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_SelfOther = t_critical .* CrossSEM_OverSess_SelfOther(Turn,:,1);
                Cross_ci_lowerSelfOther = CrossMeanOverSessSelfOther(Turn,:,1) - CrossMarginOfError_SelfOther;
                Cross_ci_upperSelfOther = CrossMeanOverSessSelfOther(Turn,:,1) + CrossMarginOfError_SelfOther;

                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                        Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                        Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');

                %
                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                %
                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                % %
                %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther(Turn,:,2), fliplr(Cross_ci_upperSelfOther(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                %                 %% pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1),'o-','Color',ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_AtSwitchSelfOther = t_critical .* CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,1);
                Cross_ci_lowerSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) - CrossMarginOfError_AtSwitchSelfOther;
                Cross_ci_upperSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) + CrossMarginOfError_AtSwitchSelfOther;

                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                        Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                        Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorAatSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');

                xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);
                pbaspect([1 1 1]);
                ylim([YlimRange(1) YlimRange(2)]);
                set(SP,'XTick', 6);
                set(SP,'XTickLabel', {'switch'});
                % set(SP, 'XColor', 'none'); % Make x-axis invisible


                title(strcat(sprintf(FirstSessActorB{1}),' own to other'));
                OveralSwitch = [];
                OveralSwitch = SelfOtherSwitchNum(Turn,2);
                subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                if OveralSwitch == 0
                    % Find and delete all lines
                    hPlots = findobj(gca, 'Type', 'line');

                    % Find and delete all xlines (ConstantLine objects)
                    hXLines = findobj(gca, 'Type', 'ConstantLine');

                    % Find and delete all shaded areas (patch objects)
                    hPatches = findobj(gca, 'Type', 'patch');

                    % Delete all found objects
                    delete([hPlots; hXLines; hPatches]);
                    H = findobj(gca);
                    set(H,'XTick', 0.5);
                    set(H,'XTickLabel', {'switch'});

                end
                %%
                %%
                clear SP, SP = subplot(3,2,6)
                hold on
                %                 %% blue curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                DegreeFreddom = AtSwitch_OtherSelf_SwitchNum(Turn,2);
                t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
                margin_of_errorAtSwitchOtherSelf = t_critical .* SEM_OverSessAtSwitch_OtherSelf(Turn,:,2);
                ci_lowerAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) - margin_of_errorAtSwitchOtherSelf;
                ci_upperAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) + margin_of_errorAtSwitchOtherSelf;

                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) > 0
                        ci_lowerAtSwitchOtherSelf(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) > 0
                        ci_upperAtSwitchOtherSelf(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                %
                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                %
                % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerOtherSelf(Turn,:,1), fliplr(ci_upperOtherSelf(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
                %                 %% red curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessOtherSelf(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_OtherSelf = t_critical .* CrossSEM_OverSess_OtherSelf(Turn,:,1);
                Cross_ci_lowerOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,1) - CrossMarginOfError_OtherSelf;
                Cross_ci_upperOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,1) + CrossMarginOfError_OtherSelf;


                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                        Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                        Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                %
                %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSel(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                % %
                %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf(Turn,:,2), fliplr(Cross_ci_upperOtherSel(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                %                 %% pink curve
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1),'o-','Color',ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol,'LineWidth',MainLineWidth);
                %% calcualte and plot 95% confidence interval based on t dist SEM
                CrossMarginOfError_AtSwitchOtherSelf = t_critical .* CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,1);
                Cross_ci_lowerOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) - CrossMarginOfError_AtSwitchOtherSelf;
                Cross_ci_upperOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) + CrossMarginOfError_AtSwitchOtherSelf;
                %here you make sure if upper CI is more than 1 and lowe CI
                %is less than 0, it is clipped before plotting
                if contains(WhatOnYaxis,'ChoiceDynamic')
                    if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                        Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                    end

                    if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                        Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                    end
                end

                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorAatSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                %
                % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                %
                % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2), fliplr(Cross_ci_upperAtSwitchOtherSelf(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
                xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);
                pbaspect([1 1 1]);
                ylim([YlimRange(1) YlimRange(2)]);
                ylabel(Ylabel);
                set(SP,'XTick', 6);
                set(SP,'XTickLabel', {'switch'});
                % set(SP, 'XColor', 'none'); % Make x-axis invisible


                OveralSwitch = [];
                OveralSwitch = OtherSelfSwitchNum(Turn,2);
                subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                title(strcat(sprintf(FirstSessActorB{1}),' other to own'));
                if OveralSwitch == 0
                    % Find and delete all lines
                    hPlots = findobj(gca, 'Type', 'line');

                    % Find and delete all xlines (ConstantLine objects)
                    hXLines = findobj(gca, 'Type', 'ConstantLine');

                    % Find and delete all shaded areas (patch objects)
                    hPatches = findobj(gca, 'Type', 'patch');

                    % Delete all found objects
                    delete([hPlots; hXLines; hPatches]);
                    H = findobj(gca);
                    set(H,'XTick', 0.5);
                    set(H,'XTickLabel', {'switch'});

                end


            end
        end
        annotation('textbox',...
            [0.00439824070371872 0.697598253275111 0.12155137944822 0.118995633187773],...
            'String',{'subject second, switcher first'},...
            'FitBoxToText','off',...
            'EdgeColor','none');

        annotation('textbox',...
            [0.0259896041583367 0.457423580786026 0.0911635345861659 0.0349344978165935],...
            'String',{'simul'},...
            'FitBoxToText','off',...
            'EdgeColor','none');


        annotation('textbox',...
            [0.00519792083166695 0.152838427947598 0.119952019192323 0.106340583059029],...
            'String',{'subject','first,','switcher','second'},...
            'FitBoxToText','off',...
            'EdgeColor','none');




        filename = [];
        filename = strcat(FirstSessActorA{1},'-LastSess-',FirstSessActorB{1},ExtentionOfFileName,'SwitchB.pdf');
        sgtitle(strcat(FirstSessActorA{1},'-',FirstSessActorB{1},'-Last4Sess-','SwitchB'));
        ax = gcf;
        exportgraphics(ax,sprintf(filename),'Resolution',600);

        filename2 = [];
        filename2 =strcat(FirstSessActorA{1},'-LastSess-',FirstSessActorB{1},ExtentionOfFileName,'SwitchB.jpg');
        exportgraphics(ax,sprintf(filename2),'Resolution',600);






        %% single sess:

    else
        for idata = 1 : length(MergedData)
            A_Name = ACTORA{idata};
            B_Name = ACTORB{idata};


            %% plotting
            % DegreeFreddom = length(MergedData);
            % t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
            for AC = 1 : 2
                for Turn = 1 : 3


                    squeezedMeanSelfOther = Selfother_SingleSess{idata}{AC,Turn};
                    squeezedMeanOtherSelf = OtherSelf_SingleSess{idata}{AC,Turn};
                    squeezedAtSwitch_MeanSelfOther= AtSwitchSelfother_SingleSess{idata}{AC,Turn};
                    squeezedAtSwitch_MeanOtherSelf = AtSwitchOtherSelf_SingleSess{idata}{AC,Turn};

                    CrossSqueezedMeanSelfOther = CrossSelfOther_SingleSess{idata}{AC,Turn};
                    CrossSqueezedMeanOtherSelf = CrossOtherSelf_SingleSess{idata}{AC,Turn};


                    CrossSqueezedAtSwitchMeanSelfOther =  AtSwitchCrossSelfother_SingleSess{idata}{AC,Turn};
                    CrossSqueezedAtSwitchMeanOtherSelf = AtSwitchCrossOtherSelf_SingleSess{idata}{AC,Turn};

                    MeanOverSessSelfOther(Turn,:,AC) = mean(squeezedMeanSelfOther,1,'omitmissing');
                    MeanOverSessOtherSelf(Turn,:,AC) = mean(squeezedMeanOtherSelf,1,'omitmissing');
                    MeanOverSessAtSwitch_MeanSelfOther(Turn,:,AC) = mean(squeezedAtSwitch_MeanSelfOther,1,'omitmissing');
                    MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,AC) = mean(squeezedAtSwitch_MeanOtherSelf,1,'omitmissing');

                    CrossMeanOverSessSelfOther(Turn,:,AC) = mean(CrossSqueezedMeanSelfOther,1,'omitmissing')
                    CrossMeanOverSessOtherSelf(Turn,:,AC) = mean(CrossSqueezedMeanOtherSelf,1,'omitmissing')
                    CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,AC) = mean(CrossSqueezedAtSwitchMeanSelfOther,1,'omitmissing')
                    CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,AC) = mean(CrossSqueezedAtSwitchMeanOtherSelf,1,'omitmissing')
                end

            end

            %%
            SessionDateEachSess = SessionDate{idata};



            FigName = strcat(A_Name,'-',B_Name)
            figure('Name',sprintf(FigName), 'NumberTitle', 'off','Position',[488,49.800000000000004,500.2,732.8000000000001])
            for Turn = 1 : 3
                if Turn == 1
                    clear SP, SP = subplot(3,2,1)
                    hold on
                    %                 %% red curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    DegreeFreddom = sum(AtSwitch_SelfOther_SwitchNum(Turn,1,idata))
                    t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
                    margin_of_errorAtSwitchSelfOther = t_critical * SEM_OverSessAtSwitch_SelfOther(Turn,:,1,idata);
                    ci_lowerAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) - margin_of_errorAtSwitchSelfOther;
                    ci_upperAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) + margin_of_errorAtSwitchSelfOther;
                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) > 0
                            ci_lowerAtSwitchSelfOther(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(ci_upperAtSwitchSelfOther > Valid_Max_FCO) > 0
                            ci_upperAtSwitchSelfOther(ci_upperAtSwitchSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');

                    %                 %% blue curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessSelfOther(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_SelfOther = t_critical * CrossSEM_OverSess_SelfOther(Turn,:,2,idata);
                    Cross_ci_lowerSelfOther = CrossMeanOverSessSelfOther(Turn,:,2) - CrossMarginOfError_SelfOther;
                    Cross_ci_upperSelfOther = CrossMeanOverSessSelfOther(Turn,:,2) + CrossMarginOfError_SelfOther;
                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                            Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                            Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],'b', 'FaceAlpha', 0.3,'EdgeColor','none');



                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    %
                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    % %
                    %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther(Turn,:,2), fliplr(Cross_ci_upperSelfOther(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                    % %                 %% pink curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2),'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_AtSwitchSelfOther = t_critical * CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,2,idata);
                    Cross_ci_lowerSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) - CrossMarginOfError_AtSwitchSelfOther;
                    Cross_ci_upperSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) + CrossMarginOfError_AtSwitchSelfOther;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                            Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                            Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                    %
                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                    %
                    % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchSelfOther(Turn,:,2), fliplr(Cross_ci_upperAtSwitchSelfOther(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
                    xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth)

                    pbaspect([1 1 1])
                    ylim([YlimRange(1) YlimRange(2)]);
                    set(SP,'XTick', 6);
                    set(SP,'XTickLabel', {'switch'});
                    set(SP, 'XColor', 'none'); % Make x-axis invisible


                    title(strcat(sprintf(A_Name),' own to other'))
                    OveralSwitch = [];
                    OveralSwitch = sum(SelfOtherSwitchNum(Turn,1,idata));
                    subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                    if OveralSwitch == 0
                        % Find and delete all lines
                        hPlots = findobj(gca, 'Type', 'line');

                        % Find and delete all xlines (ConstantLine objects)
                        hXLines = findobj(gca, 'Type', 'ConstantLine');

                        % Find and delete all shaded areas (patch objects)
                        hPatches = findobj(gca, 'Type', 'patch');

                        % Delete all found objects
                        delete([hPlots; hXLines; hPatches]);
                    end
                    %%
                    clear SP, SP = subplot(3,2,2)
                    hold on
                    %                 %% blue curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    DegreeFreddom =sum(AtSwitch_OtherSelf_SwitchNum(Turn,1,idata));
                    t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
                    margin_of_errorAtSwitchOtherSelf = t_critical * SEM_OverSessAtSwitch_OtherSelf(Turn,:,1,idata);
                    ci_lowerAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) - margin_of_errorAtSwitchOtherSelf;
                    ci_upperAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) + margin_of_errorAtSwitchOtherSelf;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) > 0
                            ci_lowerAtSwitchOtherSelf(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) > 0
                            ci_upperAtSwitchOtherSelf(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                    %
                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                    %
                    % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerOtherSelf(Turn,:,1), fliplr(ci_upperOtherSelf(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
                    %                 %% red curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessOtherSelf(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_OtherSelf = t_critical * CrossSEM_OverSess_OtherSelf(Turn,:,2,idata);
                    Cross_ci_lowerOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,2) - CrossMarginOfError_OtherSelf;
                    Cross_ci_upperOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,2) + CrossMarginOfError_OtherSelf;


                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                            Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                            Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    %
                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSel(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    % %
                    %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf(Turn,:,2), fliplr(Cross_ci_upperOtherSel(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                    %                 %% pink curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2),'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_AtSwitchOtherSelf = t_critical * CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,2,idata);
                    Cross_ci_lowerOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) - CrossMarginOfError_AtSwitchOtherSelf;
                    Cross_ci_upperOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) + CrossMarginOfError_AtSwitchOtherSelf;


                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                            Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                            Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                    %
                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                    %
                    % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2), fliplr(Cross_ci_upperAtSwitchOtherSelf(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
                    xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth)
                    pbaspect([1 1 1])
                    ylim([YlimRange(1) YlimRange(2)]);
                    ylabel(Ylabel);
                    set(SP,'XTick', 6);
                    set(SP,'XTickLabel', {'switch'});
                    set(SP, 'XColor', 'none'); % Make x-axis invisible


                    title(strcat(sprintf(A_Name),' other to own'))
                    OveralSwitch = [];
                    OveralSwitch = sum(OtherSelfSwitchNum(Turn,1,idata));
                    subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                    if OveralSwitch == 0
                        % Find and delete all lines
                        hPlots = findobj(gca, 'Type', 'line');

                        % Find and delete all xlines (ConstantLine objects)
                        hXLines = findobj(gca, 'Type', 'ConstantLine');

                        % Find and delete all shaded areas (patch objects)
                        hPatches = findobj(gca, 'Type', 'patch');

                        % Delete all found objects
                        delete([hPlots; hXLines; hPatches]);
                    end


                end
                %%
                if Turn == 2
                    clear SP, SP = subplot(3,2,3)
                    hold on
                    %                 %% blue curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    DegreeFreddom = sum(AtSwitch_SelfOther_SwitchNum(Turn,1,idata))
                    t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
                    margin_of_errorAtSwitchSelfOther = t_critical * SEM_OverSessAtSwitch_SelfOther(Turn,:,1,idata);
                    ci_lowerAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) - margin_of_errorAtSwitchSelfOther;
                    ci_upperAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) + margin_of_errorAtSwitchSelfOther;
                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) > 0
                            ci_lowerAtSwitchSelfOther(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(ci_upperAtSwitchSelfOther > Valid_Max_FCO) > 0
                            ci_upperAtSwitchSelfOther(ci_upperAtSwitchSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                    %
                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                    %
                    %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerSelfOther(Turn,:,1), fliplr(ci_upperSelfOther(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
                    % %                 %% red curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessSelfOther(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_SelfOther = t_critical * CrossSEM_OverSess_SelfOther(Turn,:,2,idata)
                    Cross_ci_lowerSelfOther = CrossMeanOverSessSelfOther(Turn,:,2) - CrossMarginOfError_SelfOther;
                    Cross_ci_upperSelfOther = CrossMeanOverSessSelfOther(Turn,:,2) + CrossMarginOfError_SelfOther;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                            Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                            Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],'b', 'FaceAlpha', 0.3,'EdgeColor','none');


                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    %
                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    % %
                    %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther(Turn,:,2), fliplr(Cross_ci_upperSelfOther(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                    % %                 %% pink curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2),'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_AtSwitchSelfOther = t_critical * CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,2,idata);
                    Cross_ci_lowerSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) - CrossMarginOfError_AtSwitchSelfOther;
                    Cross_ci_upperSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) + CrossMarginOfError_AtSwitchSelfOther;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                            Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                            Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                    %
                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                    %
                    % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchSelfOther(Turn,:,2), fliplr(Cross_ci_upperAtSwitchSelfOther(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
                    xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth)
                    pbaspect([1 1 1])
                    ylim([YlimRange(1) YlimRange(2)]);
                    set(SP,'XTick', 6);
                    set(SP,'XTickLabel', {'switch'});
                    set(SP, 'XColor', 'none'); % Make x-axis invisible


                    title(strcat(sprintf(A_Name),' own to other'))
                    OveralSwitch = [];
                    OveralSwitch = sum(SelfOtherSwitchNum(Turn,1,idata));
                    subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                    if OveralSwitch == 0
                        % Find and delete all lines
                        hPlots = findobj(gca, 'Type', 'line');

                        % Find and delete all xlines (ConstantLine objects)
                        hXLines = findobj(gca, 'Type', 'ConstantLine');

                        % Find and delete all shaded areas (patch objects)
                        hPatches = findobj(gca, 'Type', 'patch');

                        % Delete all found objects
                        delete([hPlots; hXLines; hPatches]);
                    end
                    %%
                    clear SP, SP = subplot(3,2,4)
                    hold on
                    %                 %% blue curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    DegreeFreddom = sum(AtSwitch_OtherSelf_SwitchNum(Turn,1,idata));
                    t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
                    margin_of_errorAtSwitchOtherSelf = t_critical * SEM_OverSessAtSwitch_OtherSelf(Turn,:,1,idata);
                    ci_lowerAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) - margin_of_errorAtSwitchOtherSelf;
                    ci_upperAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) + margin_of_errorAtSwitchOtherSelf;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) > 0
                            ci_lowerAtSwitchOtherSelf(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) > 0
                            ci_upperAtSwitchOtherSelf(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                    %
                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                    %
                    % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerOtherSelf(Turn,:,1), fliplr(ci_upperOtherSelf(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
                    %                 %% red curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessOtherSelf(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_OtherSelf = t_critical * mean(CrossSEM_OverSess_OtherSelf(Turn,:,2,idata),4,'omitmissing');
                    Cross_ci_lowerOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,2) - CrossMarginOfError_OtherSelf;
                    Cross_ci_upperOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,2) + CrossMarginOfError_OtherSelf;


                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                            Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                            Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');



                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    %
                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSel(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    % %
                    %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf(Turn,:,2), fliplr(Cross_ci_upperOtherSel(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                    %                 %% pink curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2),'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_AtSwitchOtherSelf = t_critical * CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,2,idata);
                    Cross_ci_lowerOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) - CrossMarginOfError_AtSwitchOtherSelf;
                    Cross_ci_upperOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) + CrossMarginOfError_AtSwitchOtherSelf;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                            Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                            Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                    %
                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                    %
                    % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2), fliplr(Cross_ci_upperAtSwitchOtherSelf(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
                    xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth)
                    pbaspect([1 1 1])
                    ylim([YlimRange(1) YlimRange(2)]);
                    ylabel(Ylabel);
                    set(SP,'XTick', 6);
                    set(SP,'XTickLabel', {'switch'});
                    set(SP, 'XColor', 'none'); % Make x-axis invisible


                    title(strcat(sprintf(A_Name),' other to own'))
                    OveralSwitch = [];
                    OveralSwitch = sum(OtherSelfSwitchNum(Turn,1,idata));
                    subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                    if OveralSwitch == 0
                        % Find and delete all lines
                        hPlots = findobj(gca, 'Type', 'line');

                        % Find and delete all xlines (ConstantLine objects)
                        hXLines = findobj(gca, 'Type', 'ConstantLine');

                        % Find and delete all shaded areas (patch objects)
                        hPatches = findobj(gca, 'Type', 'patch');

                        % Delete all found objects
                        delete([hPlots; hXLines; hPatches]);
                    end



                end
                %%
                if Turn == 3
                    clear SP, SP = subplot(3,2,5)
                    hold on
                    %                 %% blue curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    DegreeFreddom = sum(AtSwitch_SelfOther_SwitchNum(Turn,1,:));
                    t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
                    margin_of_errorAtSwitchSelfOther = t_critical * SEM_OverSessAtSwitch_SelfOther(Turn,:,1,idata)
                    ci_lowerAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) - margin_of_errorAtSwitchSelfOther;
                    ci_upperAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) + margin_of_errorAtSwitchSelfOther;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) > 0
                            ci_lowerAtSwitchSelfOther(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(ci_upperAtSwitchSelfOther > Valid_Max_FCO) > 0
                            ci_upperAtSwitchSelfOther(ci_upperAtSwitchSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');



                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                    %
                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                    %
                    %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerSelfOther(Turn,:,1), fliplr(ci_upperSelfOther(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
                    % %                 %% red curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessSelfOther(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_SelfOther = t_critical * CrossSEM_OverSess_SelfOther(Turn,:,2,idata);
                    Cross_ci_lowerSelfOther = CrossMeanOverSessSelfOther(Turn,:,2) - CrossMarginOfError_SelfOther;
                    Cross_ci_upperSelfOther = CrossMeanOverSessSelfOther(Turn,:,2) + CrossMarginOfError_SelfOther;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                            Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                            Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],'b', 'FaceAlpha', CI_Lines_LineWidth,'EdgeColor','none');

                    %
                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    %
                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    % %
                    %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther(Turn,:,2), fliplr(Cross_ci_upperSelfOther(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                    %                 %% pink curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2),'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_AtSwitchSelfOther = t_critical * CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,2,idata);
                    Cross_ci_lowerSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) - CrossMarginOfError_AtSwitchSelfOther;
                    Cross_ci_upperSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) + CrossMarginOfError_AtSwitchSelfOther;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                            Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                            Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');

                    %
                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                    %
                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                    %
                    % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchSelfOther(Turn,:,2), fliplr(Cross_ci_upperAtSwitchSelfOther(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
                    xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth)
                    pbaspect([1 1 1])
                    ylim([YlimRange(1) YlimRange(2)]);
                    set(SP,'XTick', 6);
                    set(SP,'XTickLabel', {'switch'});
                    % set(SP, 'XColor', 'none'); % Make x-axis invisible


                    title(strcat(sprintf(A_Name),' own to other'))
                    OveralSwitch = []
                    OveralSwitch = sum(SelfOtherSwitchNum(Turn,1,idata));
                    subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                    if OveralSwitch == 0
                        % Find and delete all lines
                        hPlots = findobj(gca, 'Type', 'line');

                        % Find and delete all xlines (ConstantLine objects)
                        hXLines = findobj(gca, 'Type', 'ConstantLine');

                        % Find and delete all shaded areas (patch objects)
                        hPatches = findobj(gca, 'Type', 'patch');

                        % Delete all found objects
                        delete([hPlots; hXLines; hPatches]);
                        H = findobj(gca);
                        set(H,'XTick', 0.5);
                        set(H,'XTickLabel', {'switch'});

                    end
                    %%
                    clear SP, SP = subplot(3,2,6)
                    hold on
                    %                 %% blue curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    DegreeFreddom = sum(AtSwitch_OtherSelf_SwitchNum(Turn,1,idata));
                    t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
                    margin_of_errorAtSwitchOtherSelf = t_critical * SEM_OverSessAtSwitch_OtherSelf(Turn,:,1,idata);
                    ci_lowerAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) - margin_of_errorAtSwitchOtherSelf;
                    ci_upperAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) + margin_of_errorAtSwitchOtherSelf;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) > 0
                            ci_lowerAtSwitchOtherSelf(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) > 0
                            ci_upperAtSwitchOtherSelf(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                    %
                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                    %
                    % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerOtherSelf(Turn,:,1), fliplr(ci_upperOtherSelf(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
                    %                 %% red curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessOtherSelf(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_OtherSelf = t_critical * CrossSEM_OverSess_OtherSelf(Turn,:,2,idata);
                    Cross_ci_lowerOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,2) - CrossMarginOfError_OtherSelf;
                    Cross_ci_upperOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,2) + CrossMarginOfError_OtherSelf;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                            Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                            Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],'b', 'FaceAlpha', CI_Lines_LineWidth,'EdgeColor','none');


                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    %
                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSel(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    % %
                    %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf(Turn,:,2), fliplr(Cross_ci_upperOtherSel(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                    %                 %% pink curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2),'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_AtSwitchOtherSelf = t_critical * CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,2,idata);
                    Cross_ci_lowerOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) - CrossMarginOfError_AtSwitchOtherSelf;
                    Cross_ci_upperOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) + CrossMarginOfError_AtSwitchOtherSelf;
                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                            Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                            Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                    %
                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                    %
                    % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2), fliplr(Cross_ci_upperAtSwitchOtherSelf(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
                    xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth)
                    pbaspect([1 1 1])
                    ylim([YlimRange(1) YlimRange(2)]);
                    ylabel(Ylabel);
                    set(SP,'XTick', 6);
                    set(SP,'XTickLabel', {'switch'});
                    % set(SP, 'XColor', 'none'); % Make x-axis invisible


                    title(strcat(sprintf(A_Name),' other to own'))
                    OveralSwitch = [];
                    OveralSwitch = sum(OtherSelfSwitchNum(Turn,1,idata));
                    subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                    if OveralSwitch == 0
                        % Find and delete all lines
                        hPlots = findobj(gca, 'Type', 'line');

                        % Find and delete all xlines (ConstantLine objects)
                        hXLines = findobj(gca, 'Type', 'ConstantLine');

                        % Find and delete all shaded areas (patch objects)
                        hPatches = findobj(gca, 'Type', 'patch');

                        % Delete all found objects
                        delete([hPlots; hXLines; hPatches]);
                        H = findobj(gca);
                        set(H,'XTick', 0.5);
                        set(H,'XTickLabel', {'switch'});

                    end


                end
            end


            annotation('textbox',...
                [0.00679728108756502 0.718340611353712 0.123150739704118 0.103711790393013],...
                'String',{'subject first, switcher second'},...
                'FitBoxToText','off',...
                'EdgeColor','none');

            annotation('textbox',...
                [0.0259896041583367 0.460698689956332 0.0911635345861662 0.031659388646288],...
                'String','simul',...
                'FitBoxToText','off',...
                'EdgeColor','none');

            annotation('textbox',...
                [0.00519792083166733 0.137554585152838 0.116753298680528 0.107432286115798],...
                'String',{'subject','second,','switcher','first'},...
                'FitBoxToText','off',...
                'EdgeColor','none');

            filename = [];
            filename = strcat(A_Name,'-',B_Name,'-',SessionDateEachSess,ExtentionOfFileName,'.pdf');
            sgtitle(strcat(A_Name,'-',B_Name,'-',SessionDateEachSess));
            ax = gcf;
            exportgraphics(ax,sprintf(filename),'Resolution',600);

            filename2 = [];
            filename2 = strcat(A_Name,'-',B_Name,'-',SessionDateEachSess,ExtentionOfFileName,'.jpg');
            exportgraphics(ax,sprintf(filename2),'Resolution',600);




            %% other player switches
            FigName = strcat(A_Name,'-Bswitch',B_Name);
            figure('Name',sprintf(FigName), 'NumberTitle', 'off','Position',[488,49.800000000000004,500.2,732.8000000000001])
            for Turn = 1 : 3
                if Turn == 1
                    clear SP, SP = subplot(3,2,1)
                    hold on
                    %                 %% red curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    DegreeFreddom = sum(AtSwitch_SelfOther_SwitchNum(Turn,2,idata))
                    t_critical = tinv(1 - alpha/2, DegreeFreddom - 1)
                    margin_of_errorAtSwitchSelfOther = t_critical * SEM_OverSessAtSwitch_SelfOther(Turn,:,2,idata);
                    ci_lowerAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) - margin_of_errorAtSwitchSelfOther;
                    ci_upperAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) + margin_of_errorAtSwitchSelfOther;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) > 0
                            ci_lowerAtSwitchSelfOther(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(ci_upperAtSwitchSelfOther > Valid_Max_FCO) > 0
                            ci_upperAtSwitchSelfOther(ci_upperAtSwitchSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');

                    %                 %% blue curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessSelfOther(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_SelfOther = t_critical * mean(CrossSEM_OverSess_SelfOther(Turn,:,1,idata),4,'omitmissing')
                    Cross_ci_lowerSelfOther = CrossMeanOverSessSelfOther(Turn,:,1) - CrossMarginOfError_SelfOther;
                    Cross_ci_upperSelfOther = CrossMeanOverSessSelfOther(Turn,:,1) + CrossMarginOfError_SelfOther;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                            Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                            Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');



                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    %
                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    % %
                    %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther(Turn,:,2), fliplr(Cross_ci_upperSelfOther(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                    % %                 %% pink curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1),'o-','Color',ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_AtSwitchSelfOther = t_critical * mean(CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,1,idata),4,'omitmissing');
                    Cross_ci_lowerSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) - CrossMarginOfError_AtSwitchSelfOther;
                    Cross_ci_upperSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) + CrossMarginOfError_AtSwitchSelfOther;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                            Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                            Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorAatSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');

                    xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth)
                    pbaspect([1 1 1])
                    ylim([YlimRange(1) YlimRange(2)]);
                    set(SP,'XTick', 6);
                    set(SP,'XTickLabel', {'switch'});
                    set(SP, 'XColor', 'none'); % Make x-axis invisible


                    title(strcat(sprintf(B_Name),' own to other'))
                    OveralSwitch = [];
                    OveralSwitch = sum(SelfOtherSwitchNum(Turn,2,idata));
                    subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                    if OveralSwitch == 0
                        % Find and delete all lines
                        hPlots = findobj(gca, 'Type', 'line');

                        % Find and delete all xlines (ConstantLine objects)
                        hXLines = findobj(gca, 'Type', 'ConstantLine');

                        % Find and delete all shaded areas (patch objects)
                        hPatches = findobj(gca, 'Type', 'patch');

                        % Delete all found objects
                        delete([hPlots; hXLines; hPatches]);
                    end
                    %%
                    clear SP, SP = subplot(3,2,2)
                    hold on
                    %                 %% blue curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    DegreeFreddom = sum(AtSwitch_OtherSelf_SwitchNum(Turn,2,idata));
                    t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
                    margin_of_errorAtSwitchOtherSelf = t_critical * mean(SEM_OverSessAtSwitch_OtherSelf(Turn,:,2,idata),4,'omitmissing');
                    ci_lowerAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) - margin_of_errorAtSwitchOtherSelf;
                    ci_upperAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) + margin_of_errorAtSwitchOtherSelf;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) > 0
                            ci_lowerAtSwitchOtherSelf(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) > 0
                            ci_upperAtSwitchOtherSelf(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                    %
                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                    %
                    % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerOtherSelf(Turn,:,1), fliplr(ci_upperOtherSelf(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
                    %                 %% red curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessOtherSelf(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_OtherSelf = t_critical * mean(CrossSEM_OverSess_OtherSelf(Turn,:,1,idata),4,'omitmissing');
                    Cross_ci_lowerOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,1) - CrossMarginOfError_OtherSelf;
                    Cross_ci_upperOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,1) + CrossMarginOfError_OtherSelf;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                            Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                            Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    %
                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSel(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    % %
                    %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf(Turn,:,2), fliplr(Cross_ci_upperOtherSel(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                    %                 %% pink curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1),'o-','Color',ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_AtSwitchOtherSelf = t_critical * mean(CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,1,idata),4,'omitmissing');
                    Cross_ci_lowerOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) - CrossMarginOfError_AtSwitchOtherSelf;
                    Cross_ci_upperOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) + CrossMarginOfError_AtSwitchOtherSelf;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                            Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                            Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorAatSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');
                    xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth)
                    pbaspect([1 1 1])
                    ylim([YlimRange(1) YlimRange(2)]);
                    ylabel(Ylabel);
                    set(SP,'XTick', 6);
                    set(SP,'XTickLabel', {'switch'});
                    set(SP, 'XColor', 'none'); % Make x-axis invisible


                    title(strcat(sprintf(B_Name),' other to own'))
                    OveralSwitch = []
                    OveralSwitch = sum(OtherSelfSwitchNum(Turn,2,idata));
                    subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                    if OveralSwitch == 0
                        % Find and delete all lines
                        hPlots = findobj(gca, 'Type', 'line');

                        % Find and delete all xlines (ConstantLine objects)
                        hXLines = findobj(gca, 'Type', 'ConstantLine');

                        % Find and delete all shaded areas (patch objects)
                        hPatches = findobj(gca, 'Type', 'patch');

                        % Delete all found objects
                        delete([hPlots; hXLines; hPatches]);
                    end

                end
                %%
                if Turn == 2
                    clear SP, SP = subplot(3,2,3)
                    hold on
                    %                 %% blue curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    DegreeFreddom = sum(AtSwitch_SelfOther_SwitchNum(Turn,2,idata));
                    t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
                    margin_of_errorAtSwitchSelfOther = t_critical * mean(SEM_OverSessAtSwitch_SelfOther(Turn,:,2,idata),4,'omitmissing');
                    ci_lowerAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) - margin_of_errorAtSwitchSelfOther;
                    ci_upperAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) + margin_of_errorAtSwitchSelfOther;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) > 0
                            ci_lowerAtSwitchSelfOther(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(ci_upperAtSwitchSelfOther > Valid_Max_FCO) > 0
                            ci_upperAtSwitchSelfOther(ci_upperAtSwitchSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                    %
                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                    %
                    %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerSelfOther(Turn,:,1), fliplr(ci_upperSelfOther(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
                    % %                 %% red curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessSelfOther(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_SelfOther = t_critical * mean(CrossSEM_OverSess_SelfOther(Turn,:,1,idata),4,'omitmissing');
                    Cross_ci_lowerSelfOther = CrossMeanOverSessSelfOther(Turn,:,1) - CrossMarginOfError_SelfOther;
                    Cross_ci_upperSelfOther = CrossMeanOverSessSelfOther(Turn,:,1) + CrossMarginOfError_SelfOther;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                            Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                            Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    %
                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    % %
                    %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther(Turn,:,2), fliplr(Cross_ci_upperSelfOther(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                    % %                 %% pink curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1),'o-','Color',ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_AtSwitchSelfOther = t_critical * mean(CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,1,idata),4,'omitmissing');
                    Cross_ci_lowerSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) - CrossMarginOfError_AtSwitchSelfOther;
                    Cross_ci_upperSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) + CrossMarginOfError_AtSwitchSelfOther;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                            Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                            Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorAatSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                    %
                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                    %
                    % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchSelfOther(Turn,:,2), fliplr(Cross_ci_upperAtSwitchSelfOther(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
                    xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth)
                    pbaspect([1 1 1])
                    ylim([YlimRange(1) YlimRange(2)]);
                    set(SP,'XTick', 6);
                    set(SP,'XTickLabel', {'switch'});
                    set(SP, 'XColor', 'none'); % Make x-axis invisible


                    title(strcat(sprintf(B_Name),' own to other'))
                    OveralSwitch = []
                    OveralSwitch = sum(SelfOtherSwitchNum(Turn,2,idata));
                    subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                    if OveralSwitch == 0
                        % Find and delete all lines
                        hPlots = findobj(gca, 'Type', 'line');

                        % Find and delete all xlines (ConstantLine objects)
                        hXLines = findobj(gca, 'Type', 'ConstantLine');

                        % Find and delete all shaded areas (patch objects)
                        hPatches = findobj(gca, 'Type', 'patch');

                        % Delete all found objects
                        delete([hPlots; hXLines; hPatches]);
                    end
                    %%
                    clear SP, SP = subplot(3,2,4)
                    hold on
                    %                 %% blue curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    DegreeFreddom = sum(AtSwitch_OtherSelf_SwitchNum(Turn,2,idata))
                    t_critical = tinv(1 - alpha/2, DegreeFreddom - 1)
                    margin_of_errorAtSwitchOtherSelf = t_critical * mean(SEM_OverSessAtSwitch_OtherSelf(Turn,:,2,idata),4,'omitmissing')
                    ci_lowerAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) - margin_of_errorAtSwitchOtherSelf;
                    ci_upperAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) + margin_of_errorAtSwitchOtherSelf;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) > 0
                            ci_lowerAtSwitchOtherSelf(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) > 0
                            ci_upperAtSwitchOtherSelf(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                    %
                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                    %
                    % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerOtherSelf(Turn,:,1), fliplr(ci_upperOtherSelf(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
                    %                 %% red curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessOtherSelf(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_OtherSelf = t_critical * mean(CrossSEM_OverSess_OtherSelf(Turn,:,1,idata),4,'omitmissing')
                    Cross_ci_lowerOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,1) - CrossMarginOfError_OtherSelf;
                    Cross_ci_upperOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,1) + CrossMarginOfError_OtherSelf;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                            Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                            Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');



                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    %
                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSel(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    % %
                    %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf(Turn,:,2), fliplr(Cross_ci_upperOtherSel(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                    %                 %% pink curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1),'o-','Color',ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_AtSwitchOtherSelf = t_critical * mean(CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,1,idata),4,'omitmissing')
                    Cross_ci_lowerOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) - CrossMarginOfError_AtSwitchOtherSelf;
                    Cross_ci_upperOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) + CrossMarginOfError_AtSwitchOtherSelf;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                            Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                            Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorAatSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');
                    xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth)
                    pbaspect([1 1 1])
                    ylim([YlimRange(1) YlimRange(2)]);
                    ylabel(Ylabel);
                    set(SP,'XTick', 6);
                    set(SP,'XTickLabel', {'switch'});
                    set(SP, 'XColor', 'none'); % Make x-axis invisible


                    title(strcat(sprintf(B_Name),' other to own'))
                    OveralSwitch = []
                    OveralSwitch = sum(OtherSelfSwitchNum(Turn,2,idata));
                    subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                    if OveralSwitch == 0
                        % Find and delete all lines
                        hPlots = findobj(gca, 'Type', 'line');

                        % Find and delete all xlines (ConstantLine objects)
                        hXLines = findobj(gca, 'Type', 'ConstantLine');

                        % Find and delete all shaded areas (patch objects)
                        hPatches = findobj(gca, 'Type', 'patch');

                        % Delete all found objects
                        delete([hPlots; hXLines; hPatches]);
                    end


                end
                %%
                if Turn == 3
                    clear SP, SP = subplot(3,2,5)
                    hold on
                    %                 %% blue curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    DegreeFreddom = sum(AtSwitch_SelfOther_SwitchNum(Turn,2,idata))
                    t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
                    margin_of_errorAtSwitchSelfOther = t_critical * mean(SEM_OverSessAtSwitch_SelfOther(Turn,:,2,idata),4,'omitmissing')
                    ci_lowerAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) - margin_of_errorAtSwitchSelfOther;
                    ci_upperAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) + margin_of_errorAtSwitchSelfOther;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) > 0
                            ci_lowerAtSwitchSelfOther(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(ci_upperAtSwitchSelfOther > Valid_Max_FCO) > 0
                            ci_upperAtSwitchSelfOther(ci_upperAtSwitchSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');



                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                    %
                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                    %
                    %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerSelfOther(Turn,:,1), fliplr(ci_upperSelfOther(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
                    % %                 %% red curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessSelfOther(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_SelfOther = t_critical * mean(CrossSEM_OverSess_SelfOther(Turn,:,1,idata),4,'omitmissing');
                    Cross_ci_lowerSelfOther = CrossMeanOverSessSelfOther(Turn,:,1) - CrossMarginOfError_SelfOther;
                    Cross_ci_upperSelfOther = CrossMeanOverSessSelfOther(Turn,:,1) + CrossMarginOfError_SelfOther;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                            Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                            Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');

                    %
                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    %
                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    % %
                    %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther(Turn,:,2), fliplr(Cross_ci_upperSelfOther(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                    %                 %% pink curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1),'o-','Color',ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_AtSwitchSelfOther = t_critical * mean(CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,1,idata),4,'omitmissing')
                    Cross_ci_lowerSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) - CrossMarginOfError_AtSwitchSelfOther;
                    Cross_ci_upperSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) + CrossMarginOfError_AtSwitchSelfOther;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                            Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                            Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorAatSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');

                    xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth)
                    pbaspect([1 1 1])
                    ylim([YlimRange(1) YlimRange(2)]);
                    set(SP,'XTick', 6);
                    set(SP,'XTickLabel', {'switch'});
                    % set(SP, 'XColor', 'none'); % Make x-axis invisible


                    title(strcat(sprintf(B_Name),' own to other'))
                    OveralSwitch = []
                    OveralSwitch = sum(SelfOtherSwitchNum(Turn,2,idata));
                    subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                    if OveralSwitch == 0
                        % Find and delete all lines
                        hPlots = findobj(gca, 'Type', 'line');

                        % Find and delete all xlines (ConstantLine objects)
                        hXLines = findobj(gca, 'Type', 'ConstantLine');

                        % Find and delete all shaded areas (patch objects)
                        hPatches = findobj(gca, 'Type', 'patch');

                        % Delete all found objects
                        delete([hPlots; hXLines; hPatches]);
                        H = findobj(gca);
                        set(H,'XTick', 0.5);
                        set(H,'XTickLabel', {'switch'});

                    end
                    %%
                    %%
                    clear SP, SP = subplot(3,2,6)
                    hold on
                    %                 %% blue curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    DegreeFreddom = sum(AtSwitch_OtherSelf_SwitchNum(Turn,2,idata))
                    t_critical = tinv(1 - alpha/2, DegreeFreddom - 1)
                    margin_of_errorAtSwitchOtherSelf = t_critical * mean(SEM_OverSessAtSwitch_OtherSelf(Turn,:,2,idata),4,'omitmissing')
                    ci_lowerAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) - margin_of_errorAtSwitchOtherSelf;
                    ci_upperAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) + margin_of_errorAtSwitchOtherSelf;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) > 0
                            ci_lowerAtSwitchOtherSelf(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) > 0
                            ci_upperAtSwitchOtherSelf(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                    %
                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
                    %
                    % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerOtherSelf(Turn,:,1), fliplr(ci_upperOtherSelf(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
                    %                 %% red curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessOtherSelf(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_OtherSelf = t_critical * mean(CrossSEM_OverSess_OtherSelf(Turn,:,1,idata),4,'omitmissing');
                    Cross_ci_lowerOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,1) - CrossMarginOfError_OtherSelf;
                    Cross_ci_upperOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,1) + CrossMarginOfError_OtherSelf;

                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                            Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                            Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    %
                    %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSel(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
                    % %
                    %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf(Turn,:,2), fliplr(Cross_ci_upperOtherSel(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
                    %                 %% pink curve
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1),'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth);
                    %% calcualte and plot 95% confidence interval based on t dist SEM
                    CrossMarginOfError_AtSwitchOtherSelf = t_critical * mean(CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,1,idata),4,'omitmissing');
                    Cross_ci_lowerOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) - CrossMarginOfError_AtSwitchOtherSelf;
                    Cross_ci_upperOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) + CrossMarginOfError_AtSwitchOtherSelf;
                    %here you make sure if upper CI is more than 1 and lowe CI
                    %is less than 0, it is clipped before plotting
                    if contains(WhatOnYaxis,'ChoiceDynamic')
                        if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                            Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                        end

                        if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                            Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                        end
                    end

                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                    plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
                    fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorAatSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                    %
                    % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
                    %
                    % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2), fliplr(Cross_ci_upperAtSwitchOtherSelf(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
                    xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);
                    pbaspect([1 1 1]);
                    ylim([YlimRange(1) YlimRange(2)]);
                    ylabel(Ylabel);
                    set(SP,'XTick', 6);
                    set(SP,'XTickLabel', {'switch'});
                    % set(SP, 'XColor', 'none'); % Make x-axis invisible


                    OveralSwitch = [];
                    OveralSwitch = sum(OtherSelfSwitchNum(Turn,2,idata));
                    subtitle(strcat('(Num : ',string(OveralSwitch),')'));
                    title(strcat(sprintf(B_Name),' other to own'));
                    if OveralSwitch == 0
                        % Find and delete all lines
                        hPlots = findobj(gca, 'Type', 'line');

                        % Find and delete all xlines (ConstantLine objects)
                        hXLines = findobj(gca, 'Type', 'ConstantLine');

                        % Find and delete all shaded areas (patch objects)
                        hPatches = findobj(gca, 'Type', 'patch');

                        % Delete all found objects
                        delete([hPlots; hXLines; hPatches]);
                        H = findobj(gca);
                        set(H,'XTick', 0.5);
                        set(H,'XTickLabel', {'switch'});

                    end


                end
            end
            ax = gcf;

            annotation('textbox',...
                [0.00439824070371872 0.697598253275111 0.12155137944822 0.118995633187773],...
                'String',{'subject second, switcher first'},...
                'FitBoxToText','off',...
                'EdgeColor','none');

            annotation('textbox',...
                [0.0259896041583367 0.457423580786026 0.0911635345861659 0.0349344978165935],...
                'String',{'simul'},...
                'FitBoxToText','off',...
                'EdgeColor','none');


            annotation('textbox',...
                [0.00519792083166695 0.152838427947598 0.119952019192323 0.106340583059029],...
                'String',{'subject','first,','switcher','second'},...
                'FitBoxToText','off',...
                'EdgeColor','none');


            filename = [];
            filename = strcat(A_Name,'-',B_Name,'-',SessionDateEachSess,ExtentionOfFileName,'SwitchB.pdf');
            sgtitle(strcat(A_Name,'-',B_Name,'-SwitchB-',SessionDateEachSess));
            ax = gcf;
            exportgraphics(ax,sprintf(filename),'Resolution',600);

            filename2 = [];
            filename2 = strcat(A_Name,'-',B_Name,'-',SessionDateEachSess,ExtentionOfFileName,'SwitchB.jpg');
            exportgraphics(ax,sprintf(filename2),'Resolution',600);


        end
    end



















    %% plotting for multi sessions scripts (average among sessions)
elseif contains(scriptName,'AverageAcrossMonkeys' )
    FigName = strcat(FirstSessActorA{1},'-',FirstSessActorB{1})
    figure('Name',sprintf(FigName), 'NumberTitle', 'off','Position',[488,49.800000000000004,500.2,732.8000000000001])
    for Turn = 1 : 3
        if Turn == 1
            clear SP, SP = subplot(3,2,5)
            hold on
            % here you plot choices when monkey  itself switches from own
            % to other and he was first (timing applies only at switch)
            XAX = []
            XAX = 1:BeforeAfter_Length+1+BeforeAfter_Length;
            YAX = []
            YAX = mean([WholeSess_AtSwitchSelfother{1,Turn+2};WholeSess_AtSwitchSelfother{2,Turn}],1,'omitmissing');
            plot(XAX,YAX,'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
            %% calcualte and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_SelfOther_SwitchNum(Turn+2,1,:))+sum(AtSwitch_SelfOther_SwitchNum(Turn,2,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);

            MeanAmongMonksSem = []
            MeanAmongMonksSem = calcSEM([WholeSess_AtSwitchSelfother{1,Turn+2};WholeSess_AtSwitchSelfother{2,Turn}]);

            margin_of_errorAtSwitchSelfOther = t_critical .* MeanAmongMonksSem
            ci_lowerAtSwitchSelfOther = YAX - margin_of_errorAtSwitchSelfOther;
            ci_upperAtSwitchSelfOther = YAX + margin_of_errorAtSwitchSelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) > 0
                    ci_lowerAtSwitchSelfOther(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(ci_upperAtSwitchSelfOther > Valid_Max_FCO) > 0
                    ci_upperAtSwitchSelfOther(ci_upperAtSwitchSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');

            % here you plot choices when monkey's partner switches from
            % own to other When monkey was first(timing applies on all trials)
            YAX = [];
            YAX = mean([WholeSess_CrossSelfOther{1,Turn};WholeSess_CrossSelfOther{2,Turn+2}],1,'omitmissing');
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
            %% calcualte and plot 95% confidence interval based on t dist SEM
            MeanAmongMonksSem = []
            MeanAmongMonksSem = calcSEM([WholeSess_CrossSelfOther{1,Turn};WholeSess_CrossSelfOther{2,Turn+2}]);

            CrossMarginOfError_SelfOther = t_critical .* MeanAmongMonksSem;
            Cross_ci_lowerSelfOther = YAX - CrossMarginOfError_SelfOther;
            Cross_ci_upperSelfOther = YAX + CrossMarginOfError_SelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                    Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                    Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],'b', 'FaceAlpha', 0.3,'EdgeColor','none');




            % here you plot choices when monkey's partner swichtes from
            % own to other when monkey was first( timing applies at switch )
            YAX = []
            YAX = mean([WholeSess_AtSwitchCrossSelfother{1,Turn};WholeSess_AtSwitchCrossSelfother{2,Turn+2}],1,'omitmissing');
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth)
            %% calcualte and plot 95% confidence interval based on t dist SEM

            MeanAmongMonksSem = []
            MeanAmongMonksSem = calcSEM([WholeSess_AtSwitchCrossSelfother{1,Turn};WholeSess_AtSwitchCrossSelfother{2,Turn+2}]);

            CrossMarginOfError_AtSwitchSelfOther = t_critical .* MeanAmongMonksSem;
            Cross_ci_lowerSelfOther = YAX - CrossMarginOfError_AtSwitchSelfOther;
            Cross_ci_upperSelfOther = YAX + CrossMarginOfError_AtSwitchSelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                    Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                    Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
            %
            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
            %
            % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchSelfOther(Turn,:,2), fliplr(Cross_ci_upperAtSwitchSelfOther(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
            xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth)

            pbaspect([1 1 1])
            ylim([YlimRange(1) YlimRange(2)]);
            set(SP,'XTick', 6);
            set(SP,'XTickLabel', {'switch'});
            % set(SP, 'XColor', 'none'); % Make x-axis invisible


            % title(strcat(sprintf(A_Name),' own to other switch'))
            title(' SECOND, own to other')

            OveralSwitch = []
            OveralSwitch = sum(SelfOtherSwitchNum(Turn+2,1,:),3)+sum(SelfOtherSwitchNum(Turn,2,:),3)
            subtitle(strcat('(Num : ',string(OveralSwitch),')'));
            % set(gca, 'XColor', 'none'); % Make x-axis invisible
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
                H = findobj(gca);
                set(H,'XTick', 0.5);
                set(H,'XTickLabel', {'switch'});

            end
            %%
            clear SP, SP = subplot(3,2,6)
            hold on
            % here you plot choices when monkey itself switches from own
            % to other and he was first (timing applies only at switch)
            XAX = [];
            XAX = 1:BeforeAfter_Length+1+BeforeAfter_Length;
            YAX = [];
            YAX = mean([WholeSess_AtSwitchOtherSelf{1,Turn+2};WholeSess_AtSwitchOtherSelf{2,Turn}],1,'omitmissing');
            plot(XAX,YAX,'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
            %% calcualte and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_OtherSelf_SwitchNum(Turn+2,1,:))+sum(AtSwitch_OtherSelf_SwitchNum(Turn,2,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);

            MeanAmongMonksSem = [];
            MeanAmongMonksSem = calcSEM([WholeSess_AtSwitchOtherSelf{1,Turn+2};WholeSess_AtSwitchOtherSelf{2,Turn}]);

            margin_of_errorAtSwitchOtherSelf = t_critical .* MeanAmongMonksSem;
            ci_lowerAtSwitchOtherSelf = YAX - margin_of_errorAtSwitchOtherSelf;
            ci_upperAtSwitchOtherSelf = YAX + margin_of_errorAtSwitchOtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) > 0
                    ci_lowerAtSwitchOtherSelf(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) > 0
                    ci_upperAtSwitchOtherSelf(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');

            % here you plot choices when monkey's partner switches from
            % own to other When monkey was first(timing applies on all trials)
            YAX = [];
            YAX = mean([WholeSess_CrossOtherSelf{1,Turn};WholeSess_CrossOtherSelf{2,Turn+2}],1,'omitmissing');
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
            %% calcualte and plot 95% confidence interval based on t dist SEM
            MeanAmongMonksSem = [];
            MeanAmongMonksSem = calcSEM([WholeSess_CrossOtherSelf{1,Turn};WholeSess_CrossOtherSelf{2,Turn+2}]);

            CrossMarginOfError_OtherSelf = t_critical .* MeanAmongMonksSem;
            Cross_ci_lowerOtherSelf = YAX - CrossMarginOfError_OtherSelf;
            Cross_ci_upperOtherSelf = YAX + CrossMarginOfError_OtherSelf;
            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                    Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                    Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],'b', 'FaceAlpha', 0.3,'EdgeColor','none');

            % here you plot choices when monkey's partner switches from
            % own to other when monkey was first( timing applies at switch )
            YAX = [];
            YAX = mean([WholeSess_AtSwitchCrossOtherSelf{1,Turn};WholeSess_AtSwitchCrossOtherSelf{2,Turn+2}],1,'omitmissing');
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM


            MeanAmongMonksSem = [];
            MeanAmongMonksSem = calcSEM([WholeSess_AtSwitchCrossOtherSelf{1,Turn};WholeSess_AtSwitchCrossOtherSelf{2,Turn+2}]);

            CrossMarginOfError_AtSwitchOtherSelf = t_critical .* MeanAmongMonksSem;
            Cross_ci_lowerOtherSelf = YAX - CrossMarginOfError_AtSwitchOtherSelf;
            Cross_ci_upperOtherSelf = YAX + CrossMarginOfError_AtSwitchOtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                    Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                    Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');

            xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth)


            pbaspect([1 1 1])
            ylim([YlimRange(1) YlimRange(2)]);
            ylabel(Ylabel);
            set(SP,'XTick', 6);
            set(SP,'XTickLabel', {'switch'});
            % set(SP, 'XColor', 'none'); % Make x-axis invisible


            % title(strcat(sprintf(A_Name),' own to other switch'))
            title(' SECOND, other to own')

            OveralSwitch = [];
            OveralSwitch = sum(OtherSelfSwitchNum(Turn+2,1,:),3)+sum(OtherSelfSwitchNum(Turn,2,:),3);
            subtitle(strcat('(Num : ',string(OveralSwitch),')'))
            % set(gca, 'XColor', 'none'); % Make x-axis invisible
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
                H = findobj(gca);
                set(H,'XTick', 0.5);
                set(H,'XTickLabel', {'switch'});

            end



        end
        %%
        if Turn == 2
            clear SP, SP = subplot(3,2,3)
            hold on
            % here you plot choices when monkey itself switches from own
            % to other and he was first (timing applies only at switch)
            XAX = [];
            XAX = 1:BeforeAfter_Length+1+BeforeAfter_Length;
            YAX = [];
            YAX = mean([WholeSess_AtSwitchSelfother{1,Turn}; WholeSess_AtSwitchSelfother{2,Turn}], 1,'omitmissing');
            plot(XAX,YAX,'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)

            %% calculate and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_SelfOther_SwitchNum(Turn,1,:)) + sum(AtSwitch_SelfOther_SwitchNum(Turn,2,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);

            MeanAmongMonksSem = []
            MeanAmongMonksSem = calcSEM([WholeSess_AtSwitchSelfother{1,Turn}; WholeSess_AtSwitchSelfother{2,Turn}]);

            margin_of_errorAtSwitchSelfOther = t_critical .* MeanAmongMonksSem;
            ci_lowerAtSwitchSelfOther = YAX - margin_of_errorAtSwitchSelfOther;
            ci_upperAtSwitchSelfOther = YAX + margin_of_errorAtSwitchSelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) > 0
                    ci_lowerAtSwitchSelfOther(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(ci_upperAtSwitchSelfOther > Valid_Max_FCO) > 0
                    ci_upperAtSwitchSelfOther(ci_upperAtSwitchSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length, ci_lowerAtSwitchSelfOther, '-', 'Color', CI_LINE_Color, 'LineWidth', CI_Lines_LineWidth)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length, ci_upperAtSwitchSelfOther, '-', 'Color',CI_LINE_Color, 'LineWidth', CI_Lines_LineWidth)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)], ActorAcolor, 'FaceAlpha', 0.3, 'EdgeColor', 'none');

            % plot choices when monkey's partner switches from own to other When monkey was first (timing applies on all trials)
            YAX = mean([WholeSess_CrossSelfOther{1,Turn}; WholeSess_CrossSelfOther{2,Turn}], 1,'omitmissing');
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)

            %% calculate and plot 95% confidence interval based on t dist SEM
            MeanAmongMonksSem = [];
            MeanAmongMonksSem = calcSEM([WholeSess_CrossSelfOther{1,Turn}; WholeSess_CrossSelfOther{2,Turn}]);

            CrossMarginOfError_SelfOther = t_critical .* MeanAmongMonksSem;
            Cross_ci_lowerSelfOther = YAX - CrossMarginOfError_SelfOther;
            Cross_ci_upperSelfOther = YAX + CrossMarginOfError_SelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                    Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                    Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)], 'b', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

            % plot choices when monkey's partner switches from own to other when monkey was first (timing applies at switch)
            YAX = mean([WholeSess_AtSwitchCrossSelfother{1,Turn}; WholeSess_AtSwitchCrossSelfother{2,Turn}], 1);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth)

            %% calculate and plot 95% confidence interval based on t dist SEM
            MeanAmongMonksSem = [];
            MeanAmongMonksSem = calcSEM([WholeSess_AtSwitchCrossSelfother{1,Turn}; WholeSess_AtSwitchCrossSelfother{2,Turn}]);

            CrossMarginOfError_AtSwitchSelfOther = t_critical .* MeanAmongMonksSem;
            Cross_ci_lowerSelfOther = YAX - CrossMarginOfError_AtSwitchSelfOther;
            Cross_ci_upperSelfOther = YAX + CrossMarginOfError_AtSwitchSelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                    Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                    Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)], ActorBAtSwitchCol, 'FaceAlpha', 0.3, 'EdgeColor', 'none');

            xline(BeforeAfter_Length+1, '--', 'LineWidth',DashedLine_LineWidth)

            pbaspect([1 1 1])
            ylim([YlimRange(1) YlimRange(2)]);
            set(SP,'XTick', 6);
            set(SP,'XTickLabel', {'switch'});
            set(SP, 'XColor', 'none'); % Make x-axis invisible


            title(' SIMUL, own to other')

            OveralSwitch = sum(SelfOtherSwitchNum(Turn,1,:),3) + sum(SelfOtherSwitchNum(Turn,2,:),3);
            subtitle(strcat('(Num : ',string(OveralSwitch),')'))
            % set(gca, 'XColor', 'none'); % Make x-axis invisible

            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');
                hXLines = findobj(gca, 'Type', 'ConstantLine');
                hPatches = findobj(gca, 'Type', 'patch');
                delete([hPlots; hXLines; hPatches]);
            end

            %%
            clear SP, SP = subplot(3,2,4)
            hold on
            % here you plot choices when monkey itself switches from own
            % to other and he was first (timing applies only at switch)
            XAX = [];
            XAX = 1:BeforeAfter_Length+1+BeforeAfter_Length;
            YAX = [];
            YAX = mean([WholeSess_AtSwitchOtherSelf{1,Turn};WholeSess_AtSwitchOtherSelf{2,Turn}],1,'omitmissing');
            plot(XAX,YAX,'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
            %% calcualte and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_OtherSelf_SwitchNum(Turn,1,:))+sum(AtSwitch_OtherSelf_SwitchNum(Turn,2,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);

            MeanAmongMonksSem = [];
            MeanAmongMonksSem = calcSEM([WholeSess_AtSwitchOtherSelf{1,Turn};WholeSess_AtSwitchOtherSelf{2,Turn}]);

            margin_of_errorAtSwitchOtherSelf = t_critical .* MeanAmongMonksSem;
            ci_lowerAtSwitchOtherSelf = YAX - margin_of_errorAtSwitchOtherSelf;
            ci_upperAtSwitchOtherSelf = YAX + margin_of_errorAtSwitchOtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) > 0
                    ci_lowerAtSwitchOtherSelf(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) > 0
                    ci_upperAtSwitchOtherSelf(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');

            % here you plot choices when monkey's partner switches from
            % own to other When monkey was first(timing applies on all trials)
            YAX = [];
            YAX = mean([WholeSess_CrossOtherSelf{1,Turn};WholeSess_CrossOtherSelf{2,Turn}],1,'omitmissing');
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
            %% calcualte and plot 95% confidence interval based on t dist SEM

            MeanAmongMonksSem = [];
            MeanAmongMonksSem = calcSEM([WholeSess_CrossOtherSelf{1,Turn};WholeSess_CrossOtherSelf{2,Turn}]);

            CrossMarginOfError_OtherSelf = t_critical .* MeanAmongMonksSem;
            Cross_ci_lowerOtherSelf = YAX - CrossMarginOfError_OtherSelf;
            Cross_ci_upperOtherSelf = YAX + CrossMarginOfError_OtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                    Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                    Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],'b', 'FaceAlpha', 0.3,'EdgeColor','none');

            % here you plot choices when monkey's partner switches from
            % own to other when monkey was first( timing applies at switch )
            YAX = [];
            YAX = mean([WholeSess_AtSwitchCrossOtherSelf{1,Turn};WholeSess_AtSwitchCrossOtherSelf{2,Turn}],1,'omitmissing');
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM


            MeanAmongMonksSem = [];
            MeanAmongMonksSem = calcSEM([WholeSess_AtSwitchCrossOtherSelf{1,Turn};WholeSess_AtSwitchCrossOtherSelf{2,Turn}]);

            CrossMarginOfError_AtSwitchOtherSelf = t_critical .* MeanAmongMonksSem;
            Cross_ci_lowerOtherSelf = YAX - CrossMarginOfError_AtSwitchOtherSelf;
            Cross_ci_upperOtherSelf = YAX + CrossMarginOfError_AtSwitchOtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                    Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                    Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');

            xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth)

            pbaspect([1 1 1])
            ylim([YlimRange(1) YlimRange(2)]);
            ylabel(Ylabel);
            ylabel(Ylabel);
            set(SP,'XTick', 6);
            set(SP,'XTickLabel', {'switch'});
            set(SP, 'XColor', 'none'); % Make x-axis invisible


            % title(strcat(sprintf(A_Name),' own to other switch'))
            title(' SIMUL, other to own')

            OveralSwitch = [];
            OveralSwitch = sum(OtherSelfSwitchNum(Turn,1,:),3)+sum(OtherSelfSwitchNum(Turn,2,:),3);
            subtitle(strcat('(Num : ',string(OveralSwitch),')'))
            % set(gca, 'XColor', 'none'); % Make x-axis invisible
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
            end




        end
        %%
        if Turn == 3
            clear SP, SP = subplot(3,2,1)
            hold on
            % here you plot choices when monkey  itself switches from own
            % to other and he was first (timing applies only at switch)
            XAX = []
            XAX = 1:BeforeAfter_Length+1+BeforeAfter_Length;
            YAX = []
            YAX = mean([WholeSess_AtSwitchSelfother{1,Turn-2};WholeSess_AtSwitchSelfother{2,Turn}],1,'omitmissing');
            plot(XAX,YAX,'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
            %% calculate and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_SelfOther_SwitchNum(Turn-2,1,:))+sum(AtSwitch_SelfOther_SwitchNum(Turn,2,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);

            MeanAmongMonksSem = []
            MeanAmongMonksSem = calcSEM([WholeSess_AtSwitchSelfother{1,Turn-2};WholeSess_AtSwitchSelfother{2,Turn}]);

            margin_of_errorAtSwitchSelfOther = t_critical .* MeanAmongMonksSem
            ci_lowerAtSwitchSelfOther = YAX - margin_of_errorAtSwitchSelfOther;
            ci_upperAtSwitchSelfOther = YAX + margin_of_errorAtSwitchSelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) > 0
                    ci_lowerAtSwitchSelfOther(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(ci_upperAtSwitchSelfOther > Valid_Max_FCO) > 0
                    ci_upperAtSwitchSelfOther(ci_upperAtSwitchSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');

            % here you plot choices when monkey's partner switches from
            % own to other When monkey was first (timing applies on all trials)
            YAX = []
            YAX = mean([WholeSess_CrossSelfOther{1,Turn};WholeSess_CrossSelfOther{2,Turn-2}],1,'omitmissing')
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
            %% calculate and plot 95% confidence interval based on t dist SEM

            MeanAmongMonksSem = []
            MeanAmongMonksSem = calcSEM([WholeSess_CrossSelfOther{1,Turn};WholeSess_CrossSelfOther{2,Turn-2}]);

            CrossMarginOfError_SelfOther = t_critical .* MeanAmongMonksSem
            Cross_ci_lowerSelfOther = YAX - CrossMarginOfError_SelfOther;
            Cross_ci_upperSelfOther = YAX + CrossMarginOfError_SelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                    Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                    Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],'b', 'FaceAlpha', 0.3,'EdgeColor','none');


            % here you plot choices when monkey's partner switches from
            % own to other when monkey was first (timing applies at switch)
            YAX = []
            YAX = mean([WholeSess_AtSwitchCrossSelfother{1,Turn};WholeSess_AtSwitchCrossSelfother{2,Turn-2}],1,'omitmissing')
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth)
            %% calculate and plot 95% confidence interval based on t dist SEM

            MeanAmongMonksSem = []
            MeanAmongMonksSem = calcSEM([WholeSess_AtSwitchCrossSelfother{1,Turn};WholeSess_AtSwitchCrossSelfother{2,Turn-2}]);

            CrossMarginOfError_AtSwitchSelfOther = t_critical .* MeanAmongMonksSem
            Cross_ci_lowerSelfOther = YAX - CrossMarginOfError_AtSwitchSelfOther;
            Cross_ci_upperSelfOther = YAX + CrossMarginOfError_AtSwitchSelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                    Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                    Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');

            xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth)

            pbaspect([1 1 1])
            ylim([YlimRange(1) YlimRange(2)]);
            set(SP,'XTick', 6);
            set(SP,'XTickLabel', {'switch'});
            set(SP, 'XColor', 'none'); % Make x-axis invisible


            % title(strcat(sprintf(A_Name),' own to other switch'))
            title(' FIRST, own to other')

            OveralSwitch = []
            OveralSwitch = sum(SelfOtherSwitchNum(Turn-2,1,:),3)+sum(SelfOtherSwitchNum(Turn,2,:),3);
            subtitle(strcat('(Num : ',string(OveralSwitch),')'));
            % set(gca, 'XColor', 'none'); % Make x-axis invisible
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
            end

            %%
            clear SP, SP = subplot(3,2,2)
            hold on
            % here you plot choices when monkey  itself switches from own
            % to other and he was first (timing applies only at switch)
            XAX = []
            XAX = 1:BeforeAfter_Length+1+BeforeAfter_Length;
            YAX = []
            YAX = mean([WholeSess_AtSwitchOtherSelf{1,Turn-2};WholeSess_AtSwitchOtherSelf{2,Turn}],1,'omitmissing');
            plot(XAX,YAX,'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth)
            %% calculate and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_OtherSelf_SwitchNum(Turn-2,1,:))+sum(AtSwitch_OtherSelf_SwitchNum(Turn,2,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);

            MeanAmongMonksSem = []
            MeanAmongMonksSem = calcSEM([WholeSess_AtSwitchOtherSelf{1,Turn-2};WholeSess_AtSwitchOtherSelf{2,Turn}]);

            margin_of_errorAtSwitchOtherSelf = t_critical .* MeanAmongMonksSem
            ci_lowerAtSwitchOtherSelf = YAX - margin_of_errorAtSwitchOtherSelf;
            ci_upperAtSwitchOtherSelf = YAX + margin_of_errorAtSwitchOtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) > 0
                    ci_lowerAtSwitchOtherSelf(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) > 0
                    ci_upperAtSwitchOtherSelf(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');

            % here you plot choices when monkey's partner switches from
            % own to other When monkey was first (timing applies on all trials)
            YAX = []
            YAX = mean([WholeSess_CrossOtherSelf{1,Turn};WholeSess_CrossOtherSelf{2,Turn-2}],1,'omitmissing')
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth)
            %% calculate and plot 95% confidence interval based on t dist SEM

            MeanAmongMonksSem = []
            MeanAmongMonksSem = calcSEM([WholeSess_CrossOtherSelf{1,Turn};WholeSess_CrossOtherSelf{2,Turn-2}]);

            CrossMarginOfError_OtherSelf = t_critical .* MeanAmongMonksSem
            Cross_ci_lowerOtherSelf = YAX - CrossMarginOfError_OtherSelf;
            Cross_ci_upperOtherSelf = YAX + CrossMarginOfError_OtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                    Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                    Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],'b', 'FaceAlpha', 0.3,'EdgeColor','none');


            % here you plot choices when monkey's partner switches from
            % own to other when monkey was first (timing applies at switch)
            YAX = []
            YAX = mean([WholeSess_AtSwitchCrossOtherSelf{1,Turn};WholeSess_AtSwitchCrossOtherSelf{2,Turn-2}],1,'omitmissing')
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,YAX,'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth)
            %% calculate and plot 95% confidence interval based on t dist SEM


            MeanAmongMonksSem = []
            MeanAmongMonksSem = calcSEM([WholeSess_AtSwitchCrossOtherSelf{1,Turn};WholeSess_AtSwitchCrossOtherSelf{2,Turn-2}]);

            CrossMarginOfError_AtSwitchOtherSelf = t_critical .* MeanAmongMonksSem;
            Cross_ci_lowerOtherSelf = YAX - CrossMarginOfError_AtSwitchOtherSelf;
            Cross_ci_upperOtherSelf = YAX + CrossMarginOfError_AtSwitchOtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                    Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                    Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');

            xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth)

            pbaspect([1 1 1])
            ylim([YlimRange(1) YlimRange(2)]);
            ylabel(Ylabel);
            ylabel(Ylabel);
            set(SP,'XTick', 6);
            set(SP,'XTickLabel', {'switch'});
            set(SP, 'XColor', 'none'); % Make x-axis invisible


            % title(strcat(sprintf(A_Name),' own to other switch'))
            title(' FIRST, other to own')

            OveralSwitch = []
            OveralSwitch = sum(OtherSelfSwitchNum(Turn-2,1,:),3)+sum(OtherSelfSwitchNum(Turn,2,:),3)
            subtitle(strcat('(Num : ',string(OveralSwitch),')'));
            % set(gca, 'XColor', 'none'); % Make x-axis invisible
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
            end



        end
    end


    % annotation('textbox',...
    %     [0.029188324670132,0.721615720524018,0.08796481407437,0.085152838427947],...
    %     'String',{'Actor B first'});
    %
    % annotation('textbox',...
    %     [0.029188324670132,0.435589519650655,0.091163534586166,0.080786026200873],...
    %     'String',{'Actor B simul'});
    %
    %
    % annotation('textbox',...
    %     [0.022790883646541,0.146288209606987,0.105557776889244,0.086689928037195],...
    %     'String',{'Actor B second'});
    CS = length(MergedData);

    filename = []
    filename = strcat(FirstSessActorA{1},'-',FirstSessActorB{1},ExtentionOfFileName,'MONKEYSaverage.pdf')
    % filenameSCABLE = strcat(FirstSessActorA{1},'-',FirstSessActorB{1},'MONKEYSaverage')

    sgtitle(strcat(FirstSessActorA{1},'-',FirstSessActorB{1},'-Sess Num: ',string(CS),' -MONKEYS average'))
    ax = gcf;
    exportgraphics(ax,sprintf(filename),'Resolution',600)

    % print(ax,sprintf(filenameSCABLE), '-dsvg','-r600');

    filename2 = [];
    filename2 = strcat(FirstSessActorA{1},'-',FirstSessActorB{1},ExtentionOfFileName,'MONKEYSaverage.jpg');
    exportgraphics(ax,sprintf(filename2),'Resolution',600);




    %% Among Sess analysis:
else
    CS = length(MergedData);
    for AC = 1 : 2
        for Turn = 1 :3
            MeanOverSessAtSwitch_MeanSelfOther(Turn,:,AC) = mean(WholeSess_AtSwitchSelfother{AC,Turn},1,'omitmissing');
            SEM_OverSessAtSwitch_SelfOther(Turn,:,AC) = calcSEM(WholeSess_AtSwitchSelfother{AC,Turn});

            CrossMeanOverSessSelfOther(Turn,:,AC) = mean(WholeSess_CrossSelfOther{AC,Turn},1,'omitmissing');
            CrossSEM_OverSess_SelfOther(Turn,:,AC) = calcSEM(WholeSess_CrossSelfOther{AC,Turn});

            CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,AC) = mean(WholeSess_AtSwitchCrossSelfother{AC,Turn},1,'omitmissing');
            CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,AC) = calcSEM(WholeSess_AtSwitchCrossSelfother{AC,Turn});

            MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,AC) = mean(WholeSess_AtSwitchOtherSelf{AC,Turn},1,'omitmissing');
            SEM_OverSessAtSwitch_OtherSelf(Turn,:,AC) = calcSEM(WholeSess_AtSwitchOtherSelf{AC,Turn});

            CrossMeanOverSessOtherSelf(Turn,:,AC) = mean(WholeSess_CrossOtherSelf{AC,Turn},1,'omitmissing');
            CrossSEM_OverSess_OtherSelf(Turn,:,AC) = calcSEM(WholeSess_CrossOtherSelf{AC,Turn});

            CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,AC) = mean(WholeSess_AtSwitchCrossOtherSelf{AC,Turn},1,'omitmissing');
            CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,AC) = calcSEM(WholeSess_AtSwitchCrossOtherSelf{AC,Turn});







        end
    end

    %%
    FigName = strcat(FirstSessActorA{1},'-',FirstSessActorB{1});
    figure('Name',sprintf(FigName), 'NumberTitle', 'off','Position',[488,49.800000000000004,500.2,732.8000000000001]);
    for Turn = 1 : 3
        if Turn == 1
            clear SP, SP = subplot(3,2,1)
            hold on
            %                 %% red curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_SelfOther_SwitchNum(Turn,1,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
            margin_of_errorAtSwitchSelfOther = t_critical .* SEM_OverSessAtSwitch_SelfOther(Turn,:,1);
            ci_lowerAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) - margin_of_errorAtSwitchSelfOther;
            ci_upperAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) + margin_of_errorAtSwitchSelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) > 0
                    ci_lowerAtSwitchSelfOther(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(ci_upperAtSwitchSelfOther > Valid_Max_FCO) > 0
                    ci_upperAtSwitchSelfOther(ci_upperAtSwitchSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');

            %                 %% blue curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessSelfOther(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_SelfOther = t_critical .* CrossSEM_OverSess_SelfOther(Turn,:,2);
            Cross_ci_lowerSelfOther = CrossMeanOverSessSelfOther(Turn,:,2) - CrossMarginOfError_SelfOther;
            Cross_ci_upperSelfOther = CrossMeanOverSessSelfOther(Turn,:,2) + CrossMarginOfError_SelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                    Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                    Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],'b', 'FaceAlpha', 0.3,'EdgeColor','none');



            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            %
            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            % %
            %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther(Turn,:,2), fliplr(Cross_ci_upperSelfOther(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
            % %                 %% pink curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2),'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_AtSwitchSelfOther = t_critical .* CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,2);
            Cross_ci_lowerSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) - CrossMarginOfError_AtSwitchSelfOther;
            Cross_ci_upperSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) + CrossMarginOfError_AtSwitchSelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                    Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                    Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);

            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
            %
            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
            %
            % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchSelfOther(Turn,:,2), fliplr(Cross_ci_upperAtSwitchSelfOther(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
            xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);

            pbaspect([1 1 1]);
            ylim([YlimRange(1) YlimRange(2)]);
            set(SP,'XTick', 6);
            set(SP,'XTickLabel', {'switch'});
            set(SP, 'XColor', 'none'); % Make x-axis invisible


            title(strcat(sprintf(FirstSessActorA{1}),' own to other'));
            OveralSwitch = [];
            OveralSwitch = sum(SelfOtherSwitchNum(Turn,1,:));
            subtitle(strcat('(Num : ',string(OveralSwitch),')'));
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
            end
            %%
            clear SP, SP = subplot(3,2,2)
            hold on
            %                 %% blue curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            DegreeFreddom =sum(AtSwitch_OtherSelf_SwitchNum(Turn,1,:))
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1)
            margin_of_errorAtSwitchOtherSelf = t_critical .* SEM_OverSessAtSwitch_OtherSelf(Turn,:,1);
            ci_lowerAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) - margin_of_errorAtSwitchOtherSelf;
            ci_upperAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) + margin_of_errorAtSwitchOtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) > 0
                    ci_lowerAtSwitchOtherSelf(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) > 0
                    ci_upperAtSwitchOtherSelf(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
            %
            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
            %
            % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerOtherSelf(Turn,:,1), fliplr(ci_upperOtherSelf(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
            %                 %% red curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessOtherSelf(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_OtherSelf = t_critical .* CrossSEM_OverSess_OtherSelf(Turn,:,2);
            Cross_ci_lowerOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,2) - CrossMarginOfError_OtherSelf;
            Cross_ci_upperOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,2) + CrossMarginOfError_OtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                    Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                    Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            %
            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSel(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            % %
            %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf(Turn,:,2), fliplr(Cross_ci_upperOtherSel(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
            %                 %% pink curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2),'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_AtSwitchOtherSelf = t_critical .* CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,2);
            Cross_ci_lowerOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) - CrossMarginOfError_AtSwitchOtherSelf;
            Cross_ci_upperOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) + CrossMarginOfError_AtSwitchOtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                    Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                    Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
            %
            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
            %
            % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2), fliplr(Cross_ci_upperAtSwitchOtherSelf(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
            xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);
            pbaspect([1 1 1]);
            ylim([YlimRange(1) YlimRange(2)]);

            ylabel(Ylabel);
            set(SP,'XTick', 6);
            set(SP,'XTickLabel', {'switch'});
            set(SP, 'XColor', 'none'); % Make x-axis invisible


            title(strcat(sprintf(FirstSessActorA{1}),' other to own'));
            OveralSwitch = [];
            OveralSwitch = sum(OtherSelfSwitchNum(Turn,1,:));
            subtitle(strcat('(Num : ',string(OveralSwitch),')'));
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
            end


        end
        %%
        if Turn == 2
            clear SP, SP = subplot(3,2,3)
            hold on
            %                 %% blue curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_SelfOther_SwitchNum(Turn,1,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
            margin_of_errorAtSwitchSelfOther = t_critical .* SEM_OverSessAtSwitch_SelfOther(Turn,:,1)
            ci_lowerAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) - margin_of_errorAtSwitchSelfOther;
            ci_upperAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) + margin_of_errorAtSwitchSelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) > 0
                    ci_lowerAtSwitchSelfOther(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(ci_upperAtSwitchSelfOther > Valid_Max_FCO) > 0
                    ci_upperAtSwitchSelfOther(ci_upperAtSwitchSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
            %
            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
            %
            %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerSelfOther(Turn,:,1), fliplr(ci_upperSelfOther(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
            % %                 %% red curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessSelfOther(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_SelfOther = t_critical .* CrossSEM_OverSess_SelfOther(Turn,:,2);
            Cross_ci_lowerSelfOther = CrossMeanOverSessSelfOther(Turn,:,2) - CrossMarginOfError_SelfOther;
            Cross_ci_upperSelfOther = CrossMeanOverSessSelfOther(Turn,:,2) + CrossMarginOfError_SelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                    Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                    Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],'b', 'FaceAlpha', 0.3,'EdgeColor','none');


            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            %
            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            % %
            %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther(Turn,:,2), fliplr(Cross_ci_upperSelfOther(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
            % %                 %% pink curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2),'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_AtSwitchSelfOther = t_critical .* CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,2);
            Cross_ci_lowerSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) - CrossMarginOfError_AtSwitchSelfOther;
            Cross_ci_upperSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) + CrossMarginOfError_AtSwitchSelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                    Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                    Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
            %
            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
            %
            % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchSelfOther(Turn,:,2), fliplr(Cross_ci_upperAtSwitchSelfOther(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
            xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth)
            pbaspect([1 1 1])
            ylim([YlimRange(1) YlimRange(2)]);
            set(SP,'XTick', 6);
            set(SP,'XTickLabel', {'switch'});
            set(SP, 'XColor', 'none'); % Make x-axis invisible


            title(strcat(sprintf(FirstSessActorA{1}),' own to other'));
            OveralSwitch = [];
            OveralSwitch = sum(SelfOtherSwitchNum(Turn,1,:));
            subtitle(strcat('(Num : ',string(OveralSwitch),')'));
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
            end
            %%
            clear SP, SP = subplot(3,2,4)
            hold on
            %                 %% blue curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_OtherSelf_SwitchNum(Turn,1,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
            margin_of_errorAtSwitchOtherSelf = t_critical .* SEM_OverSessAtSwitch_OtherSelf(Turn,:,1)
            ci_lowerAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) - margin_of_errorAtSwitchOtherSelf;
            ci_upperAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) + margin_of_errorAtSwitchOtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) > 0
                    ci_lowerAtSwitchOtherSelf(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) > 0
                    ci_upperAtSwitchOtherSelf(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
            %
            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
            %
            % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerOtherSelf(Turn,:,1), fliplr(ci_upperOtherSelf(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
            %                 %% red curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessOtherSelf(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_OtherSelf = t_critical .* CrossSEM_OverSess_OtherSelf(Turn,:,2);
            Cross_ci_lowerOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,2) - CrossMarginOfError_OtherSelf;
            Cross_ci_upperOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,2) + CrossMarginOfError_OtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                    Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                    Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');



            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            %
            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSel(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            % %
            %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf(Turn,:,2), fliplr(Cross_ci_upperOtherSel(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
            %                 %% pink curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2),'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_AtSwitchOtherSelf = t_critical .*CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,2)
            Cross_ci_lowerOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) - CrossMarginOfError_AtSwitchOtherSelf;
            Cross_ci_upperOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) + CrossMarginOfError_AtSwitchOtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                    Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                    Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
            %
            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
            %
            % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2), fliplr(Cross_ci_upperAtSwitchOtherSelf(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
            xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);
            pbaspect([1 1 1]);
            ylim([YlimRange(1) YlimRange(2)]);
            ylabel(Ylabel);
            set(SP,'XTick', 6);
            set(SP,'XTickLabel', {'switch'});
            set(SP, 'XColor', 'none'); % Make x-axis invisible


            title(strcat(sprintf(FirstSessActorA{1}),' other to own'));
            OveralSwitch = []
            OveralSwitch = sum(OtherSelfSwitchNum(Turn,1,:));
            subtitle(strcat('(Num : ',string(OveralSwitch),')'));
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
            end



        end
        %%
        if Turn == 3
            clear SP, SP = subplot(3,2,5)
            hold on
            %                 %% blue curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_SelfOther_SwitchNum(Turn,1,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
            margin_of_errorAtSwitchSelfOther = t_critical .* SEM_OverSessAtSwitch_SelfOther(Turn,:,1);
            ci_lowerAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) - margin_of_errorAtSwitchSelfOther;
            ci_upperAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) + margin_of_errorAtSwitchSelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) > 0
                    ci_lowerAtSwitchSelfOther(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(ci_upperAtSwitchSelfOther > Valid_Max_FCO) > 0
                    ci_upperAtSwitchSelfOther(ci_upperAtSwitchSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');



            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
            %
            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
            %
            %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerSelfOther(Turn,:,1), fliplr(ci_upperSelfOther(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
            % %                 %% red curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessSelfOther(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_SelfOther = t_critical .* CrossSEM_OverSess_SelfOther(Turn,:,2);
            Cross_ci_lowerSelfOther = CrossMeanOverSessSelfOther(Turn,:,2) - CrossMarginOfError_SelfOther;
            Cross_ci_upperSelfOther = CrossMeanOverSessSelfOther(Turn,:,2) + CrossMarginOfError_SelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                    Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                    Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],'b', 'FaceAlpha', 0.3,'EdgeColor','none');

            %
            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            %
            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            % %
            %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther(Turn,:,2), fliplr(Cross_ci_upperSelfOther(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
            %                 %% pink curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2),'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth)
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_AtSwitchSelfOther = t_critical .* CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,2);
            Cross_ci_lowerSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) - CrossMarginOfError_AtSwitchSelfOther;
            Cross_ci_upperSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) + CrossMarginOfError_AtSwitchSelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                    Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                    Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');

            %
            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
            %
            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
            %
            % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchSelfOther(Turn,:,2), fliplr(Cross_ci_upperAtSwitchSelfOther(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
            xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);
            pbaspect([1 1 1]);
            ylim([YlimRange(1) YlimRange(2)]);
            set(SP,'XTick', 6);
            set(SP,'XTickLabel', {'switch'});
            % set(SP, 'XColor', 'none'); % Make x-axis invisible


            title(strcat(sprintf(FirstSessActorA{1}),' own to other'));
            OveralSwitch = [];
            OveralSwitch = sum(SelfOtherSwitchNum(Turn,1,:));
            subtitle(strcat('(Num : ',string(OveralSwitch),')'));
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
                H = findobj(gca);
                set(H,'XTick', 0.5);
                set(H,'XTickLabel', {'switch'});

            end
            %%
            clear SP, SP = subplot(3,2,6)
            hold on
            %                 %% blue curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_OtherSelf_SwitchNum(Turn,1,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
            margin_of_errorAtSwitchOtherSelf = t_critical .* SEM_OverSessAtSwitch_OtherSelf(Turn,:,1);
            ci_lowerAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) - margin_of_errorAtSwitchOtherSelf;
            ci_upperAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) + margin_of_errorAtSwitchOtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) > 0
                    ci_lowerAtSwitchOtherSelf(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) > 0
                    ci_upperAtSwitchOtherSelf(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
            %
            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
            %
            % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerOtherSelf(Turn,:,1), fliplr(ci_upperOtherSelf(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
            %                 %% red curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessOtherSelf(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_OtherSelf = t_critical .*CrossSEM_OverSess_OtherSelf(Turn,:,2);
            Cross_ci_lowerOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,2) - CrossMarginOfError_OtherSelf;
            Cross_ci_upperOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,2) + CrossMarginOfError_OtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                    Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                    Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],'b', 'FaceAlpha', 0.3,'EdgeColor','none');


            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            %
            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSel(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            % %
            %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf(Turn,:,2), fliplr(Cross_ci_upperOtherSel(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
            %                 %% pink curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2),'o-','Color',ActorBAtSwitchCol,'MarkerFaceColor',ActorBAtSwitchCol,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_AtSwitchOtherSelf = t_critical .* CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,2);
            Cross_ci_lowerOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) - CrossMarginOfError_AtSwitchOtherSelf;
            Cross_ci_upperOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) + CrossMarginOfError_AtSwitchOtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                    Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                    Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorBAtSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
            %
            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
            %
            % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2), fliplr(Cross_ci_upperAtSwitchOtherSelf(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
            xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);
            pbaspect([1 1 1]);
            ylim([YlimRange(1) YlimRange(2)]);
            ylabel(Ylabel);
            set(SP,'XTick', 6);
            set(SP,'XTickLabel', {'switch'});
            % set(SP, 'XColor', 'none'); % Make x-axis invisible


            title(strcat(sprintf(FirstSessActorA{1}),' other to own'));
            OveralSwitch = [];
            OveralSwitch = sum(OtherSelfSwitchNum(Turn,1,:));
            subtitle(strcat('Switch Num: ',string(OveralSwitch)));
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
            end


        end
    end
    annotation('textbox',...
        [0.00679728108756502 0.718340611353712 0.123150739704118 0.103711790393013],...
        'String',{'subject first, switcher second'},...
        'FitBoxToText','off',...
        'EdgeColor','none');

    annotation('textbox',...
        [0.0259896041583367 0.460698689956332 0.0911635345861662 0.031659388646288],...
        'String','simul',...
        'FitBoxToText','off',...
        'EdgeColor','none');

    annotation('textbox',...
        [0.00519792083166733 0.137554585152838 0.116753298680528 0.107432286115798],...
        'String',{'subject','second,','switcher','first'},...
        'FitBoxToText','off',...
        'EdgeColor','none');








    filename = [];
    filename = strcat(FirstSessActorA{1},'-',FirstSessActorB{1},ExtentionOfFileName,'.pdf');
    sgtitle(strcat(FirstSessActorA{1},'-',FirstSessActorB{1},'-Sess Num: ',string(CS)));
    ax = gcf;
    exportgraphics(ax,sprintf(filename),'Resolution',600);

    filename2 = [];
    filename2 = strcat(FirstSessActorA{1},'-',FirstSessActorB{1},ExtentionOfFileName,'.jpg');
    exportgraphics(ax,sprintf(filename2),'Resolution',600);



    %% other player switches
    %% other player switches
    FigName = strcat(FirstSessActorA{1},'-Bswitch-',FirstSessActorB{1});
    figure('Name',sprintf(FigName), 'NumberTitle', 'off','Position',[488,49.800000000000004,500.2,732.8000000000001]);
    for Turn = 1 : 3
        if Turn == 1
            clear SP, SP = subplot(3,2,1)
            hold on
            %                 %% red curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_SelfOther_SwitchNum(Turn,2,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
            margin_of_errorAtSwitchSelfOther = t_critical .* SEM_OverSessAtSwitch_SelfOther(Turn,:,2);
            ci_lowerAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) - margin_of_errorAtSwitchSelfOther;
            ci_upperAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) + margin_of_errorAtSwitchSelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) > 0
                    ci_lowerAtSwitchSelfOther(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(ci_upperAtSwitchSelfOther > Valid_Max_FCO) > 0
                    ci_upperAtSwitchSelfOther(ci_upperAtSwitchSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');

            %                 %% blue curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessSelfOther(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_SelfOther = t_critical .* CrossSEM_OverSess_SelfOther(Turn,:,1);
            Cross_ci_lowerSelfOther = CrossMeanOverSessSelfOther(Turn,:,1) - CrossMarginOfError_SelfOther;
            Cross_ci_upperSelfOther = CrossMeanOverSessSelfOther(Turn,:,1) + CrossMarginOfError_SelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                    Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                    Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');



            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            %
            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            % %
            %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther(Turn,:,2), fliplr(Cross_ci_upperSelfOther(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
            % %                 %% pink curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1),'o-','Color',ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_AtSwitchSelfOther = t_critical .* CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,1);
            Cross_ci_lowerSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) - CrossMarginOfError_AtSwitchSelfOther;
            Cross_ci_upperSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) + CrossMarginOfError_AtSwitchSelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                    Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                    Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorAatSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');

            xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);
            pbaspect([1 1 1]);
            ylim([YlimRange(1) YlimRange(2)]);
            set(SP,'XTick', 6);
            set(SP,'XTickLabel', {'switch'});
            set(SP, 'XColor', 'none'); % Make x-axis invisible


            title(strcat(sprintf(FirstSessActorB{1}),' own to other'));
            OveralSwitch = [];
            OveralSwitch = sum(SelfOtherSwitchNum(Turn,2,:));
            subtitle(strcat('(Num : ',string(OveralSwitch),')'));
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
            end
            %%
            clear SP, SP = subplot(3,2,2)
            hold on
            %                 %% blue curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_OtherSelf_SwitchNum(Turn,2,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
            margin_of_errorAtSwitchOtherSelf = t_critical .* SEM_OverSessAtSwitch_OtherSelf(Turn,:,2)
            ci_lowerAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) - margin_of_errorAtSwitchOtherSelf;
            ci_upperAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) + margin_of_errorAtSwitchOtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) > 0
                    ci_lowerAtSwitchOtherSelf(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) > 0
                    ci_upperAtSwitchOtherSelf(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
            %
            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
            %
            % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerOtherSelf(Turn,:,1), fliplr(ci_upperOtherSelf(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
            %                 %% red curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessOtherSelf(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_OtherSelf = t_critical .* CrossSEM_OverSess_OtherSelf(Turn,:,1);
            Cross_ci_lowerOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,1) - CrossMarginOfError_OtherSelf;
            Cross_ci_upperOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,1) + CrossMarginOfError_OtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                    Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                    Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth)
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            %
            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSel(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            % %
            %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf(Turn,:,2), fliplr(Cross_ci_upperOtherSel(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
            %                 %% pink curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1),'o-','Color',ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_AtSwitchOtherSelf = t_critical .* CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,1);
            Cross_ci_lowerOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) - CrossMarginOfError_AtSwitchOtherSelf;
            Cross_ci_upperOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) + CrossMarginOfError_AtSwitchOtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                    Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                    Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorAatSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');
            xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);
            pbaspect([1 1 1]);
            ylim([YlimRange(1) YlimRange(2)]);
            ylabel(Ylabel);
            set(SP,'XTick', 6);
            set(SP,'XTickLabel', {'switch'});
            set(SP, 'XColor', 'none'); % Make x-axis invisible


            title(strcat(sprintf(FirstSessActorB{1}),' other to own'));
            OveralSwitch = [];
            OveralSwitch = sum(OtherSelfSwitchNum(Turn,2,:));
            subtitle(strcat('(Num : ',string(OveralSwitch),')'));
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
            end

        end
        %%
        if Turn == 2
            clear SP, SP = subplot(3,2,3)
            hold on
            %                 %% blue curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_SelfOther_SwitchNum(Turn,2,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
            margin_of_errorAtSwitchSelfOther = t_critical .* SEM_OverSessAtSwitch_SelfOther(Turn,:,2);
            ci_lowerAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) - margin_of_errorAtSwitchSelfOther;
            ci_upperAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) + margin_of_errorAtSwitchSelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) > 0
                    ci_lowerAtSwitchSelfOther(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(ci_upperAtSwitchSelfOther > Valid_Max_FCO) > 0
                    ci_upperAtSwitchSelfOther(ci_upperAtSwitchSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
            %
            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
            %
            %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerSelfOther(Turn,:,1), fliplr(ci_upperSelfOther(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
            % %                 %% red curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessSelfOther(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_SelfOther = t_critical .* CrossSEM_OverSess_SelfOther(Turn,:,1);
            Cross_ci_lowerSelfOther = CrossMeanOverSessSelfOther(Turn,:,1) - CrossMarginOfError_SelfOther;
            Cross_ci_upperSelfOther = CrossMeanOverSessSelfOther(Turn,:,1) + CrossMarginOfError_SelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                    Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                    Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            %
            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            % %
            %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther(Turn,:,2), fliplr(Cross_ci_upperSelfOther(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
            % %                 %% pink curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1),'o-','Color',ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_AtSwitchSelfOther = t_critical .* CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,1);
            Cross_ci_lowerSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) - CrossMarginOfError_AtSwitchSelfOther;
            Cross_ci_upperSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) + CrossMarginOfError_AtSwitchSelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                    Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                    Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorAatSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
            %
            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchSelfOther(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
            %
            % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchSelfOther(Turn,:,2), fliplr(Cross_ci_upperAtSwitchSelfOther(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
            xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);
            pbaspect([1 1 1]);
            ylim([YlimRange(1) YlimRange(2)]);
            set(SP,'XTick', 6);
            set(SP,'XTickLabel', {'switch'});
            set(SP, 'XColor', 'none'); % Make x-axis invisible


            title(strcat(sprintf(FirstSessActorB{1}),' own to other'));
            OveralSwitch = []
            OveralSwitch = sum(SelfOtherSwitchNum(Turn,2,:));
            subtitle(strcat('(Num : ',string(OveralSwitch),')'));
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
            end
            %%
            clear SP, SP = subplot(3,2,4)
            hold on
            %                 %% blue curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_OtherSelf_SwitchNum(Turn,2,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
            margin_of_errorAtSwitchOtherSelf = t_critical .* SEM_OverSessAtSwitch_OtherSelf(Turn,:,2);
            ci_lowerAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) - margin_of_errorAtSwitchOtherSelf;
            ci_upperAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) + margin_of_errorAtSwitchOtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) > 0
                    ci_lowerAtSwitchOtherSelf(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) > 0
                    ci_upperAtSwitchOtherSelf(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
            %
            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
            %
            % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerOtherSelf(Turn,:,1), fliplr(ci_upperOtherSelf(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
            %                 %% red curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessOtherSelf(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_OtherSelf = t_critical .* CrossSEM_OverSess_OtherSelf(Turn,:,1);
            Cross_ci_lowerOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,1) - CrossMarginOfError_OtherSelf;
            Cross_ci_upperOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,1) + CrossMarginOfError_OtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                    Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                    Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');



            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            %
            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSel(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            % %
            %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf(Turn,:,2), fliplr(Cross_ci_upperOtherSel(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
            %                 %% pink curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1),'o-','Color',ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_AtSwitchOtherSelf = t_critical .* CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,1)
            Cross_ci_lowerOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) - CrossMarginOfError_AtSwitchOtherSelf;
            Cross_ci_upperOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) + CrossMarginOfError_AtSwitchOtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                    Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                    Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorAatSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');
            xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);
            pbaspect([1 1 1]);
            ylim([YlimRange(1) YlimRange(2)]);
            ylabel(Ylabel);
            set(SP,'XTick', 6);
            set(SP,'XTickLabel', {'switch'});
            set(SP, 'XColor', 'none'); % Make x-axis invisible


            title(strcat(sprintf(FirstSessActorB{1}),' other to own'));
            OveralSwitch = [];
            OveralSwitch = sum(OtherSelfSwitchNum(Turn,2,:));
            subtitle(strcat('(Num : ',string(OveralSwitch),')'));
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
            end


        end
        %%
        if Turn == 3
            clear SP, SP = subplot(3,2,5)
            hold on
            %                 %% blue curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_SelfOther_SwitchNum(Turn,2,:))
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
            margin_of_errorAtSwitchSelfOther = t_critical .* SEM_OverSessAtSwitch_SelfOther(Turn,:,2);
            ci_lowerAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) - margin_of_errorAtSwitchSelfOther;
            ci_upperAtSwitchSelfOther = MeanOverSessAtSwitch_MeanSelfOther(Turn,:,2) + margin_of_errorAtSwitchSelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) > 0
                    ci_lowerAtSwitchSelfOther(ci_lowerAtSwitchSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(ci_upperAtSwitchSelfOther > Valid_Max_FCO) > 0
                    ci_upperAtSwitchSelfOther(ci_upperAtSwitchSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchSelfOther, fliplr(ci_upperAtSwitchSelfOther)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');



            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
            %
            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperSelfOther(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
            %
            %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerSelfOther(Turn,:,1), fliplr(ci_upperSelfOther(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
            % %                 %% red curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessSelfOther(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_SelfOther = t_critical .* CrossSEM_OverSess_SelfOther(Turn,:,1);
            Cross_ci_lowerSelfOther = CrossMeanOverSessSelfOther(Turn,:,1) - CrossMarginOfError_SelfOther;
            Cross_ci_upperSelfOther = CrossMeanOverSessSelfOther(Turn,:,1) + CrossMarginOfError_SelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                    Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                    Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');

            %
            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            %
            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            % %
            %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther(Turn,:,2), fliplr(Cross_ci_upperSelfOther(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
            %                 %% pink curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1),'o-','Color',ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_AtSwitchSelfOther = t_critical .* CrossAtSwitch_SEM_OverSess_SelfOther(Turn,:,1);
            Cross_ci_lowerSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) - CrossMarginOfError_AtSwitchSelfOther;
            Cross_ci_upperSelfOther = CrossMeanOverSessAtSwitch_MeanSelfOther(Turn,:,1) + CrossMarginOfError_AtSwitchSelfOther;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerSelfOther < Valid_Min_FCO) > 0
                    Cross_ci_lowerSelfOther(Cross_ci_lowerSelfOther < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if sum(Cross_ci_upperSelfOther > Valid_Max_FCO)> 0
                    Cross_ci_upperSelfOther(Cross_ci_upperSelfOther > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperSelfOther,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerSelfOther, fliplr(Cross_ci_upperSelfOther)],ActorAatSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');

            xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);
            pbaspect([1 1 1]);
            ylim([YlimRange(1) YlimRange(2)]);
            set(SP,'XTick', 6);
            set(SP,'XTickLabel', {'switch'});
            % set(SP, 'XColor', 'none'); % Make x-axis invisible


            title(strcat(sprintf(FirstSessActorB{1}),' own to other'));
            OveralSwitch = [];
            OveralSwitch = sum(SelfOtherSwitchNum(Turn,2,:));
            subtitle(strcat('(Num : ',string(OveralSwitch),')'));
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
                H = findobj(gca);
                set(H,'XTick', 0.5);
                set(H,'XTickLabel', {'switch'});

            end
            %%
            %%
            clear SP, SP = subplot(3,2,6)
            hold on
            %                 %% blue curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2),'o-','Color',ActorBcolor,'MarkerFaceColor',ActorBcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            DegreeFreddom = sum(AtSwitch_OtherSelf_SwitchNum(Turn,2,:));
            t_critical = tinv(1 - alpha/2, DegreeFreddom - 1);
            margin_of_errorAtSwitchOtherSelf = t_critical .* SEM_OverSessAtSwitch_OtherSelf(Turn,:,2);
            ci_lowerAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) - margin_of_errorAtSwitchOtherSelf;
            ci_upperAtSwitchOtherSelf = MeanOverSessAtSwitch_MeanOtherSelf(Turn,:,2) + margin_of_errorAtSwitchOtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) > 0
                    ci_lowerAtSwitchOtherSelf(ci_lowerAtSwitchOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) > 0
                    ci_upperAtSwitchOtherSelf(ci_upperAtSwitchOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperAtSwitchOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerAtSwitchOtherSelf, fliplr(ci_upperAtSwitchOtherSelf)],ActorBcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_lowerOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
            %
            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,ci_upperOtherSelf(Turn,:,1),'-b','LineWidth',CI_Lines_LineWidth)
            %
            % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [ci_lowerOtherSelf(Turn,:,1), fliplr(ci_upperOtherSelf(Turn,:,1))],'b', 'FaceAlpha', 0.3,'EdgeColor','none');
            %                 %% red curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessOtherSelf(Turn,:,1),'o-','Color',ActorAcolor,'MarkerFaceColor',ActorAcolor,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_OtherSelf = t_critical .* CrossSEM_OverSess_OtherSelf(Turn,:,1);
            Cross_ci_lowerOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,1) - CrossMarginOfError_OtherSelf;
            Cross_ci_upperOtherSelf = CrossMeanOverSessOtherSelf(Turn,:,1) + CrossMarginOfError_OtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                    Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                    Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorAcolor, 'FaceAlpha', 0.3,'EdgeColor','none');


            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            %
            %                  plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSel(Turn,:,2),'-r','LineWidth',CI_Lines_LineWidth)
            % %
            %                  fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf(Turn,:,2), fliplr(Cross_ci_upperOtherSel(Turn,:,2))],'r', 'FaceAlpha', 0.3,'EdgeColor','none');
            %                 %% pink curve
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1),'o-','Color',ActorAatSwitchCol,'MarkerFaceColor',ActorAatSwitchCol,'LineWidth',MainLineWidth);
            %% calcualte and plot 95% confidence interval based on t dist SEM
            CrossMarginOfError_AtSwitchOtherSelf = t_critical .* CrossAtSwitch_SEM_OverSess_OtherSelf(Turn,:,1);
            Cross_ci_lowerOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) - CrossMarginOfError_AtSwitchOtherSelf;
            Cross_ci_upperOtherSelf = CrossMeanOverSessAtSwitch_MeanOtherSelf(Turn,:,1) + CrossMarginOfError_AtSwitchOtherSelf;

            %here you make sure if upper CI is more than 1 and lowe CI
            %is less than 0, it is clipped before plotting
            if contains(WhatOnYaxis,'ChoiceDynamic')
                if  sum(Cross_ci_lowerOtherSelf < Valid_Min_FCO) > 0
                    Cross_ci_lowerOtherSelf(Cross_ci_lowerOtherSelf < Valid_Min_FCO) = Valid_Min_FCO;
                end

                if  sum(Cross_ci_upperOtherSelf > Valid_Max_FCO) > 0
                    Cross_ci_upperOtherSelf(Cross_ci_upperOtherSelf > Valid_Max_FCO) = Valid_Max_FCO;
                end
            end

            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperOtherSelf,'-','Color',CI_LINE_Color,'LineWidth',CI_Lines_LineWidth);
            fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerOtherSelf, fliplr(Cross_ci_upperOtherSelf)],ActorAatSwitchCol, 'FaceAlpha', 0.3,'EdgeColor','none');


            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
            %
            % plot(1:BeforeAfter_Length+1+BeforeAfter_Length,Cross_ci_upperAtSwitchOtherSelf(Turn,:,2),'-m','LineWidth',CI_Lines_LineWidth)
            %
            % fill([1:BeforeAfter_Length+1+BeforeAfter_Length, fliplr(1:BeforeAfter_Length+1+BeforeAfter_Length)], [Cross_ci_lowerAtSwitchOtherSelf(Turn,:,2), fliplr(Cross_ci_upperAtSwitchOtherSelf(Turn,:,2))],'m', 'FaceAlpha', 0.3,'EdgeColor','none');
            xline(BeforeAfter_Length+1,'--','LineWidth',DashedLine_LineWidth);
            pbaspect([1 1 1]);
            ylim([YlimRange(1) YlimRange(2)]);
            ylabel(Ylabel);
            set(SP,'XTick', 6);
            set(SP,'XTickLabel', {'switch'});
            % set(SP, 'XColor', 'none'); % Make x-axis invisible


            OveralSwitch = [];
            OveralSwitch = sum(OtherSelfSwitchNum(Turn,2,:));
            subtitle(strcat('(Num : ',string(OveralSwitch),')'));
            title(strcat(sprintf(FirstSessActorB{1}),' other to own'));
            if OveralSwitch == 0
                % Find and delete all lines
                hPlots = findobj(gca, 'Type', 'line');

                % Find and delete all xlines (ConstantLine objects)
                hXLines = findobj(gca, 'Type', 'ConstantLine');

                % Find and delete all shaded areas (patch objects)
                hPatches = findobj(gca, 'Type', 'patch');

                % Delete all found objects
                delete([hPlots; hXLines; hPatches]);
                H = findobj(gca);
                set(H,'XTick', 0.5);
                set(H,'XTickLabel', {'switch'});

            end


        end
    end
    annotation('textbox',...
        [0.00439824070371872 0.697598253275111 0.12155137944822 0.118995633187773],...
        'String',{'subject second, switcher first'},...
        'FitBoxToText','off',...
        'EdgeColor','none');

    annotation('textbox',...
        [0.0259896041583367 0.457423580786026 0.0911635345861659 0.0349344978165935],...
        'String',{'simul'},...
        'FitBoxToText','off',...
        'EdgeColor','none');


    annotation('textbox',...
        [0.00519792083166695 0.152838427947598 0.119952019192323 0.106340583059029],...
        'string',{'subject','first,','switcher','second'},...
        'FitBoxToText','off',...
        'EdgeColor','none');




    filename = [];
    filename = strcat(FirstSessActorA{1},'-',FirstSessActorB{1},ExtentionOfFileName,'SwitchB.pdf');
    sgtitle(strcat(FirstSessActorA{1},'-',FirstSessActorB{1},'SwitchB-Sess Num: ',string(CS)));
    ax = gcf;
    exportgraphics(ax,sprintf(filename),'Resolution',600);

    filename2 = [];
    filename2 = strcat(FirstSessActorA{1},'-',FirstSessActorB{1},ExtentionOfFileName,'SwitchB.jpg');
    exportgraphics(ax,sprintf(filename2),'Resolution',600);




end