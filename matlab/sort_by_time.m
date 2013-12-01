function [ sorted_news, sorted_article_labels ] = sort_by_time( news, article_labels )
% Sorts by time

temp = sortrows([article_labels [1:size(article_labels, 1)]'], 4);

sorted_article_labels = temp(:, 1:4);
sorted_news = news(temp(:, 5), :);

end

