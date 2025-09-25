%��ȡ����
signal_length = 2e8;
ch1 = read_signal('../cross-correlation/20190604164852.7960CH1.dat',signal_length);
% x = downsample(ch1,50);
% filtered_signalx = preprocess(x);
% plot_signal_spectrum(filtered_signalx);

ch2 = read_signal('../cross-correlation/20190604164852.7960CH2.dat',signal_length);
ch3 = read_signal('../cross-correlation/20190604164852.7960CH3.dat',signal_length);

N = 3;
d = 20;
c = 0.299792458;
window_length = 1024;

angle12 = -150;
angle13 = -90;
angle23 = -30;


% ��һ���ı��ļ�����д�����н��
fileID = fopen('result2.preprocess.12.txt', 'w');
% д���һ�е����ݽ���
fprintf(fileID, '%-13s%-15s%-15s%-15s%-15s%-15s%-15s%-15s%-15s%-15s%-15s\n', ...
     'Start_loc','Peak_loc','t12', 't13', 't23', 'cos��', 'cos��', 'Azimuth', 'Elevation', 'Rcorr', 't123');

filtered_signal1 = preprocess(ch1);
filtered_signal2 = preprocess(ch2);
filtered_signal3 = preprocess(ch3);

%Ѱ���ź�1���������������ķ�ֵ
peaks = find_peaks(filtered_signal1,12);
%�������з�ֵ
for  pi = 1:numel(peaks)
    idx = peaks(pi);
    if idx-(window_length*1/2-1) <= 0 
        continue;  % ������Χ��ִ����һ������
    end
    if  idx+(window_length*1/2) > length(filtered_signal1)
        break;  % ������Χ��ִ����һ������
    end
%     ȡ��ֵ����һ�����ȵ��ź�
    signal1 = filtered_signal1(idx-(window_length*1/2-1):idx+(window_length*1/2));
    signal2 = filtered_signal2(idx-(window_length*1/2-1):idx+(window_length*1/2));
    signal3 = filtered_signal3(idx-(window_length*1/2-1):idx+(window_length*1/2));
%     ���ڴ���
    windows =1:256:length(signal1)-window_length+1;
    for  wi = 1:numel(windows)
        win_signal1 = signal1(windows(wi):windows(wi)+window_length-1);
        win_signal2 = signal2(windows(wi):windows(wi)+window_length-1);
        win_signal3 = signal3(windows(wi):windows(wi)+window_length-1);
        
% %         ���źŽ����˲�����
%         filtered_signal1 = real(filter_fft(win_signal1, 20e6 ,80e6 ));
%         filtered_signal2 = real(filter_fft(win_signal2, 20e6 ,80e6 ));
%         filtered_signal3 = real(filter_fft(win_signal3, 20e6 ,80e6 ));
%          
%         %��ͨ�˲���
%         filtered_signal1 = filter_bp(win_signal1,20e6,80e6,8);
%         filtered_signal2 = filter_bp(win_signal2,20e6,80e6,8);
%         filtered_signal3 = filter_bp(win_signal3,20e6,80e6,8);

%         filtered_signal1 = preprocess(win_signal1);
%         filtered_signal2 = preprocess(win_signal2);
%         filtered_signal3 = preprocess(win_signal3);

        %ȥֱ������
        signal1_removed = detrend(win_signal1);
        signal2_removed = detrend(win_signal2);
        signal3_removed = detrend(win_signal3);

        % ���˲�����ź�Ӧ�ô�����
        windowed_signal1 = real(windowsignal(signal1_removed));
        windowed_signal2 = real(windowsignal(signal2_removed));
        windowed_signal3 = real(windowsignal(signal3_removed));
        %�������ź�
        ch1_new = windowed_signal1;
        ch2_new = windowed_signal2;
        ch3_new = windowed_signal3;
        
        % �����
        [r12,lags12] = xcorr(ch1_new,ch2_new,'normalized');
        [r13,lags13] = xcorr(ch1_new,ch3_new,'normalized');
        [r23,lags23] = xcorr(ch2_new,ch3_new,'normalized');

        R12 = max(r12);
        R13 = max(r13);
        R23 = max(r23);
        %�����ϵ�����������ϲ���
        r12_upsp = upsampling_gc(r12,lags12,8);
        r13_upsp = upsampling_gc(r13,lags13,8);
        r23_upsp = upsampling_gc(r23,lags23,8);
    
        t12 = showfitted(r12_upsp)*5;
        t13 = showfitted(r13_upsp)*5;
        t23 = showfitted(r23_upsp)*5;
    
