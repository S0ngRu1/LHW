% ����Ŀ�꺯��
function F = objective(x,t12,t13,t23,type)
    % ��ȡ���Ż��ı���
    cos_alpha = x(1);
    cos_beta = x(2);

    % �����ij������ֵ��_ij^obs
    tau_ij_obs = calculate_tau_obs(cos_alpha, cos_beta,type);
    % ���㦤t12, ��t13, ��t23
    delta_t12 = delta_t(t12,tau_ij_obs(1));
    delta_t13 = delta_t(t13,tau_ij_obs(2));
    delta_t23 = delta_t(t23,tau_ij_obs(3));

    % ����Ŀ�꺯������ʽ(4)
    F = (delta_t12^2 + delta_t13^2 + delta_t23^2) / 75;
end