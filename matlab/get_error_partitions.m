function [ errors ] = get_error_partitions( SVMstruct, testX, testY)

predictY = svmclassify(SVMstruct,testX);

pos = predictY;
pos(pos<0) = 0;
total_pos = sum(pos);

false_pos = sum((pos.*testY)<0)/length(testY);
correct_pos = 1-false_pos;

neg = predictY;
neg(neg>0) = 0;
total_neg = sum(neg);
if abs(total_neg) == 1
    index = find(neg == -1)
end
    
false_neg = sum((neg.*testY)<0)/length(testY);
correct_neg = 1-false_neg;

errors = struct('correct_pos', correct_pos, 'correct_neg', correct_neg, 'false_pos',...
    false_pos, 'false_neg', false_neg, 'total_pos', total_pos, 'total_neg', total_neg);

end

