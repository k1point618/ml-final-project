% Using MATLAB version of SVM. We fix beta and try different values of C
% in order to find the value of C that gives the min error for the 
% LOOCV(10%) test.

load('___.mat');
X_s = S;
X_v1 = V1;
X_v2 = V2;
X_v3 = V3;
X_v4 = V4;
X_c1 = C1;
X_c2 = C2;

all_features = {X_s, X_v1, X_v2, X_v3, X_v4, X_c1, X_c2};
%all_features = {X_s, X_v1};
feature_str = {'S', 'V1', 'V2', 'V3', 'V4', 'C1', 'C2'};
Y = y;

beta =
C = [0.1:0.2:1 2:5];

Variable = C;

% Want the best beta for each feature. The training and test error for that
% beta.
BETAS = zeros(1, length(all_features));
TRAIN_ERRORS = zeros(1, length(all_features));
TEST_ERRORS = zeros(1, length(all_features));
RAW_DATA = cell(2, length(all_features));

for i=1:length(all_features)
    
    X = all_features{i};
    fearure = i
    
    avg_test_errors = zeros(1, length(Variable));
    avg_train_errors = zeros(1, length(Variable));

    for j=1:length(Variable)

        beta = Variable(j)
        [avg_test_errors(j), avg_train_errors(j)] = LOOCV(X, sign(Y+0.00001), C(j), beta);

    end

    best_idx = find(min(avg_test_errors));
    BETAS(i) = betas(best_idx);
    TRAIN_ERRORS(i) = avg_train_errors(best_idx);
    TEST_ERRORS(i) = avg_test_errors(best_idx);
    RAW_DATA{1, i} = avg_test_errors;
    RAW_DATA{2, i} = avg_train_errors;
   
    % Now plot the Training and Test Error of this Feature
    figure
    plot(betas, avg_test_errors, 'Color', 'blue', 'LineWidth', 1.5);
    hold on;
    plot(betas, avg_train_errors, 'Color', 'red', 'LineWidth', 1.5);

    title(strcat('Beta Experiment: Feature ', feature_str{i}), 'FontSize', 20)
    xlabel('Error Rate', 'FontSize', 16)
    ylabel('Beta', 'FontSize', 16)
    
end
