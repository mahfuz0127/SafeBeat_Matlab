clc;
clear;

[ann,anntype] = rdann('C:\SafeBeat\Data\100','atr');

disp('First 20 annotations:')
disp(anntype(1:20))
uniqueTypes = unique(anntype);

disp(uniqueTypes)
for k = 1:length(uniqueTypes)

    fprintf('%s : %d\n', ...
        uniqueTypes(k), ...
        sum(anntype == uniqueTypes(k)));

end
save('C:\SafeBeat\Data\annotations100.mat',...
     'ann','anntype');
Fs = 360;

timeSec = ann/Fs;

n = min(100,length(timeSec));

plot(timeSec(1:n),ones(n,1),'r*')
grid on
title('MIT-BIH Record 100 Annotations')
xlabel('Time (s)')
