clc;
clear;
close all;

%% =========================================================
% SAFEBEAT ECG ANALYSIS
% Generates:
% 1. Summary MAT file
% 2. Master CSV
% 3. ECG Plots
% 4. SQI Plot
% 5. Confidence Plot
% 6. Diagnosis Plot
% 7. Acceptance Plot
% 8. Dashboard Plot
% 9. Metrics CSV
% =========================================================

%% RECORD SELECTION

recordID = 230;

%% LOAD ECG FILE

fileName = fullfile('C:\SafeBeat\MAT', ...
    sprintf('%d.mat',recordID));

load(fileName);

%% CREATE TIME VECTOR

t = (0:length(ecg)-1)'/Fs;

%% CREATE SIMULINK INPUT

ecgSignal = [t ecg];

%% RUN MODEL

assignin('base','ecgSignal',ecgSignal);

out = sim('Safebeat_v1');

%% OUTPUT EXTRACTION

LabelLog      = out.LabelLog;
ConfidenceLog = out.ConfidenceLog;
SQILog        = out.SQILog;
AcceptedLog   = out.AcceptedLog;
DiagnosisLog  = out.DiagnosisLog;

%% CREATE SUMMARY

Summary.Record      = recordID;
Summary.Label       = mode(LabelLog);
Summary.Confidence  = mean(ConfidenceLog);
Summary.SQI         = mean(SQILog);
Summary.Accepted    = mode(double(AcceptedLog));
Summary.Diagnosis   = mode(DiagnosisLog);

%% CREATE RESULT FOLDERS

resultsFolder = 'C:\SafeBeat\Results';

if ~exist(resultsFolder,'dir')
    mkdir(resultsFolder);
end

figFolder = fullfile(resultsFolder,'Figures');

if ~exist(figFolder,'dir')
    mkdir(figFolder);
end

%% SAVE SUMMARY MAT FILE

save( ...
    fullfile(resultsFolder,...
    sprintf('Record%d_Summary.mat',recordID)),...
    'Summary');

%% UPDATE MASTER CSV

csvFile = fullfile(resultsFolder,...
    'All_Records_Summary.csv');

T = struct2table(Summary);

if exist(csvFile,'file')

    oldT = readtable(csvFile);

    oldT(oldT.Record==recordID,:) = [];

    newT = [oldT; T];

    writetable(newT,csvFile);

else

    writetable(T,csvFile);

end

%% =========================================================
% FIGURE 1 : RAW ECG
%% =========================================================

f1 = figure('Visible','off');

plot(t,ecg,'b');

xlabel('Time (s)');
ylabel('Amplitude');

title(sprintf('Record %d Raw ECG',recordID));

grid on;

saveas(f1,...
    fullfile(figFolder,...
    sprintf('Record%d_RawECG.png',recordID)));

close(f1);

%% =========================================================
% FIGURE 2 : FIRST 10 SECONDS ECG
%% =========================================================

samples10 = min(length(ecg),Fs*10);

f2 = figure('Visible','off');

plot(t(1:samples10), ...
     ecg(1:samples10), ...
     'k');

xlabel('Time (s)');
ylabel('Amplitude');

title('ECG First 10 Seconds');

grid on;

saveas(f2,...
    fullfile(figFolder,...
    sprintf('Record%d_ECG10sec.png',recordID)));

close(f2);

%% =========================================================
% FIGURE 3 : SQI TREND
%% =========================================================

f3 = figure('Visible','off');

plot(SQILog,...
    'LineWidth',1.5);

xlabel('Beat Number');
ylabel('SQI');

title('Signal Quality Index');

ylim([0 1]);

grid on;

saveas(f3,...
    fullfile(figFolder,...
    sprintf('Record%d_SQI.png',recordID)));

close(f3);

%% =========================================================
% FIGURE 4 : CONFIDENCE TREND
%% =========================================================

f4 = figure('Visible','off');

plot(ConfidenceLog,...
    'r',...
    'LineWidth',1.5);

xlabel('Beat Number');
ylabel('Confidence');

