%% ʹ��EEMD���źŽ��н�����˲�
function filtered_signal = filter_eemd(sig)
    %EEMD�ֽ�
    Nstd = 0.2; %NstdΪ����������׼����Y��׼��֮��
    NE = 20;   %NEΪ���źŵ�ƽ������
    imf = eemd(sig,Nstd,NE);
    %�ź��ع�
    indices = [2,5,6,7,8,9,10,11];  
    filtered_imfs = imf(:,indices);
    filtered_signal = sum(filtered_imfs, 2);
end