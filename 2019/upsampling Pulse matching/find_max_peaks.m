%������Ѱ���źŵ�����ֵ
function peaks = find_max_peaks(signal,threshold)
    % �ҵ��ź��еķ�ֵ
    [pks,locs] = findpeaks(signal);
    % ������ֵɸѡ��ֵ
    selectedLocs = locs(pks > threshold);
    % ��ȡ���˺��ÿ����ֵ��xֵ
    
    peaks =selectedLocs;
end