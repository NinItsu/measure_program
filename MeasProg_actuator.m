function [imp] = MeasProg_actuator()
%�C���p���X�����𑪒肷��v���O����(���ꑪ�葕�u)
%2020/09/29 written by Nin
%2020/11/13 Updated: SNR/SDR calculation, time/size/memory estimation. 
%           by Nin
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
act.MIN_X=input('X axis starts from (in cm, 0 to 100): ');
act.MAX_X=input('X axis ends to (in cm, 0 to 100): ');
act.INR_X=input('X axis interval (in cm, 0 for static): ');
if act.INR_X==0
    act.INR_X=1;
end
act.MIN_Z=input('Z axis starts from (in cm, 0 to 50): ');
act.MAX_Z=input('Z axis ends to (in cm, 0 to 50): ');
act.INR_Z=input('Z axis interval (in cm, 0 for static): ');
if act.INR_Z==0
    act.INR_Z=1;
end
imp.L=input('Length of the IR: ');
sig.TYPE=input('Signal type (TSP=UPTSP/DWTSP/LogSS) : ','s');
if (~strcmp(sig.TYPE,'TSP'))&&(~strcmp(sig.TYPE,'UPTSP'))&&(~strcmp(sig.TYPE,'DWTSP'))&&(~strcmp(sig.TYPE,'LogSS'))
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

