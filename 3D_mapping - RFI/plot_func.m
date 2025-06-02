%���1
logicalIndex = abs(result1.t123) < 1 & abs(result1.Rcorr) > 0.3;
% logicalIndex = abs(result1.t123) <1 & abs(result1.Rcorr) > 0.3 &  result1.Start_loc < 523418116+3.3e7 & result1.Start_loc > 451501808+3.3e7;
filteredTable1 = result1(logicalIndex, :);
Start_loc = filteredTable1.Start_loc;
% colorValues = (Start_loc - 3e8) / 2e8;
colorValues = (Start_loc - min(Start_loc)) / (max(Start_loc) - min(Start_loc));
% ת�� Azimuth ��Χ�� 0-360 �� -180-180
filteredTable1.Azimuth = mod(filteredTable1.Azimuth - 180, 360) - 180;
figure;
scatter(filteredTable1.Azimuth,filteredTable1.Elevation, 2, colorValues, 'filled');
title('Azimuth vs Elevation');
xlabel('Azimuth');
xlim([-180, 180]); % �޸� x �᷶Χ
xticks(-180:40:180);
ylabel('Elevation');
ylim([-40, 100]);
yticks(-40:20:100);
colormap('hsv');
colorbar;
caxis([0, 1.5]);
grid on;
% 
% %���2
% figure;
 logicalIndex = abs(result2.t123) <1 & abs(result2.Rcorr) > 0.3 &  result2.Start_loc < 5e8 & result2.Start_loc > 4.5e8;
% logicalIndex = abs(result2.t123) < 1 & abs(result2.Rcorr) > 0.3;
filteredTable2 = result2(logicalIndex, :);
index = 1:256:size(filteredTable2, 1);
Start_loc = filteredTable2.Start_loc;
colorValues = (Start_loc - 3e8) / 2e8;
figure;
scatter(filteredTable2.Azimuth,filteredTable2.Elevation, 1, colorValues, 'filled');
title('Azimuth vs Elevation');
xlabel('Azimuth');
xlim([0, 360]);
xticks(0:40:360);
ylabel('Elevation');
ylim([-40, 100]);
yticks(-40:20:100);
colormap('jet');
colorbar;
caxis([0, 1.5]);
grid on;

% %���3
% logicalIndex = abs(result3.t123) > 0.001 & abs(result3.Rcorr) < 0.2 &  result3.Start_loc < 600000000 & result3.Start_loc > 400000000;
% filteredTable3 = result3(logicalIndex, :);
% Start_loc = filteredTable3.Start_loc;
% colorValues = (Start_loc - 3e8) / 2e8;
% figure;
% scatter(filteredTable3.Azimuth,filteredTable3.Elevation, 1, colorValues, 'filled');
% title('Azimuth vs Elevation');
% xlabel('Azimuth');
% xlim([0, 360]);
% xticks(0:40:360);
% ylabel('Elevation');
% ylim([-40, 100]);
% yticks(-40:20:100);
% colormap('hsv');
% colorbar;
% caxis([0, 1.5]);
% grid on;



original_signal_length = 60000;
original_signal_loc =4.5e8 ;
sub_filter_signal_length = 60000;
chj_signal3 = read_signal('../2024 822 85933.651462CH3.dat', original_signal_length, original_signal_loc+165/5);
filtered_chj_signal3 = rfi_filter(chj_signal3,sub_filter_signal_length);
subplot(2,1,1);plot(chj_signal3);title('chj_signal3');xlabel('��������');ylabel('��ֵ');
subplot(2,1,2);plot(filtered_chj_signal3);title('filtered_chj_signal3');xlabel('��������');ylabel('��ֵ');








