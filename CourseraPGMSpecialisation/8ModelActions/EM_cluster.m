% File: EM_cluster.m
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

function [P loglikelihood ClassProb] = EM_cluster(poseData, G, InitialClassProb, maxIter)

% INPUTS
% poseData: N x 10 x 3 matrix, where N is number of poses;
%   poseData(i,:,:) yields the 10x3 matrix for pose i.
% G: graph parameterization as explained in PA8
% InitialClassProb: N x K, initial allocation of the N poses to the K
%   classes. InitialClassProb(i,j) is the probability that example i belongs
%   to class j
% maxIter: max number of iterations to run EM

% OUTPUTS
% P: structure holding the learned parameters as described in the PA
% loglikelihood: #(iterations run) x 1 vector of loglikelihoods stored for
%   each iteration
% ClassProb: N x K, conditional class probability of the N examples to the
%   K classes in the final iteration. ClassProb(i,j) is the probability that
%   example i belongs to class j

% Initialize variables
N = size(poseData, 1);
K = size(InitialClassProb, 2);

ClassProb = InitialClassProb;

loglikelihood = zeros(maxIter,1);

P.c = [];
P.clg.sigma_x = [];
P.clg.sigma_y = [];
P.clg.sigma_angle = [];

% EM algorithm
for iter=1:maxIter

  % M-STEP to estimate parameters for Gaussians
  %
  % Fill in P.c with the estimates for prior class probabilities
  % Fill in P.clg for each body part and each class
  % Make sure to choose the right parameterization based on G(i,1)
  %
  % Hint: This part should be similar to your work from PA8

  P.c = zeros(1,K);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%convert G

dataset=poseData;

if length(size(G))==2
    oldG=G;
    clear G;
    for i=1:K
        G(1:10,1:2,i)=oldG;
    end
end
%P.c
for i=1:K
    P.c(i)=sum(ClassProb(:,i))/N;
end
%P.clg
P.clg=repmat(struct('mu_y',[],'sigma_y',[],'mu_x',[],'sigma_x',[],'mu_angle',[],'sigma_angle',[],'theta',[]),1,10);

% initialisation till here

for i=1:10
    for j=1:K
        dataoneclass=[];
        dataparentoneclass=[];
        for m=1:N
            dataoneclass=[dataoneclass;dataset(m,i,1),dataset(m,i,2),dataset(m,i,3);];
        end
        if G(i,1,j)==0
            [P.clg(i).mu_y(1,j),P.clg(i).sigma_y(1,j)]=FitG(dataoneclass(:,1),ClassProb(:,j));
            [P.clg(i).mu_x(1,j),P.clg(i).sigma_x(1,j)]=FitG(dataoneclass(:,2),ClassProb(:,j));
            [P.clg(i).mu_angle(1,j),P.clg(i).sigma_angle(1,j)]=FitG(dataoneclass(:,3),ClassProb(:,j));
        end
        if G(i,1,j)==1
            for m=1:N
                dataparentoneclass=[dataparentoneclass;dataset(m,G(i,2,j),1),dataset(m,G(i,2,j),2),dataset(m,G(i,2,j),3);];
            end
            [thetheta,P.clg(i).sigma_y(1,j)]=FitLG(dataoneclass(:,1),dataparentoneclass,ClassProb(:,j));
            P.clg(i).theta(j,1:4)=[thetheta(4),thetheta(1:3)'];
            [thetheta,P.clg(i).sigma_x(1,j)]=FitLG(dataoneclass(:,2),dataparentoneclass,ClassProb(:,j));
            P.clg(i).theta(j,5:8)=[thetheta(4),thetheta(1:3)'];
            [thetheta,P.clg(i).sigma_angle(1,j)]=FitLG(dataoneclass(:,3),dataparentoneclass,ClassProb(:,j));
            P.clg(i).theta(j,9:12)=[thetheta(4),thetheta(1:3)'];
        end
    end
end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % E-STEP to re-estimate ClassProb using the new parameters
  %
  % Update ClassProb with the new conditional class probabilities.
  % Recall that ClassProb(i,j) is the probability that example i belongs to
  % class j.
  %
  % You should compute everything in log space, and only convert to
  % probability space at the end.
  %
  % Tip: To make things faster, try to reduce the number of calls to
  % lognormpdf, and inline the function (i.e., copy the lognormpdf code
  % into this file)
  %
  % Hint: You should use the logsumexp() function here to do
  % probability normalization in log space to avoid numerical issues

  ClassProb = zeros(N,K);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:N
    for j=1:K
        thep=0;
        for m=1:10
            clear nowsum;
            if G(m,1,j)==0
                nowsum=lognormpdf(dataset(i,m,1),P.clg(m).mu_y(j),P.clg(m).sigma_y(j))+lognormpdf(dataset(i,m,2),P.clg(m).mu_x(j),P.clg(m).sigma_x(j))+lognormpdf(dataset(i,m,3),P.clg(m).mu_angle(j),P.clg(m).sigma_angle(j));
            end
            if G(m,1,j)==1
                parentdata=[1,dataset(i,G(m,2,j),1),dataset(i,G(m,2,j),2),dataset(i,G(m,2,j),3)];
                nowsum=lognormpdf(dataset(i,m,1),sum(P.clg(m).theta(j,1:4).*parentdata),P.clg(m).sigma_y(j))+lognormpdf(dataset(i,m,2),sum(P.clg(m).theta(j,5:8).*parentdata),P.clg(m).sigma_x(j))+lognormpdf(dataset(i,m,3),sum(P.clg(m).theta(j,9:12).*parentdata),P.clg(m).sigma_angle(j));
            end
            thep=thep+nowsum;
        end
        ClassProb(i,j)=thep+log(P.c(j));
    end
end
sumProb=logsumexp(ClassProb);
for j=1:K
    ClassProb(:,j)=ClassProb(:,j)-sumProb;
end
ClassProb=exp(ClassProb);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Compute log likelihood of dataset for this iteration
  % Hint: You should use the logsumexp() function here
  loglikelihood(iter) = 0;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
loglikelihood(iter)=sum(sumProb);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Print out loglikelihood
  disp(sprintf('EM iteration %d: log likelihood: %f', ...
    iter, loglikelihood(iter)));
  if exist('OCTAVE_VERSION')
    fflush(stdout);
  end

  % Check for overfitting: when loglikelihood decreases
  if iter > 1
    if loglikelihood(iter) < loglikelihood(iter-1)
      break;
    end
  end

end

% Remove iterations if we exited early
loglikelihood = loglikelihood(1:iter);
