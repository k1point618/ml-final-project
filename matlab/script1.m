load('news.mat');
X = news;
load('after_day_label');
Y = after_day_label;

NUM_ITERATION = 10;
errors = zeros(NUM_ITERATION, 1);

for i=1:NUM_ITERATION
    [ trainX, trainY, testX, testY ] = split_data(X, sign(Y+0.00001), .85);

    model = svm_build(trainX, trainY, 1, 1)
    %test(trainX, trainY, model, trainX, trainY)
    errors(i) = test(trainX, trainY, model, testX, testY);
    
end

errors