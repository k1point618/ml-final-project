load('data.mat');
Y = after_day_labels;
X = news;

betas = [0.001:0.001:0.1];
%C = [0.01:0.05:1];

Variable = betas;

avg_test_errors = zeros(1, length(Variable));
avg_train_errors = zeros(1, length(Variable));

for j=1:length(Variable)
    
    betas(j)
    test_errors = zeros(1, NUM_ITERATION);
    train_errors = zeros(1, NUM_ITERATION);

    [avg_test_errors(j), avg_train_errors(j)] = LOOCV(X, sign(Y+0.00001), 1, betas(j));
    
end
    
avg_test_errors
avg_train_errors

plot(Variable, avg_test_errors);
hold on;
plot(Variable, avg_train_errors);
hold off;

