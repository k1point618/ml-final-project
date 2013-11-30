function [K] = Krb(X1,X2,kernel_param)

if (nargin<3), kernel_param = 1; end;

K = repmat(sum(X1.^2,2),1,size(X2,1)); 
K = K + repmat(sum(X2.^2,2)',size(X1,1),1);
K = exp(-0.5*kernel_param*(K - 2*X1*X2')); 

