function max_index = maxindex(vector)
    % ��ȡʵ������
    
    max_value = max(vector);
    % �ҵ����ֵ��Ӧ������
    max_index = find(vector == max_value);
end