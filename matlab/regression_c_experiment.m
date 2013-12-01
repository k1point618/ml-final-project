load('data.mat');
X = news;
y = sign(after_day_labels + 00001);

'Regression Experiment'

NUM_ITERATION = 5;
%betas = [0.2:0.2:1, 2:2:20];
%betas=[0.01:0.01:0.1];

C = [0.1:0.1:1]
beta = 0.001

avg_test_errors = zeros(1, length(C));
avg_train_errors = zeros(1, length(C));

for j=1:length(C)

    j
    % script-FOUR is for REGRESSION

    test_errors = zeros(1, NUM_ITERATION);
    train_errors = zeros(1, NUM_ITERATION);

    for i=1:NUM_ITERATION
        [ trainX, trainY, testX, testY ] = split_data(X, y, .85);

        model = build_reg(trainX,trainY,C(j),@Krb,beta);
        train_errors(i) = 1-sum(eval_reg(trainX, model).*trainY >0)/length(trainY);
        test_errors(i) = 1-sum(eval_reg(testX, model).*testY >0)/length(testY);

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

