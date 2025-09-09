function mswed_signal = msw_signal(signal , peak_x ,length)
    peak_x_idx = find(signal(:,1) == peak_x);  % �ҵ���ֵ�� x ֵ���ź��е�����
    left_idx = max(peak_x_idx - length+1, 1);  % ȷ����߽������
    right_idx = min(peak_x_idx + length, 10240);  % ȷ���ұ߽������
    mswed_signal = signal(left_idx:right_idx,2);  % ��ȡ������ x ֵΪ���ĵ�����40��������

end