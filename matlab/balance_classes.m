function [ X, y ] = balance_classes( X, y )

num_pos = sum(y > 0);
num_neg = sum(y < 0);

assert (num_pos + num_neg == length(y));

smaller = min(num_pos, num_neg);
p1 = randperm(num_pos);
p2 = randperm(num_neg);

pos = find(y > 0);
neg = find(y < 0);
pos = pos(p1);
neg = neg(p2);

index = [pos(1:smaller) neg(1:smaller)];
p3 = randperm(2*smaller);
index = index(p3);

X = X(index, :);
y = y(index, :);

end
