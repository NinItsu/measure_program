function [imp] = MeasProg(setting)
%�C���p���X�����𑪒肷��v���O����(�֐�)
%2020/01/20 written by Nin
%2021/11/02 Updated: Bandpass Log SS.
%           by Nin
%�����ݒ�
switch setting
    case 'default'
        FS=48000; %�T���v�����O���g��
        DEVICE_ID=102; %�f�o�C�XID
        DLY=2150; %�@��̒x���� 809:2150; ������:2150
        TRIAL=1; %�����
        NO_MIC=1; %�}�C�N��
        NO_LSP=1; %�X�s�[�J��
        WARM_UP='OFF'; %Warming Up
        rot.STAT='OFF'; %��]��̎g�p
        rot.INR=5; %��]�p�x �i2.5/5/10�j
        imp.L=2400; %�C���p���X������(�T���v����)
        sig.TYPE='TSP'; %����p�M���̎�ށiTSP=UPTSP/DWTSP/LogSS/BPLogSS�j
        sig.A=0.1; %����p�M���̐U��
        sig.t=2; %����p�M���̒����i�b�j
        sig.L=sig.t*FS; %����p�M���̒����i�T���v�����j
        [sig.s sig.inv]=meas_sig_gen(sig,FS); %����p�M���̐���
        meas_name='default-meas';
    case 'manual'
        FS=input('Sampling frequency: ');
        DEVICE_ID=select_play_device;
        DLY=input('ADDA Delay (2150 for 809, 2150 for Anechoic Room) : ');
        NO_LSP=input('No. of loudspeakers: ');
        NO_MIC=input('No. of microphones: ');
        TRIAL=input('Trial: ');
        WARM_UP=input('Loudspeaker warming up? (Y/N) ','s');
        if strcmp(WARM_UP,'Y')
            WARM_UP='ON';
        elseif strcmp(WARM_UP,'N')
            WARM_UP='OFF';
        else
            warning('Unknown command, warming up turned off.\n');
            WARM_UP='OFF';
        end
        rot.STAT=input('Use of turntable? (Y/N) ','s');
        if strcmp(rot.STAT,'Y')
            rot.STAT='ON';
            rot.INR=input('Rotation angle: ');
        elseif strcmp(rot.STAT,'N')
            rot.STAT='OFF';
            rot.INR=5;
        else
            warning('Unknown command, turntable turned off.\n');
            rot.STAT='OFF';
            rot.INR=5;
        end
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

%����p�M���̊m�F
%figure; plot(sig.s);
%figure; plot([0:sig.L-1],sig.s);
%sound(sig.s,FS);
%figure; spectrogram(sig.s,hamming(64),32,256,FS,'yaxis'); 

%�t�@�C����
date=datestr(now,'yymmdd')
s1 = strcat(meas_name,'-',sig.TYPE,num2str(sig.A),'-');
s2 = strcat('L_',num2str(imp.L));
s3 = strcat('_LSPNO_',num2str(NO_LSP));
s4 = strcat('_MICNO_',num2str(NO_MIC));
s6 = strcat('_TRIAL',num2str(TRIAL));
ss = strcat(s1,s2,s3,s4);

%�z��̏�����
imp.raw = zeros(sig.L,NO_LSP,NO_MIC);
imp.full = zeros(sig.L*2-1,NO_LSP,NO_MIC);
imp.s = zeros(imp.L,NO_LSP,NO_MIC);

%��]�䏉���ݒ� �������񂩂��������v���O�������Q�l����
if strcmp(rot.STAT,'ON')
    rot.port = serial('COM7'); %����p�@�B�ƃ|�[�g�ڑ�
    fopen(rot.port);
    get(rot.port);
    set(rot.port,'Parity','odd','Terminator',{'CR/LF','CR/LF'},'StopBits',1,'DataBits',7);%�d�v!
    get(rot.port);
    pause(10);
    %���_���A���Ăяo���B
    fprintf(rot.port,'L16 0');fscanf(rot.port) %0�Ԃ����_���A
    fprintf(rot.port,'S1');fscanf(rot.port)
    pause(10);
    fprintf(rot.port,'S2');fscanf(rot.port)
    %��]�v���O�������Ăяo���@3�Ԃ�10�x  2�Ԃ�2.5�x
    if rem(rot.INR,10)==0
        fprintf(rot.port,'L16 3');fscanf(rot.port)
    else
        fprintf(rot.port,'L16 2');fscanf(rot.port)
    end 
end