title('Classification Confidence');

ylim([0 1]);

grid on;

saveas(f4,...
    fullfile(figFolder,...
    sprintf('Record%d_Confidence.png',recordID)));

close(f4);

%% =========================================================
% FIGURE 5 : DIAGNOSIS TIMELINE
%% =========================================================

f5 = figure('Visible','off');

stairs(DiagnosisLog,...
    'LineWidth',2);

xlabel('Beat Number');
ylabel('Class');

title('Diagnosis Timeline');

yticks([0 1]);
yticklabels({'Normal','PVC'});

grid on;

saveas(f5,...
    fullfile(figFolder,...
    sprintf('Record%d_Diagnosis.png',recordID)));

close(f5);

%% =========================================================
% FIGURE 6 : CONFIDENCE HISTOGRAM
%% =========================================================

f6 = figure('Visible','off');

histogram(ConfidenceLog,20);

xlabel('Confidence');
ylabel('Count');

title('Confidence Distribution');

grid on;

saveas(f6,...
    fullfile(figFolder,...
    sprintf('Record%d_ConfidenceHistogram.png',recordID)));

close(f6);

%% =========================================================
% FIGURE 7 : ACCEPTED / REJECTED
%% =========================================================

f7 = figure('Visible','off');

stairs(double(AcceptedLog),...
    'LineWidth',2);

xlabel('Beat Number');
ylabel('Status');

title('Signal Acceptance');

ylim([-0.1 1.1]);

yticks([0 1]);
yticklabels({'Rejected','Accepted'});

grid on;

saveas(f7,...
    fullfile(figFolder,...
    sprintf('Record%d_Accepted.png',recordID)));

close(f7);

%% =========================================================
% FIGURE 8 : DASHBOARD
%% =========================================================

f8 = figure('Visible','off');

subplot(2,2,1)

plot(t(1:samples10),...
     ecg(1:samples10));

title('ECG 10 sec');
grid on;

subplot(2,2,2)

plot(SQILog,...
    'LineWidth',1.5);

title('SQI');
ylim([0 1]);
grid on;

subplot(2,2,3)

plot(ConfidenceLog,...
    'r',...
    'LineWidth',1.5);

title('Confidence');
ylim([0 1]);
grid on;

subplot(2,2,4)

stairs(DiagnosisLog,...
    'LineWidth',2);

title('Diagnosis');
grid on;

sgtitle(sprintf('SafeBeat Dashboard Record %d',recordID));

saveas(f8,...
    fullfile(figFolder,...
    sprintf('Record%d_Dashboard.png',recordID)));

close(f8);

%% =========================================================
% CALCULATE METRICS
%% =========================================================

Metrics.Record = recordID;

Metrics.MeanSQI = mean(SQILog);
Metrics.MaxSQI = max(SQILog);
Metrics.MinSQI = min(SQILog);

Metrics.MeanConfidence = mean(ConfidenceLog);
Metrics.MaxConfidence = max(ConfidenceLog);
Metrics.MinConfidence = min(ConfidenceLog);

Metrics.AcceptanceRate = ...
    mean(double(AcceptedLog))*100;

%% SAVE METRICS

metricsTable = struct2table(Metrics);

writetable(...
    metricsTable,...
    fullfile(resultsFolder,...
    sprintf('Record%d_Metrics.csv',recordID)));

%% =========================================================
% DISPLAY RESULTS
%% =========================================================

fprintf('\n');
fprintf('====================================\n');
fprintf('SAFEBEAT ANALYSIS COMPLETED\n');
fprintf('====================================\n');

fprintf('Record ID        : %d\n',recordID);
fprintf('Mean SQI         : %.4f\n',Metrics.MeanSQI);
fprintf('Mean Confidence  : %.4f\n',Metrics.MeanConfidence);
fprintf('Acceptance Rate  : %.2f %%\n',Metrics.AcceptanceRate);

fprintf('\nFiles Saved To:\n');
fprintf('%s\n',resultsFolder);

fprintf('\nDone Successfully.\n');