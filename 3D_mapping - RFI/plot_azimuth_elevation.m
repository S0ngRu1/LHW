function plot_azimuth_elevation(x, y, z, station)
    % 输入：
    %   x, y, z - 目标点的直角坐标（可以是向量）
    %   station - 站位坐标 [x0, y0, z0]
    
    % 站位平移（将目标点坐标转换为相对站位的坐标）
    x = x - station(1);
    y = y - station(2);
    z = z - station(3);

    % 将直角坐标转换为球坐标
    [azimuth, elevation, ~] = cart2sph(x, y, z);
    azimuth = mod(azimuth, 2*pi);

% 然后，将角度转换为以正北方向为参考的顺时针角度
% 正北方向对应的角度是pi/2
azimuth_north = pi/2 - azimuth;

% 由于azimuth_north的范围可能超出[-pi, pi]，需要进行调整
azimuth_north = mod(azimuth_north + pi, 2*pi) - pi;
    % 将弧度转换为角度
    azimuth = azimuth_north * 180 / pi;
    elevation = elevation * 180 / pi;
    azimuth = mod(azimuth, 360);
    % 调整仰角范围为 0-90 度
    elevation = abs(elevation); % 确保仰角为非负值
    elevation(elevation > 90) = 90; % 限制最大值为 90 度

    % 绘制方位角和仰角的散点图
    figure;
    scatter(azimuth, elevation, 1, 'filled');
    xlabel('方位角 (度)');
    ylabel('仰角 (度)');
    title('方位角和仰角分布');
    grid on;
    axis([0 360 0 90]); % 设置坐标轴范围
    colorbar; % 添加颜色条（可选）
end
