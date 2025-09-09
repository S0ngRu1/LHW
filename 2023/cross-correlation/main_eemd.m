%��ȡ����
signal_length = 2e3;
sig = read_signal('20190604164852.7960CH1.dat',signal_length);
fs = 200e6;
t = (0:signal_length-1) * 1e6/fs; % ��ʱ�䵥λ�����Ϊ΢��
figure('color','white')
plot(t, sig, 'k') % ����ԭʼ�ź�
xlabel('Time (\mu s)') % ���� x ���ǩ��λΪ΢��
ylabel('Amplitude')
title('Original Signal')
%EEMD�ֽ�
Nstd = 0.2; %NstdΪ����������׼����Y��׼��֮��
NE = 20;   %NEΪ���źŵ�ƽ������
imf = eemd(sig,Nstd,NE);

%����EEMD�ĸ���IMFͼ�����Ӧ��Ƶ��ͼ
i = size(imf, 2);
figure;
for j = 1:i
    % ����IMF�ź�ͼ
    subplot(i, 1, j);
    plot(imf(:,j));
    title(['IMF' num2str(j) ' �ź�']);
    
end

figure;
for j = 1:i
% ���㲢����IMF�źŵ�Ƶ��ͼ
    subplot(i, 1, j);
    fs = 200e6;
    fft_signal = fft(imf(:,j));
    n = length(fft_signal);
    x = (0:n/2-1) * (fs/n);
    plot(x, 2.0 / n * abs(fft_signal(1:n/2)));
    title(['IMF' num2str(j) ' Ƶ��']);
end


%�ź��ع�
indices = [3];  
filtered_imfs = imf(:,indices);
filtered_signal1 = sum(filtered_imfs, 2);
ori = sig;  %�������ź�
fil = filtered_signal1;  %�˲����ź�
figure('color','w')
subplot(211);plot(sig,'k');title('ԭʼ�ź�')
subplot(212);plot(fil,'k');title('�˲����ź�')

%��ͨ�˲�
filtered_bandpass = bandpass(fil, [40e6 80e6],200e6);


plot_signal_spectrum(fil);

plot_signal_spectrum(sig);

plot_signal_spectrum(filtered_bandpass);

figure('color','w')
subplot(211);plot(fil,'k');title('ԭʼ�ź�')
subplot(212);plot(filtered_bandpass,'k');title('�˲����ź�')

[r12,lags12] = xcorr(sig,filtered_bandpass,'normalized');

figure
plot(lags12,r12)
