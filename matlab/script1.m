load('news.mat');
X = news;


load('after_day_label');
%y = after_day_label;
y = arrayfun( @(a) ( a> 0)*2 - 1,after_day_label);


[ trainX, trainY, testX, testY ] = split_data(X, y, .80);

model = svm_build(trainX, trainY, 1, .02);

test2(trainX, trainY, model, trainX, trainY)
test2(trainX, trainY, model, testX, testY)

plot_Rn(trainX, trainY, model)
