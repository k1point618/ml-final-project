function [ test_var, train_var ] = LOOCV( X, Y, C, beta)
% Leave One Out Cross Validation.
% Except that instead of leaving 1 out every time, we leave 10% (or
% variable) of the data to lower the number of iterations. 

K = 100;
intervals = [1:K:length(Y)];
N = length(intervals)-1;

test_errors = zeros(N, 1);
train_errors = zeros(N, 1);

% test_errors = struct('correct_pos', 0, 'correct_neg', 0, 'false_pos',...
%     0, 'false_neg', 0, 'total_pos', 0, 'total_neg', 0);
% train_errors = struct('correct_pos', 0, 'correct_neg', 0, 'false_pos',...
%     0, 'false_neg', 0, 'total_pos', 0, 'total_neg', 0);

for i=1:length(intervals)-1
    
    all_idx = 1:length(Y);
    test_idx = intervals(i):min(intervals(i)+K, length(Y));
    all_idx(test_idx) = 0;
    train_idx = find(all_idx>0);
    
    trainX = X(train_idx, :);
    trainY = Y(train_idx, :);
    testX = X(test_idx, :);
    testY = Y(test_idx, :);
    
    options = optimset('maxiter',1500);
    SVMstruct = svmtrain(trainX,trainY,'Kernel_Function','linear',...
        'boxconstraint', C, 'method', 'QP', 'quadprog_opts',options);
    
%     'training on...'
%     length(trainY)
%     'testing on...'
%     length(testY)
    
%     train_error = get_error_partitions(SVMstruct, trainX, trainY);
%     test_error = get_error_partitions(SVMstruct, testX, testY);
%     
%     train_errors.correct_pos(i) = train_error.correct_pos;
%     train_errors.correct_neg(i) = train_error.correct_neg;
%     train_errors.false_pos(i) = train_error.false_pos;
%     train_errors.false_neg(i) = train_error.false_neg;
%     train_errors.total_pos(i) = train_error.total_pos;
%     train_errors.total_neg(i) = train_error.total_neg;
%     
%     
%     test_errors.correct_pos(i) = test_error.correct_pos;
%     test_errors.correct_neg(i) = test_error.correct_neg;
%     test_errors.false_pos(i) = test_error.false_pos;
%     test_errors.false_neg(i) = test_error.false_neg;
%     test_errors.total_pos(i) = test_error.total_pos;
%     test_errors.total_neg(i) = test_error.total_neg;
    
    
    
   train_errors(i) = sum((svmclassify(SVMstruct,trainX).*trainY)<0)/length(trainY);
   test_errors(i) = sum((svmclassify(SVMstruct,testX).*testY)<0)/length(testY)
    
end

test_var = sum(test_errors)/length(test_errors)
train_var = sum(train_errors)/length(train_errors)
% 
% correct_pos = sum(test_errors.correct_pos)/length(test_errors.correct_pos);
% correct_neg = sum(test_errors.correct_neg)/length(test_errors.correct_pos);
% false_pos = sum(test_errors.false_pos)/length(test_errors.correct_pos);
% false_neg = sum(test_errors.false_neg)/length(test_errors.correct_pos);
% total_pos= sum(test_errors.total_pos)/length(test_errors.total_pos);
% total_neg= sum(test_errors.total_neg)/length(test_errors.total_neg);
% 
% test = struct('correct_pos', correct_pos, 'correct_neg', correct_neg, 'false_pos',...
%     false_pos, 'false_neg', false_neg, 'total_pos', total_pos, 'total_neg', total_neg);
% 
% correct_pos = sum(train_errors.correct_pos)/length(train_errors.correct_pos);
% correct_neg = sum(train_errors.correct_neg)/length(train_errors.correct_pos);
% false_pos = sum(train_errors.false_pos)/length(train_errors.correct_pos);
% false_neg = sum(train_errors.false_neg)/length(train_errors.correct_pos);
% total_pos= sum(train_errors.total_pos)/length(train_errors.total_pos);
% total_neg= sum(train_errors.total_neg)/length(train_errors.total_neg);
% 
% train = struct('correct_pos', correct_pos, 'correct_neg', correct_neg, 'false_pos',...
%     false_pos, 'false_neg', false_neg, 'total_pos', total_pos, 'total_neg', total_neg);




