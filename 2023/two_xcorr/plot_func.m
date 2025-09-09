%�Լ��Ľ��
logicalIndex = abs(result1.t123) < 0.001  & abs(result1.Rcorr) > 0.3;
% logicalIndex = abs(result1.t123) < 1 & abs(result1.Rcorr) > 0.3 &  result1.Start_loc < 500000000 & result1.Start_loc > 400000000;

filteredTable1 = result1(logicalIndex, :);
Start_loc = filteredTable1.Start_loc;
colorValues = (Start_loc - 3e8) / 2e8;
figure;
scatter(filteredTable1.Azimuth,filteredTable1.Elevation, 1, colorValues, 'filled');
title('Azimuth vs Elevation');
xlabel('Azimuth');
xlim([0, 360]);
xticks(0:40:360);
ylabel('Elevation');
ylim([-40, 100]);
yticks(-40:20:100);
colormap('hsv');
colorbar;
caxis([0, 1.5]);
grid on;

%�Լ��Ľ��
figure;
% logicalIndex = abs(result2.t123) < 1 & abs(result2.Rcorr) > 0.3 &  result2.Start_loc > 500000000 ;
logicalIndex = abs(result2.t123) < 1 & abs(result2.Rcorr) > 0.3  ;
filteredTable2 = result2(logicalIndex, :);
Start_loc = filteredTable2.Start_loc;
colorValues = (Start_loc - 3e8) / 2e8;
figure;
scatter(filteredTable2.Azimuth,filteredTable2.Elevation, 1, colorValues, 'filled');
title('Azimuth vs Elevation');
% xlabel('Azimuth');
% xlim([0, 360]);
% xticks(0:40:360);
% ylabel('Elevation');
% ylim([58, 60]);
% yticks(58:20:100);
colormap('hot');
colorbar;
caxis([0, 1.5]);
grid on;

%���
% logicalIndex = abs(Untitled.VarName11) < 1 & abs(Untitled.VarName12) > 0.25 & Untitled.Paramers >500000000;
logicalIndex = abs(Untitled.VarName11) < 1 & abs(Untitled.VarName12) > 0.25 & Untitled.Paramers > 5.2e8 & Untitled.Paramers < 5.4e8 ;
filteredTable3 = Untitled(logicalIndex, :);
Start_loc = filteredTable3.Paramers;
colorValues = (Start_loc - 3e8) / 2e8;
figure;
scatter(filteredTable3.VarName5,filteredTable3.VarName6, 1, colorValues, 'filled');
title('Azimuth vs Elevation');
xlabel('Azimuth');
xlim([0, 360]);
xticks(0:40:360);
ylabel('Elevation');
ylim([-40, 100]);
yticks(-40:20:100);
colormap('hsv');
colorbar;
caxis([0, 1.5]);
grid on;





% ������������
plot(ch1, 'b');
hold on;
plot(filtered_signal1-500, 'r');
legend('ch1', 'filteredch1');
xlabel('��������');
ylabel('��ֵ');
title('bp filter');







x = downsample(filtered_signal1,50);
plot(x)
subplot(3,1,1);plot(ch1);title('ch1');xlabel('��������');ylabel('��ֵ');
subplot(3,1,2);plot(filtered_signal1);title('ch1kalman');xlabel('��������');ylabel('��ֵ');
subplot(3,1,3);plot(filtered_signal3);title('ch3');xlabel('��������');ylabel('��ֵ');





scatter(filteredTable1.cos_alpha_opt,filteredTable1.cos_beta_opt,2);
xlim([-1, 1]);
% ָ��y�᷶Χ�Ϳ̶ȱ��
ylim([-1, 1]);

scatter(Untitled.VarName5,Untitled.VarName6,1);
xlim([0, 360]);
xticks(0:40:360);
% ָ��y�᷶Χ�Ϳ̶ȱ��
ylim([0, 90]);
yticks(0:20:90);
scatter(result1.VarName10,result1.VarName11);
scatter(result1.cos,result1.cos1);
histogram(result.VarName11);
histogram(Untitled.VarName6);
subplot(3,1,1);plot(signal3);title('ch1');xlabel('��������');ylabel('��ֵ');
%���ú�������Ϊ32

subplot(3,1,2);plot(filtered_signal3);title('ch2');xlabel('��������');ylabel('��ֵ');

subplot(3,1,3);plot(filtered_signal3);title('ch3');xlabel('��������');ylabel('��ֵ');


plot(lag12_msw,R12_msw);
plot(ch1);
 %�����ϲ����Ա�ͼ
plot(ch3_gcc_new, 'b');
hold on;
plot(ch3_upsp(:,1), ch3_upsp(:,2), 'r--');
legend('ch3����', '�ϲ���ch3����');
xlabel('��������');
ylabel('��ֵ');
plot(lag12_gcc,R12_gcc);

 %�����ϲ����Ա�ͼ
plot(filtered_signal1, 'b');
hold on;
plot(ch1, 'r--');
legend('ch2����', '�ϲ���ch2����');
xlabel('��������');
ylabel('��ֵ');
axis auto


% ������������
plot(ch1, 'b');
hold on;
plot(IMF(:,3), 'r--');
legend('ch1����', '���˺��ch1����');
xlabel('��������');
ylabel('��ֵ');
title('���ݻ�������ߵ����ֵ��������ƽ�ƵĽ��');

% ������������
plot(ch1_gcc_new, 'b');
hold on;
plot(ch3_gcc_new, 'r--');
legend('ԭ�ź�', 'ƽ�ƺ�');
xlabel('��������');
ylabel('��ֵ');
title('���');