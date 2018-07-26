%NAIVEGETNEXTCLUSTERS Takes in a node adjacency matrix and returns the indices
%   of the nodes between which the m+1th message should be passed.
%
%   Output [i j]
%     i = the origin of the m+1th message
%     j = the destination of the m+1th message
%
%   This method should iterate over the messages in increasing order where
%   messages are sorted in ascending ordered by their destination index and 
%   ties are broken based on the origin index. (note: this differs from PA4's
%   ordering)
%
%   Thus, if m is 0, [i j] will be the pair of clusters with the lowest j value
%   and (of those pairs over this j) lowest i value as this is the 'first'
%   element in our ordering. (this difference is because matlab is 1-indexed)
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function [thei, thej] = NaiveGetNextClusters(P, m)

    thei = size(P.clusterList,1);
    thej = size(P.clusterList,1);
    N=length(P.clusterList);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE
    % Find the indices between which to pass a cluster
    % The 'find' function may be useful
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
messagelen=0;
for i=1:N
    for j=1:N
        if P.edges(i,j)==1
            messagelen=messagelen+1;
            message(messagelen,1)=i;%destination
            message(messagelen,2)=j;%origin
            message(messagelen,3)=0;%not sent
        end
    end
end
for i=1:mod(m,messagelen)+1
    thei=message(i,2);
    thej=message(i,1);
end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

