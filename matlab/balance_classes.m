function [ X, y ] = balance_classes( X, y )

num_pos = sum(y == 1);
num_neg = sum(y == -1);

assert (num_pos + num_neg == length(y));

smaller = min(num_pos, num_neg);
p1 = randperm(num_pos);
p2 = randperm(num_neg);

pos = find(y ==1);
neg = find(y ==-1);
pos = pos(p1);
neg = neg(p2);

index = [pos(1:smaller) neg(1:smaller)];

X = X(index, :);
y = y(index, :);

end
