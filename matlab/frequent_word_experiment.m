

'Frequent Word Experiment'

load('data.mat');
X = (news > 0); % rounding for nbc 
y = sign(after_day_labels + .00001);
[ trainX2, trainY, testX, testY ] = split_data(X, y, .8);


%  number of words
m = size(X, 2)

word_sums = sum(X,1);
sorted_words = sort(word_sums);

threshold = sorted_words(floor(m*.9));

frequent = find(word_sums > threshold);
infrequent = find(word_sums <= threshold);

length(frequent)
length(infrequent)

trials = 25

test_correctness = zeros(trials,1);
test_correctness2 = zeros(trials,1);

for trial = 1:trials
    
    
    
    [ trainX, trainY, testX, testY ] = split_data(X, y, .8);
    
    trainX2 = trainX(:,infrequent);
    testX2 = testX(:,infrequent);
    
    model1 = nbc_build(trainX, trainY);
    model2 = nbc_build(trainX2, trainY);
    
    out1 = testX * model1.b' + model1.a;
    test_correctness(trial) = sum(out1 .* testY > 0 )/length(testY);

    out2 = testX2 * model2.b' + model2.a;
    test_correctness2(trial) = sum(out2 .* testY > 0 )/length(testY);
end

mean(test_correctness)
mean(test_correctness2)