noisetime=10;                                                               %�Ñ������莞��(sec)
WRM_TIME=1;                                                                 %�X�s�[�J�[�E�H�[�~���O�A�b�v����(min)

%���莞�Ԑ���(min) +-5min���x
estimated_measuring_time=(...
noisetime/60+WRM_TIME+...
act.MAX_X+act.MAX_Z*(act.MAX_X-act.MIN_X)/act.INR_X+...�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@
(act.MAX_X-act.MIN_X)/act.INR_X*(1+(act.MAX_Z-act.MIN_Z)/act.INR_Z)*3+...�@�@�@�@�@�@�@�@�@�@�@%ACT_MOVE�̎���
(act.MAX_X+act.MAX_Z*(act.MAX_X-act.MIN_X)/act.INR_X)/5+...
(1+(act.MAX_X-act.MIN_X)/act.INR_X)*5+...                                                    %ACT_RETURN�̎���
(sig.t+0.4)*NO_LSP*((act.MAX_X-act.MIN_X)/act.INR_X+1)*...
((act.MAX_Z-act.MIN_Z)/act.INR_Z+1)+...                                                      %playrec�̎���
((act.MAX_X-act.MIN_X)/act.INR_X+1)*((act.MAX_Z-act.MIN_Z)...
/act.INR_Z+1)*(15/30*NO_LSP/48*NO_MIC/2*sig.t)...                                               %CONV�Ȃǂ̎���
)/60;
fprintf('Estimated measuring time: %f min.\n',estimated_measuring_time);

%�t�@�C���e�ʐ���(GB)
estimated_file_size=...
imp.L*NO_LSP*NO_MIC*((act.MAX_X-act.MIN_X)/act.INR_X+1)*((act.MAX_Z-act.MIN_Z)...
/act.INR_Z+1)/1024/1024/1024/2*8;
fprintf('Estimated file size: %f GB.\n',estimated_file_size);

%���v����������(GB)
estimated_memory_required=...                                                               %RAW2IR/CONV�֐��̌Ăяo���ɂ��2�{�̃��������K�v
(sig.L*(3*2+2*2)+imp.L*2)*NO_LSP*NO_MIC*8/1024/1024/1024;
fprintf('Estimated memory required: %f GB.\n',estimated_memory_required);

tic
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
imp.full = zeros(sig.L*2,NO_LSP,NO_MIC);
imp.s = zeros(imp.L,NO_LSP,NO_MIC);

%���u�����ݒ�
act.port = actuatorConnect();
pause(5);
%���_���A
ACT_RETURN(act.port,1);
ACT_RETURN(act.port,2);
%�X�^�[�g�n�_�Ɉړ�
ACT_MOVE(act.port,1,act.MIN_X);
ACT_MOVE(act.port,2,act.MIN_Z);


%�Ñ������� (10�b��)
fprintf('Measuring background noise...\n');
noise = recs(NO_MIC,noisetime*FS,FS,DEVICE_ID);
fprintf('Done.\n');
fprintf('Saving noise data...');
%For old version MATLAB
if isempty(dir('BGN'))
    mkdir('BGN');
end
filename_bgn = strcat('BGN\',meas_name,'-',s4,s6,'.float');
writebin(noise,filename_bgn,'float');
fprintf('Done.\n');
%    figure; plot(noise(:,1)); %�Ñ����̊m�F
    %���g�������̊m�F
%    noise_fft=fft(squeeze(noise(:,1)),FS);
%    figure; semilogx(20*log10(abs(noise_fft(1:FS/2))));

%Warming Up
if strcmp(WARM_UP,'ON')
    WN = randn(WRM_TIME*60*FS,1); %10���ԃz���C�g�m�C�Y
    WN = (WN/max(WN))*sig.A;
    WN = WN*ones(1,NO_LSP);
    fprintf('Loudspeaker warming up(10 minutes)...\n');
    plays(WN,NO_LSP,FS,DEVICE_ID);
    fprintf('Done.\n');
end
WN=0;

imp.raw=zeros(sig.L,NO_LSP,NO_MIC);
imp.s=zeros(imp.L,NO_LSP,NO_MIC);
imp.full=zeros(sig.L*2,NO_LSP,NO_MIC);
imp.d=zeros(DLY-1,NO_LSP,NO_MIC);
SNR=zeros(NO_LSP,NO_MIC);
SDR=zeros(NO_LSP,NO_MIC);
noise=CONV(noise,sig.inv);
noise=noise(sig.L+1:noisetime*FS,:);

for x_pos = act.MIN_X:act.INR_X:act.MAX_X
for z_pos = act.MIN_Z:act.INR_Z:act.MAX_Z

    %����
    fprintf('Measuring...');
    for idx_LSP = 1:NO_LSP
        fprintf('\nCh: %d ',idx_LSP);
        imp.raw(:,idx_LSP,:) = play1_rec(sig.s,idx_LSP,NO_MIC,FS,DEVICE_ID);
    end
    fprintf('Done.\n');

    %�C���p���X�����Z�o
    imp = RAW2IR(imp,sig,DLY);
    imp.d = imp.full(sig.L+1:sig.L+DLY-1,:,:);
    
%    figure; plot(imp.raw(:,1,1)); %�^���M���̊m�F
%    figure; plot(imp.s(:,1,1)); %�����ʃC���p���X�����̊m�F
    %�����ʎ��g�������̊m�F
%    s_fft=fft(squeeze(imp.s(:,1,1)),FS);
%    figure; semilogx(20*log10(abs(s_fft(1:FS/2))));
%    figure; spectrogram(imp.s(:,1,1),hamming(64),32,256,FS,'yaxis'); %�X�y�N�g���O�����̊m�F
    %�S�ẴC���p���X�����̊m�F
%    f1=figure(1);
% %    MIC_chk=[1 7 13 19 22 28 36];
%    set(f1,'position',get(0,'screensize'));
%    for idx_LSP = 1:NO_LSP
%        for idx_MIC = 1:NO_MIC
%            subplot(NO_MIC,NO_LSP,idx_LSP+(idx_MIC-1)*NO_LSP,'replace');
%            plot(imp.s(:,idx_LSP,idx_MIC));
%        end
%    end 
%    drawnow;
    
    %SNR/SDR�̊m�F
   for idx_LSP=1:NO_LSP
       for idx_MIC=1:NO_MIC
           S=abs(sum(imp.s(:,idx_LSP,idx_MIC).^2)/imp.L);
           N=abs(sum(noise(:,idx_MIC).^2)/(noisetime*FS-sig.L));
           D=abs(sum(imp.d(:,idx_LSP,idx_MIC).^2)/(DLY-1));
           SNR(idx_LSP,idx_MIC)=10*log10(S/N);
           SDR(idx_LSP,idx_MIC)=10*log10(S/D);
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
%    maxSNR=max(max(SNR))
   minSNR=min(min(SNR));
%    maxSDR=max(max(SDR))
   minSDR=min(min(SDR));
   fprintf('Minimum SNR: %f dB; Minimum SDR: %f dB.\n',minSNR,minSDR);
    
    fprintf('Saving data...X: %f cm, Z: %f cm.\n',x_pos,z_pos);
    s5=strcat('_X_',num2str(x_pos),'_Z_',num2str(z_pos));

    %�t�@�C���ۑ�
%     %For old version MATLAB
%     if isempty(dir(strcat('RAW',date)))
%         mkdir(strcat('RAW',date));
%     end
%     filename_raw = strcat('RAW',date,'\',s1,'L_',num2str(length(imp.raw)),s3,s4,s5,s6,'.float');
%     writebin(imp.raw,filename_raw,'float');

    %For old version MATLAB
    if isempty(dir('IR'))
        mkdir('IR');
    end
    filename_imp = strcat('IR\',ss,s5,s6,'.float');
    writebin(imp.s,filename_imp,'float');
    fprintf('Done.\n');
    
    if z_pos >= act.MAX_Z
        break;
    end
    %Z���̈ړ�
    ACT_MOVE(act.port,2,act.INR_Z);
    imp.raw=zeros(sig.L,NO_LSP,NO_MIC);
    imp.s=zeros(imp.L,NO_LSP,NO_MIC);
    imp.full=zeros(sig.L*2,NO_LSP,NO_MIC);
    imp.d=zeros(DLY-1,NO_LSP,NO_MIC);
end
    if x_pos >= act.MAX_X
        break;
    end
    %Z���̕��A
    ACT_RETURN(act.port,2);
    ACT_MOVE(act.port,2,act.MIN_Z);
    %X���̈ړ�
    ACT_MOVE(act.port,1,act.INR_X);
end

%���_���A
ACT_RETURN(act.port,1);
ACT_RETURN(act.port,2);
actuatorDisconnect(act.port)
clear act.port
DUR=toc;
fprintf('Finished.\n');
fprintf('Duration of the measurement: %f min.\n',DUR/60);
end