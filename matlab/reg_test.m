% for polynomial kernel K(x,z) = (1+c*x.z)^p
kernel_param.p = 2; kernel_param.c = 1; 

% for the radial basis kernel k(x,z) = exp(-1/2 beta*||x-z||^2)
kernel_param.beta = 0.008; 

% regularization parameter
lambda = .1; 

% load/process time course data; 
% data = load('timecourse.dat');
% [X,y] = process_data(data,3);

set(0,'DefaultLineLineWidth',2)    
set(0,'DefaultAxesFontSize',14)        

n = round(0.6*size(Y,1)); 
[trainX, trainY, testX, testY] = split_data(X, Y, 0.8);

model = build_reg(trainX,trainY,lambda,@Krb,kernel_param.beta);
%model = build_reg(train.X,train.y,lambda,@Klinear,kernel_param);
ytr = eval_reg(trainX,model); 
yte = eval_reg(testX,model);

figure(1); 
plot([[trainY;testY],[ytr;yte]]); hold on; 
plot([[trainY;testY],[ytr;yte]],'o'); 
n = size(trainY,1); plot([n,n],[min(trainY),max(trainY)],'k');
grid on;
hold off; 

fprintf('train RMSE = %6.4f\n', sqrt(mean((trainY-ytr).^2)));
fprintf('test  RMSE = %6.4f\n', sqrt(mean((testY-yte).^2)));
