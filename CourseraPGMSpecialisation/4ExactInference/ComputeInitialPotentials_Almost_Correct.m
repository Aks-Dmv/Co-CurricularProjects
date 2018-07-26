%COMPUTEINITIALPOTENTIALS Sets up the cliques in the clique tree that is
%passed in as a parameter.
%
%   P = COMPUTEINITIALPOTENTIALS(C) Takes the clique tree skeleton C which is a
%   struct with three fields:
%   - nodes: cell array representing the cliques in the tree.
%   - edges: represents the adjacency matrix of the tree.
%   - factorList: represents the list of factors that were used to build
%   the tree.
%
%   It returns the standard form of a clique tree P that we will use through
%   the rest of the assigment. P is struct with two fields:
%   - cliqueList: represents an array of cliques with appropriate factors
%   from factorList assigned to each clique. Where the .val of each clique
%   is initialized to the initial potential of that clique.
%   - edges: represents the adjacency matrix of the tree.
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function P = ComputeInitialPotentials(C)

% number of cliques
N = length(C.nodes);

% initialize cluster potentials
P.cliqueList = repmat(struct('var', [], 'card', [], 'val', []), N, 1);
P.edges = zeros(N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% First, compute an assignment of factors from factorList to cliques.
% Then use that assignment to initialize the cliques in cliqueList to
% their initial potentials.

% C.nodes is a list of cliques.
% So in your code, you should start with: P.cliqueList(i).var = C.nodes{i};
% Print out C to get a better understanding of its structure.
%

P.edges = C.edges
% this is obvious because both are the same adjacency matrices
% why? because C is the clique tree skeleton

% This for loop just makes an array where if you input a var, it will give you its corresponding card
% 		

for i=1:length(C.factorList)
    for j=1:length(C.factorList(i).card)
        cardmat(C.factorList(i).var(j))=C.factorList(i).card(j);
    end
end



% for each factor, we check whether C.nodes{j} is a subset of the factor
% if it is, we link i and j by making ass(i) = j ie. if we input a factor, we get the clique it is in

for i=1:length(C.factorList)
    for j=1:N
        dummy=intersect(C.nodes{j},C.factorList(i).var);
        if length(dummy)==length(C.factorList(i).var)
            ass(i)=j;
            break;
        end
    end
end


% for each N nodes ie. each clique, in the clique tree skeleton
%
%	Put the first node into the final clique list
%	We just update the cardinality of the final clique tree factor
%	*So now all we have to do is put the values into the final clique tree clique and we are done
% 
% 	second, we are checking how many factors are fitting into this node
% 	then we are noting down those factors into a vector fac
% 	
%	if more than one factor, then we do the product
%	in case of one, we just put it into THE CLIQUE
%
%	if facnum == 0 then send in ones [ie. that clique will have only ones] and then leave the loop
%	why do we break?
%	because we are done putting the values of the clique (refer *)
% 
%	So what do we have till now? We have made our factor product. Now we need to update the clique list.
%	But, How do we know which order to put them in?
%	that is, what we are doing here is for each assignment, we are checking 
%	How did we implement it? we made theass1 which holds the max asignment of each variable
%	we check for the corresponding variable and transfer that into theass2
% 	what we had initially was the cliqueList(i) having card in different orders, now we have max assignments in the order of the the clique
%	Now we take those CPD’s and the cardinalities and send them into ASStoIndex to get the .val
%
%	the next for loop is basically saying for each assignment in the table CPD
%	make #####
% 	then for each variable in the clique, iterate through the variables in the 

for i=1:N
    P.cliqueList(i).var=C.nodes{i};
    for j=1:length(P.cliqueList(i).var)
        P.cliqueList(i).card(j)=cardmat(P.cliqueList(i).var(j));
    end
    
    facnum=0;
    for j=1:length(C.factorList)
        if ass(j)==i
            facnum=facnum+1;
            fac(facnum)=j;
        end
    end
    
    if facnum==1
        theclique=C.factorList(fac(1));
    else
        theclique=C.factorList(fac(1));
        for j=1:(facnum-1)
            theclique=FactorProduct(theclique,C.factorList(fac(j+1)));
        end
    end
    
    if facnum==0
        P.cliqueList(i).val=ones(1,prod(P.cliqueList(i).card));
        break;
    end

    for j=1:prod(P.cliqueList(i).card)
        theass1=0;
        theass2=0;
        theass1=IndexToAssignment(j,P.cliqueList(i).card);
        for a1=1:length(theclique.var)
            for a2=1:length(P.cliqueList(i).var)
                if (theclique.var(a1))==(P.cliqueList(i).var(a2))
                    theass2(a1)=theass1(a2);
                end
            end
        end
        theind2=AssignmentToIndex(theass2,theclique.card);
        theval=theclique.val(theind2);
        P.cliqueList(i).val(j)=theval;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end
