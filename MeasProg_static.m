function [imp] = MeasProg_static()
%インパルス応答を測定するプログラム(静態)
%2020/09/25 written by Nin
%2020/11/13 Updated: SNR/SDR calculation, time/size/memory estimation. 
%           by Nin
%2021/11/02 Updated: Bandpass Log SS, log file.
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

%測定用信号の確認
%figure; plot(sig.s);
%figure; plot([0:sig.L-1],sig.s);
%sound(sig.s,FS);
%figure; spectrogram(sig.s,hamming(64),32,256,FS,'yaxis'); 

noisetime=10;                                                               %暗騒音測定時間(sec)
WRM_TIME=1;                                                                 %スピーカーウォーミングアップ時間(min)

%測定時間推定(min) +-5min程度
estimated_measuring_time=(...
noisetime/60+WRM_TIME+...
(sig.t+0.4)*NO_LSP+...                                                      %playrecの時間
(15/30*NO_LSP/48*NO_MIC/2*sig.t)...                                         %CONVなどの時間
)/60;
fprintf('Estimated measuring time: %f min.\n',estimated_measuring_time);

%インパルス応答のファイル容量推定(GB)
estimated_file_size=...
imp.L*NO_LSP*NO_MIC/1024/1024/1024/2*8;
fprintf('Estimated IR file size: %f GB.\n',estimated_file_size);

%生録音データのファイル容量推定(GB)
estimated_file_size=...
sig.L*NO_LSP*NO_MIC/1024/1024/1024/2*8;
fprintf('Estimated RAW file size: %f GB.\n',estimated_file_size);

%所要メモリ推定(GB)
estimated_memory_required=...                                                               %RAW2IR/CONV関数の呼び出しにより2倍のメモリが必要
(sig.L*(3+2)+imp.L)*NO_LSP*NO_MIC*8/1024/1024/1024;
fprintf('Estimated memory required: %f GB.\n',estimated_memory_required);

tic
%ファイル名
date=datestr(now,'yymmdd')
s1 = strcat(meas_name,'-',sig.TYPE,num2str(sig.A),'-');
s2 = strcat('L_',num2str(imp.L));
s3 = strcat('_LSPNO_',num2str(NO_LSP));
s4 = strcat('_MICNO_',num2str(NO_MIC));
s5 = strcat('_TRIAL',num2str(TRIAL));
ss = strcat(s1,s2,s3,s4);

%logファイル
logfile=fopen(strcat(ss,'.log'),'w');
fprintf(logfile, ['Date: ',datestr(now),'\n']);
fprintf(logfile, ['No. of loudspeakers: ', num2str(NO_LSP),'\n']);
fprintf(logfile, ['No. of microphones: ', num2str(NO_MIC),'\n']);
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
fprintf(logfile, 'Estimated measuring time: %f min.\n',estimated_measuring_time);
fprintf(logfile, 'Estimated IR file size: %f GB.\n',estimated_file_size);
fprintf(logfile, 'Estimated RAW file size: %f GB.\n',estimated_file_size);
fprintf(logfile, 'Estimated memory required: %f GB.\n',estimated_memory_required);

%配列の初期化
imp.raw = zeros(sig.L,NO_LSP,NO_MIC);
imp.full = zeros(sig.L*2-1,NO_LSP,NO_MIC);
imp.s = zeros(imp.L,NO_LSP,NO_MIC);

%暗騒音測定 (10秒間)
fprintf('Measuring background noise...\n');
fprintf(logfile, 'Measuring background noise...\n');
noise = recs(NO_MIC,noisetime*FS,FS,DEVICE_ID);
fprintf('Done.\n');
fprintf(logfile, 'Done.\n');
fprintf('Saving noise data...');
fprintf(logfile, 'Saving noise data...');
%For old version MATLAB
if isempty(dir('BGN'))
    mkdir('BGN');
