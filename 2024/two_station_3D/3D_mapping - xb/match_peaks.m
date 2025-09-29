function matched_peaks_x = match_peaks(peaks1,peaks2,peaks3)
    matched_peaks_x = []; % �洢ƥ���ֵ��xֵ����
    for i = 1:numel(peaks1)
        curr_peak1 = peaks1(i);
        % ���peaks2��peaks3���Ƿ������peaks1��Ӧ�ķ�ֵ��xֵ�Ĳ����10��0.1ns
        idx_peak2 = find(abs(peaks2 - curr_peak1) <= 5);  % ��ȡpeaks2��ƥ���ֵ������
        idx_peak3 = find(abs(peaks3 - curr_peak1) <= 5);  % ��ȡpeaks3��ƥ���ֵ������
        % ����Ƿ��ҵ���ƥ��ķ�ֵ
        if ~isempty(idx_peak2) && ~isempty(idx_peak3)
            matched_peaks_x = [matched_peaks_x; [curr_peak1, peaks2(idx_peak2(1)), peaks3(idx_peak3(1))]];% ���ƥ���ֵ��xֵ����
        end
    end
end