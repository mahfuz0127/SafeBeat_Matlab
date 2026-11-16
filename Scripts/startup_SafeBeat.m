
clc;
clear;

% SafeBeat project directory
projectPath = 'C:\SafeBeat';

% Set working directory
cd(projectPath);

% Add project folders to MATLAB path
addpath(genpath(projectPath));

% Find ECG generation script
scriptFile = fullfile(projectPath, 'script', 'create_test_ecg.m');

if ~isfile(scriptFile)
    scriptFile = fullfile(projectPath, 'scripts', 'create_test_ecg.m');
end

% Generate ECG signal
if isfile(scriptFile)
    run(scriptFile);
    disp('ECG signal generated successfully!');
else
    error('create_test_ecg.m was not found!');
end

% Verify ECG variable
assert(exist('ecgSignal', 'var') == 1, ...
    'ecgSignal was not created!');

disp('SafeBeat is ready for simulation!');
