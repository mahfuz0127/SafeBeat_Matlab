clc;
clear;

Fs = 360;              % Sampling frequency
t = 0:1/Fs:10;         % 10 seconds

% ECG-like waveform
ecg = 1.2*sin(2*pi*1.2*t);

% Add Gaussian noise
noise = 0.4*randn(size(t));

% Noisy ECG
ecg_noisy = ecg + noise;

% Format for Simulink From Workspace block
ecgSignal = [t' ecg_noisy'];

assignin('base','ecgSignal',ecgSignal);

% Plot
figure;
subplot(2,1,1);
plot(t,ecg);
title('Original ECG');
grid on;

subplot(2,1,2);
plot(t,ecg_noisy);
title('Noisy ECG');
grid on;