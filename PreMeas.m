function imp = PreMeas(setting)
%����p�M�����m�F����v���O����(�֐�)
%2020/01/27 written by Nin
%2020/11/13 Updated: SNR/SDR calculation, high order distortion calculation. 
%           by Nin
%2021/11/02 Updated: Bandpass Log SS.
%           by Nin
%�����ݒ�
switch setting
    case 'default'
        FS=48000; %�T���v�����O���g��
        DEVICE_ID=102; %�f�o�C�XID
        DLY=2150; %�@��̒x���� 809:2150; ������:2150
        NO_MIC=48; %�}�C�N��
        NO_LSP=1; %�X�s�[�J��
        imp.L=2400; %�C���p���X������(�T���v����)
        sig.TYPE='LogSS'; %����p�M���̎�ށiTSP=UPTSP/DWTSP/LogSS�j
        sig.A=0.1; %����p�M���̐U��
        sig.t=2; %����p�M���̒����i�b�j
        sig.L=sig.t*FS; %����p�M���̒����i�T���v�����j
        [sig.s sig.inv]=meas_sig_gen(sig,FS); %����p�M���̐���
    case 'manual'
        FS=input('Sampling frequency: ');
        DEVICE_ID=select_play_device;
        DLY=input('ADDA Delay (2150 for 809, 2150 for Anechoic Room) : ');
        NO_LSP=input('No. of loudspeakers: ');
        NO_MIC=input('No. of microphones: ');
        imp.L=input('Length of the IR: ');
        sig.TYPE=input('Signal type (TSP=UPTSP/DWTSP/LogSS/BPLogSS) : ','s');
        if (strcmp(sig.TYPE,'BPLogSS'))
            sig.fmin=input('High pass frequency: ');
            sig.fmax=input('Low pass frequency: ');
        end
        if ((~strcmp(sig.TYPE,'TSP'))&&(~strcmp(sig.TYPE,'UPTSP'))&&(~strcmp(sig.TYPE,'DWTSP'))&&(~strcmp(sig.TYPE,'LogSS'))&&(~strcmp(sig.TYPE,'BPLogSS')))
            warning('Unknown command, use default TSP.\n');
            sig.TYPE='TSP';
        end
        sig.A=input('Signal amplitude: ');
        sig.t=input('Signal length (in sec) : ');
        sig.L=sig.t*FS;
        [sig.s sig.inv]=meas_sig_gen(sig,FS);
end

%�z��̏�����
imp.raw = zeros(sig.L,NO_LSP,NO_MIC);
imp.full = zeros(sig.L*2-1,NO_LSP,NO_MIC);
imp.s = zeros(imp.L,NO_LSP,NO_MIC);

%�Ñ������� (10�b��)
fprintf('Measuring background noise...\n');
noisetime=10;
noise = recs(NO_MIC,noisetime*FS,FS,DEVICE_ID);
fprintf('Done.\n');

%����
fprintf('Measuring...');
for idx_LSP = 1:NO_LSP
    fprintf('\nCh: %d ',idx_LSP);
    imp.raw(:,idx_LSP,:) = play1_rec(sig.s,idx_LSP,NO_MIC,FS,DEVICE_ID);
end
fprintf('Done.\n');

%�C���p���X�����Z�o
fprintf('Calculating convolution...');
%    for idx_LSP = 1:NO_LSP
%        for idx_MIC = 1:NO_MIC
%             imp.full(:,idx_LSP,idx_MIC) = conv(imp.raw(:,idx_LSP,idx_MIC),sig.inv);
%           imp.full(:,idx_LSP,idx_MIC) = conv_fft(imp.raw(:,idx_LSP,idx_MIC),sig.inv,sig.L); %���g���̈�conv
%        end
%    end
imp.full=CONV(imp.raw,sig.inv);
fprintf('Done.\n');
%�@��̒x������菜�����C���p���X������
imp.s = imp.full(sig.L+DLY:sig.L+DLY+imp.L-1,:,:);
imp.d = imp.full(sig.L+1:sig.L+DLY-1,:,:);
if (strcmp(sig.TYPE,'LogSS'))
    [peak.v,peak.i]=max(abs(imp.full),[],1);
    for idx_MIC=1:NO_MIC
        for idx_LSP=1:NO_LSP
            imp.d2(:,idx_LSP,idx_MIC) = imp.full(...
        peak.i(1,idx_LSP,idx_MIC)-floor(sig.L/2*log(2)/log(sig.L/2))-600:...
        peak.i(1,idx_LSP,idx_MIC)-1200,idx_LSP,idx_MIC);
            imp.d3(:,idx_LSP,idx_MIC) = imp.full(...
        peak.i(1,idx_LSP,idx_MIC)-floor(sig.L/2*log(3)/log(sig.L/2))-300:...
        peak.i(1,idx_LSP,idx_MIC)-floor(sig.L/2*log(2)/log(sig.L/2))...
        -600,idx_LSP,idx_MIC);
            imp.d4(:,idx_LSP,idx_MIC) = imp.full(...
        peak.i(1,idx_LSP,idx_MIC)-floor(sig.L/2*log(4)/log(sig.L/2))-150:...
        peak.i(1,idx_LSP,idx_MIC)-floor(sig.L/2*log(3)/log(sig.L/2))...
        -300,idx_LSP,idx_MIC);
        end
    end
end
if (strcmp(sig.TYPE,'BPLogSS'))
    [peak.v,peak.i]=max(abs(imp.full),[],1);
    for idx_MIC=1:NO_MIC
        for idx_LSP=1:NO_LSP
            imp.d2(:,idx_LSP,idx_MIC) = imp.full(...
        peak.i(1,idx_LSP,idx_MIC)-floor(sig.L/2*log(2)/log(sig.fmax/sig.fmin))-600:...
        peak.i(1,idx_LSP,idx_MIC)-1200,idx_LSP,idx_MIC);
            imp.d3(:,idx_LSP,idx_MIC) = imp.full(...
        peak.i(1,idx_LSP,idx_MIC)-floor(sig.L/2*log(3)/log(sig.fmax/sig.fmin))-300:...
        peak.i(1,idx_LSP,idx_MIC)-floor(sig.L/2*log(2)/log(sig.fmax/sig.fmin))...
        -600,idx_LSP,idx_MIC);
            imp.d4(:,idx_LSP,idx_MIC) = imp.full(...
        peak.i(1,idx_LSP,idx_MIC)-floor(sig.L/2*log(4)/log(sig.fmax/sig.fmin))-150:...
        peak.i(1,idx_LSP,idx_MIC)-floor(sig.L/2*log(3)/log(sig.fmax/sig.fmin))...
        -300,idx_LSP,idx_MIC);
        end
    end
end
noise=CONV(noise,sig.inv);
noise=noise(sig.L+1:noisetime*FS,:);

%idx_MIC�Ԗڃ}�C�N�M���m�F
idx_MIC=1;
%�^���M���̊m�F
f1=figure(1);
set(f1,'position',get(0,'screensize'));
subplot(2,2,1); plot(imp.raw(:,1,idx_MIC)); 
%�C���p���X�����̊m�F
subplot(2,2,2); plot(imp.s(:,1,idx_MIC)); 
%���g�������̊m�F
s_fft=fft(squeeze(imp.s(:,1,idx_MIC)),FS);
%�Ñ����̎��g������
noise_fft=fft(noise(:,idx_MIC),FS);
distortion_fft=fft(imp.d(:,1,idx_MIC),FS);
subplot(2,2,3); semilogx(20*log10(abs(s_fft(1:FS/2))));xlim([20 20000]);grid minor;
hold on; semilogx(20*log10(abs(noise_fft(1:FS/2)))); 
if (strcmp(sig.TYPE,'LogSS')||strcmp(sig.TYPE,'BPLogSS'))
    distortion2_fft=fft(imp.d2(:,1,idx_MIC),FS);
    semilogx((1:FS/2)/2,20*log10(abs(distortion2_fft(1:FS/2))));
    distortion3_fft=fft(imp.d3(:,1,idx_MIC),FS);
    semilogx((1:FS/2)/3,20*log10(abs(distortion3_fft(1:FS/2))));
    distortion4_fft=fft(imp.d4(:,1,idx_MIC),FS);
    semilogx((1:FS/2)/4,20*log10(abs(distortion4_fft(1:FS/2))));
    legend('IR','BGN','2nd DST','3rd DST','4th DST','Location','southeast');hold off;
