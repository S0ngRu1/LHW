function windowed_signal = windowsignal(signal)
%     r_length = length(signal);
%    % ʹ�ú�����
%    window = hamming(r_length);
%    % ���˲�����ź�Ӧ�ô�����
%    windowed_signal = signal .* window; % �ź��봰�������

    X = fft(signal);      %�任��Ƶ��Ӵ�
    r_length = length(X);
    window = hamming(r_length);
%     �õ�����Ƶ���ź�
    X_windowed = X .* window;

% %     % �����渵��Ҷ�任�õ�ʱ���ź�
      windowed_signal = ifft(X_windowed);

end

