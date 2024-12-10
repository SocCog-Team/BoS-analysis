base_path = '\\172.16.9.188\snd\taskcontroller\SCP_DATA\SCP-CTRL-01\SESSIONLOGS\';
Year = '2023';   

Sessions = {'20230623T124557B.A_Curius.B_Elmo.SCP_01.triallog.v017.mat'}


  %'20230630T115937.A_Curius.B_Elmo.SCP_01.triallog.v017.mat';  Only Dyadic
  %for Elmo, for Curius is Dyadic and SoloArewardedAB, so Elmo was passive
  %observor and passive reciever of the reward


  %'20230704T130229.A_Curius.B_Elmo.SCP_01.triallog.v017.mat' number of
  %hitted trials in SoloB iz zero

  %'20230707T102457.A_Curius.B_Elmo.SCP_01.triallog.v017.mat'; Only Dyadic
  %for Elmo, for Curius is Dyadic and SoloArewardedAB


  for s = 1 : numel(Sessions)
    foldername = strcat(extractBefore(Sessions{s},'triallog'),'sessiondir');
    monthName = extractBetween(foldername,'20','T');
    ElmoB_Monkey2023EphysFullSessionPath{s} = strcat(base_path,Year,'\',monthName,'\',foldername,'\',Sessions{s});
 end
clear base_path
clear Year
 