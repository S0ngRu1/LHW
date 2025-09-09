%�������������ڽ����ϲ���
function new_signal = upsampling(original_signal,upsampling_factor)

    % ԭ�ź�
    original_x = (1:numel(original_signal))';
    original_y = original_signal;
    % �ϲ�����Ĳ�������
    upsampled_length = length(original_x) * upsampling_factor;
    % �ϲ�����Ĳ������ x ����
    upsampled_x = linspace(1, length(original_x), upsampled_length);
    % ʹ�ö���ʽ��ֵ��ԭ�źŽ����ϲ���
    interpolated_signal = interp1(original_x, original_y, upsampled_x, 'spline');
    new_signal = [upsampled_x; interpolated_signal];
end