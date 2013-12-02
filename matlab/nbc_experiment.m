
'Naive Bayes Classifier Experiment'

load('data.mat');
X = news;
y = sign(after_day_labels + 00001);
[ trainX, trainY, testX, testY ] = split_data(X, y, .8);


model = nbc_build(trainX, trainY);
out = testX * model.b' + model.a;

correct_rate = sum(out .* testY > 0 )/length(testY)