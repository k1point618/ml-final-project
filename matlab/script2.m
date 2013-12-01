load('news.mat');
X = news;

load('after_day_label');
Y = after_day_label;

NUM_ITERATION = 10;
test_errors = zeros(1, NUM_ITERATION);
train_errors = zeros(1, NUM_ITERATION);

for i=1:NUM_ITERATION
    i
    [ trainX, trainY, testX, testY ] = split_data(X, sign(Y+0.00001), .85);

    model = svm_build(trainX, trainY, 1, 20);
    train_errors(i) = test2(trainX, trainY, model, trainX, trainY);
    test_errors(i) = test2(trainX, trainY, model, testX, testY);
    
end

train_errors
test_errors