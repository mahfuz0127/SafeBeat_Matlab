clc;
clear;

X = [
0.10 0.30 120 1.2;
0.15 0.25 130 1.1;
0.12 0.28 125 1.3;
0.80 0.90 350 3.5;
0.75 0.85 340 3.2;
0.82 0.88 360 3.8
];

Y = [0;0;0;1;1;1];

svmModel = fitcsvm(...
    X,...
    Y,...
    'KernelFunction','rbf',...
    'Standardize',true);

svmModel = fitPosterior(svmModel);

save('../Models/SafeBeatSVM.mat','svmModel');

disp('Model Saved Successfully');