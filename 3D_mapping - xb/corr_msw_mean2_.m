clear;
N = 3;
c = 0.299792458;
fs = 200e6;
upsampling_factor = 50;
window_length = 512;
window = window_length * upsampling_factor;
% 从化局
% angle12 = -2.8381;
% angle13 = 50.3964;
% angle23 = 120.6568;
% d12 = 41.6496;
% d13 = 36.9015;
% d23 = 35.4481;
% signal_length = 4e7;
% r_loction = 3.95e8;
% ch1 = read_signal('..\\2024 822 85933.651462CH1.dat',signal_length,r_loction);
% ch2 = read_signal('..\\2024 822 85933.651462CH2.dat',signal_length,r_loction);
% ch3 = read_signal('..\\2024 822 85933.651462CH3.dat',signal_length,r_loction+215/5);
% %引雷点
signal_length = 4e7;
r_loction = 3.6e8;
d12 = 24.9586;
d13 = 34.9335;
d23 = 24.9675;
angle12 = -110.8477;
angle13 = -65.2405;
angle23 = -19.6541;
ch1 = read_signal('..\\20240822165932.6610CH1.dat',signal_length,r_loction);
ch2 = read_signal('..\\20240822165932.6610CH2.dat',signal_length,r_loction);
ch3 = read_signal('..\\20240822165932.6610CH3.dat',signal_length,r_loction);


filtered_signal1 = filter_bp(ch1,30e6,80e6,5);
filtered_signal2 = filter_bp(ch2,30e6,80e6,5);
filtered_signal3 = filter_bp(ch3,30e6,80e6,5);
%引雷点阈值
noise = read_signal('..\\20240822165932.6610CH1.dat',1e8,1e8);
filtered_noise = filter_bp(noise,30e6,80e6,5);
threshold = mean(filtered_noise)+5*std(filtered_noise);
% %从化局阈值
% noise = read_signal('..\\2024 822 85933.651462CH1.dat',1e8,1e8);
% filtered_noise = filter_bp(noise,30e6,80e6,5);
% threshold = mean(filtered_noise)+5*std(filtered_noise);


% 打开一个文本文件用于写入运行结果
fileID = fopen('result_chj_window512_512_阈值_5std_3.95-4.35——30——80.txt', 'w');
fprintf(fileID, '%-13s%-15s%-15s%-15s%-15s%-15s%-15s%-15s%-15s%-15s%-15s\n', ...
    'Start_loc','peak','t12', 't13', 't23', 'cos_alpha_opt', 'cos_beta_opt','Azimuth', 'Elevation', 'Rcorr', 't123');

% 设置阈值
all_peaks = [];
all_locs = [];


[peaks, locs] = findpeaks(filtered_signal1, 'MinPeakHeight',threshold , 'MinPeakDistance', 512);

% 存储所有峰值和阈值
all_peaks = peaks;
%     all_thresholds = [all_thresholds; threshold];
%     all_locs = [all_locs; locs + (subsignal_start(subi) - 1)];
all_locs = locs;

% 遍历所有峰值
num_peaks = numel(all_peaks);
% 创建进度条
h = waitbar(0, '正在处理峰值...');
for pi = 1:num_peaks
    waitbar(pi / num_peaks, h, sprintf('正在处理峰值 %d/%d', pi, num_peaks));
    idx = all_locs(pi);

    % 确保峰值不超出信号范围
    if idx - (window_length / 2 - 1) <= 0 || idx + (window_length / 2) > length(filtered_signal1)
        continue;
    end

    % 截取窗口信号
    [signal1, signal2, signal3] = deal(...
        filtered_signal1(idx-(window_length/2-1):idx+(window_length/2)), ...
        filtered_signal2(idx-(window_length/2-1):idx+(window_length/2)), ...
        filtered_signal3(idx-(window_length/2-1):idx+(window_length/2)));
    % 去直流分量并应用窗函数
    [ch1_new, ch2_new, ch3_new] = deal(...
        real(windowsignal(detrend(signal1))), ...
        real(windowsignal(detrend(signal2))), ...
        real(windowsignal(detrend(signal3))));

    % 上采样
    [ch1_up, ch2_up, ch3_up] = deal(...
        upsampling(ch1_new, upsampling_factor)', ...
        upsampling(ch2_new, upsampling_factor)', ...
        upsampling(ch3_new, upsampling_factor)');
    ch1_upsp = ch1_up(:,2);
    ch2_upsp = ch2_up(:,2);
    ch3_upsp = ch3_up(:,2);

      %互相关
    [r12_gcc,lags12_gcc] = xcorr(ch1_upsp ,ch2_upsp,'normalized');
    [r13_gcc,lags13_gcc] = xcorr(ch1_upsp ,ch3_upsp,'normalized');
    [r23_gcc,lags23_gcc] = xcorr(ch2_upsp ,ch3_upsp,'normalized');
    R12_gcc = max(r12_gcc);
    R13_gcc = max(r13_gcc);
    R23_gcc = max(r23_gcc);
    t12_gcc = cal_tau(r12_gcc,lags12_gcc');
    t13_gcc = cal_tau(r13_gcc,lags13_gcc');
    t23_gcc = cal_tau(r23_gcc,lags23_gcc');


        %从化局
        t12 = t12_gcc *0.1;
        t13 = t13_gcc *0.1+1.600061;
        t23 = t23_gcc *0.1+1.600061;
        t13 = t13_gcc *0.1;
        t23 = t23_gcc *0.1;

%     %引雷场
%     t12 = t12_gcc *0.1;
%     t13 = t13_gcc *0.1;
%     t23 = t23_gcc *0.1;

    cos_beta_0 =((c*t13*d12*sind(angle12))-(c*t12*sind(angle13)*d13))/(d13*d12*sind(angle12-angle13)) ;
    cos_alpha_0 = ((c*t12)/d12-cos_beta_0*cosd(angle12))/sind(angle12);
    if abs(cos_beta_0)>1 || abs(cos_alpha_0)>1
        continue;
    end
    x0 = [cos_alpha_0,cos_beta_0];
    % 调用lsqnonlin函数进行优化
    options = optimoptions('lsqnonlin', 'MaxIter', 1000, 'TolFun', 1e-6);
    x = lsqnonlin(@(x) objective(x, t12, t13, t23,'chj'), x0, [-1 -1],[1 1], options);
    % 输出最优的cos(α)和cos(β)值
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
    % 将弧度转换为角度
    Az_deg = rad2deg(Az);
    El_deg = rad2deg(El);
    if Az_deg < 0
        Az_deg = Az_deg + 360;
    end

    t123 = t12 + t23 - t13;
    Rcorr = (R12_gcc + R13_gcc + R23_gcc) / 3;

    % 写入计算后的数据
    fprintf(fileID, '%-13d%-15d%-15.6f%-15.6f%-15.6f%-15.6f%-15.6f%-15.6f%-15.6f%-15.6f%-15.6f\n', ...
        r_loction+idx-window/100,window/100, t12, t13, t23, cos_alpha_opt, cos_beta_opt, Az_deg, El_deg, Rcorr,t123);
end
% 关闭文件
fclose(fileID);
% 关闭进度条
close(h);
