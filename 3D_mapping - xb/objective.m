% % ����Ŀ�꺯��
% function F = objective(x,t12,t13,t23,type)
%     % ��ȡ���Ż��ı���
%     cos_alpha = x(1);
%     cos_beta = x(2);
% 
%     % �����ij������ֵ��_ij^obs
%     tau_ij_obs = calculate_tau_obs(cos_alpha, cos_beta,type);
%     % ���㦤t12, ��t13, ��t23
%     delta_t12 = delta_t(t12,tau_ij_obs(1));
%     delta_t13 = delta_t(t13,tau_ij_obs(2));
%     delta_t23 = delta_t(t23,tau_ij_obs(3));
% 
%     % ����Ŀ�꺯������ʽ(4)
%     F = (delta_t12^2 + delta_t13^2 + delta_t23^2) / 75;
% end

% ����Ŀ�꺯�� (��ȷ�汾)
function F = objective(x, t12_meas, t13_meas, t23_meas, type)
    % ��ȡ���Ż��ı���
    cos_alpha = x(1);
    cos_beta = x(2);

    % �����ij������ֵ ��_model (�ҽ� obs ��Ϊ model�����������)
    tau_model = calculate_tau_obs(cos_alpha, cos_beta, type);
    
    % t12, t13, t23 �ǲ�����ʱ�� (measurement)
    % tau_model(1), tau_model(2), tau_model(3) �Ǹ��ݵ�ǰ x �����������ʱ��
    
    % ����в�����
    residual12 = t12_meas - tau_model(1);
    residual13 = t13_meas - tau_model(2);
    residual23 = t23_meas - tau_model(3);

    % ���زв����� F
    % lsqnonlin ���Զ���С�� sum(F.^2)
    F = [residual12; residual13; residual23];
end