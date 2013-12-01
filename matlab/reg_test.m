% for polynomial kernel K(x,z) = (1+c*x.z)^p
kernel_param.p = 2; kernel_param.c = 1; 

% for the radial basis kernel k(x,z) = exp(-1/2 beta*||x-z||^2)
kernel_param.beta = 1; 

% regularization parameter
lambda = .1; 

% load/process time course data; 
data = load('timecourse.dat');
[X,y] = process_data(data,3);

set(0,'DefaultLineLineWidth',2)    
set(0,'DefaultAxesFontSize',14)        

n = round(0.6*size(y,1)); 
train.X = X(1:n,:); train.y = y(1:n); 
test.X = X(n+1:end,:); test.y = y(n+1:end);

model = build_reg(train.X,train.y,lambda,@Kradialbasis,kernel_param);
%model = build_reg(train.X,train.y,lambda,@Klinear,kernel_param);
ytr = eval_reg(train.X,model); 
yte = eval_reg(test.X,model);

figure(1); 
plot([[train.y;test.y],[ytr;yte]]); hold on; 
plot([[train.y;test.y],[ytr;yte]],'o'); 
n = size(train.y,1); plot([n,n],[min(train.y),max(train.y)],'k');
grid on;
hold off; 

fprintf('train RMSE = %6.4f\n', sqrt(mean((train.y-ytr).^2)));
fprintf('test  RMSE = %6.4f\n', sqrt(mean((test.y-yte).^2)));
