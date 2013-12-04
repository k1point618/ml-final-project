function [ output_args ] = make_figure( X, Y1, Y2, Title, XLabel, YLabel)
% Now plot the Training and Test Error of this Feature
    figure
    plot(X, Y1, 'Color', 'blue', 'LineWidth', 2);
    hold on;
    plot(X, Y2, 'Color', 'red', 'LineWidth', 2);

    title(Title, 'FontSize', 20)
    xlabel(XLabel, 'FontSize', 16)
    ylabel(YLabel, 'FontSize', 16)

end

