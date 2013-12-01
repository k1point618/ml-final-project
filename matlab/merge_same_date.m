function [ merged_news, merged_article_labels ] = merge_same_date( news, article_labels )

% If two articles are on the same day, merge them. 
labels = article_labels(:, 1);
labels2 = article_labels(:, 2);
labels3 = article_labels(:, 3);

diff = labels(1:length(labels)-1, :) - labels(2:length(labels));
delete_idx = find(diff == 0);
save_idx = diff~=0;

merged_article_labels = article_labels(save_idx, :);

merged_news = news;

for i=1:length(delete_idx)
    id = delete_idx(i);
    article = news(id, :);
    merged_news(id-1, :) = merged_news(id-1, :) + article;
    
    index = true(1, size(merged_news, 1));
    index(id) = false;
    merged_news = merged_news(index, :);
    delete_idx = delete_idx - 1;
end

