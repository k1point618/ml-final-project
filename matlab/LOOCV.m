function [ test_error, train_error ] = LOOCV( X, Y, C, beta)
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
    
    SVMstruct = svmtrain(trainX,trainY,'Kernel_Function','rbf',...
        'boxconstraint', C, 'rbf_sigma', sqrt((1/beta)*0.5));
    
    train_errors(i) = sum((svmclassify(SVMstruct,trainX).*trainY)<0)/length(trainY);
    test_errors(i) = sum((svmclassify(SVMstruct,testX).*testY)<0)/length(testY);
    
end

test_error = sum(test_errors)/length(test_errors);
train_error = sum(train_errors)/length(train_errors);
