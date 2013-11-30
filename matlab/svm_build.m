
function [svm]= svm_build(X,y,C,kparam)

n = length(y);  % y is n x 1

% initialize A matrix
A = feval(@Krb,X,X,kparam); 
A = diag(y)*A*diag(y);

% solve dual problem...
options_org = optimset(@quadprog);
options = optimset(options_org, 'MaxIter',int32(10000));
options = optimset(options,'Display','off'); 
alpha = quadprog(A,-ones(n,1),[],[],[],[],zeros(n,1),repmat(C,n,1),zeros(n,1),options);

% select support vectors
svm_eps = max(alpha)*1e-6; 
S = find(alpha > svm_eps);
NS = length(S);

alpha_y = alpha(S).*y(S);
XS = X(S,:);

svm.kernel = @Krb;
svm.kparam = kparam;
svm.alpha_y = alpha_y;
svm.alpha = alpha;
svm.NS = NS; 
svm.XS = XS;

%computing the margin gamma
theta_norm=sqrt(alpha(S)'*(A(S,S)*alpha(S)));
svm.theta_norm = theta_norm;
svm.gamma=1/theta_norm;
