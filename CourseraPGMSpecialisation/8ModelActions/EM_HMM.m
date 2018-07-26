% File: EM_HMM.m
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

function [P loglikelihood ClassProb PairProb] = EM_HMM(actionData, poseData, G, InitialClassProb, InitialPairProb, maxIter)

% INPUTS
% actionData: structure holding the actions as described in the PA
% poseData: N x 10 x 3 matrix, where N is number of poses in all actions
% G: graph parameterization as explained in PA description
% InitialClassProb: N x K matrix, initial allocation of the N poses to the K
%   states. InitialClassProb(i,j) is the probability that example i belongs
%   to state j.
%   This is described in more detail in the PA.
% InitialPairProb: V x K^2 matrix, where V is the total number of pose
%   transitions in all HMM action models, and K is the number of states.
%   This is described in more detail in the PA.
% maxIter: max number of iterations to run EM

% OUTPUTS
% P: structure holding the learned parameters as described in the PA
% loglikelihood: #(iterations run) x 1 vector of loglikelihoods stored for
%   each iteration
% ClassProb: N x K matrix of the conditional class probability of the N examples to the
%   K states in the final iteration. ClassProb(i,j) is the probability that
%   example i belongs to state j. This is described in more detail in the PA.
% PairProb: V x K^2 matrix, where V is the total number of pose transitions
%   in all HMM action models, and K is the number of states. This is
%   described in more detail in the PA.

% Initialize variables
N = size(poseData, 1);
K = size(InitialClassProb, 2);
L = size(actionData, 2); % number of actions
V = size(InitialPairProb, 1);

ClassProb = InitialClassProb;
PairProb = InitialPairProb;

loglikelihood = zeros(maxIter,1);

P.c = [];
P.clg.sigma_x = [];
P.clg.sigma_y = [];
P.clg.sigma_angle = [];

% EM algorithm
for iter=1:maxIter
  
  % M-STEP to estimate parameters for Gaussians
  % Fill in P.c, the initial state prior probability (NOT the class probability as in PA8 and EM_cluster.m)
  % Fill in P.clg for each body part and each class
  % Make sure to choose the right parameterization based on G(i,1)
  % Hint: This part should be similar to your work from PA8 and EM_cluster.m
  
  P.c = zeros(1,K);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
dataset=poseData;

%convert G
if length(size(G))==2
    oldG=G;
    clear G;
    for i=1:K
        G(1:10,1:2,i)=oldG;
    end
end
%P.c
initialCP=zeros(1,K);
for i=1:L
    initialCP=initialCP+ClassProb(actionData(i).marg_ind(1),:);
end
for i=1:K
    P.c(i)=initialCP(i)/sum(initialCP);
end
%P.clg
P.clg=repmat(struct('mu_y',[],'sigma_y',[],'mu_x',[],'sigma_x',[],'mu_angle',[],'sigma_angle',[],'theta',[]),1,10);
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
  
  % M-STEP to estimate parameters for transition matrix
  % Fill in P.transMatrix, the transition matrix for states
  % P.transMatrix(i,j) is the probability of transitioning from state i to state j
  P.transMatrix = zeros(K,K);
  
  % Add Dirichlet prior based on size of poseData to avoid 0 probabilities
  P.transMatrix = P.transMatrix + size(PairProb,1) * .05;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
transsum=zeros(1,K*K);
for i=1:(K*K)
    transsum(1,i)=sum(PairProb(:,i));
end
transMat=reshape(transsum,K,K);
transMat=transMat+size(PairProb,1)*0.05;
for i=1:K
    for j=1:K
       P.transMatrix(i,j)=transMat(i,j)/sum(transMat(i,:));
    end
end


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
    
  % E-STEP preparation: compute the emission model factors (emission probabilities) in log space for each 
  % of the poses in all actions = log( P(Pose | State) )
  % Hint: This part should be similar to (but NOT the same as) your code in EM_cluster.m
  
  logEmissionProb = zeros(N,K);
  
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
        logEmissionProb(i,j)=thep;
    end
end


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
    
  % E-STEP to compute expected sufficient statistics
  % ClassProb contains the conditional class probabilities for each pose in all actions
  % PairProb contains the expected sufficient statistics for the transition CPDs (pairwise transition probabilities)
  % Also compute log likelihood of dataset for this iteration
  % You should do inference and compute everything in log space, only converting to probability space at the end
  % Hint: You should use the logsumexp() function here to do probability normalization in log space to avoid numerical issues
  
  ClassProb = zeros(N,K);
  PairProb = zeros(V,K^2);
  loglikelihood(iter) = 0;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:L
    nowlength=length(actionData(i).marg_ind);
    clear F;
    F=repmat(struct('var',[],'card',[],'val',[]),1,1);
    F(1).var=1;
    F(1).card=K;
    F(1).val=log(P.c);
    for j=1:nowlength
        F(j+1).var=j;
        F(j+1).card=K;
        F(j+1).val=logEmissionProb(actionData(i).marg_ind(j),:);
    end
    for j=1:nowlength-1
        F(nowlength+1+j).var=[j,j+1];
        F(nowlength+1+j).card=[K,K];
        F(nowlength+1+j).val=log(reshape(P.transMatrix,1,K*K));
    end
    [M,PCalibrated]=ComputeExactMarginalsHMM(F);
    for j=1:nowlength
        ClassProb(actionData(i).marg_ind(M(j).var),1:K)=M(j).val;
    end
    for j=1:(nowlength-1)
        PairProb(actionData(i).pair_ind(j),:)=PCalibrated.cliqueList(j).val;
    end
    loglikelihood(iter)=loglikelihood(iter)+logsumexp(PCalibrated.cliqueList(end).val);
end
sumProb1=logsumexp(ClassProb);
for j=1:K
    ClassProb(:,j)=ClassProb(:,j)-sumProb1;
end
sumProb2=logsumexp(PairProb);
for j=1:(K*K)
    PairProb(:,j)=PairProb(:,j)-sumProb2;
end
ClassProb=exp(ClassProb);
PairProb=exp(PairProb);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Print out loglikelihood
  disp(sprintf('EM iteration %d: log likelihood: %f', ...
    iter, loglikelihood(iter)));
  if exist('OCTAVE_VERSION')
    fflush(stdout);
  end
  
  % Check for overfitting by decreasing loglikelihood
  if iter > 1
    if loglikelihood(iter) < loglikelihood(iter-1)
      break;
    end
  end
  
end

% Remove iterations if we exited early
loglikelihood = loglikelihood(1:iter);
