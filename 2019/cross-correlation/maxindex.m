function max_index = maxindex(vector)
    % ��ȡʵ������
    real_vector = real(vector);
    % �ҵ�ʵ���������Ԫ��
    positive_values = real_vector(real_vector > 0);
    % �ҵ�ʵ���������Ԫ���е����ֵ
    max_value = max(positive_values);
    % �ҵ����ֵ��Ӧ������
    max_index = find(real_vector == max_value);
end