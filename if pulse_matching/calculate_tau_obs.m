% ��������ij������ֵ��_ij^obs�ĺ���
function tau_ij_obs = calculate_tau_obs(cos_alpha, cos_beta)
%     angle12 = -110.85;
%     angle13 = -65.24;
%     angle23 = -19.65;
    %�ӻ���
    angle12 = -2.8381;
    angle13 = 28.2006;
    angle23 = 87.3358;
    % ʹ��ʽ(3)�����ij������ֵ��_ij^obs
    tau_ij_obs(1) = (cos_alpha * sind(angle12) + cos_beta * cosd(angle12)) * 24.96 / 0.299792458;
    tau_ij_obs(2) = (cos_alpha * sind(angle13) + cos_beta * cosd(angle13)) * 34.93 / 0.299792458;
    tau_ij_obs(3) = (cos_alpha * sind(angle23) + cos_beta * cosd(angle23)) * 24.98 / 0.299792458;
end