%������Ѱ���źŵ�����ֵ
function peaks = find_max_peaks(signal,threshold)
    % �ҵ��ź��еķ�ֵ
    [pks,locs] = findpeaks(signal(:,2));
    % ������ֵɸѡ��ֵ
    selectedLocs = locs(pks > threshold);
    % ��ȡ���˺��ÿ����ֵ��xֵ
    x = signal(:,1);
    peaks = x(selectedLocs);
end