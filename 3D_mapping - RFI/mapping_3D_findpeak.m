clear
% Step0 滤波
%RFI滤波
% original_signal_length = 3e8;
% original_signal_loc = 3e8;
% sub_filter_signal_length = 60000;
% yld_signal1 = read_signal('../20240822165932.6610CH1.dat', original_signal_length, original_signal_loc);
% chj_signal1 = read_signal('../2024 822 85933.651462CH1.dat', original_signal_length, original_signal_loc + 34236594);
% chj_signal2 = read_signal('../2024 822 85933.651462CH2.dat', original_signal_length, original_signal_loc + 34236594);
% chj_signal3 = read_signal('../2024 822 85933.651462CH3.dat', original_signal_length, original_signal_loc + 34236594+165/5);
% filtered_yld_signal1 = rfi_filter(yld_signal1,sub_filter_signal_length);
% filtered_chj_signal1 = rfi_filter(chj_signal1,sub_filter_signal_length);
% filtered_chj_signal2 = rfi_filter(chj_signal2,sub_filter_signal_length);
% filtered_chj_signal3 = rfi_filter(chj_signal3,sub_filter_signal_length);
% %卡尔曼滤波

%% Step1 读取引雷点的二维定位结果（需要条件筛选出合格的）
% 引入变量：位置，方位角，仰角
chj_signal_length = 1024;
match_signal_length = 6000;
yld_result_path = 'result_yld_th1_3-6e8_RFI.txt';
start_read_loc_yld = 451518508;
end_read_loc_yld = 494910665;    % 引入两个站的位置关系
yld_sit = [0, 0, 0];
chj_sit = [1991, -7841.2, 0];
dltas = [];
% yld相对于chj的位置
p = chj_sit-yld_sit;
dist = 8.09e3; %单位：米
c = 0.299792458;
W = 30000; % 时间误差

sub_filter_signal_length = 60000;

