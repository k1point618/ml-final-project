'Extra Features Experiment'

C = 1;
beta = 3;

% Lets do a four way comparison between:
% words only, others only, words + others, title only

load('data.mat');
words = news;
y = sign(after_day_labels + .00001);

load('data_other_features.mat');
others = news;
y2 = sign(after_day_labels + .00001);

load('data_title_only.mat');
titles = news;
y3 = sign(after_day_labels + .00001);


words_others = [words others];

samples = size(words,1);
assert(size(others,1) == samples);
assert(size(titles,1) == samples);
assert(size(y,1) == samples);
assert(norm(y - y2) == 0);
assert(norm(y2 - y3) == 0);


[test1, train1] = LOOCV( words, y, C, beta)
[test2, train2] = LOOCV( titles, y, C, beta)
[test3, train3] = LOOCV( others, y, C, beta)
[test4, train4] = LOOCV( words_others, y, C, beta)


