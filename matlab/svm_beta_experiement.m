load('data_other_features.mat');
Y = after_day_labels;
X = rand(length(after_day_labels), 10);

NUM_ITERATION = 5;
betas = [0.001:0.001:0.01 0.015:0.005:0.05 0.6:0.1:1];
C = 1;

avg_test_errors = zeros(1, length(betas));
avg_train_errors = zeros(1, length(betas));

for j=1:length(betas)

    j
    test_errors = zeros(1, NUM_ITERATION);
    train_errors = zeros(1, NUM_ITERATION);

    for i=1:NUM_ITERATION
        [ trainX, trainY, testX, testY ] = split_data(X, sign(Y+0.00001), .85);

        model = svm_build(trainX, trainY, C, betas(j));
        train_errors(i) = test2(trainX, trainY, model, trainX, trainY);
        test_errors(i) = test2(trainX, trainY, model, testX, testY);

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

