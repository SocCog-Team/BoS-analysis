base_path = '\\172.16.9.188\snd\taskcontroller\SCP_DATA\SCP-CTRL-01\SESSIONLOGS\';
Year = '2023';                                                   

Sessions = {'20230524T141900.A_None.B_Elmo.SCP_01.triallog.v017.mat'

  '20230525T142609.A_None.B_Elmo.SCP_01.triallog.v017.mat'

  '20230606T150341.A_None.B_Elmo.SCP_01.triallog.v017.mat'

  '20230607T152146.A_None.B_Elmo.SCP_01.triallog.v017.mat'

  '20230608T141913.A_None.B_Elmo.SCP_01.triallog.v017.mat'

  '20230609T134845.A_None.B_Elmo.SCP_01.triallog.v017.mat'

  '20230612T155358.A_None.B_Elmo.SCP_01.triallog.v017.mat'

  '20230613T161556.A_MK.B_Elmo.SCP_01.triallog.v017.mat'

  '20230614T160832.A_MK.B_Elmo.SCP_01.triallog.v017.mat'

  '20230615T170548.A_None.B_Elmo.SCP_01.triallog.v017.mat'

  '20230619T151413.A_None.B_Elmo.SCP_01.triallog.v017.mat'

  '20230620T142144.A_MK.B_Elmo.SCP_01.triallog.v017.mat'

  '20230621T141449.A_MK.B_Elmo.SCP_01.triallog.v017.mat'

  '20230622T155406.A_MK.B_Elmo.SCP_01.triallog.v017.mat'

  '20230623T124557.A_Curius.B_Elmo.SCP_01.triallog.v017.mat'

  '20230626T162258.A_None.B_Elmo.SCP_01.triallog.v017.mat'

  '20230627T165641.A_MK.B_Elmo.SCP_01.triallog.v017.mat'

  '20230628T144009.A_MK.B_Elmo.SCP_01.triallog.v017.mat'

  '20230629T152509.A_MK.B_Elmo.SCP_01.triallog.v017.mat'

  '20230630T115937.A_Curius.B_Elmo.SCP_01.triallog.v017.mat'

  '20230703T164353.A_MK.B_Elmo.SCP_01.triallog.v017.mat'

  '20230704T130229.A_Curius.B_Elmo.SCP_01.triallog.v017.mat'

  '20230707T102457.A_Curius.B_Elmo.SCP_01.triallog.v017.mat'};

for s = 1 : numel(Sessions)
    foldername = strcat(extractBefore(Sessions{s},'triallog'),'sessiondir');
    monthName = extractBetween(foldername,'20','T');
    FullSessionPath{s} = strcat(base_path,Year,'\',monthName,'\',foldername,'\',Sessions{s})
end
clearvars -except FullSessionPath
%% attention:  use load(char(FullSessionPath{s})) to go through each directory