signal_length = 6000;
r_loction_yld =470170313;
r_loction_chj = 504925409;
ch_yld = read_signal('..\\20240822165932.6610CH1.dat',signal_length,r_loction_yld);
ch_chj = read_signal('..\\2024 822 85933.651462CH1.dat',signal_length,r_loction_chj);
% filtered_yld = rfi_filter(ch_yld,1536);
% filtered_chj = rfi_filter(ch_chj,1536);
filtered_yld = filter_bp(ch_yld,20e6,80e6,5);
filtered_chj = filter_bp(ch_chj,20e6,80e6,5);
subplot(2,1,1);plot(filtered_yld);title('yld');xlabel('��������');ylabel('��ֵ');
subplot(2,1,2);plot(filtered_chj);title('chj');xlabel('��������');ylabel('��ֵ');
[r_gcc, lags_gcc] = xcorr(filtered_yld, filtered_chj, 'normalized');
R_gcc = max(r_gcc);
t_gcc = cal_tau(r_gcc, lags_gcc');

 filtered_chj_signal1 = waveletDenoiseAdaptive(ch2, level, wavelet);
 filtered_chj_signal2 = filter_bp(ch2,20e6,80e6,5);
x1 = downsample(ch1,50);
x2 = downsample(ch2,50);
x3 = downsample(ch3,50);
% x3 = downsample(ch3,50);
subplot(3,1,1);plot(ch1);title('ch1');xlabel('��������');ylabel('��ֵ');
subplot(3,1,2);plot(data_filter1);title('wf');xlabel('��������');ylabel('��ֵ');
subplot(3,1,3);plot(filter2);title('bp');xlabel('��������');ylabel('��ֵ');


original_signal_length = 8e7;
original_signal_loc = 4.8e8;
sub_filter_signal_length = 60000;
yld_signal1 = read_signal('../2024 822 85933.651462CH1.dat', original_signal_length, original_signal_loc);
filtered_yld_signal1 = rfi_filter(yld_signal1,sub_filter_signal_length);
plot(filtered_yld_signal1)

%�źŲ�������ֵ�Ա�ͼ
N = 5e7; % �ź��ܳ���
subsignal_length = 4000;
M = ceil(N / subsignal_length); % �ܶ���
subsignal_start = 1:subsignal_length:length(filtered_signal1);
for subi = 1:numel(subsignal_start)
subsignal1 = filtered_signal1(subsignal_start(subi):subsignal_start(subi)+subsignal_length-1);
threshold =  mean(abs(subsignal1)) + 3*std(subsignal1);
end
% ����ÿ�ε���ֵ�Ѿ�����ã��洢�� thresholds ��
threshold = rand(1, M) * 5; % ʾ����ֵ��ʵ�����������ֵ�滻
% �����ź�
figure;
plot(filtered_signal1, 'b', 'LineWidth', 1.5); % �����źţ���ɫ��
hold on;
% ����ÿ�ε���ֵ
for i = 1:M
    start_index = (i - 1) * subsignal_length + 1;
    end_index = min(i * subsignal_length, N); % ��ֹ���һ�γ����źų���
    x = [start_index, end_index]; % ��ǰ�ε� x ��Χ
    y = [threshold(i), threshold(i)]; % ��ǰ�ε���ֵ
    plot(x, y, 'r--', 'LineWidth', 1.5); % �ú�ɫ���߻�����ֵ
end
% ���ͼ���ͱ�ǩ
legend('filtered_signal1', 'Thresholds');
xlabel('Sample Index');
ylabel('Amplitude');
title('Signal and Thresholds Comparison');
grid on; % �������
hold off;







subplot(3,1,1);plot(ch1);title('ch1');xlabel('��������');ylabel('��ֵ');
subplot(3,1,2);plot(ch2);title('ch2');xlabel('��������');ylabel('��ֵ');
subplot(3,1,3);plot(ch3);title('ch3');xlabel('��������');ylabel('��ֵ');







fs = 200e6;
signal_length = 71916308;
r_loction = 451501808;
ch1_yld = read_signal('..\\20240822165932.6610CH1.dat',signal_length,r_loction);
ch1_chj = read_signal('..\\2024 822 85933.651462CH1.dat',signal_length,r_loction + 3.3e7);
ch2 = read_signal('..\\2024 822 85933.651462CH2.dat',signal_length,r_loction);
ch3 = read_signal('..\\2024 822 85933.651462CH3.dat',signal_length,r_loction+165/5);

% ��ƴ�ͨ�˲���
[b, a] = butter(4, [20e6, 80e6] / (fs / 2), 'bandpass'); 
% ���źŽ��д�ͨ�˲�
filtered_signal1 = filter(b, a, ch1);
filtered_signal2 = filter(b, a, ch2);
filtered_signal3 = filter(b, a, ch3);

%bp
filtered_signal1_yld = filter_bp(ch1_yld, 20e6 ,80e6 ,5);
filtered_signal1_chj = filter_bp(ch1_chj, 20e6 ,80e6 ,5);
filtered_signal3 = filter_bp(ch3, 20e6 ,80e6 ,5);








subplot(3,1,1);plot(filtered_signal1);title('ch1');xlabel('��������');ylabel('��ֵ');
subplot(3,1,2);plot(filtered_signal2);title('ch2');xlabel('��������');ylabel('��ֵ');
subplot(3,1,3);plot(filtered_signal3);title('ch3');xlabel('��������');ylabel('��ֵ');


plot(ch3,'b');
hold on;
plot(filtered_signal3 +50,'r');
legend('ԭ�ź�','�˲���');
xlabel('��������');
ylabel('��ֵ');


[R1_x, R1_y, R1_z] = sph2cart(deg2rad(181.588691),deg2rad(49.691292),1);
% �������ǣ���λ���ȣ�
theta = asin(R1_z) * (180/pi); % ȡֵ��ΧΪ [-90, 90] ��
% ���㷽λ�ǣ���λ���ȣ�
phi = atan2(R1_y, R1_x) * (180/pi); % ȡֵ��ΧΪ [-180, 180] ��
% �����Ҫ����λ��ת��Ϊ [0, 360) ��Χ
if phi < 0
    phi = phi + 360;
end
% ������
fprintf('��λ�� (Azimuth): %.2f ��\n', phi);
fprintf('���� (Elevation): %.2f ��\n', theta);



