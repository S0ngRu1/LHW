% ��ư�����˹��ͨ�˲���
function filtered_signal = filtersignal(signal,f1,f2,order,fs)
     % �˲���ͨ���±߽�Ƶ��f1 �˲���ͨ���ϱ߽�Ƶ��f2  �˲�������order
     % �����˲�������
     filter = designfilt('bandpassiir', 'FilterOrder', order, 'HalfPowerFrequency1', f1, 'HalfPowerFrequency2', f2, 'SampleRate', fs);
     filtered_signal = filtfilt(filter,signal);
end