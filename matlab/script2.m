load('data_merged_dates.mat');
X = news;
Y = after_day_labels;

% author: kgu

idx = find(abs(Y)>0.001);
newX = X(idx,:);
newY = Y(idx,:);

NUM_ITERATION = 20;
test_errors = zeros(1, NUM_ITERATION);
train_errors = zeros(1, NUM_ITERATION);

for i=1:NUM_ITERATION
    
    i

    [ trainX, trainY, testX, testY ] = split_data(newX, sign(newY+0.00001), .85);

    model = svm_build(trainX, trainY, 1, 0.008);
    train_errors(1, i) = test2(trainX, trainY, model, trainX, trainY);
    test_errors(1, i) = test2(trainX, trainY, model, testX, testY);
        
end

train_errors
test_errors

error = sum(test_errors)/NUM_ITERATION
beep