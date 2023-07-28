%% Functionality of this function is to create a spectrum of one color for plotting
%% This function creates a tonality for the main colour you feed it with.
%% For example if you want to make a tonality of lavender colour toward black,
%% just feed the function with: MainColor = [127 0 255]./255
%% and if the number of your data points is 100, TonalityNumber = 100
%% run this code to see the result:
% Given data:
% x = 1:100;
% y = 1:100;
% MainColor = [127 0 255]./255  %% for more RGB codes, go to:
% https://www.rapidtables.com/web/color/RGB_Color.html
% TonalityNumber = 100
% BeautifulColorVector = TonalityMaker(MainColor,TonalityNumber)
% ScatterPlot = @(i) scatter(x(i),y(i),200,'filled','MarkerFaceColor',BeautifulColorVector(i,:)), hold on
% arrayfun(ScatterPlot,1:length(x))
function BeautifulColorVector = TonalityMaker(MainColor,TonalityNumber)
ToBeAdded = MainColor./(TonalityNumber);
BeautifulColorVector = zeros(TonalityNumber,3);
for CL = 1 : TonalityNumber
    BeautifulColorVector(CL,:) = MainColor-(CL*(ToBeAdded));
end
for CHECK = 1 : TonalityNumber
    if sum(BeautifulColorVector(CL,:)) == 0
       BeautifulColorVector(CL,:) =  BeautifulColorVector(CL,:)+0.07;
    end
    if sum(BeautifulColorVector(CL,:)) == 3
       BeautifulColorVector(CL,:) =  BeautifulColorVector(CL,:)-0.07;
    end
end
