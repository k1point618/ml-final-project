load('news.mat');
X = news;

load('after_day_label');
Y = after_day_label;

NUM_ITERATION = 5;
%betas = [0.2:0.2:1, 2:2:20];
%betas=[0.01:0.01:0.1];

C = [0.1:0.1:1]

avg_test_errors = zeros(1, length(betas));
avg_train_errors = zeros(1, length(betas));

for j=1:length(C)
    
    j
    % script-FOUR is for REGRESSION
    
    test_errors = zeros(1, NUM_ITERATION);
    train_errors = zeros(1, NUM_ITERATION);

    for i=1:NUM_ITERATION
        [ trainX, trainY, testX, testY ] = split_data(X, sign(Y+0.00001), .85);

        model = build_reg(trainX,trainY,C(j),@Krb,0.001);
        train_errors(i) = 1-sum(eval_reg(trainX, model).*trainY >0)/length(trainY);
        test_errors(i) = 1-sum(eval_reg(testX, model).*testY >0)/length(testY);

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

