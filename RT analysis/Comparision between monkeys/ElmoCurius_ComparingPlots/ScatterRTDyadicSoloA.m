close all, clear,clc

load Curius_RTDyadic.mat
load Curius_RTSolo.mat
load ELMO_DyadicRT.mat
load ELMO_SoloART.mat

figure;
subplot(1,2,1)
for Timing = 1 : 3
    ElmoSZ = corrcoef(ElmoMean_RTSoloA_SoloADyadicSessions(Timing,:),ElmoMean_RTDyadic_SoloADyadicSessions(Timing,:));
    ElmoSZ_EACH = (ElmoSZ(2)*100);
    Elmosz_each(Timing) = ElmoSZ(2);
    if Timing == 1
       C = [102 0 204]./255;
    end
    if Timing == 2
       C = [255 51 255]./255;
    end
    if Timing == 3
       C = [255 153 204]./255;
    end
    scatter(ElmoMean_RTSoloA_SoloADyadicSessions(:,Timing),ElmoMean_RTDyadic_SoloADyadicSessions(:,Timing),ElmoSZ_EACH,C,'filled')
    hold on
end

plot(250:800,250:800,'--','color',[0.5 0.5 0.5])
legend('first','simult','second','criterion line: x = y','Position',[0.624166662511372 0.140555551922511 0.265357147012438 0.165476194109235])
title('Elmo')
subtitle('Pearson coef: first = 0.45, simul = 0.49, second = 0.57')
xlabel('RT in SoloA condition among sessions with SoloA and Dyadic,(ms)')
ylabel('RT in Dyadic condition among sessions with SoloA and Dyadic,(ms)')
%% Curius
subplot(1,2,2)
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
title('Curius')
subtitle('Pearson coef: first = 0.77, simul = 0.33, second = 0.71')
xlabel('RT in SoloA condition among sessions with SoloA and Dyadic,(ms)')
% ylabel('RT in Dyadic condition among sessions with SoloA and Dyadic,(ms)')





