
function [ train_error, test_error, model ] = svm_train(X, y, C, beta)

y = arrayfun( @(a) ( a> 0)*2 - 1, y); % make all labels 1 or -1

trials = 5;
errors = zeros(trials,2);

for trial = 1:trials

    [ trainX, trainY, testX, testY ] = split_data(X, y, .80);
    model = svm_build(trainX, trainY, C, beta);
    errors(trial, :) = [test2(trainX, trainY, model, trainX, trainY),...
            test2(trainX, trainY, model, testX, testY)];
end

train_error = mean(errors(:,1));
test_error = mean(errors(:,2));

end
