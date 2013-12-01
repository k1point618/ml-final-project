function [y] = eval_reg(X,model)

% fill in missing parts 
Kx = feval(model.kernel,X,model.X,model.kernel_param); 
[n, d] = size(X);
one = ones(n, 1);
y = Kx * model.alpha + model.theta0 * one;
%y


