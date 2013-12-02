
'Naive Bayes Classifier Experiment'

load('data.mat');
X = (news > 0);
y = sign(after_day_labels + .00001);
[ trainX, trainY, testX, testY ] = split_data(X, y, .8);


model = nbc_build(trainX, trainY);

trainOut = trainX * model.b' + model.a;
train_correctness = sum(trainOut .* trainY > 0 )/length(trainY)

testOut = testX * model.b' + model.a;
test_correctness = sum(testOut .* testY > 0 )/length(testY)
