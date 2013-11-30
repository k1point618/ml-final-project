load('news.mat');
X = news;
load('after_day_label');
y_signed = after_day_label;
y = arrayfun( @(a) ( a> 0)*2 - 1,y_signed);

[ trainX, trainY, testX, testY ] = split_data(X, y, .8);


model = svm_build(trainX, trainY, 1, 1);
test(trainX, trainY, model, trainX, trainY)
test(trainX, trainY, model, testX, testY)