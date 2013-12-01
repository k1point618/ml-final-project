function [ rn ] = Rn( X, y, svm, gamma )

n = length(y);  % y is n x 1

% initialize A matrix
K = feval(@Krb,X,X,svm.kparam);
%K = diag(y)*K*diag(y);

alpha = svm.alpha .* y;
rn = sum(y .* (K*alpha) * svm.gamma <= gamma)/n;

end

