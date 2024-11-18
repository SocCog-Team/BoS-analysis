%% This function pour what is inside in a structure into the base workspace
function Str2Vars(ResultsInStruct)
FILEDS = fieldnames(ResultsInStruct);  % Get all field names of the structure

for i = 1:numel(FILEDS)
    assignin('caller', FILEDS{i}, ResultsInStruct.(FILEDS{i}));
end