function [model] = build_reg(X,y,lambda,kernel,kernel_param)

% default arguments
if (nargin<3), lambda = 1; end; 
if (nargin<4), kernel = @Klinear; end;
if (nargin<5), kernel_param = []; end;

K = feval(kernel,X,X,kernel_param); 

n = length(y);

% fill in missing parts
I = eye(n);
one = ones(n);
C = (I - (1/n) * one);
model.alpha  = inv(lambda * I +C*K) * C * y;
%model.alpha

one = ones(1, n);
model.theta0 = 1/n * one * (y-K*model.alpha);
%model.theta0

model.kernel = kernel;
model.kernel_param = kernel_param;
model.X = X; % need to store the training points