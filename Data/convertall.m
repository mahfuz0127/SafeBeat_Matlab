clc;
clear;

dataFolder = 'C:\SafeBeat\Data';
outputFolder = 'C:\SafeBeat\MAT';

if ~exist(outputFolder,'dir')
    mkdir(outputFolder);
end

% Move to record folder
cd(dataFolder)

heaFiles = dir('*.hea');

for k = 1:length(heaFiles)

    [~,recordName,~] = fileparts(heaFiles(k).name);

    fprintf('Processing %s\n',recordName);

    try

        [signal,Fs,tm] = rdsamp(recordName);

        [ann,anntype] = rdann(recordName,'atr');

        ecg = signal(:,1);

        save(fullfile(outputFolder,...
            [recordName '.mat']),...
            'ecg','Fs','ann','anntype');

        fprintf('Saved %s.mat\n',recordName);

    catch ME

        fprintf('FAILED: %s\n',recordName);
        disp(ME.message)

    end

end