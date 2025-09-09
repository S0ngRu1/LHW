function tau = showfitted(data)
    % ���������ҵ�y�����ֵ��������
    [max_value, max_index] = max(data(:, 2));
    % ��ȡ���ֵ��Χ��3���������
    if max_index > length(data(:,2))-3 || max_index <3
        tau = 20/0.299552816 + 1;
    else
        fit_range = [ -3,-2,-1, 0, 1, 2, 3] + max_index;
        % ��ȡ10����������Ͷ�Ӧ��ֵ
        fit_indices = data(fit_range, 1);
        fit_values = data(fit_range, 2);
        % �������������
        coefficients = polyfit(fit_indices, fit_values, 2);
        % ������Ͻ��������������ϵĵ�
        fit_indices_curve = linspace(min(fit_indices), max(fit_indices), 1000);
        fit_values_curve = polyval(coefficients, fit_indices_curve);
        % ����ԭʼ���ݺ��������
%         figure;
%         plot(data(:, 1), data(:, 2))
%         plot(data(:, 1), data(:, 2), 'b', fit_indices_curve, fit_values_curve, 'r--');
%         legend('ԭʼ����', '�������');
%         xlabel('y������');
%         ylabel('y��ֵ');
        [max_value_fit, max_index_fit] = max(fit_values_curve);
        tau = fit_indices_curve(1,max_index_fit);
    end
    
end

