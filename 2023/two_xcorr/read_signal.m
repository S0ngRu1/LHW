function signal = read_signal(signal_path, r_length)
    fid  = fopen(signal_path,'r');
    r_loction = 4401e5;%��ȡ���ݵ�λ��

    %ʹ��fseek�������ļ�ָ���ƶ���ָ��λ�ã��Ա��ȡ���ݡ�
    %����ָ���ƶ�λ��Ϊr_location����ʾ�ƶ���ָ��λ�ÿ�ʼ��ȡ���ݡ�
    fseek(fid,r_loction*2,'bof');
    %ʹ��fread�������ļ��ж�ȡ���ݣ���ȡ�����ݳ���Ϊr_length��������int16��ʽ��ȡ��
    %����ȡ�������ݷֱ𱣴浽����ch_1��ch_2��ch_3�С�
    signal = fread(fid,r_length,'int16');
    %�ر������ļ�
    fclose('all');
end

