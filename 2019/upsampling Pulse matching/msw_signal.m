function mswed_signal = msw_signal(signal , peak_x ,length)
      % �ҵ���ֵ�� x ֵ���ź��е�����
    left_idx = max(peak_x - length+1, 1);  % ȷ����߽������
    right_idx = min(peak_x + length, 10240);  % ȷ���ұ߽������
    mswed_signal = signal(left_idx:right_idx);  % ��ȡ������ x ֵΪ���ĵ�����40��������

end