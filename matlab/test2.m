function [ error_rate ] = test2( trainX, trainY, svm, testX, testY)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% initialize A matrix
K = feval(@Krb,testX,trainX,svm.kparam);
%K = diag(y)*K*diag(y);

alpha = svm.alpha .* trainY;
agreement = testY .* (K*alpha) * svm.gamma;

errors = (agreement <= 0);

error_rate = sum(errors)/length(errors);

end