%         % �������� A ������ B
%         A = [sqrt(3)/2 1/2; sqrt(3)/2 -1/2; 0 1];
%         B = [c*t12/d; c*t13/d; c*t23/d];
%         % ʹ����������������Է���������Ž�
%         result = A \ B;
%         % ������ŵ�cos(��)��cos(��)ֵ
%         cos_alpha_opt = result(1);
%         cos_beta_opt = result(2);
%         if abs(cos_alpha_opt)>1 || abs(cos_beta_opt)>1
%             continue;
%         end
%         Az = atan2( cos_alpha_opt,cos_beta_opt);
%         if abs(cos_beta_opt/cos(Az)) > 1
%             continue;
%         end
%         El = acos( cos_beta_opt/cos(Az) );
%         % ������ת��Ϊ�Ƕ�
%         Az_deg = rad2deg(Az);
%         El_deg = rad2deg(El);
%         if Az_deg < 0
%            Az_deg = Az_deg + 360;
%         end


            cos_alpha_0 = c*t23*tand(angle23)/(d*sind(angle23)*(tand(angle23) - tand(angle12))) - c*t12/(d*cosd(angle12)*(tand(angle23)-tand(angle12)));
            cos_beta_0 = (c*t12-d*cos_alpha_0*sind(angle12))/(d*cosd(angle12));
            if abs(cos_beta_0)>1 || abs(cos_alpha_0)>1
               continue;
            end
            x0 = [cos_alpha_0,cos_beta_0];
            % ����lsqnonlin���������Ż�
            options = optimoptions('lsqnonlin', 'MaxIter', 1000, 'TolFun', 1e-6);
            x = lsqnonlin(@objective, x0, [-1 -1],[1 1], options);
            % ������ŵ�cos(��)��cos(��)ֵ
            cos_alpha_opt = x(1);
            cos_beta_opt = x(2);
             if abs(cos_alpha_opt)>1 || abs(cos_beta_opt)>1
                 continue;
             end
             Az = atan2( cos_alpha_opt,cos_beta_opt);
             if abs(cos_beta_opt/cos(Az)) > 1
                continue;
             end
             El = acos( cos_beta_opt/cos(Az) );
             % ������ת��Ϊ�Ƕ�
             Az_deg = rad2deg(Az);
             El_deg = rad2deg(El);
             if Az_deg < 0
             Az_deg = Az_deg + 360;
             end

        peak_loc = find_max_peaks(ch1_new);
        t123 = t12 + t23 - t13;
        Rcorr = (R12 + R13 + R23)/3;
        
        
        if abs(t123) > 1
           continue;
        end
        % д�����������
        fprintf(fileID, '%-13d%-15d%-15.6f%-15.6f%-15.6f%-15.6f%-15.6f%-15.6f%-15.6f%-15.6f%-15.6f\n', ...
             300000000+idx+windows(wi),peak_loc, t12, t13, t23, cos_alpha_opt, cos_beta_opt, Az_deg, El_deg, Rcorr,t123);
    end
end
% �ر��ļ�
fclose(fileID);



function y = preprocess(x)
%  Ԥ�������� x
%    This function expects an input vector x.

% Generated by MATLAB(R) 9.12 and Signal Processing Toolbox 9.0.
% Generated on: 28-May-2024 16:47:33

y = bandstop(x,[0.2 0.8],'Steepness',0.9,'StopbandAttenuation',80);
end

function max_index = maxindex(vector)
    % ��ȡʵ������
    real_vector = real(vector);
    % �ҵ�ʵ���������Ԫ��
    positive_values = real_vector(real_vector > 0);
    % �ҵ�ʵ���������Ԫ���е����ֵ
    max_value = max(positive_values);
    % �ҵ����ֵ��Ӧ������
    max_index = find(real_vector == max_value);
end

function max_value = maxvalue(vector)
    % ��ȡʵ������
    real_vector = real(vector);
    % �ҵ�ʵ���������Ԫ��
    positive_values = real_vector(real_vector > 0);
    % �ҵ�ʵ���������Ԫ���е����ֵ
    max_value = max(positive_values);
end

function plot_signal_spectrum(signal)
% Plotting the signal spectrumʱ���źŵ�Ƶ��ͼ
fs = 200;
fft_signal = fft(signal);
n = length(fft_signal);
x = (0:n/2-1) * (fs/n);
figure
plot(x, 2.0 / n * abs(fft_signal(1:n/2)))

xlabel('Frequency (MHz)')
ylabel('Amplitude')
grid on
end





function delta_t = delta_t(tij,tij_obs)
    delta_t = tij - tij_obs;
end



