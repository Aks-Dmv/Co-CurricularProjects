function [Beta sigma] = FitLinearGaussianParameters(X, U)

% Estimate parameters of the linear Gaussian model:
% X|U ~ N(Beta(1)*U(1) + ... + Beta(n)*U(n) + Beta(n+1), sigma^2);

% Note that Matlab/Octave index from 1, we can't write Beta(0).
% So Beta(n+1) is essentially Beta(0) in the text book.

% X: (M x 1), the child variable, M examples
% U: (M x N), N parent variables, M examples
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

M = size(U,1);
N = size(U,2);

Beta = zeros(N+1,1);
sigma = 1;

% what are the U’s?
% the U’s are just the parent thetas

% collect expectations and solve the linear system
% A = [ E[U(1)],      E[U(2)],      ... , E[U(n)],      1     ; 
%       E[U(1)*U(1)], E[U(2)*U(1)], ... , E[U(n)*U(1)], E[U(1)];
%       ...         , ...         , ... , ...         , ...   ;
%       E[U(1)*U(n)], E[U(2)*U(n)], ... , E[U(n)*U(n)], E[U(n)] ]

% construct A

% A is the matrix of the n+1 equations we have to solve.
% we get these equations when we calculate the expectations of the normal distribution.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=zeros(N+1,N+1);
A(1,N+1)=1;
for i=1:N
    A(1,i)=mean(U(:,i));
    A(i+1,N+1)=A(1,i);

end
% notice how the matrix is the same for the first row and the last column
% here we are just building the matrix

for i=1:N
    for j=1:N
        A(i+1,j)=mean(U(:,j).*U(:,i));
    end
end


% B = [ E[X]; E[X*U(1)]; ... ; E[X*U(n)] ]

% construct B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

B=zeros(N+1,1);
B(1,1)=mean(X);
for i=1:N
    B(i+1,1)=mean(X.*U(:,i));
end

% similarly, just constructing B

% solve A*Beta = B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Beta=A\B;

% as per the pdf

% then compute sigma according to eq. (11) in PA description
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

thesum=mean(X.*X)-mean(X)*mean(X);
for i=1:N
    for j=1:N
        thesum=thesum-Beta(i)*Beta(j)*(mean(U(:,i).*U(:,j))-mean(U(:,i))*mean(U(:,j)));
    end
end
% the sum is the variance
sigma=sqrt(thesum);
