function [ test_error, train_error ] = LOOCV_regression( X, Y, C, beta)
% Leave One Out Cross Validation.
% Except that instead of leaving 1 out every time, we leave 10% (or
% variable) of the data to lower the number of iterations. 

K = ceil(length(Y)/10);
intervals = [1:K:length(Y)];

test_errors = zeros(1, length(intervals));
train_errors = zeros(1, length(intervals));
    
for i=1:length(intervals)
    
    all_idx = 1:length(Y);
    test_idx = intervals(i):min(intervals(i)+K, length(Y));
    all_idx(test_idx) = 0;
    train_idx = find(all_idx>0);
    
    trainX = X(train_idx, :);
    trainY = Y(train_idx, :);
    testX = X(test_idx, :);
    testY = Y(test_idx, :);
    
    
    model = build_reg(trainX,trainY,C,@Krb,beta);
    train_errors(i) = sum(eval_reg(trainX, model).*trainY<0)/length(trainY);
    test_errors(i) = sum(eval_reg(testX, model).*testY<0)/length(testY);
    
end

test_error = sum(test_errors)/length(test_errors);
train_error = sum(train_errors)/length(train_errors);
