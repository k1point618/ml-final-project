% Using MATLAB version of SVM. We fix beta and try different values of C
% in order to find the value of C that gives the min error for the 
% LOOCV(10%) test.

load('data.mat');
Y = after_day_labels;
X = news;

beta = 3;
C = [0.01, 0.1, 1, 10, 100, 1000];

Variable = C;

avg_test_errors = zeros(1, length(Variable));
avg_train_errors = zeros(1, length(Variable));

for j=1:length(Variable)
    
    Variable(j)
    [avg_test_errors(j), avg_train_errors(j)] = LOOCV(X, sign(Y+0.00001), Variable(j), beta);
    
end
    
avg_test_errors
avg_train_errors

plot([-2:3], avg_test_errors);
hold on;
plot([-2:3], avg_train_errors);
hold off;

