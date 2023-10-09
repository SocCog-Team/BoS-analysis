base_path = '\\172.16.9.188\snd\taskcontroller\SCP_DATA\SCP-CTRL-01\SESSIONLOGS\';
Year = '2023';                                                   

Sessions = {%'20230112T161349.A_Curius.B_SM.SCP_01.triallog.v017.mat' %Elmo is A and
%No hit trials, Only  Dyadic


  %'20230512T125943.A_Curius.B_SM.SCP_01.triallog.v017.mat' Only SoloB
 % with 10 trials , 2) No Ephys


 % '20230515T134959.A_Curius.B_None.SCP_01.triallog.v017.mat' Only SoloB
 % with 10 trials , 2) No Ephys



 %'20230516T133503.A_Curius.B_RB.SCP_01.triallog.v017.mat' Only Dyadic
 %  , 2) No Ephys

 %'20230517T130621.A_Curius.B_RB.SCP_01.triallog.v017.mat' Only SoloB
 % Dyadic has only 2 trial , 2) No Ephys



 %'20230518T135808.A_Curius.B_SM.SCP_01.triallog.v017.mat' Only SoloB
 % Dyadic has only 1 trial , 2) No Ephys


 %'20230522T133212.A_Curius.B_None.SCP_01.triallog.v017.mat' 1) Only SoloB
 %  , 2) No Ephys


 %'20230523T145755.A_Curius.B_SM.SCP_01.triallog.v017.mat' 1) Only SoloB
 %  , 2) No Ephys



 %'20230524T141900.A_None.B_Elmo.SCP_01.triallog.v017.mat' 1) Only SoloB
 % Dyadic has only 1 trial , 2) No Ephys



 %'20230525T142609.A_None.B_Elmo.SCP_01.triallog.v017.mat' 1) Only Dyadic
 %with 1 hit, 2) No Ephys


 %'20230606T150341.A_None.B_Elmo.SCP_01.triallog.v017.mat' 1) No Ephys 2)
 %Dyadic only



 %'20230607T152146.A_None.B_Elmo.SCP_01.triallog.v017.mat' 1) No Ephys 2)
 %SoloB only


 %'20230608T141913.A_None.B_Elmo.SCP_01.triallog.v017.mat' 1) No Ephys 2)
 %SoloB only


 %'20230609T134845.A_None.B_Elmo.SCP_01.triallog.v017.mat'  1)No Ephys 2)
 %Only SoloB


 %'20230612T155358.A_None.B_Elmo.SCP_01.triallog.v017.mat' 1)No Ephys data
 %2) Number of dyadic trials is only 2



 %'20230613T161556.A_MK.B_Elmo.SCP_01.triallog.v017.mat' % No hit in SoloB trials No Ephys data



 %'20230614T160832.A_MK.B_Elmo.SCP_01.triallog.v017.mat' % % No hit in SoloB trials No Ephys data



 %'20230615T170548.A_None.B_Elmo.SCP_01.triallog.v017.mat' Only Dyadic



 %'20230619T151413.A_None.B_Elmo.SCP_01.triallog.v017.mat' only SoloB


 %'20230620T142144.A_MK.B_Elmo.SCP_01.triallog.v017.mat'  % No hit in SoloB trials No Ephys data


 %'20230621T141449.A_MK.B_Elmo.SCP_01.triallog.v017.mat' % % No hit in SoloB trials No Ephys data


 %'20230622T155406.A_MK.B_Elmo.SCP_01.triallog.v017.mat' %No hit in SoloB trials No Ephys data



 %'20230626T162258.A_None.B_Elmo.SCP_01.triallog.v017.mat' only dyadic


 %'20230627T165641.A_MK.B_Elmo.SCP_01.triallog.v017.mat' %only duadic


  %'20230628T144009.A_MK.B_Elmo.SCP_01.triallog.v017.mat' only 7 trials
  %for soloB


  %'20230629T152509.A_MK.B_Elmo.SCP_01.triallog.v017.mat' % only dyadic,
  %because it is Dyadic and SoloArewardedAB, it means that for solo trials
  %Elmo was passive observor and passive reciever of the reward.
  
%'20230703T164353.A_MK.B_Elmo.SCP_01.triallog.v017.mat'};  % %No hit in SoloB trials No Ephys data


for s = 1 : numel(Sessions)
    foldername = strcat(extractBefore(Sessions{s},'triallog'),'sessiondir');
    monthName = extractBetween(foldername,'20','T');
    ElmoB_Human2023EphysFullSessionPath{s} = strcat(base_path,Year,'\',monthName,'\',foldername,'\',Sessions{s});
end
clear base_path
clear Year
 

