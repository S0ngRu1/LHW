
%����t123
result1.t123 = result1.t12 + result1.t23-result1.t13;
%������е����ϵ������Ϊ����0.����ɸѡ
% logicalIndex = abs(result1.corr12) > 0.3 & abs(result1.corr13) > 0.3 & abs(result1.corr23) > 0.3 & abs(result1.t123) < 1;
logicalIndex = abs(result1.t123) < 1 & abs(result1.Rcorr) > 0.3;
filteredTable1 = result1(logicalIndex, :);
% %��ͼ
scatter(filteredTable1.Azimuth,filteredTable1.Elevation,1);
% scatter(result1.Azimuth,result1.Elevation,1);
xlim([0, 360]);
xticks(0:40:360);
% ָ��y�᷶Χ�Ϳ̶ȱ��
ylim([-40, 100]);
yticks(-40:20:100);

figure;
logicalIndex = abs(result2.t123) < 1 & abs(result2.Rcorr) > 0.3;
filteredTable2 = result2(logicalIndex, :);
% %��ͼ
scatter(filteredTable2.Azimuth,filteredTable2.Elevation,1);
% scatter(result1.Azimuth,result1.Elevation,1);
xlim([0, 360]);
xticks(0:40:360);
% ָ��y�᷶Χ�Ϳ̶ȱ��
ylim([-40, 100]);
yticks(-40:20:100);


scatter(filteredTable1.cos,filteredTable1.cos1,2);
xlim([-1, 1]);
% ָ��y�᷶Χ�Ϳ̶ȱ��
ylim([-1, 1]);

figure;
logicalIndex = abs(Untitled.VarName11) < 0.001 & abs(Untitled.VarName12) > 0.3;
filteredTable2 = Untitled(logicalIndex, :);
scatter(filteredTable2.VarName5,filteredTable2.VarName6,1);
xlim([0, 360]);
xticks(0:40:360);
% ָ��y�᷶Χ�Ϳ̶ȱ��
ylim([-40, 100]);
yticks(-40:20:100);

scatter(result1.VarName10,result1.VarName11);
scatter(result1.cos,result1.cos1);
histogram(result.VarName11);
histogram(Untitled.VarName6);

subplot(3,1,1);plot(ch1_gcc);title('ch1');xlabel('��������');ylabel('��ֵ');
%���ú�������Ϊ32
xticks(0:1024:3072);
subplot(3,1,2);plot(ch2_gcc);title('ch2');xlabel('��������');ylabel('��ֵ');
xticks(0:1024:3072);
subplot(3,1,3);plot(ch3_gcc);title('ch3');xlabel('��������');ylabel('��ֵ');
xticks(0:1024:3072);

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
plot(ch1_gcc, 'b');
hold on;
plot(ch3_new(idx-98:idx+91), 'r--');
legend('ch1����', 'ƽ�ƺ�ch3����');
xlabel('��������');
ylabel('��ֵ');
title('���ݻ�������ߵ����ֵ��������ƽ�ƵĽ��');