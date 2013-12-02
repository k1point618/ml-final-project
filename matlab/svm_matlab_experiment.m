% Uses the MATLAB implementation of the SVM, but ran using our
% implementation of LOOCV. Prints both the average test and training error
% from LOOCV (10%).

load('data.mat');
Y = after_day_labels;
X = news;

beta = % fill
C = % fill

[test_error, train_error] = LOOCV(X, sign(Y+0.00001), C, beta)
