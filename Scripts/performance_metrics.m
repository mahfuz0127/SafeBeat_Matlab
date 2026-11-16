clc;
clear;

trueLabels = [0 0 0 1 1 1 0 1 0 1];

predLabels = [0 0 1 1 1 0 0 1 0 1];

TN = sum((trueLabels==0) & (predLabels==0));
FP = sum((trueLabels==0) & (predLabels==1));
FN = sum((trueLabels==1) & (predLabels==0));
TP = sum((trueLabels==1) & (predLabels==1));

cm = [TN FP;
      FN TP];

disp('Confusion Matrix')
disp(cm)

accuracy = (TP+TN)/(TP+TN+FP+FN);
sensitivity = TP/(TP+FN);
specificity = TN/(TN+FP);
precision = TP/(TP+FP);

F1 = 2*(precision*sensitivity) / ...
     (precision+sensitivity);

fprintf('Accuracy    = %.2f %%\n',accuracy*100);
fprintf('Sensitivity = %.2f %%\n',sensitivity*100);
fprintf('Specificity = %.2f %%\n',specificity*100);
fprintf('Precision   = %.2f %%\n',precision*100);
fprintf('F1 Score    = %.2f %%\n',F1*100);