end
filename_bgn = strcat('BGN\',meas_name,'-',s4,s5,'.float');
writebin(noise,filename_bgn,'float');
fprintf('Done.\n');
fprintf(logfile, 'Done.\n');
%    figure; plot(noise(:,1)); %暗騒音の確認
    %周波数特性の確認
%    noise_fft=fft(squeeze(noise(:,1)),FS);
%    figure; semilogx(20*log10(abs(noise_fft(1:FS/2))));

%Warming Up
if strcmp(WARM_UP,'ON')
    WN = randn(WRM_TIME*60*FS,1); %10分間ホワイトノイズ
    WN = (WN/max(WN))*sig.A;
    WN = WN*ones(1,NO_LSP);
    fprintf(['Loudspeaker warming up(',num2str(WRM_TIME),' minutes)...\n']);
    fprintf(logfile, ['Loudspeaker warming up(',num2str(WRM_TIME),' minutes)...\n']);
    plays(WN,NO_LSP,FS,DEVICE_ID);
    fprintf('Done.\n');
    fprintf(logfile, 'Done.\n');
end
WN=0;

SNR=zeros(NO_LSP,NO_MIC);
SDR=zeros(NO_LSP,NO_MIC);
noise=CONV(noise,sig.inv);
noise=noise(sig.L+1:noisetime*FS,:);

%測定
fprintf('Measuring...');
fprintf(logfile, 'Measuring...');
for idx_LSP = 1:NO_LSP
    fprintf('\nCh: %d ',idx_LSP);
    fprintf(logfile, '\nCh: %d ',idx_LSP);
    imp.raw(:,idx_LSP,:) = play1_rec(sig.s,idx_LSP,NO_MIC,FS,DEVICE_ID);
end
fprintf('Done.\n');
fprintf(logfile, 'Done.\n');

%インパルス応答算出
imp = RAW2IR(imp,sig,DLY);
imp.d = imp.full(sig.L+1:sig.L+DLY-1,:,:);

%    figure; plot(imp.raw(:,1,1)); %録音信号の確認
%    figure; plot(imp.s(:,1,1)); %水平面インパルス応答の確認
%水平面周波数特性の確認
%    s_fft=fft(squeeze(imp.s(:,1,1)),FS);
%    figure; semilogx(20*log10(abs(s_fft(1:FS/2))));
%    figure; spectrogram(imp.s(:,1,1),hamming(64),32,256,FS,'yaxis'); %スペクトログラムの確認
%全てのインパルス応答の確認
% f1=figure(1);
% %    MIC_chk=[1 7 13 19 22 28 36];
% set(f1,'position',get(0,'screensize'));
% for idx_LSP = 1:NO_LSP
%    for idx_MIC = 1:NO_MIC
%        subplot(NO_MIC,NO_LSP,idx_LSP+(idx_MIC-1)*NO_LSP,'replace');
%        plot(imp.s(:,idx_LSP,idx_MIC));
%    end
% end 
% drawnow;
    
%SNR/SDRの確認
for idx_LSP=1:NO_LSP
   for idx_MIC=1:NO_MIC
       S=abs(sum(imp.s(:,idx_LSP,idx_MIC).^2)/imp.L);
       N=abs(sum(noise(:,idx_MIC).^2)/(noisetime*FS-sig.L));
       D=abs(sum(imp.d(:,idx_LSP,idx_MIC).^2)/(DLY-1));
       SNR(idx_LSP,idx_MIC)=10*log10(S/N);
       SDR(idx_LSP,idx_MIC)=10*log10(S/D);
       if SNR(idx_LSP,idx_MIC)<=20
           warning('Low SNR at LSP%d MIC%d.',idx_LSP,idx_MIC);
           fprintf(logfile, 'Low SNR at LSP%d MIC%d.',idx_LSP,idx_MIC);
           figure; plot(imp.s(:,idx_LSP,idx_MIC)); 
           title(['LSP: ',num2str(idx_LSP),' MIC: ',num2str(idx_MIC),...
               ' SNR: ',num2str(SNR(idx_LSP,idx_MIC)),' dB.']);
           drawnow;
       end
       if SDR(idx_LSP,idx_MIC)<=20
           warning('Low SDR at LSP%d MIC%d.',idx_LSP,idx_MIC);
           fprintf(logfile, 'Low SDR at LSP%d MIC%d.',idx_LSP,idx_MIC);
           figure; plot(imp.s(:,idx_LSP,idx_MIC)); 
           title(['LSP: ',num2str(idx_LSP),' MIC: ',num2str(idx_MIC),...
               ' SDR: ',num2str(SDR(idx_LSP,idx_MIC)),' dB.']);
           drawnow;
       end
   end
end
% maxSNR=max(max(SNR))
minSNR=min(min(SNR));
% maxSDR=max(max(SDR))
minSDR=min(min(SDR));
fprintf('Minimum SNR: %f dB; Minimum SDR: %f dB.\n',minSNR,minSDR);
fprintf(logfile, 'Minimum SNR: %f dB; Minimum SDR: %f dB.\n',minSNR,minSDR);


fprintf('Saving data...');
fprintf(logfile, 'Saving data...');

%ファイル保存
%For old version MATLAB
if isempty(dir(strcat('RAW',date)))
    mkdir(strcat('RAW',date));
end
filename_raw = strcat('RAW',date,'\',s1,'L_',num2str(length(imp.raw)),s3,s4,s5,'.float');
writebin(imp.raw,filename_raw,'float');

%For old version MATLAB
if isempty(dir('IR'))
    mkdir('IR');
end
filename_imp = strcat('IR\',ss,s5,'.float');
writebin(imp.s,filename_imp,'float');
fprintf('Done.\n');
fprintf(logfile, 'Done.\n');
DUR=toc;
fprintf('Finished.\n');
fprintf(logfile, 'Finished.\n');
fprintf('Duration of the measurement: %f min.\n',DUR/60);
fprintf(logfile, 'Duration of the measurement: %f min.\n',DUR/60);
fclose(logfile);
end
    