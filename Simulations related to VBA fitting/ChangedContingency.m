
    probRewardGood = 1;
% draw 25 random feedbacks
contBloc = (rand(1,100) < probRewardGood); 
% create 6 blocs with reversals
% contingencies = [contBloc, 1-contBloc, ...
%                  contBloc, 1-contBloc, ...
%                  contBloc, 1-contBloc] ;
contingencies = [contBloc];
 
