function [ model ] = nbc_build( X, y )

% let U,D be events for stock price going up or down
% let W_i be the event for the presence of word i

% need to estimate P(U, W_i), P(D, W_i) for each word i
% assuming every label is -1 or 1

% # of words
m = size(X,2);

pos = find(y == 1);
neg = find(y == -1);

assert (length(pos) + length(neg) == length(y));

% class f   requencies
p_pos = length(pos)/length(y);
p_neg = length(neg)/length(y);

X_pos = X(pos,:);
X_neg = X(neg,:);

X_pos = (X_pos > 0);
X_neg = (X_neg > 0);

% naive conditional probabilities 
pw_pos = (sum(X_pos, 1) + ones(1,m)) / (length(pos)+2);
pw_neg = (sum(X_neg, 1) + ones(1,m)) / (length(neg)+2);

pnw_pos = ones(1,m) - pw_pos;
pnw_neg = ones(1,m) - pw_neg;

%model 
a = sum(log(pnw_pos ./ pnw_neg)) + log(p_pos/p_neg);
b = log( (pw_pos .* pnw_neg) ./ (pw_neg .* pnw_pos));

model = struct('a',a,'b',b);

end

