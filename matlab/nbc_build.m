function [ model ] = nbc_build( X, y )


% precondition X is valued over 0,1
% precondition y is valued over -1,1

% outputs a linear model, with intercept a, slope b.
%
% classify input x with: x * model.b' + model.a;

assert(sum(sum((X == 0) + (X == 1))) == numel(X));

% # of words
m = size(X,2);
size(X)

pos = find(y == 1);
neg = find(y == -1);

assert (length(pos) + length(neg) == length(y));

% class frequencies
p_pos = length(pos)/length(y);
p_neg = length(neg)/length(y);

X_pos = X(pos,:);
X_neg = X(neg,:);

% naive conditional probabilities 
pw_pos = (sum(X_pos, 1) + ones(1,m)) / (length(pos)+2);
pw_neg = (sum(X_neg, 1) + ones(1,m)) / (length(neg)+2);

pnw_pos = ones(1,m) - pw_pos;
pnw_neg = ones(1,m) - pw_neg;

% model
a = sum(log(pnw_pos ./ pnw_neg)) + log(p_pos/p_neg);
b = log( (pw_pos .* pnw_neg) ./ (pw_neg .* pnw_pos));

model = struct('a',a,'b',b);

end

