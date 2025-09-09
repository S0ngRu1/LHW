%�Ի���غ��������ϲ���
function upsampling_gcc = upsampling_gc(r,lag,upsampling_factor)

    % �ϲ�����Ĳ�������
    upsampled_length = length(lag) * upsampling_factor;
    % �ϲ�����Ĳ������ x ����
    upsampled_x = linspace(-numel(r)/2, numel(r)/2, upsampled_length);
    % ʹ�ö���ʽ��ֵ��ԭ�źŽ����ϲ���
    interpolated_signal = interp1(lag, r, upsampled_x, 'spline');
    upsampling_gcc = [upsampled_x; interpolated_signal]';

end