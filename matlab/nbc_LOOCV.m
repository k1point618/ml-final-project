function [ test_error, train_error ] = nbc_LOOCV(X, Y)
% Leave One-hundred Out Cross Validation.
K = 200;
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
    
    model = nbc_build(trainX, trainY);
    trainOut = trainX * model.b' + model.a;
    train_errors(i) =  sum(trainOut .* trainY <= 0 )/length(trainY);

    testOut = testX * model.b' + model.a;
    test_errors(i) = sum(testOut .* testY <= 0 )/length(testY);
end

test_error = mean(test_errors);
train_error = mean(train_errors);
