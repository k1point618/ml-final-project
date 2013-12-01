%% Author ernest

% splits X,y into a bunch of partially overlapping intervals.
% each interval is a length of 'interval_length' and is 'shift' after the previous


function [ Xs, ys ] = interval_splitter( X, y, interval_length, shift)

M = size(X,2);
num_intervals = 1+ floor((length(y) - interval_length)/shift)

Xs = zeros(interval_length, M, num_intervals);
ys = zeros(interval_length,1, num_intervals);

    for i = 1:num_intervals
        I = ((i-1)*shift + 1):((i-1)*shift + interval_length);
        
        assert(length(I) == interval_length);
        
        Xs(:,:,i) = X(I,:);
        ys(:,:,i) = y(I,:); 
    end

end

