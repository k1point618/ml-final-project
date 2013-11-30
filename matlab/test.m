function [ test_error ] = test(trainX,trainY,model,testX,testY)
    agreement = arrayfun( @(i) evaluate(trainX, trainY, model, testX(i)) * testY(i),...
                        1: length(testY));
    minimum_agreement = min(agreement)
    errors = arrayfun(@(a) a <= 0, agreement);
    test_error = sum(errors)/length(errors);                
end

function [ y ] = evaluate(trainX, trainY, model, x)
    y = sum(arrayfun( @(i) trainY(i)*model.alpha(i)*model.kernel(trainX(i),x,model.kparam) , 1:length(trainY)));
end