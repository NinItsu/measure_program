function [imp] = MeasProg_turntable()
%�C���p���X�����𑪒肷��v���O����(��]��)
%2020/09/25 written by Nin
%2021/11/02 Updated: Bandpass Log SS, log file. 
%           NOTE: SNR/SDR calculation, time/size/memory estimation TO BE
%           UPDATED.
%           by Nin
%�����ݒ�

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
rot.MIN=input('Rotation starts from: ');
rot.MAX=input('Rotation ends to: ');
rot.INR=input('Rotation angle: ');
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
meas_name=input('Measure name: ','s');

%����p�M���̊m�F
%figure; plot(sig.s);
%figure; plot([0:sig.L-1],sig.s);
%sound(sig.s,FS);
%figure; spectrogram(sig.s,hamming(64),32,256,FS,'yaxis'); 

tic
%�t�@�C����
date=datestr(now,'yymmdd')
s1 = strcat(meas_name,'-',sig.TYPE,num2str(sig.A),'-');
s2 = strcat('L_',num2str(imp.L));
s3 = strcat('_LSPNO_',num2str(NO_LSP));
s4 = strcat('_MICNO_',num2str(NO_MIC));
s6 = strcat('_TRIAL',num2str(TRIAL));
ss = strcat(s1,s2,s3,s4);

%log�t�@�C��
logfile=fopen(strcat(ss,'.log'),'w');
fprintf(logfile, ['Date: ',datestr(now),'\n']);
fprintf(logfile, ['No. of loudspeakers: ', num2str(NO_LSP),'\n']);
fprintf(logfile, ['No. of microphones: ', num2str(NO_MIC),'\n']);
fprintf(logfile, ['Rotation range: [',num2str(rot.MIN),', ',num2str(rot.MAX),']\n']);
fprintf(logfile, ['Rotation step: ', num2str(rot.INR),'\n']);
fprintf(logfile, ['Sampling frequency: ', num2str(FS),'\n']);
fprintf(logfile, ['ADDA Delay: ', num2str(DLY),'\n']);
fprintf(logfile, ['Length of the IR: ', num2str(imp.L),'\n']);
fprintf(logfile, ['Signal type: ',sig.TYPE,'\n']);
if (strcmp(sig.TYPE,'BPLogSS'))
    fprintf(logfile, ['Frequency Band: [',num2str(sig.fmin),', ',num2str(sig.fmax),']\n']);
end
fprintf(logfile, ['Signal amplitude: ', num2str(sig.A),'\n']);
fprintf(logfile, ['Signal length (in sec) : ', num2str(sig.t),'\n']);
fprintf(logfile, ['Trial: ', num2str(TRIAL),'\n']);
fprintf(logfile, ['Loudspeaker warming up: ', WARM_UP,'\n']);

%�z��̏�����
imp.raw = zeros(sig.L,NO_LSP,NO_MIC);
imp.full = zeros(sig.L*2-1,NO_LSP,NO_MIC);
imp.s = zeros(imp.L,NO_LSP,NO_MIC);

%��]�䏉���ݒ� �������񂩂��������v���O�������Q�l����
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

%�Ñ������� (10�b��)
fprintf('Measuring background noise...\n');
fprintf(logfile, 'Measuring background noise...\n');
noise = recs(NO_MIC,10*FS,FS,DEVICE_ID);
fprintf('Done.\n');
fprintf(logfile, 'Done.\n');
fprintf('Saving noise data...');
fprintf(logfile, 'Saving noise data...');
filename_bgn = strcat('BGN\',meas_name,'-',s4,s6,'.float');
writebin(noise,filename_bgn,'float');
fprintf('Done.\n');
fprintf(logfile, 'Done.\n');
%    figure; plot(noise(:,1)); %�Ñ����̊m�F
    %���g�������̊m�F
%    noise_fft=fft(squeeze(noise(:,1)),FS);
%    figure; semilogx(20*log10(abs(noise_fft(1:FS/2))));

%Warming Up
if strcmp(WARM_UP,'ON')
    WN = randn(10*60*FS,1); %10���ԃz���C�g�m�C�Y
    WN = (WN/max(WN))*sig.A;
    WN = WN*ones(1,NO_LSP);
    fprintf(['Loudspeaker warming up(',num2str(WRM_TIME),' minutes)...\n']);
    fprintf(logfile, ['Loudspeaker warming up(',num2str(WRM_TIME),' minutes)...\n']);
    plays(WN,NO_LSP,FS,DEVICE_ID);
    fprintf('Done.\n');
    fprintf(logfile, 'Done.\n');
end


for ang = rot.MIN:rot.INR:rot.MAX
    
    %����
    fprintf('Measuring...');
    fprintf(logfile, 'Measuring...');
    for idx_LSP = 1:NO_LSP
        fprintf('\nCh: %d ',idx_LSP);
        fprintf(logfile, '\nCh: %d ',idx_LSP);
        imp.raw(:,idx_LSP,:) = play1_rec(sig.s,idx_LSP,NO_MIC,FS,DEVICE_ID);
    end
    fprintf('Done.\n');
    fprintf(logfile, 'Done.\n');

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
               fprintf(logfile, 'Low SNR at LSP%d MIC%d.',idx_LSP,idx_MIC);
           end
       end
   end
   maxSNR=max(max(SNR))
   minSNR=min(min(SNR))
    
   fprintf('Saving data...Angle: %f degree.\n',ang);
   fprintf(logfile, 'Saving data...Angle: %f degree.\n',ang);
   s5=strcat('_ANG_',num2str(ang));


    %�t�@�C���ۑ�
    filename_raw = strcat('RAW',date,'\',s1,'L_',num2str(length(imp.raw)),s3,s4,s5,s6,'.float');
    writebin(imp.raw,filename_raw,'float');

    filename_imp = strcat('IR\',ss,s5,s6,'.float');
    writebin(imp.s,filename_imp,'float');
    fprintf('Done.\n');
    fprintf(logfile, 'Done.\n');

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
DUR=toc;
fprintf('Finished.\n');
fprintf(logfile, 'Finished.\n');
fprintf('Duration of the measurement: %f min.\n',DUR/60);
fprintf(logfile, 'Duration of the measurement: %f min.\n',DUR/60);
fclose(logfile);
end