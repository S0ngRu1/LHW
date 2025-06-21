%���1
% logicalIndex = abs(result1.t123) < 1 & abs(result1.Rcorr) > 0.3;
logicalIndex = abs(result1.t123) <0.5 & abs(result1.Rcorr) > 0.4 &  result1.Start_loc < r_loction + signal_length & result1.Start_loc > r_loction;
filteredTable1 = result1(logicalIndex, :);
Start_loc = filteredTable1.Start_loc;
% colorValues = (Start_loc - 3e8) / 2e8;
colorValues = (Start_loc - min(Start_loc)) / (max(Start_loc) - min(Start_loc));
% ת�� Azimuth ��Χ�� 0-360 �� -180-180
% filteredTable1.Azimuth = mod(filteredTable1.Azimuth - 180, 360) - 180;
figure;
scatter(filteredTable1.Azimuth,filteredTable1.Elevation, 2, colorValues, 'filled');
title('Azimuth vs Elevation');
xlabel('Azimuth');
xlim([0, 360]); % �޸� x �᷶Χ
xticks(0:40:360);
ylabel('Elevation');
ylim([0,90]);
yticks(0:10:90);
colormap('hot');
colorbar;
caxis([0, 1.5]);
grid on;


% %���2
logicalIndex = abs(resultyldclustermethod.t123) <1 & abs(resultyldclustermethod.Rcorr) > 0.3 ;
filteredTable1 = resultyldclustermethod(logicalIndex, :);
figure;
scatter(filteredTable1.Azimuth,filteredTable1.Elevation, 2, 'filled');
title('Azimuth vs Elevation');
xlabel('Azimuth');
xlim([0, 360]); % �޸� x �᷶Χ
xticks(0:40:360);
ylabel('Elevation');
ylim([0,90]);
yticks(0:10:90);
grid on;
% 
% %���2
% figure;
% logicalIndex = abs(result2.t123) <1 & abs(result2.Rcorr) > 0.3 &  result2.Start_loc <4e8 & result2.Start_loc > 3.6e8;
logicalIndex = abs(result2.t123) < 1 & abs(result2.Rcorr) > 0.5;
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
ylim([0, 90]);
yticks(0:10:90);
colormap('hot');
colorbar;
caxis([0, 1.5]);
grid on;

% %���3
logicalIndex = abs(result3.t123) < 1 & abs(result3.Rcorr) > 0.3;
% logicalIndex = abs(result3.t123) <1 & abs(result3.Rcorr) > 0.3 &  result3.Start_loc < 434189858 & result3.Start_loc > 399845561;
filteredTable3 = result3(logicalIndex, :);
Start_loc = filteredTable3.Start_loc;
colorValues = (Start_loc - 3e8) / 2e8;
figure;
scatter(filteredTable3.Azimuth,filteredTable3.Elevation, 1, colorValues, 'filled');
title('Azimuth vs Elevation');
xlabel('Azimuth');
xlim([0, 360]);
xticks(0:40:360);
ylabel('Elevation');
ylim([0, 90]);
yticks(0:10:90);
colormap('hot');
colorbar;
caxis([0, 1.5]);
grid on;



signal_length = 8e5;
r_loction_yld = 4.694e8;
r_loction_chj = 4.694e8+34236594-93364;
ch_yld = read_signal('..\\20240822165932.6610CH1.dat',signal_length,r_loction_yld);
ch_chj = read_signal('..\\2024 822 85933.651462CH1.dat',signal_length,r_loction_chj);
% rfi_filtered_yld = rfi_filter(ch_yld,60000);
% filtered_chj = rfi_filter(ch_chj,1536);
% xb_filtered_yld = filter_xb(ch_yld);
% xb_filtered_chj = filter_xb(ch_chj);
bp_filtered_yld = filter_bp(ch_yld,30e6,80e6,5);
bp_filtered_chj = filter_bp(ch_chj,30e6,80e6,5);
subplot(2,1,1);plot(bp_filtered_yld);title('yld');xlabel('��������');ylabel('��ֵ');
subplot(2,1,2);plot(bp_filtered_chj);title('xb_filtered_yld');xlabel('��������');ylabel('��ֵ');
subplot(3,1,3);plot(bp_filtered_yld);title('bp_filtered_yld');xlabel('��������');ylabel('��ֵ');

plot(bp_filtered_chj,'r','LineWidth', 1.5)
hold on
plot(ch_chj,'b','LineWidth', 1.5)

[r_gcc, lags_gcc] = xcorr(bp_filtered_chj, bp_filtered_yld, 'normalized');
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

%����25%�˲�


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






signal_length = 1e7;
% r_loction = 4.2e8;
ch1_yld = read_signal('..\\20240822165932.6610CH1.dat',signal_length,3.65e8);
ch1_chj = read_signal('..\\2024 822 85933.651462CH1.dat',signal_length,3.65e8+34236156);
figure;
subplot(2,1,1);plot(ch1_yld);title('yld');
subplot(2,1,2);plot(ch1_chj);title('chj');


% ���� .mat �ļ�
load('E:\˫վ\���_�Զ�У׼\all_match_results_3.6-4.8_new.mat');
% ���ṹ������ת��Ϊ���
resultsTable = struct2table(all_match_results);
% ������Ϊ Excel �ļ�
writetable(resultsTable, 'E:\\˫վ\\���_�Զ�У׼\\output.xlsx');







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


chj_noise1 = read_signal('..\\2024 822 85933.651462CH1.dat',1e8,1e8);
chj_ch1 = read_signal('..\\2024 822 85933.651462CH1.dat',2e7,3.5e8);
data1 = load('chj_noise1.mat');
chj_Noise1 = (data1.chj_noise1)';
chj_R1 = cov(chj_Noise1); 
Q = 0.5;
%�˲�
kalmanfiltered_chj1 = KalmanFilter(chj_ch1,Q,chj_R1);
subplot(2,1,1);plot(chj_ch1);title('chj');xlabel('��������');ylabel('��ֵ');
subplot(2,1,2);plot(kalmanfiltered_chj1);title('filtered_chj');xlabel('��������');ylabel('��ֵ');
