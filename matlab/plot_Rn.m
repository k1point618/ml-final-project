function [ output_args ] = plot_Rn(X, y, svm)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

agreement = Agreement(X, y, svm);

n = length(agreement);

plot(sort(agreement), [1:n]/n);
end

