function [ sorted_news, sorted_article_labels ] = sort_by_time( news, article_labels )
% Sorts by time

m = size(article_labels,2);

temp = sortrows([article_labels [1:size(article_labels, 1)]'], 4);

sorted_article_labels = temp(:, 1:m);
sorted_news = news(temp(:, m+1), :);

end

