load('data.mat');
X = news;
Y = after_day_labels;

NUM_ITERATION = 5;
beta = 0.008;
C = [0.1:0.1:1 2:1:10];

avg_test_errors = zeros(1, length(betas));
avg_train_errors = zeros(1, length(betas));

for j=1:length(C)

    test_errors = zeros(1, NUM_ITERATION);
    train_errors = zeros(1, NUM_ITERATION);

    for i=1:NUM_ITERATION
        [ trainX, trainY, testX, testY ] = split_data(X, sign(Y+0.00001), .85);

        model = svm_build(trainX, trainY, C(j), beta);
        train_errors(i) = test2(trainX, trainY, model, trainX, trainY);
        test_errors(i) = test2(trainX, trainY, model, testX, testY);

    end

    avg_test_errors(j) = sum(test_errors)/length(test_errors);
    avg_train_errors(j) = sum(train_errors)/length(train_errors);

end
    
avg_test_errors
avg_train_errors

plot(C, avg_test_errors);
hold on;
plot(C, avg_train_errors);
hold off;

