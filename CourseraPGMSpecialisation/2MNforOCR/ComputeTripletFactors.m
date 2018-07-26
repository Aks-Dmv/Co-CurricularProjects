function factors = ComputeTripletFactors (images, tripletList, K)
% This function computes the triplet factor values for one word.
%
% Input:
%   images: An array of structs containing the 'img' value for each
%     character in the word.
%   tripletList: An array of the character triplets we will consider (other
%     factor values should be 1). tripletList(i).chars gives character
%     assignment, and triplistList(i).factorVal gives the value for that
%     entry in the factor table.
%   K: The alphabet size (accessible in imageModel.K for the provided
%     imageModel).
%
% Hint: Every character triple in the word will use the same 'val' table.
%   Consider computing that array once and then resusing for each factor.
%
% Copyright (C) Daphne Koller, Stanford University, 2012


n = length(images);

% If the word has fewer than three characters, then return an empty list.
if (n < 3)
    factors = [];
    return
end

factors = repmat(struct('var', [], 'card', [], 'val', []), n - 2, 1);

% Your code here:
for i=1:(n-2)
    factors(i).var = [i,i+1,i+2];
    factors(i).card=[K,K,K];
    factors(i).val =ones(K*K*K,1);
    % initialized to one because we never initialize to zero
    % it can cause calculation problems
    for j=1:2000
        % the tripletList has two attributes
        % chars which is like [3,5,2]
        % factorVal which is like 11.234
        % so we need to convert the chars (which are values of the variables in the 26*26*26 matrix)
        % into an index and put that factorVal into that index (in the .val)
        ass=AssignmentToIndex(tripletList(j).chars,[K,K,K]);
        factors(i).val(ass)=tripletList(j).factorVal;
    end
end

end
