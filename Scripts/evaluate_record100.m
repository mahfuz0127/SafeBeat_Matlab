load('C:\SafeBeat\Data\100.mat');

predictedLabels = label_log;    % from Simulink logs

groundTruth = true_labels;      % from annotations

confMat = confusionmat(groundTruth,predictedLabels);

disp(confMat);