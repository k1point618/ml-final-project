load('news.mat');
X = news;

load('after_day_label');
Y = after_day_label;

NUM_ITERATION = 20;
%betas = [0.2:0.2:1, 2:2:20];
%betas=[0.001:0.001:0.01];
betas = [0.001:0.001:0.01 0.015:0.005:0.05 0.6:0.1:1];
C = [0.1:0.1:1 2:1:10];

avg_test_errors = zeros(length(C), length(betas));
avg_train_errors = zeros(length(C), length(betas));

for k=1:length(betas)
    
    for j=1:length(C)

        test_errors = zeros(1, NUM_ITERATION);
        train_errors = zeros(1, NUM_ITERATION);

        for i=1:NUM_ITERATION
            [ trainX, trainY, testX, testY ] = split_data(X, sign(Y+0.00001), .85);

            model = svm_build(trainX, trainY, C(j), betas(k));
            train_errors(i) = test2(trainX, trainY, model, trainX, trainY);
            test_errors(i) = test2(trainX, trainY, model, testX, testY);

        end

        avg_test_errors(j, k) = sum(test_errors)/length(test_errors);
        avg_train_errors(j, k) = sum(train_errors)/length(train_errors);

    end
    
end
avg_test_errors
avg_train_errors

% plot(C, avg_test_errors);
% hold on;
% plot(C, avg_train_errors);
% hold off;