else
    semilogx(20*log10(abs(distortion_fft(1:FS/2))));
    legend('IR','BGN','DST','Location','southeast');hold off;
end
%�X�y�N�g���O�����̊m�F
subplot(2,2,4); spectrogram(imp.full(:,1,idx_MIC),hamming(64),32,256,FS,'yaxis'); 
% %����`�c�݂̊m�F
% figure(3);spectrogram(imp.full(:,1,idx_MIC),hamming(64),32,256,FS,'yaxis');

%�S�ẴC���p���X�����̊m�F
f1=figure(2);
set(f1,'position',get(0,'screensize'));
for idx_LSP = 1:NO_LSP
   for idx_MIC = 1:NO_MIC
       subplot(NO_MIC,NO_LSP,idx_LSP+(idx_MIC-1)*NO_LSP,'replace');
       plot(imp.s(:,idx_LSP,idx_MIC));
   end
end 

%SNR�̊m�F�i�U�j
for idx_LSP=1:NO_LSP
   for idx_MIC=1:NO_MIC
       S=abs(sum(imp.s(:,idx_LSP,idx_MIC).^2)/imp.L);
       N=abs(sum(noise(:,idx_MIC).^2)/(noisetime*FS-sig.L));
       D=abs(sum(imp.d(:,idx_LSP,idx_MIC).^2)/(DLY-1));
       SDR(idx_LSP,idx_MIC)=10*log10(S/D);
       SNR(idx_LSP,idx_MIC)=10*log10(S/N);
       if SNR(idx_LSP,idx_MIC)<=20
           warning('Low SNR at LSP%d MIC%d.',idx_LSP,idx_MIC);
           figure; plot(imp.s(:,idx_LSP,idx_MIC)); 
           title(['LSP: ',num2str(idx_LSP),' MIC: ',num2str(idx_MIC),...
               ' SNR: ',num2str(SNR(idx_LSP,idx_MIC)),' dB.']);
           drawnow;
       end
       if SDR(idx_LSP,idx_MIC)<=20
           warning('Low SDR at LSP%d MIC%d.',idx_LSP,idx_MIC);
           figure; plot(imp.s(:,idx_LSP,idx_MIC)); 
           title(['LSP: ',num2str(idx_LSP),' MIC: ',num2str(idx_MIC),...
               ' SDR: ',num2str(SDR(idx_LSP,idx_MIC)),' dB.']);
           drawnow;
       end
   end
end
maxSNR=max(max(SNR));
minSNR=min(min(SNR));
fprintf('Minimum SNR: %f dB; Maximum SNR: %f dB.\n',minSNR,maxSNR);
maxSDR=max(max(SDR));
minSDR=min(min(SDR));
fprintf('Minimum SDR: %f dB; Maximum SDR: %f dB.\n',minSDR,maxSDR);
end