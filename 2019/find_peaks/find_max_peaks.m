%������Ѱ���źŵ������λ��
function max_peak_loc = find_max_peaks(x)
    % �ҵ��źŵķ�ֵ
    [peaks, peak_locs] = findpeaks(x);
    [~, max_idx] = max(peaks);
    max_peak_loc = peak_locs(max_idx);
end