%���������������źţ��ҵ�΢�߶ȴ��������ϵ������0.8�Ĵ���
function correlated_windows = find_correlated_windows(signal1, signal2, signal3, window_size, threshold, Fs, N)
    % ��������
    num_windows = N - window_size + 1;  
    % �洢���ϵ��������ֵ�Ĵ���
    correlated_windows = [];
    for i = 1:num_windows
        % ��ȡ��ǰ���ڵ�����
        window1 = signal1(i:i+window_size-1);
        window2 = signal2(i:i+window_size-1);
        window3 = signal3(i:i+window_size-1);
        [tau12,R12,lag12] = gccphat(window1,window2, Fs);
        [tau13,R13,lag13] = gccphat(window1,window3, Fs);
        [tau23,R23,lag23] = gccphat(window2,window3, Fs);
        max_R12 = maxvalue(R12);
        max_R13 = maxvalue(R13);
        max_R23 = maxvalue(R23);
        
        % ������ϵ��������ֵ����������ӵ�����б���
        if max_R12 > threshold && max_R13 > threshold && max_R23 > threshold
            correlated_windows = [correlated_windows; i];
        end
    end
end

