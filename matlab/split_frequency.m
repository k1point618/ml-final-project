function [infrequent, frequent] = split_frequency(X, fraction)

%  number of words
m = size(X, 2);

word_sums = sum(X,1);
sorted_words = sort(word_sums);
threshold = sorted_words(floor(m*fraction));

freq_index = find(word_sums > threshold);
infreq_index = find(word_sums <= threshold);

frequent = X(:,freq_index);
infrequent = X(:,infreq_index);

end


    