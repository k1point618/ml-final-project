beta = .0005
C = 1


load('data.mat');

X = news;
y = after_day_labels;

[Xs, ys] = interval_splitter(X, y, 500, 40);

num_intervals = size(ys,3);

train_errors = zeros(num_intervals);
test_errors = zeros(num_intervals);

for interval = 1:num_intervals

    interval

    [ train_error, test_error, model ] = svm_train(Xs(:,:,interval), ys(:,:,interval),C,beta);

    train_errors(interval) = train_error;
    test_errors(interval) = test_error;

end


plot(1:num_intervals, train_errors); hold on;
plot(1:num_intervals, test_errors); hold off;
