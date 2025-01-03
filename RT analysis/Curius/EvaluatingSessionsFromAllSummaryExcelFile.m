%% 1] This script is written to help finding certain sessions with certain conditions, for example if you are looking for sessions when Elmo was actor B and Human actor A in 2021
%% 2] By time I see, some sessions are mislabeled in 'Allsessionsummarytable' and because this scriipt, use that table, eventually you should evaluate extracted sessions manually,
%% within each function, look at the plot for every individual session, if histograms are empty, reevaluate the session




%% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 22);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A2:V5871";

% Specify column names and types
opts.VariableNames = ["session_ID", "sort_key_string", "version", "date", "time", "Analysed", "TankID_list", "EPhysRecorded", "EPhysClustered", "subject_A", "subject_B", "trial_subtype", "CueRandomizationMethod_A", "CueRandomizationMethod_B", "record_type", "HitTrials", "AbortedTrials", "HitTrials_A", "AbortedTrials_A", "HitTrials_B", "AbortedTrials_B", "Session_dir"];
opts.VariableTypes = ["categorical", "string", "string", "string", "string", "double", "string", "string", "string", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "double", "double", "double", "double", "double", "double", "categorical"];

% Specify variable properties
opts = setvaropts(opts, ["sort_key_string", "version", "date", "time", "TankID_list", "EPhysRecorded", "EPhysClustered"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["session_ID", "sort_key_string", "version", "date", "time", "TankID_list", "EPhysRecorded", "EPhysClustered", "subject_A", "subject_B", "trial_subtype", "CueRandomizationMethod_A", "CueRandomizationMethod_B", "record_type", "Session_dir"], "EmptyFieldRule", "auto");

% Import the data
Allsessionsummarytable = readtable("C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes\All_session_summary_table.V1 - Copy (2).xlsx", opts, "UseExcel", false);


%% Clear temporary variables
clear opts

%% Looking through the data
ActorA = string(Allsessionsummarytable.subject_A);
ActorB = string(Allsessionsummarytable.subject_B);
EphysData = string(Allsessionsummarytable.EPhysRecorded);

ChoiceStringBlockedType = string(Allsessionsummarytable.CueRandomizationMethod_B);

DateConverted = string(Allsessionsummarytable.date);

TaskType = string(Allsessionsummarytable.trial_subtype);

ALLIDs = 1:numel(Allsessionsummarytable.subject_A)
ElmoID_A = find(strcmp(ActorA,'Elmo'));
ElmoID_B = find(strcmp(ActorB,'Elmo'));

CuriusID_A = find(strcmp(ActorA,'Curius'));
CuriusID_B = find(strcmp(ActorB,'Curius'));
NoneID_B = find(strcmp(ActorB,'None'));

All_NotCuriusAs_A = setdiff(ALLIDs,CuriusID_A);
All_NotCuriusAs_B = setdiff(ALLIDs,CuriusID_B);

All_NotElmoAs_A = setdiff(ALLIDs,ElmoID_A);
All_NotElmoAs_B = setdiff(ALLIDs,ElmoID_B);

BlockedChoiceStringIndices = find(contains(ChoiceStringBlockedType,'BLOCKED'))
ShuffledChoiceStringIndices = find(contains(ChoiceStringBlockedType,'SHUFFLED'))

DyadicIndices = find(contains(TaskType,'Dyadic'));
SoloAIndices = find(contains(TaskType,'SoloA'));
SoloARewardABIndices = find(contains(TaskType,'SoloARewardAB'));
AllSoloAIndices = union(SoloAIndices,SoloARewardABIndices);

SoloABlockedViewIndices = find(contains(TaskType,'SoloABlockedView'))
DyadicBlockedViewIndices = find(contains(TaskType,'DyadicBlockedView'))

BlockedViewDyadicSoloAIndices = intersect(DyadicBlockedViewIndices,SoloABlockedViewIndices)

Year2023Indices = find(contains(DateConverted,'2023'));
Year2021Indices = find(contains(DateConverted,'2021'));

EphysID = find(contains(EphysData,'1'));

Elmo_2023Behav_A = intersect(ElmoID_A,Year2023Indices);
Elmo_2023Behav_B = intersect(ElmoID_B,Year2023Indices);
Elmo_2021Behav_A = intersect(ElmoID_A,Year2021Indices);
Elmo_2021Behav_B = intersect(ElmoID_B,Year2021Indices);

Elmo_2023Ephys_A = intersect(Elmo_2023Behav_A,EphysID);
Elmo_2023Ephys_B = intersect(Elmo_2023Behav_B,EphysID);
Elmo_2021Ephys_A = intersect(Elmo_2021Behav_A,EphysID);
Elmo_2021Ephys_B = intersect(Elmo_2021Behav_B,EphysID);


UniqueSess_Elmo_2023_A = unique(DateConverted(Elmo_2023Ephys_A));
UniqueSess_Elmo_2023_B = unique(DateConverted(Elmo_2023Ephys_B));
UniqueSess_Elmo_2021_A = unique(DateConverted(Elmo_2021Ephys_A));
UniqueSess_Elmo_2021_B = unique(DateConverted(Elmo_2021Ephys_B));


Curius_2023Behav_A = intersect(CuriusID_A,Year2023Indices);
Curius_2023Behav_B = intersect(CuriusID_B,Year2023Indices);
Curius_2021Behav_A = intersect(CuriusID_A,Year2021Indices);
Curius_2021Behav_B = intersect(CuriusID_B,Year2021Indices);

Curius_2023Ephys_A = intersect(Curius_2023Behav_A,EphysID);
Curius_2023Ephys_B = intersect(Curius_2023Behav_B,EphysID);
Curius_2021Ephys_A = intersect(Curius_2021Behav_A,EphysID);
Curius_2021Ephys_B = intersect(Curius_2021Behav_B,EphysID);

Curius_2023Behav_A_HumanB = intersect(All_NotElmoAs_B',Curius_2023Behav_A);
Curius_2023Behav_A_HumanB = setdiff(Curius_2023Behav_A_HumanB,NoneID_B);

Curius_2023Behav_A_HumanB_BlockedChoiceString = intersect(Curius_2023Behav_A_HumanB,BlockedChoiceStringIndices);
Curius_2023Behav_A_HumanB_BlockedChoiceStringDYADIC  = intersect(Curius_2023Behav_A_HumanB_BlockedChoiceString,DyadicIndices)
Curius_2023Behav_A_HumanB_BlockedChoiceStringAllSolo  = intersect(Curius_2023Behav_A_HumanB_BlockedChoiceString,AllSoloAIndices)

Curius_2023Behav_A_HumanB_Dyadic = intersect(Curius_2023Behav_A_HumanB,DyadicIndices)
Curius_2023Behav_A_HumanB_AllSoloA = intersect(Curius_2023Behav_A_HumanB,AllSoloAIndices)

Curius_2023Behav_A_HumanB_DyadicSoloaAll = union(Curius_2023Behav_A_HumanB_Dyadic,Curius_2023Behav_A_HumanB_AllSoloA)
Curius_2023Behav_A_HumanB_NOTblockedView_DYADICsOLOA = setdiff(Curius_2023Behav_A_HumanB_DyadicSoloaAll,BlockedViewDyadicSoloAIndices)


Curius_2023Ephys_A_HumanB = intersect(All_NotElmoAs_B',Curius_2023Ephys_A);
Curius_2023Ephys_A_HumanB = setdiff(Curius_2023Ephys_A_HumanB,NoneID_B);


Curius_2023Ephys_A_HumanB_BlockedChoiceString = intersect(Curius_2023Ephys_A_HumanB,BlockedChoiceStringIndices);
Curius_2023Ephys_A_HumanB_BlockedChoiceStringDYADIC  = intersect(Curius_2023Ephys_A_HumanB_BlockedChoiceString,DyadicIndices)




UniqueSess_Curius_2023_A = unique(DateConverted(Curius_2023Ephys_A));
UniqueSess_Curius_2023_B = unique(DateConverted(Curius_2023Ephys_B));
UniqueSess_Curius_2021_A = unique(DateConverted(Curius_2021Ephys_A));
UniqueSess_Curius_2021_B = unique(DateConverted(Curius_2021Ephys_B));


Elmo_2023Ephys_B_HumanA = intersect(All_NotCuriusAs_A',Elmo_2023Ephys_B);
Elmo_2023Ephys_B_CuriusA = intersect(CuriusID_A,Elmo_2023Ephys_B);

Elmo_2021Ephys_B_HumanA = intersect(All_NotCuriusAs_A',Elmo_2021Ephys_B);
Elmo_2021Ephys_B_CuriusA = intersect(CuriusID_A,Elmo_2021Ephys_B);

Elmo_2021Behav_B_HumanA = intersect(All_NotCuriusAs_A',Elmo_2021Behav_B);

Elmo_2021Behav_B_CuriusA = intersect(CuriusID_A,Elmo_2021Behav_B);


Elmo_2021Behav_A_HumanB = intersect(All_NotCuriusAs_B',Elmo_2021Behav_A);
Elmo_2021Behav_A_HumanB = setdiff(Elmo_2021Behav_A_HumanB,NoneID_B)

Elmo_2021Behav_A_CuriusB = intersect(CuriusID_B,Elmo_2021Behav_A);

Elmo_2021Behav_A_HumanB_BlockedChoiceString = intersect(Elmo_2021Behav_A_HumanB,BlockedChoiceStringIndices)
Elmo_2021Behav_A_HumanB_BlockedChoiceStringDYADIC  = intersect(Elmo_2021Behav_A_HumanB_BlockedChoiceString,DyadicIndices)

Elmo_2021Behav_A_HumanB_ShuffledChoiceString = intersect(Elmo_2021Behav_A_HumanB,ShuffledChoiceStringIndices)
Elmo_2021Behav_A_HumanB_ShuffledChoiceStringDYADIC  = intersect(Elmo_2021Behav_A_HumanB_ShuffledChoiceString,DyadicIndices)


unique(DateConverted(Elmo_2021Behav_A_HumanB))
unique(DateConverted(Elmo_2021Behav_A_CuriusB))
unique(DateConverted(Curius_2023Behav_A_HumanB_BlockedChoiceStringDYADIC))

unique(DateConverted(Elmo_2021Behav_A_HumanB_BlockedChoiceStringDYADIC))

unique(DateConverted(Elmo_2021Behav_A_HumanB_ShuffledChoiceStringDYADIC))

unique(DateConverted(Curius_2023Behav_A_HumanB_NOTblockedView_DYADICsOLOA))

