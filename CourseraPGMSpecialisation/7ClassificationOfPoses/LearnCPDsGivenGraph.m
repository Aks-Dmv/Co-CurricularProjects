function [P loglikelihood] = LearnCPDsGivenGraph(dataset, G, labels)
%
% Inputs:
% dataset: N x 10 x 3, N poses represented by 10 parts in (y, x, alpha)
% G: graph parameterization as explained in PA description
% labels: N x 2 true class labels for the examples. labels(i,j)=1 if the 
%         the ith example belongs to class j and 0 elsewhere        
%
% Outputs:
% P: struct array parameters (explained in PA description)
% loglikelihood: log-likelihood of the data (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset, 1);
K = size(labels,2);

loglikelihood = 0;
P.c = zeros(1,K);

% estimate parameters
% fill in P.c, MLE for class probabilities
% fill in P.clg for each body part and each class
% choose the right parameterization based on G(i,1)
% compute the likelihood - you may want to use ComputeLogLikelihood.m
% you just implemented.
%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE

%convert G
if length(size(G))==2
    oldG=G;
    clear G;
    for i=1:K
        G(1:10,1:2,i)=oldG;
    end
end
%P.c
for i=1:K
    P.c(i)=sum(labels(:,i))/N;
end
%P.clg
P.clg=repmat(struct('mu_y',[],'sigma_y',[],'mu_x',[],'sigma_x',[],'mu_angle',[],'sigma_angle',[],'theta',[]),1,10);

% till here was just initialisation

for i=1:10
    for j=1:K
        dataoneclass=[];
        dataparentoneclass=[];
        for m=1:N
            if labels(m,j)==1
                dataoneclass=[dataoneclass;dataset(m,i,1),dataset(m,i,2),dataset(m,i,3);];
            end
        end
        if G(i,1,j)==0
            [P.clg(i).mu_y(1,j),P.clg(i).sigma_y(1,j)]=FitGaussianParameters(dataoneclass(:,1));
            [P.clg(i).mu_x(1,j),P.clg(i).sigma_x(1,j)]=FitGaussianParameters(dataoneclass(:,2));
            [P.clg(i).mu_angle(1,j),P.clg(i).sigma_angle(1,j)]=FitGaussianParameters(dataoneclass(:,3));
        end
        if G(i,1,j)==1
            for m=1:N
                if labels(m,j)==1
                    dataparentoneclass=[dataparentoneclass;dataset(m,G(i,2,j),1),dataset(m,G(i,2,j),2),dataset(m,G(i,2,j),3);];
                end
            end
            [thetheta,P.clg(i).sigma_y(1,j)]=FitLinearGaussianParameters(dataoneclass(:,1),dataparentoneclass);
            P.clg(i).theta(j,1:4)=[thetheta(4),thetheta(1:3)'];
            [thetheta,P.clg(i).sigma_x(1,j)]=FitLinearGaussianParameters(dataoneclass(:,2),dataparentoneclass);
            P.clg(i).theta(j,5:8)=[thetheta(4),thetheta(1:3)'];
            [thetheta,P.clg(i).sigma_angle(1,j)]=FitLinearGaussianParameters(dataoneclass(:,3),dataparentoneclass);
            P.clg(i).theta(j,9:12)=[thetheta(4),thetheta(1:3)'];
        end
    end
end
loglikelihood=ComputeLogLikelihood(P,G,dataset);

fprintf('log likelihood: %f\n', loglikelihood);


