load('data.mat');
X = news;
Y = sign(after_day_labels + 0.00001);

'Regression Experiment'

NUM_ITERATION = 5;
%betas = [0.2:0.2:1, 2:2:20];
%betas=[0.01:0.01:0.1];

C = 1;
betas = [0.1:0.1:1];

avg_test_errors = zeros(1, length(betas));
avg_train_errors = zeros(1, length(betas));

for j=1:length(betas)

    betas(j)

    [avg_test_errors(j), avg_train_errors(j)] = LOOCV_regression(X, Y, C, betas(j));

end

avg_test_errors
avg_train_errors

plot(C, avg_test_errors);
hold on;
plot(C, avg_train_errors);
hold off;

