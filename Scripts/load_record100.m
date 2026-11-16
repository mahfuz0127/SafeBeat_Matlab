clear;
clc;

fid = fopen('100.dat','r');

A = fread(fid,[3 inf],'uint8')';
fclose(fid);

M = size(A,1);

sig1 = zeros(M,1);
sig2 = zeros(M,1);

for i = 1:M

    b1 = A(i,1);
    b2 = A(i,2);
    b3 = A(i,3);

    sample1 = bitshift(bitand(b2,15),8) + b1;

    sample2 = bitshift(bitand(b2,240),4) + b3;

    if sample1 > 2047
        sample1 = sample1 - 4096;
    end

    if sample2 > 2047
        sample2 = sample2 - 4096;
    end

    sig1(i) = sample1;
    sig2(i) = sample2;

end

Fs = 360;

ecg = sig1;

t = (0:length(ecg)-1)/Fs;

save('103.mat','ecg','Fs','t');

disp('Record 103 loaded successfully');