% ��������ij������ֵ��_ij^obs�ĺ���
function tau_ij_obs = calculate_tau_obs(cos_alpha, cos_beta)
    angle12 = -150;
    angle13 = -90;
    angle23 = -30;
    % ʹ��ʽ(3)�����ij������ֵ��_ij^obs
    tau_ij_obs(1) = (cos_alpha * sind(angle12) + cos_beta * cosd(angle12)) * 20 / 0.299792458;
    tau_ij_obs(2) = (cos_alpha * sind(angle13) + cos_beta * cosd(angle13)) * 20 / 0.299792458;
    tau_ij_obs(3) = (cos_alpha * sind(angle23) + cos_beta * cosd(angle23)) * 20 / 0.299792458;
end


function tau = cal_tau(R, lag)
    % ���������ҵ�y�����ֵ��������
    [~, max_index] = max(R);
    tau = lag(max_index,1);
end


%% ��ư�����˹��ͨ�˲���
function filtered_signal = filter_bp(signal,f1,f2,order)
    Fs = 200e6;
    fn = Fs/2;
    Wn = [f1 f2]/fn;
    [b,a] = butter(order,Wn); 
    filtered_signal = filtfilt(b,a,signal);

end



function filtered_signal = filter_fft(sig,f1,f2)
    y=fft(sig);%����Ҷ�任�õ�һ������
    fs = 200e6;
    n = length(y);
    %����һ�������������ź� y ��ͬ�������� yy��
    yy=zeros(1,length(y));
    % ʹ�� for ѭ�������ź� y ��ÿ�������㣨m ��ʾ��ǰ�Ĳ�������������0�� N-1����
    for m=1:n-1
    %     �жϵ�ǰ�������Ӧ��Ƶ���Ƿ��� 8Hz �� 15Hz ��Χ�ڣ�����ڸ÷�Χ�ڣ��򽫶�Ӧ�� yy ֵ��Ϊ0����ʾ��Ƶ�ʵ��źű��˳���
        if m*(fs/n)<f1 || m*(fs/n)>f2 %���ο�˹��֮���Ƶ��Ҳ�˳����
            yy(m+1)=0;
        else
    %         �����ǰ�������Ӧ��Ƶ�ʲ��� 8Hz �� 15Hz ��Χ�ڣ��� yy ��ֵ����Ϊԭʼ�ź� y ��ֵ��
            yy(m+1)=y(m+1);
        end
    end %��Ƶ��Ϊ8Hz-15Hz���źŵķ�ֵ��0
    filtered_signal=ifft(yy)';
    
end


% ��ư�����˹��ͨ�˲���
function filtered_signal = filtersignal(signal,f1,f2,order,fs)
     % �˲���ͨ���±߽�Ƶ��f1 �˲���ͨ���ϱ߽�Ƶ��f2  �˲�������order
     % �����˲�������
     filter = designfilt('bandpassiir', 'FilterOrder', order, 'HalfPowerFrequency1', f1, 'HalfPowerFrequency2', f2, 'SampleRate', fs);
     filtered_signal = filtfilt(filter,signal);
end





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



%������Ѱ���źŵ�����ֵ
function peaks = find_max_peaks(signal,threshold)
    % �ҵ��ź��еķ�ֵ
    [pks,locs] = findpeaks(signal);
    % ������ֵɸѡ��ֵ
    selectedLocs = locs(pks > threshold);
    % ��ȡ���˺��ÿ����ֵ��xֵ
    
    peaks =selectedLocs;
end


%������Ѱ���źŵķ�ֵ
function peaks = find_peaks(signal,threshold)
    % �ҵ��ź��еķ�ֵ
    [pks,locs] = findpeaks(signal);
    % ������ֵɸѡ��ֵ
    peaks = locs(pks > threshold);
end


function matched_peaks_x = match_peaks(peaks1,peaks2,peaks3)
    matched_peaks_x = []; % �洢ƥ���ֵ��xֵ����
    for i = 1:numel(peaks1)
        curr_peak1 = peaks1(i);
        % ���peaks2��peaks3���Ƿ������peaks1��Ӧ�ķ�ֵ��xֵ�Ĳ����4
        idx_peak2 = find(abs(peaks2 - curr_peak1) <= 10);  % ��ȡpeaks2��ƥ���ֵ������
        idx_peak3 = find(abs(peaks3 - curr_peak1) <= 10);  % ��ȡpeaks3��ƥ���ֵ������
        % ����Ƿ��ҵ���ƥ��ķ�ֵ
        if ~isempty(idx_peak2) && ~isempty(idx_peak3)
            matched_peaks_x = [matched_peaks_x; [curr_peak1, peaks2(idx_peak2(1)), peaks3(idx_peak3(1))]];% ���ƥ���ֵ��xֵ����
        end
    end
end


