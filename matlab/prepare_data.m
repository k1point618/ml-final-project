function [ output_args ] = prepare_data( dir )

% SOURCE 1
% article_labels(:,1:4) is today close, tomorrow open, tomorrow close, date
% article_labels(:,5:end) gives some historical prices
article_labels = csvread(strcat(dir, '/article_labels.mat'));
historical_prices = article_labels(:,5:end);

% SOURCE 2
% word count vector
word_counts = csvread(strcat(dir, '/news.mat'));

% SOURCE 3
% other features are sentiment, length, etc
other = csvread(strcat(dir, '/other_features.mat'));


% row operations: merge, sort, balance

n1 = size(word_counts,2);
n2 = size(historical_prices,2);
n3 = size(other, 2);

total = [word_counts historical_prices other];
[ total, article_labels ] = merge_same_date(total, article_labels);
[ total, article_labels ] = sort_by_time(total, article_labels );

after_day_labels = article_labels(:,2) - article_labels(:,1);
y = after_day_labels + .00001;
assert(sum(y==0) == 0);

[ total, y ] = balance_classes(total, y);

% extract final feature matrices

S = total(:,1:n1);
[foo, V1] = split_frequency(S,.1);
[V2, foo] = split_frequency(S,.9);

V3 = total(:,n1+n2+1:end);
V4 = total(:,n1+1:n1+n2);
C1 = total(:,n1+1:end);
C2 = total(:,1:n1+n2);

save('data.mat', 'S', 'V1', 'V2', 'V3', 'V4','C1','C2', 'y');

end