%�Ñ������� (10�b��)
fprintf('Measuring background noise...\n');
noise = recs(NO_MIC,10*FS,FS,DEVICE_ID);
fprintf('Done.\n');
fprintf('Saving noise data...');
filename_bgn = strcat('BGN\',meas_name,'-',s4,s6,'.float');
writebin(noise,filename_bgn,'float');
fprintf('Done.\n');
%    figure; plot(noise(:,1)); %�Ñ����̊m�F
    %���g�������̊m�F
%    noise_fft=fft(squeeze(noise(:,1)),FS);
%    figure; semilogx(20*log10(abs(noise_fft(1:FS/2))));

%Warming Up
if strcmp(WARM_UP,'ON')
    WN = randn(10*60*FS,1); %10���ԃz���C�g�m�C�Y
    WN = (WN/max(WN))*sig.A;
    WN = WN*ones(1,NO_LSP);
    fprintf('Loudspeaker warming up(10 minutes)...\n')
    plays(WN,NO_LSP,FS,DEVICE_ID);
    fprintf('Done.\n');
end
end

%%
for ang = 0:rot.INR:360-rot.INR
    
    %����
    fprintf('Measuring...');
    for idx_LSP = 1:NO_LSP
        fprintf('\nCh: %d ',idx_LSP);
        imp.raw(:,idx_LSP,:) = play1_rec(sig.s,idx_LSP,NO_MIC,FS,DEVICE_ID);
    end
    fprintf('Done.\n');

    %�C���p���X�����Z�o
    imp = RAW2IR(imp,sig,DLY);
    
%    figure; plot(imp.raw(:,1,1)); %�^���M���̊m�F
%    figure; plot(imp.s(:,1,1)); %�����ʃC���p���X�����̊m�F
    %�����ʎ��g�������̊m�F
%    s_fft=fft(squeeze(imp.s(:,1,1)),FS);
%    figure; semilogx(20*log10(abs(s_fft(1:FS/2))));
%    figure; spectrogram(imp.s(:,1,1),hamming(64),32,256,FS,'yaxis'); %�X�y�N�g���O�����̊m�F
    %�S�ẴC���p���X�����̊m�F
   f1=figure(1);
%    MIC_chk=[1 7 13 19 22 28 36];
   set(f1,'position',get(0,'screensize'));
   for idx_LSP = 1:NO_LSP
       for idx_MIC = 1:NO_MIC
           subplot(NO_MIC,NO_LSP,idx_LSP+(idx_MIC-1)*NO_LSP,'replace');
           plot(imp.s(:,idx_LSP,idx_MIC));
       end
   end 
   drawnow;
    
    %SNR�̊m�F�i�U�j
   for idx_LSP=1:NO_LSP
       for idx_MIC=1:NO_MIC
           P=abs(max(imp.s(:,idx_LSP,idx_MIC)).^2);
           S=abs(sum(imp.s(:,idx_LSP,idx_MIC).^2)/imp.L);
           N=abs(sum(noise(:,idx_MIC).^2)/FS/10);
%            N=abs(sum(imp.full(imp.L/2+1:end,idx_LSP,idx_MIC).^2)/imp.L*2);
%            N=abs(max(imp.s(imp.L/2+1:end,idx_LSP,idx_MIC)).^2);
           PNR(idx_LSP,idx_MIC)=10*log10(P/N);
           SNR(idx_LSP,idx_MIC)=10*log10(S/N);
           if SNR(idx_LSP,idx_MIC)<=20
               warning('Low SNR at LSP%d MIC%d.',idx_LSP,idx_MIC);
           end
       end
   end
   maxSNR=max(max(SNR))
   minSNR=min(min(SNR))
    
    if strcmp(rot.STAT,'ON')
        fprintf('Saving data...Angle: %f degree.\n',ang);
        s5=strcat('_ANG_',num2str(ang));
    else
        fprintf('Saving data...');
        s5='';
    end

    %�t�@�C���ۑ�
    filename_raw = strcat('RAW',date,'\',s1,'L_',num2str(length(imp.raw)),s3,s4,s5,s6,'.float');
    writebin(imp.raw,filename_raw,'float');

    filename_imp = strcat('IR\',ss,s5,s6,'.float');
    writebin(imp.s,filename_imp,'float');
    fprintf('Done.\n');

    if ~strcmp(rot.STAT,'ON')
        return;
    end
    
    %��]���� 5�x�̏ꍇ��2.5�x��2��
    fprintf(rot.port,'S1');fscanf(rot.port)
    pause(5);
    fprintf(rot.port,'S2');fscanf(rot.port)
    if rot.INR==5
        pause(3);
        fprintf(rot.port,'S1');fscanf(rot.port)
        pause(5);
        fprintf(rot.port,'S2');fscanf(rot.port)
    end

end

fclose(rot.port); %�|�[�g�ڑ����� �����G���[���o����K��fclose���Ă���f�o�b�O
delete(rot.port);
clear rot.port;