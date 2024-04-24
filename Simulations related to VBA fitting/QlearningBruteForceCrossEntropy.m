cd 'C:\Users\zahra\OneDrive\Documents\PostDoc_DPZ\Zahra codes\Simulations related to VBA fitting'
%%
close all
clear
clc
%%
DeltaTime = 10:10:300;
RewardMat = [1,2];
nTrials = 450

transformChoiceToFeedback = @(x) (x == 1) + 1;

SubjectChoice = nan(numel(DeltaTime),nTrials);
Subjectfeedbacks = nan(numel(DeltaTime),nTrials);
FixedHighProb_AfterLearning = 0.9

for DELTAt = 1 : numel(DeltaTime)
    DELTATIME = DeltaTime(DELTAt)

    ChoiceProb = FixedHighProb_AfterLearning;
    A = nan(1,nTrials);
    A(1:DELTATIME) = binornd(1,0.5,[1,DELTATIME]);
    A(DELTATIME+1:end) = binornd(1,ChoiceProb,[1,nTrials-DELTATIME]);
    SubjectChoice(DELTAt,:) = A;

    Subjectfeedbacks(DELTAt,:) = arrayfun(transformChoiceToFeedback, A);
end

Q_AtTrial_1 = 0.5;

PhiRange = 0:0.5:6
ThetaRange = 0 : 0.1: 1


for SUBJECT = 1 : numel(DeltaTime)
    CrossEntLOSS = nan(numel(ThetaRange),numel(PhiRange));
    for PHI = 1 : numel(PhiRange)
        InverseTempt = PhiRange(PHI);
        for THETHA = 1 : numel(ThetaRange)
            LearningRate = ThetaRange(THETHA);
            Qvector = nan(1,nTrials);
            PrevQ = Q_AtTrial_1;
            for N = 1 : nTrials
                reward = Subjectfeedbacks(SUBJECT,N);
                Qvector(N) =  QLEARNING(PrevQ,LearningRate,reward);
                PrevQ = Qvector(N);
            end

            QvectorActionA = nan(1,nTrials);
            QvectorActionB = nan(1,nTrials);
            QvectorActionA(Subjectfeedbacks(SUBJECT,:)== 2) = Qvector(Subjectfeedbacks(SUBJECT,:)== 2);
            QvectorActionB(Subjectfeedbacks(SUBJECT,:)== 1) = Qvector(Subjectfeedbacks(SUBJECT,:)== 1);

            if isnan(QvectorActionA(1))
                QvectorActionA(1) = Q_AtTrial_1;
            end
            if isnan(QvectorActionB(1))
                QvectorActionB(1) = Q_AtTrial_1;
            end
            while sum(isnan(QvectorActionB))>0
                for i = 2 : numel(QvectorActionB)
                    if isnan(QvectorActionB(i))
                        QvectorActionB(i) = QvectorActionB(i-1);
                    end
                end
            end
            while sum(isnan(QvectorActionA))>0
                for i = 2 : numel(QvectorActionA)
                    if isnan(QvectorActionA(i))
                        QvectorActionA(i) = QvectorActionA(i-1);
                    end
                end
            end



            ActionProbA = SoftMax_Qlearning(InverseTempt,QvectorActionA,QvectorActionB); %probability of choosing option with value 2
            ActionProbB = SoftMax_Qlearning(InverseTempt,QvectorActionB,QvectorActionA); %probability of choosing option with value 1
            AllActionProb = nan(1,nTrials);
            AllActionProb(SubjectChoice(SUBJECT,:)==1) = ActionProbA(SubjectChoice(SUBJECT,:)==1);
            AllActionProb(SubjectChoice(SUBJECT,:)==0) = ActionProbB(SubjectChoice(SUBJECT,:)==0);

            CrossEntLOSS(THETHA,PHI) = CrossEntropy(SubjectChoice(SUBJECT,:),AllActionProb);
        end
    end
    [minValue, linearIndex] = min(CrossEntLOSS(:))
    [rowIndex, colIndex] = ind2sub(size(CrossEntLOSS), linearIndex)
    SubjectBestTheta(SUBJECT) = ThetaRange(rowIndex);
    SubjectBestPhi(SUBJECT) = PhiRange(colIndex);

end



for PHI = 1 : numel(PhiRange)
    InverseTempt = PhiRange(PHI);
    for THETHA = 1 : numel(ThetaRange)
        LearningRate = ThetaRange(THETHA);
        plot3(LearningRate,InverseTempt,CrossEntLOSS(THETHA,PHI),'ok')
        hold on
    end
end

plot3(ThetaRange(rowIndex),PhiRange(colIndex),min(CrossEntLOSS(:)),'or')
xlabel('Learning rate')
ylabel('Inverse tempreture')
zlabel('Loss value')
title('Subject: Maximizing after 300 trials')
figure
plot(SubjectBestTheta,'om')
figure
plot(SubjectBestPhi,'ob')
