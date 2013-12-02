% Using MATLAB version of SVM. We fix both C and beta. We vary the size of
% the dataset that we use for our LOOCV. The script prints the average test
% errors across different sizes of our datasiet and plots them. 
% Uses more day than the normal 1727 articles. 

load('data_more.mat');
Y = after_day_labels;
X = news;

beta = 3;
C = 1;

Variable = [1500:100:2200, 2277];

avg_test_errors = zeros(1, length(Variable));
avg_train_errors = zeros(1, length(Variable));

for j=1:length(Variable)
    
    X = news(1:Variable(j), :);
    Y = after_day_labels(1:Variable(j), :);
    
    [avg_test_errors(j), avg_train_errors(j)] = LOOCV(X, sign(Y+0.00001), C, beta);
    
end
    
avg_test_errors
avg_train_errors

plot(length(Variable), avg_test_errors);
hold on;
plot(length(Variable), avg_train_errors);
hold off;

