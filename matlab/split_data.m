function [ trainX, trainY, testX, testY ] = split_data(X, Y, percent_training)
 % Takes in X that is d x M; Y that is M x 1. 
 % X's are features of dimention d;
 % Y's are the M labels.
 % Returns:
 % trainX is the first N columns of the permutated feature vectors.
 %   d x N
 % trainY is the corresponding label of the training data, trainX. 
 %   N x 1
 % testX is the last M-N columns of the permutated feature vectors.
 %   d x (M-N)
 % testY is the corresponding label of the test data, testX. 
 %   (M-N) x 1
 
M = size(Y, 1);

perm = randperm(M);

shuffX = X(perm, :);
shuffY = Y(perm, :);

N = floor(percent_training * M);

trainX = shuffX(1:N, :);
trainY = shuffY(1:N,:);
testX = shuffX(N:end,:);
testY = shuffY(N:end,:);

end

