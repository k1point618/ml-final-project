function [ agreement ] = Agreement( X, y, svm)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

n = length(y);  % y is n x 1

% initialize A matrix
K = feval(@Krb,X,X,svm.kparam);
%K = diag(y)*K*diag(y);

alpha = svm.alpha .* y;
agreement = y .* (K*alpha) * svm.gamma;

end

