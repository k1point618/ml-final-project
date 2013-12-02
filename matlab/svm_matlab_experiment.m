load('data.mat');
Y = after_day_labels;
X = news;

NUM_ITERATION = 5;
betas = [0.015:0.005:0.05 0.6:0.1:1];
C = 1;

avg_test_errors = zeros(2, length(betas));
avg_train_errors = zeros(2, length(betas));

for j=1:length(betas)

    
    test_errors = zeros(1, NUM_ITERATION);
    train_errors = zeros(1, NUM_ITERATION);

    for i=1:NUM_ITERATION
        [ trainX, trainY, testX, testY ] = split_data(X, sign(Y+0.00001), .85);

        SVMstruct = svmtrain(trainX,trainY,'Kernel_Function','rbf', ...
            'rbf_sigma', betas(j), 'boxconstraint', C);
        
        train_errors(i) = sum((svmclassify(SVMstruct,trainX).*trainY)<0)/length(trainY);
        test_errors(i) = sum((svmclassify(SVMstruct,testX).*testY)<0)/length(testY);
    
%         model = svm_build(trainX, trainY, C, betas(j));
%         
%         train_errors(2, i) = test2(trainX, trainY, model, trainX, trainY);
%         test_errors(2, i) = test2(trainX, trainY, model, testX, testY);

    end

    avg_test_errors(j) = sum(test_errors)/length(test_errors);
    avg_train_errors(j) = sum(train_errors)/length(train_errors);

end
    
avg_test_errors
avg_train_errors

plot(betas, avg_test_errors);
hold on;
plot(betas, avg_train_errors);
hold off;

