
base_path = '\\172.16.9.188\snd\taskcontroller\SCP_DATA\SCP-CTRL-01\SESSIONLOGS\';
Year = '2021';   

Sessions = {'20210901T123203.A_Elmo.B_Curius.SCP_01.triallog.v017.mat'} %Only Dyadic




  for s = 1 : numel(Sessions)
    foldername = strcat(extractBefore(Sessions{s},'triallog'),'sessiondir');
    monthName = extractBetween(foldername,'20','T');
    ElmoA_Monkey2021EphysFullSessionPath{s} = strcat(base_path,Year,'\',monthName,'\',foldername,'\',Sessions{s});
 end
clear base_path
clear Year
 
