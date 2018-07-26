function loglikelihood = ComputeLogLikelihood(P, G, dataset)
% returns the (natural) log-likelihood of data given the model and graph structure
%
% Inputs:
% P: struct array parameters (explained in PA description)
% G: graph structure and parameterization (explained in PA description)
%
%    NOTICE that G could be either 10x2 (same graph shared by all classes)
%    or 10x2x2 (each class has its own graph). your code should compute
%    the log-likelihood using the right graph.
%
% dataset: N x 10 x 3, N poses represented by 10 parts in (y, x, alpha)
% 
% Output:
% loglikelihood: log-likelihood of the data (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset,1); % number of examples
K = length(P.c); % number of classes

loglikelihood = 0;
% You should compute the log likelihood of data as in eq. (12) and (13)
% in the PA description
% Hint: Use lognormpdf instead of log(normpdf) to prevent underflow.
%       You may use log(sum(exp(logProb))) to do addition in the original
%       space, sum(Prob).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%convert G
% here G could have the other format as shown in the PDF
if length(size(G))==2
    oldG=G;
    clear G;
    for i=1:K
        G(1:10,1:2,i)=oldG;
    end
end

%compute P
for i=1:N
    datanolog=0;
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
        datanolog=datanolog+P.c(j)*exp(thep);
    end
    loglikelihood=loglikelihood+log(datanolog);
end