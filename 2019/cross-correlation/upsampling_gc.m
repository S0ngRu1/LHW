%�Ի���غ��������ϲ���
function upsampling_gcc = upsampling_gc(r,lag,upsampling_factor)
    % ������ֵ��������               
    interpolant = griddedInterpolant(lag, r, 'spline');
    % �����µĲ�ֵ����
    new_x = linspace(-numel(r)/2, numel(r)/2, numel(r)*upsampling_factor);
    % ִ�в�ֵ�ϲ���
    interpolated_signal = interpolant(new_x);
    upsampling_gcc = [new_x; interpolated_signal]';
end