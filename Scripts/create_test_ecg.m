% create_test_ecg.m

Fs = 360;          % Sampling frequency
t = 0:1/Fs:10;     % 10 seconds

ecg = 1.2*sin(2*pi*1.2*t)+ ...
       0.3*sin(2*pi*2.4*t);

ecgSignal = [t' ecg'];

assignin('base','ecgSignal',ecgSignal);