% Using MATLAB version of SVM. We fix C and try 40 different values of beta
% in order to find the value of beta that gives the min error for the 
% LOOCV(10%) test.

load('data.mat');
Y = after_day_labels;
X = news;

beta = [0.001:0.001:0.01 0.02:0.01:0.1 0.2:0.1:1 1:10]; %40 values of beta.
C = 1;

Variable = beta;

avg_test_errors = zeros(1, length(Variable));
avg_train_errors = zeros(1, length(Variable));

for j=1:length(Variable)
    
    Variable(j)
    [avg_test_errors(j), avg_train_errors(j)] = LOOCV(X, sign(Y+0.00001), C, Variable(j));
    
end
    
avg_test_errors
avg_train_errors

plot(beta, avg_test_errors);
hold on;
plot(beta, avg_train_errors);
hold off;

