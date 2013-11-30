function [ test_error ] = test(trainX,trainY,model,testX,testY)
    errors = arrayfun( @(i) evaluate(trainX, trainY, model, testX(i)) == testY(i),...
                        1: length(testY));
    test_error = sum(errors)/length(errors);                
end

function [ y ] = evaluate(trainX, trainY, model, x)
    f = sum(arrayfun( @(i) trainY(i)*model.alpha(i)*model.kernel(trainX(i),x), 1:length(trainY)));
    y = sign(f);
end