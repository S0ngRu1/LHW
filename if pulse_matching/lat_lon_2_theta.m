% 定义两个点的经纬度
lat1 = 23.56888; % 点1的纬度
lon1 = 113.614722; % 点1的经度
lat2 = 23.6392983; % 点2的纬度
lon2 = 113.5957504; % 点2的经度

% 假设地球表面距离转换（这里使用简单的平面坐标系统，地球曲率略过）
% 计算两个点的平面坐标差（单位：米）
R = 6371e3; % 地球半径（米）
x1 = R * lon1 * pi / 180; % 经度转化为平面坐标X
y1 = R * lat1 * pi / 180; % 纬度转化为平面坐标Y
x2 = R * lon2 * pi / 180;
y2 = R * lat2 * pi / 180;

% 计算直线的斜率
m = (y2 - y1) / (x2 - x1);

% 计算直线与x轴的夹角（单位：弧度）
theta = atan(m);

% 计算直线与y轴的夹角（单位：弧度）
phi = pi / 2 - abs(theta);

% 将弧度转换为角度
phi_deg = rad2deg(phi);

% 输出结果
disp(['直线与y轴的夹角为：', num2str(phi_deg), '°']);
