clear
w = 10000
t = 1 : w; %current time step
N = 1 : w; %the number of times action i has been selected up to time t 
ExplorationTerm = nan(w,w);
for tsample = 1 : w
    for nsample = 1 : w
        a = 2*log(t(tsample));
        b = N(nsample);
        ExplorationTerm(t(tsample),N(nsample)) = sqrt(a/b);
    end
end
plot(N,sum(ExplorationTerm,2)./w,'o')
xlabel('N')
ylabel('marginalized expl term on t')

%Exploration term: sqrt([2*log(t)]/N(t)])
%upper confidenc bound (UCB)
% UCB = R(t) + ExplorationTerm