function mswed_signal = msw_signal(signal , peak_x ,length)
      % �ҵ���ֵ�� x ֵ���ź��е�����
    left_idx = max(peak_x - length+1, 1);  % ȷ����߽������
    right_idx = min(peak_x + length, 10240);  % ȷ���ұ߽������
    mswed_signal = signal(left_idx:right_idx);  % ��ȡ������ x ֵΪ���ĵ�����40��������

end

% ����Ŀ�꺯��
function F = objective(x)
    % ��ȡ���Ż��ı���
    cos_alpha = x(1);
    cos_beta = x(2);

    % �����ij������ֵ��_ij^obs
    tau_ij_obs = calculate_tau_obs(cos_alpha, cos_beta);
    t12 = evalin('base', 't12');
    t13 = evalin('base', 't13');
    t23 = evalin('base', 't23');
    % ���㦤t12, ��t13, ��t23
    delta_t12 = delta_t(t12,tau_ij_obs(1));
    delta_t13 = delta_t(t13,tau_ij_obs(2));
    delta_t23 = delta_t(t23,tau_ij_obs(3));

    % ����Ŀ�꺯������ʽ(4)
    F = (delta_t12^2 + delta_t13^2 + delta_t23^2) / 75;
end


function shifted_signal = shift_signal(signal, shift_amount)

    % ʹ�� circshift ����ƽ��
    shifted_signal = circshift(signal, shift_amount);
    % ���������ƽ�ƣ��Ҳಹ�㣻���������ƽ�ƣ���ಹ��
    if shift_amount < 0
        shifted_signal(end+shift_amount+1:end) = 0;
    else
        shifted_signal(1:shift_amount) = 0;
    end
    
end


function tau = showfitted(data)
    % ���������ҵ�y�����ֵ��������
    [max_value, max_index] = max(data(:, 2));
    % ��ȡ���ֵ��Χ��3���������
    if max_index > length(data(:,2))-3 || max_index <3
        tau = 20/0.299552816 + 1;
    else
        fit_range = [ -3,-2,-1, 0, 1, 2, 3] + max_index;
        % ��ȡ10����������Ͷ�Ӧ��ֵ
        fit_indices = data(fit_range, 1);
        fit_values = data(fit_range, 2);
        % �������������
        coefficients = polyfit(fit_indices, fit_values, 2);
        % ������Ͻ��������������ϵĵ�
        fit_indices_curve = linspace(min(fit_indices), max(fit_indices), 1000);
        fit_values_curve = polyval(coefficients, fit_indices_curve);
        % ����ԭʼ���ݺ��������
%         figure;
%         plot(data(:, 1), data(:, 2))
%         plot(data(:, 1), data(:, 2), 'b', fit_indices_curve, fit_values_curve, 'r--');
%         legend('ԭʼ����', '�������');
%         xlabel('y������');
%         ylabel('y��ֵ');
        [max_value_fit, max_index_fit] = max(fit_values_curve);
        tau = fit_indices_curve(1,max_index_fit);
    end
    
end


%�������������ڽ����ϲ���
function new_signal = upsampling(original_signal,upsampling_factor)

    % ԭ�ź�
    original_x = (1:numel(original_signal))';
    original_y = original_signal;
    % �ϲ�����Ĳ�������
    upsampled_length = length(original_x) * upsampling_factor;
    % �ϲ�����Ĳ������ x ����
    upsampled_x = linspace(1, length(original_x), upsampled_length);
    % ʹ�ö���ʽ��ֵ��ԭ�źŽ����ϲ���
    interpolated_signal = interp1(original_x, original_y, upsampled_x, 'spline');
    new_signal = [upsampled_x; interpolated_signal];
end


%�Ի���غ��������ϲ���
function upsampling_gcc = upsampling_gc(r,lag,upsampling_factor)

    % �ϲ�����Ĳ�������
    upsampled_length = length(lag) * upsampling_factor;
    % �ϲ�����Ĳ������ x ����
    upsampled_x = linspace(-numel(r)/2, numel(r)/2, upsampled_length);
    % ʹ�ö���ʽ��ֵ��ԭ�źŽ����ϲ���
    interpolated_signal = interp1(lag, r, upsampled_x, 'spline');
    upsampling_gcc = [upsampled_x; interpolated_signal]';

end


function windowed_signal = windowsignal(signal)
%     r_length = length(signal);
%    % ʹ�ú�����
%    window = hamming(r_length);
%    % ���˲�����ź�Ӧ�ô�����
%    windowed_signal = signal .* window; % �ź��봰�������
% 
    X = fft(signal);      %�任��Ƶ��Ӵ�
    r_length = length(X);
    window = hamming(r_length);
%     �õ�����Ƶ���ź�
    X_windowed = X .* window;

% %     % �����渵��Ҷ�任�õ�ʱ���ź�
      windowed_signal = ifft(X_windowed);

end