load('chj_RFI-filtered_ch1_3-6e8mat.mat');
load('chj_RFI-filtered_ch2_3-6e8mat.mat');
load('chj_RFI-filtered_ch3_3-6e8mat.mat');
load('yld_RFI-filtered_ch1_3-6e8mat.mat');
S_results = [];
match_results = struct('yld_start_loc', {}, 'chj_loc', {}, 'r_gccs', {});
[yld_start_loc, yld_azimuth, yld_elevation, yld_Rcorr, yld_t123] = read_result(yld_result_path,start_read_loc_yld, end_read_loc_yld);
h = waitbar(0, 'Processing...');
first_start_read_loc_chj = 0;
%% Step2 根据引雷点的信号窗口得到匹配到的从化局的信号
for i =1 :numel(yld_start_loc)
    sub_S_results = [];
    sub_R_gccs = [];
    waitbar(i/numel(yld_start_loc), h, sprintf('Processing %.2f%%', i/numel(yld_start_loc)*100));
    if yld_Rcorr(i) < 0.3 && yld_t123(i) > 1
        continue
    end
    % 判断是否需要进行大窗口匹配：
    if first_start_read_loc_chj == 0 
        skip_large = 0;  % 进行大窗口匹配
        [first_start_read_loc_chj, r_gccs] = get_match_single_yld_chj_find_peak(filtered_chj_signal1,filtered_yld_signal1,yld_start_loc(i), skip_large);
        start_read_loc_chj = first_start_read_loc_chj;
    else
        skip_large = first_start_read_loc_chj + yld_start_loc(i) - yld_start_loc(1);  % 跳过大窗口匹配
        [start_read_loc_chj, r_gccs] = get_match_single_yld_chj_find_peak(filtered_chj_signal1,filtered_yld_signal1,yld_start_loc(i), skip_large);
    end
    if isempty(start_read_loc_chj)
        continue
    end
    % 读取 match_signal_length*2 长度的信号
    chj_match_signal1 = filtered_chj_signal1(start_read_loc_chj-match_signal_length:start_read_loc_chj+match_signal_length);
    chj_match_signal2 = filtered_chj_signal2(start_read_loc_chj-match_signal_length:start_read_loc_chj+match_signal_length);
    chj_match_signal3 = filtered_chj_signal3(start_read_loc_chj-match_signal_length:start_read_loc_chj+match_signal_length);


    % 寻峰匹配计算所有可能的三维源
    %设置寻峰阈值
    noise = read_signal('../2024 822 85933.651462CH1.dat',65400,1e8);
    filtered_chj_noise = rfi_filter(noise,65400);
    threshold = 5*std(filtered_chj_noise);

    % 寻找峰值
    [peaks, locs] = findpeaks(chj_match_signal1, 'MinPeakHeight', threshold, 'MinPeakDistance', 256);
    all_locs = locs;
    % 遍历所有峰值
    num_peaks = numel(all_locs);
    if num_peaks == 0
        continue;
    end

    processed_yld_signal = filtered_yld_signal1(yld_start_loc(i)+1-3e8-sub_filter_signal_length/4 : yld_start_loc(i)-3e8-sub_filter_signal_length/4+chj_signal_length);
    processed_yld_signal = real(windowsignal(detrend(processed_yld_signal)));

    for pi = 1:num_peaks
        idx = all_locs(pi);
        if idx - (chj_signal_length / 2 - 1) <= 0 || idx + (chj_signal_length / 2) > match_signal_length*2
            continue;
        end
        processed_chj_signal1 = chj_match_signal1(idx - (chj_signal_length / 2)+ 1:idx + (chj_signal_length / 2));
        processed_chj_signal2 = chj_match_signal2(idx - (chj_signal_length / 2)+ 1:idx + (chj_signal_length / 2));
        processed_chj_signal3 = chj_match_signal3(idx - (chj_signal_length / 2)+ 1:idx + (chj_signal_length / 2));

        processed_chj_signal1 = real(windowsignal(detrend(processed_chj_signal1)));
        processed_chj_signal2 = real(windowsignal(detrend(processed_chj_signal2)));
        processed_chj_signal3 = real(windowsignal(detrend(processed_chj_signal3)));
        
        [r_gcc, lags_gcc] = xcorr(processed_chj_signal1, processed_yld_signal, 'normalized');
        R_gcc = max(r_gcc);
        t_gcc = cal_tau(r_gcc, lags_gcc');
        if R_gcc < 0.15
            continue
        end

        [chj_start_loc, chj_azimuth, chj_elevation, chj_Rcorr, chj_t123] = get_2d_result_single_window(start_read_loc_chj,processed_chj_signal1,processed_chj_signal2,processed_chj_signal3);
        if chj_start_loc == 0
            continue
        end

        [R1_x, R1_y, R1_z] = sph2cart(deg2rad(90-yld_azimuth(i)), deg2rad(yld_elevation(i)),1);
        [R2_x, R2_y, R2_z] = sph2cart(deg2rad(90-chj_azimuth), deg2rad(chj_elevation),1);
        A1 = [R1_x, R1_y, R1_z];
        A2 = [R2_x, R2_y, R2_z];
        C = cross(A1, A2);
        if norm(c) < eps
            continue;  % 避免除以零
        end
        c_unit = C  / norm(C);  % 单位向量
        M = [A1(1), -A2(1), c_unit(1);
            A1(2), -A2(2), c_unit(2);
            A1(3), -A2(3), c_unit(3)];
        % 使用克莱姆法则求R1,R2,R3的标量
        detM = det(M);
        detR1 = det([p', M(:,2), M(:,3)]);
        detR2 = det([M(:,1), p', M(:,3)]);
        detR3 = det([M(:,1), M(:,2), p']);
        R1_value = detR1 / detM;
        R2_value = detR2 / detM;
        R3_value = detR3 / detM;
        R1 = R1_value * A1;
        R2 = R2_value * A2;
        R3 = R3_value/norm(C)* C;
        if R1_value <= R2_value
            % 使用第一个公式
            sub_S = R1 + (R1_value / R2_value)*(R1_value / (R1_value + R2_value)) * R3;
        else
            % 使用第二个公式
            sub_S = R2 - (R2_value / R1_value)* (R2_value / (R1_value + R2_value))  * R3 + p;
        end
        if ~isempty(sub_S)
            t_chj = sqrt(sum((sub_S - chj_sit).^2))/c;
            t_yld = sqrt(sum((sub_S - yld_sit).^2))/c;
            dlta_t = abs(t_yld-t_chj);
            dlta_T = abs(t_gcc)*5;
            dlta = abs(dlta_t-dlta_T);
            dltas = [dltas;dlta];
            if dlta <= W
                sub_S_results = [sub_S_results; sub_S];
                sub_R_gccs = [sub_R_gccs;R_gcc];
                match_results = [match_results; struct('yld_start_loc', yld_start_loc(i), 'chj_loc', start_read_loc_chj-match_signal_length + idx - (chj_signal_length / 2)+1 + 3e8+sub_filter_signal_length/4+34371950, 'r_gccs', R_gcc)];
            end
        end
    end
    [max_R_gcc, max_R_gcc_index] = max(sub_R_gccs);

    S_results = [S_results;sub_S_results(max_R_gcc_index,:)];

end

close(h);

%% Step 5: 差分到达时间 (DTOA) 技术


% 绘制 S 的结果
% 设置过滤条件
x_range = [-50000, 50000]; % X 的合理范围
y_range = [-50000, 0]; % Y 的合理范围
z_range = [0, 50000];    % Z 的合理范围（Z > 0）

% 过滤数据
filtered_S = S_results(...
    S_results(:,1) >= x_range(1) & S_results(:,1) <= x_range(2) & ... % X 在合理范围内
    S_results(:,2) >= y_range(1) & S_results(:,2) <= y_range(2) & ... % Y 在合理范围内
    S_results(:,3) >= z_range(1) & S_results(:,3) <= z_range(2), :); % Z 在合理范围内


% 绘制过滤后的数据
figure;
% scatter3(filtered_S(:,1), filtered_S(:,2), filtered_S(:,3),3, 'filled');
scatter3(S_results(:,1), S_results(:,2), S_results(:,3),3, 'filled');
xlabel('X');
ylabel('Y');
zlabel('Z');
title('过滤后的所有 S 点的分布');
grid on;

% 转换为极坐标
% [x, y, z] = deal(filtered_S(:,1), filtered_S(:,2), filtered_S(:,3));
% theta = atan2(y, x); % 计算角度 (弧度)
% r = sqrt(x.^2 + y.^2); % 计算半径

% 绘制极坐标图
% figure;
% polarscatter(theta, r, 1, z, 'filled'); % 使用颜色表示 Z 坐标
% title('过滤后的所有 S 点的极坐标分布');
% colorbar; % 添加颜色条表示 Z 值

% x = filtered_S(:, 1);
% y = filtered_S(:, 2);
% z = filtered_S(:, 3);
x = S_results(:, 1);
y = S_results(:, 2);
z = S_results(:, 3);

plot_azimuth_elevation(x, y, z, yld_sit)