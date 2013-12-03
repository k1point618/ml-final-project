

'Infrequent Word Experiment'

load('data.mat');
X = news;
y = sign(after_day_labels + .00001);


%  number of words
m = size(X, 2)
C = 1;
beta = 3;

word_sums = sum(X,1);
sorted_words = sort(word_sums);
threshold = sorted_words(floor(m*.1));


frequent = find(word_sums > threshold);
infrequent = find(word_sums <= threshold);
length(frequent)
length(infrequent)


X2 = X(:,frequent);

result1 = LOOCV( X, y, C, beta);
result2 = LOOCV( X2, y, C, beta);

test_error1 = result1(1)
test_error2 = result2(1)
    