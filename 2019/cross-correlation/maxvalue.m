function max_value = maxvalue(vector)
    % ��ȡʵ������
    real_vector = real(vector);
    % �ҵ�ʵ���������Ԫ��
    positive_values = real_vector(real_vector > 0);
    % �ҵ�ʵ���������Ԫ���е����ֵ
    max_value = max(positive_values);
end