%% Step1 读取引雷点的二维定位结果（需要条件筛选出合格的）
% 引入变量：位置，方位角，仰角
chj_signal_length = 1024;
yld_result_path = 'result_yld3.5-5.5.txt';
start_read_loc_yld = 365620096;
end_read_loc_yld = 458861666;    % 引入两个站的位置关系
yld_sit = [0, 0, 0];
chj_sit = [7.8115e3, 2.1045e3, 0];
% yld相对于chj的位置
p = chj_sit-yld_sit;
dist = 8.09e3; %单位：米
c = 0.299552816;
% W = 40; % 时间误差，单位：采样点
S_results = [];
match_results = struct('yld_start_loc', {}, 'chj_loc', {}, 'r_gccs', {});
[yld_start_loc, yld_azimuth, yld_elevation, yld_Rcorr, yld_t123] = read_result(yld_result_path,start_read_loc_yld, end_read_loc_yld);
h = waitbar(0, 'Processing...');

% 用于记录上一次进行大窗口匹配的 yld_start_loc
last_large_match_yld_loc = -inf;
last_large_match_result = 0;
%% Step2 根据引雷点的信号窗口得到匹配到的从化局的信号
for i =1 :numel(yld_start_loc)
    waitbar(i/numel(yld_start_loc), h, sprintf('Processing %.2f%%', i/numel(yld_start_loc)*100));
    if yld_Rcorr(i) < 0.3 && yld_t123(i) > 1
        continue
    end
    % 判断是否需要进行大窗口匹配：
    % 第一个一定进行大窗口匹配
    % 后续的如果当前的 yld_start_loc 小于上次大窗口匹配的位置加 2e7，则跳过大窗口匹配
    if i == 1 || (yld_start_loc(i) >= last_large_match_yld_loc + 2e7)
        skip_large = 0;  % 进行大窗口匹配
        last_large_match_yld_loc = yld_start_loc(i);  % 更新记录
    else
        skip_large = last_large_match_result;  % 跳过大窗口匹配
    end
    
    % 调用匹配函数，传入是否跳过大窗口匹配的参数
    [start_read_loc_chj, r_gccs, result_2e7] = get_match_single_yld_chj_siddle(yld_start_loc(i), skip_large);
    if result_2e7 ~= 0
        last_large_match_result = result_2e7;
    end
    match_results = [match_results; struct('yld_start_loc', yld_start_loc(i), 'chj_loc', start_read_loc_chj, 'r_gccs', r_gccs)];
    chj_signal1 = read_signal('../2024 822 85933.651462CH1.dat',chj_signal_length,start_read_loc_chj);
    chj_signal2 = read_signal('../2024 822 85933.651462CH2.dat',chj_signal_length,start_read_loc_chj);
    chj_signal3 = read_signal('../2024 822 85933.651462CH3.dat',chj_signal_length,start_read_loc_chj+165/5);
    [chj_start_loc, chj_azimuth, chj_elevation, chj_Rcorr, chj_t123] = get_2d_result_single_window(start_read_loc_chj,chj_signal1,chj_signal2,chj_signal3);
    if chj_start_loc == 0
        continue
    end
%     [R1_x, R1_y, R1_z] = az_el_to_direction(yld_azimuth(i), yld_elevation(i));
%     [R2_x, R2_y, R2_z] = az_el_to_direction(chj_azimuth, chj_elevation);
    
    [R1_x, R1_y, R1_z] = sph2cart(deg2rad(90-yld_azimuth(i)), deg2rad(yld_elevation(i)),1);
    [R2_x, R2_y, R2_z] = sph2cart(deg2rad(90-chj_azimuth), deg2rad(chj_elevation),1);
    A1 = [R1_x, R1_y, R1_z];
    A2 = [R2_x, R2_y, R2_z];
    C = cross(A1, A2);
    if C == [0, 0, 0]
        continue
    end
    M = [A1; A2; C];
    % 使用克莱姆法则求R1,R2,R3的标量
    [R1_value, R2_value, R3_value] = cramer_rule(M, p);
    R1 = R1_value * A1;
    R2 = R2_value * A2;
    R3 = R3_value/norm(C)* C;
    if R1_value <= R2_value
        % 使用第一个公式
        S = R1 + (R1_value / R2_value)*(R1_value / (R1_value + R2_value)) * (R1_value / R2_value) * R3;
    else
        % 使用第二个公式
        S = R2 - (R2_value / R1_value)* (R2_value / (R1_value + R2_value)) * (R2_value / R1_value) * R3 + p;
    end
    if ~isempty(S)
        S_results = [S_results; S];
    end

    %         t_chj = sqrt(sum((S - chj_sit).^2))/c;
    %         t_yld = sqrt(sum((S - yld_sit).^2))/c;
    %         dlta_t = abs(t_yld-t_chj);
    %         dlta_T = abs(start_read_loc_chj_top10(j)-yld_start_loc(i))/5;
    %         if abs(dlta_t-dlta_T) <= W
    %         end
    %% Step 4: 保存S 并计算源到两个站点的时间延迟
end
close(h);

%% Step 5: 差分到达时间 (DTOA) 技术


% 绘制 S 的结果
% 设置过滤条件
x_range = [-50000, 50000]; % X 的合理范围
y_range = [-50000, 50000]; % Y 的合理范围
z_range = [0, 50000];    % Z 的合理范围（Z > 0）

% 过滤数据
filtered_S = S_results(...
    S_results(:,1) >= x_range(1) & S_results(:,1) <= x_range(2) & ... % X 在合理范围内
    S_results(:,2) >= y_range(1) & S_results(:,2) <= y_range(2) & ... % Y 在合理范围内
    S_results(:,3) >= z_range(1) & S_results(:,3) <= z_range(2), :); % Z 在合理范围内


% 绘制过滤后的数据
figure;
scatter3(filtered_S(:,1), filtered_S(:,2), filtered_S(:,3), 1, 'filled');
xlabel('X');
ylabel('Y');
zlabel('Z');
title('过滤后的所有 S 点的分布');
grid on;

% 转换为极坐标
[x, y, z] = deal(filtered_S(:,1), filtered_S(:,2), filtered_S(:,3));
theta = atan2(y, x); % 计算角度 (弧度)
r = sqrt(x.^2 + y.^2); % 计算半径

% 绘制极坐标图
figure;
polarscatter(theta, r, 1, z, 'filled'); % 使用颜色表示 Z 坐标
title('过滤后的所有 S 点的极坐标分布');
colorbar; % 添加颜色条表示 Z 值