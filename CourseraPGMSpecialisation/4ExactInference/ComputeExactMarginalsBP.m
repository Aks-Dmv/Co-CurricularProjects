%COMPUTEEXACTMARGINALSBP Runs exact inference and returns the marginals
%over all the variables (if isMax == 0) or the max-marginals (if isMax == 1). 
%
%   M = COMPUTEEXACTMARGINALSBP(F, E, isMax) takes a list of factors F,
%   evidence E, and a flag isMax, runs exact inference and returns the
%   final marginals for the variables in the network. If isMax is 1, then
%   it runs exact MAP inference, otherwise exact inference (sum-prod).
%   It returns an array of size equal to the number of variables in the 
%   network where M(i) represents the ith variable and M(i).val represents 
%   the marginals of the ith variable. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function M = ComputeExactMarginalsBP(F, E, isMax)

% initialization
% you should set it to the correct value in your code
M = struct('var', [], 'card', [], 'val', []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Implement Exact and MAP Inference.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P = CreateCliqueTree(F, E);
P = CliqueTreeCalibrate(P, isMax);
for i=1:length(P.cliqueList)
    for j=1:length(P.cliqueList(i).var)
        thefactor.var=P.cliqueList(i).var(j);
        thefactor.card=P.cliqueList(i).card(j);
        if isMax==0
            thefactor.val=zeros(1,thefactor.card);
        end
        if isMax==1
            thefactor.val=zeros(1,thefactor.card);
            for kkkk=1:length(thefactor.val)
                thefactor.val(kkkk)=-Inf;
            end
        end
        for k=1:length(P.cliqueList(i).val)
            ass=IndexToAssignment(k,P.cliqueList(i).card);
            ass2=ass(j);
            if isMax==0
                thefactor.val(ass2)=thefactor.val(ass2)+P.cliqueList(i).val(k);
            end
            if isMax==1
                if thefactor.val(ass2)<P.cliqueList(i).val(k)
                    thefactor.val(ass2)=P.cliqueList(i).val(k);
                end
            end
        end
        if isMax==0
            thefactor.val=thefactor.val/sum(thefactor.val);
        end
        M(thefactor.var,1)=thefactor;
    end
end
end

