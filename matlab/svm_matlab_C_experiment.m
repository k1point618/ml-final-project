% Using MATLAB version of SVM. We fix C and try 40 different values of beta
% in order to find the value of beta that gives the min error for the 
% LOOCV(10%) test.

load('data.mat');
X_s = S;
X_v1 = V1;
X_v2 = V2;
X_v3 = V3;
X_v4 = V4;
X_c1 = C1;
X_c2 = C2;

all_features = {X_s, X_v1, X_v2, X_v3, X_v4, X_c1, X_c2};
feature_str = {'S', 'V1', 'V2', 'V3', 'V4', 'C1', 'C2'};
Y = sign(y);

betas = [0.006, 0.006, 0.03, 0.02, 0.04, 0.001, 0.007];
C = [0.005 0.01:0.01:0.1 0.2:0.1:1 1:10]; %28 values of C
Variable = C;

% Want the best beta for each feature. 
% The training and test error for that beta.
BEST_C = zeros(1, length(all_features));
TRAIN_ERRORS = zeros(1, length(all_features));
TEST_ERRORS = zeros(1, length(all_features));
RAW_DATA = cell(2, length(all_features));

for i=1:length(all_features)
    
    X = all_features{i};
    feature = i-1 % in order to index S as 0 and Vi as i.
    beta = betas(i)
    
    avg_test_errors = zeros(1, length(Variable));
    avg_train_errors = zeros(1, length(Variable));

    for j=1:length(Variable)

        C = Variable(j)
        assert(sum(Y==0)==0)
        [avg_test_errors(j), avg_train_errors(j)] = LOOCV(X, Y, Variable(j), betas(i));

    end

    best_idx = find(avg_test_errors==min(avg_test_errors), 1, 'first');
    BEST_C(i) = betas(best_idx)
    TRAIN_ERRORS(i) = avg_train_errors(best_idx)
    TEST_ERRORS(i) = avg_test_errors(best_idx)
    RAW_DATA{1, i} = avg_test_errors;
    RAW_DATA{2, i} = avg_train_errors;
    
    % Now plot the Training and Test Error of this Feature
    figure
    plot(C, avg_test_errors, 'Color', 'blue', 'LineWidth', 1.5);
    hold on;
    plot(C, avg_train_errors, 'Color', 'red', 'LineWidth', 1.5);

    title(strcat('C Experiment: Feature ', feature_str{i}), 'FontSize', 20)
    xlabel('Error Rate', 'FontSize', 16)
    ylabel('Beta', 'FontSize', 16)

end


