function accuracy = ClassifyDataset(dataset, labels, P, G)
% returns the accuracy of the model P and graph G on the dataset 
%
% Inputs:
% dataset: N x 10 x 3, N test instances represented by 10 parts
% labels:  N x 2 true class labels for the instances.
%          labels(i,j)=1 if the ith instance belongs to class j 
% P: struct array model parameters (explained in PA description)
% G: graph structure and parameterization (explained in PA description) 
%
% Outputs:
% accuracy: fraction of correctly classified instances (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset, 1);
accuracy = 0.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

K = length(P.c);

predict=zeros(N,K);
Ps=zeros(N,K);
%convert G
if length(size(G))==2
    oldG=G;
    clear G;
    for i=1:K
        G(1:10,1:2,i)=oldG;
    end
end
%compute P
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
        Ps(i,j)=P.c(j)*exp(thep);
    end
end
%compute predict
for i=1:N
    nowclass=find(Ps(i,:)==max(Ps(i,:)));
    predict(i,nowclass)=1;
end
%compute accuracy
acc=0;
for i=1:N
    if sum(predict(i,:)==labels(i,:))==K
        acc=acc+1;
    end
end
accuracy=acc/N;

fprintf('Accuracy: %.2f\n', accuracy);