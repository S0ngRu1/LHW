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

% function new_signal = upsampling(original_signal, upsampling_factor, method)
    % ���������
    % original_signal - ԭʼ�ź�
    % upsampling_factor - �ϲ�������
    % method - ��ֵ��������ѡֵ��'linear', 'spline', 'polyfit'
    
%     % ԭ�źŵĲ�����λ��
%     original_x = (1:numel(original_signal))';
%     original_y = original_signal;
% 
%     % �����ϲ�������źų��Ⱥ�λ��
%     upsampled_length = length(original_x) * upsampling_factor;
%     upsampled_x = linspace(1, length(original_x), upsampled_length)';
% 
%     switch method
%         case 'linear'
%             % ���Բ�ֵ
%             interpolated_signal = interp1(original_x, original_y, upsampled_x, 'linear');
%             
%         case 'spline'
%             % ������ֵ
%             interpolated_signal = interp1(original_x, original_y, upsampled_x, 'spline');
%             
%         case 'polyfit'
%             % ����ʽ��ϲ�ֵ
%             poly_order = 1; % �趨����ʽ�Ľ���
%             p = polyfit(original_x, original_y, poly_order);
%             interpolated_signal = polyval(p, upsampled_x);
%             
%         otherwise
%             error('Unsupported interpolation method. Use ''linear'', ''spline'', or ''polyfit''.');
%     end
% 
%     % �����ϲ�������ź�
%     new_signal = [upsampled_x, interpolated_signal];
% end
% 
