%������Ѱ���źŵķ�ֵ
function peaks = find_peaks(signal,threshold)
    % �ҵ��ź��еķ�ֵ
    [pks,locs] = findpeaks(signal);
    % ������ֵɸѡ��ֵ
    peaks = locs(pks > threshold);
end