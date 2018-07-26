%CLIQUETREECALIBRATE Performs sum-product or max-product algorithm for 
%clique tree calibration.

%   P = CLIQUETREECALIBRATE(P, isMax) calibrates a given clique tree, P 
%   according to the value of isMax flag. If isMax is 1, it uses max-sum
%   message passing, otherwise uses sum-product. This function 
%   returns the clique tree where the .val for each clique in .cliqueList
%   is set to the final calibrated potentials.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function P = CliqueTreeCalibrate(P, isMax)


% Number of cliques in the tree.
N = length(P.cliqueList);

% Setting up the messages that will be passed.
% MESSAGES(i,j) represents the message going from clique i to clique j. 
MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% We have split the coding part for this function in two chunks with
% specific comments. This will make implementation much easier.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE
% While there are ready cliques to pass messages between, keep passing
% messages. Use GetNextCliques to find cliques to pass messages between.
% Once you have clique i that is ready to send message to clique
% j, compute the message and put it in MESSAGES(i,j).
% Remember that you only need an upward pass and a downward pass.
%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isMax==1
    for i=1:N
        for j=1:length(P.cliqueList(i).val)
            P.cliqueList(i).val(j)=log(P.cliqueList(i).val(j));
        end
    end
end

doit=1;
while doit
    [thei,thej]=GetNextCliques(P,MESSAGES);
    if (thei==0) && (thej==0)
        break;
    end
    upstreamnum=0;
    for k=1:N
        if k==thej
            continue;
        else
            if P.edges(k,thei)==1
                upstreamnum=upstreamnum+1;
                uplist(upstreamnum)=k;
            end
        end
    end
    thefactor=P.cliqueList(thei);
    if upstreamnum>0
        for k=1:upstreamnum
            if isMax==0
                thefactor=FactorProduct(MESSAGES(uplist(k),thei),thefactor);
            end
            if isMax==1
                thefactor=FactorSum(MESSAGES(uplist(k),thei),thefactor);
            end
        end
    end
    [MESSAGES(thei,thej).var,aa,bb]=intersect(P.cliqueList(thei).var,P.cliqueList(thej).var);
    MESSAGES(thei,thej).card=P.cliqueList(thei).card(aa);
    if isMax==0
        MESSAGES(thei,thej).val=zeros(1,prod(MESSAGES(thei,thej).card));
    end
    if isMax==1
        MESSAGES(thei,thej).val=zeros(1,prod(MESSAGES(thei,thej).card));
        for kkkk=1:length(MESSAGES(thei,thej).val)
            MESSAGES(thei,thej).val(kkkk)=-Inf;
        end
    end
    [dummy,aa,bb]=intersect(thefactor.var,MESSAGES(thei,thej).var);
    for k=1:length(thefactor.val)
        ass=IndexToAssignment(k,thefactor.card);
        newass=ass(aa);
        newind=AssignmentToIndex(newass,MESSAGES(thei,thej).card);
        if isMax==0
            MESSAGES(thei,thej).val(newind)=MESSAGES(thei,thej).val(newind)+thefactor.val(k);
        end
        if isMax==1
            if MESSAGES(thei,thej).val(newind)<thefactor.val(k)
                MESSAGES(thei,thej).val(newind)=thefactor.val(k);
            end
            %MESSAGES(thei,thej).val(newind)=max([MESSAGES(thei,thej).val(newind),thefactor.val(k)]);
        end
    end
    if isMax==0
        MESSAGES(thei,thej).val=MESSAGES(thei,thej).val/sum(MESSAGES(thei,thej).val);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Now the clique tree has been calibrated. 
% Compute the final potentials for the cliques and place them in P.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:N
    upstreamnum=0;
    for k=1:N
        if P.edges(k,i)==1
            upstreamnum=upstreamnum+1;
            upstream(upstreamnum)=k;
        end
    end
    if upstreamnum>0
        for k=1:upstreamnum
            if isMax==0
                P.cliqueList(i)=FactorProduct(P.cliqueList(i),MESSAGES(upstream(k),i));
            end
            if isMax==1
                P.cliqueList(i)=FactorSum(P.cliqueList(i),MESSAGES(upstream(k),i));
            end
        end
    end
end


return
