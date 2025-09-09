%��ȡ����
signal_length = 2e8;
ch1 = read_signal('20190604164852.7960CH1.dat',signal_length);
ch2 = read_signal('20190604164852.7960CH2.dat',signal_length);
ch3 = read_signal('20190604164852.7960CH3.dat',signal_length); 

% plot_signal_spectrum(ch1);
% x_down = downsample(ch1,20);
% plot(x_down); 
window_length = 1024;   
windows =1:256:signal_length-window_length+1;
N = 3;
d = 20;
c = 0.299552816;
fs = 200e6;

angle12 = -150;
angle13 = -90;
angle23 = -30;


% ��һ���ı��ļ�����д�����н��
fileID = fopen('result4.data2023.txt', 'w');
% д���һ�е����ݽ���
fprintf(fileID, '%-13s%-15s%-15s%-15s%-15s%-15s%-15s%-15s%-15s%-15s\n', ...
    'Start_loc','t12', 't13', 't23', 'cos_alpha_opt', 'cos_beta_opt','Azimuth', 'Elevation', 'Rcorr', 't123');


%�������д���
for  wi = 1:numel(windows)
%   ���ź�
    signal1 = ch1(windows(wi):windows(wi)+window_length-1);
    signal2 = ch2(windows(wi):windows(wi)+window_length-1);
    signal3 = ch3(windows(wi):windows(wi)+window_length-1);


%   �˲�
    filtered_signal1 = real(filter_fft(signal1,20e6 ,80e6));
    filtered_signal2 = real(filter_fft(signal2,20e6 ,80e6));
    filtered_signal3 = real(filter_fft(signal3,20e6 ,80e6));

    %ȥֱ������
    signal1_removed = detrend(filtered_signal1);
    signal2_removed = detrend(filtered_signal2);
    signal3_removed = detrend(filtered_signal3);

    % ���˲�����ź�Ӧ�ô�����
    windowed_signal1 = windowsignal(signal1_removed);
    windowed_signal2 = windowsignal(signal2_removed);
    windowed_signal3 = windowsignal(signal3_removed);
    %�������ź�
    ch1_new = real(windowed_signal1);
    ch2_new = real(windowed_signal2);
    ch3_new = real(windowed_signal3);
 
%     [~,r12,lags12] = gccphat(ch1_new,ch2_new);
%     [~,r13,lags13] = gccphat(ch1_new,ch3_new);
%     [~,r23,lags23] = gccphat(ch2_new,ch3_new);
    
    [r12,lags12] = xcorr(ch1_new,ch2_new,'normalized');
    [r13,lags13] = xcorr(ch1_new,ch3_new,'normalized');
    [r23,lags23] = xcorr(ch2_new,ch3_new,'normalized');
    

    R12 = max(r12);
    R13 = max(r13);
    R23 = max(r23);
    %�����ϵ�����������ϲ���
    r12_upsp = upsampling_gc(r12,lags12,8);
    r13_upsp = upsampling_gc(r13,lags13,8);
    r23_upsp = upsampling_gc(r23,lags23,8);

    t12 = showfitted(r12_upsp)*5;
    t13 = showfitted(r13_upsp)*5;
    t23 = showfitted(r23_upsp)*5;

%     % �������� A ������ B
%     A = [sqrt(3)/2 1/2; sqrt(3)/2 -1/2; 0 1];
%     B = [c*t12/d; c*t13/d; c*t23/d];
%     % ʹ����������������Է���������Ž�
%     result = A \ B;
%     % ������ŵ�cos(��)��cos(��)ֵ
%     cos_alpha_opt = result(1);
%     cos_beta_opt = result(2);

    cos_alpha_0 = c*t23*tand(angle23)/(d*sind(angle23)*(tand(angle23) - tand(angle12))) - c*t12/(d*cosd(angle12)*(tand(angle23)-tand(angle12)));
    cos_beta_0 = (c*t12-d*cos_alpha_0*sind(angle12))/(d*cosd(angle12));
    if abs(cos_beta_0)>1 || abs(cos_alpha_0)>1
        continue;
    end
    x0 = [cos_alpha_0,cos_beta_0];
    % ����lsqnonlin���������Ż�
    options = optimoptions('lsqnonlin', 'MaxIter', 1000, 'TolFun', 1e-6);
    x = lsqnonlin(@objective, x0, [-1 -1],[1 1], options);
    % ������ŵ�cos(��)��cos(��)ֵ
    cos_alpha_opt = x(1);
    cos_beta_opt = x(2);
    if abs(cos_alpha_opt)>1 || abs(cos_beta_opt)>1
        continue;
    end
    Az = atan2( cos_alpha_opt,cos_beta_opt);
    if abs(cos_beta_opt/cos(Az)) > 1
        continue;
    end
    El = acos( cos_beta_opt/cos(Az) );
    % ������ת��Ϊ�Ƕ�
    Az_deg = rad2deg(Az);
    El_deg = rad2deg(El);
    if Az_deg < 0
       Az_deg = Az_deg + 360;
    end


    t123 = t12 + t23 - t13;
    Rcorr = (R12 + R13 + R23)/3;
    % д�����������
        fprintf(fileID, '%-13d%-15.6f%-15.6f%-15.6f%-15.6f%-15.6f%-15.6f%-15.6f%-15.6f%-15.6f\n', ...
             300000000+windows(wi), t12, t13, t23, cos_alpha_opt, cos_beta_opt, Az_deg, El_deg, Rcorr,t123);
end
% �ر��ļ�
fclose(fileID);