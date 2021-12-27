function [imp] = MeasProg_turntable(varargin)
%インパルス応答を測定するプログラム(回転台)
%2020/09/25 written by Nin
%2021/11/02 Updated: Bandpass Log SS, log file. 
%           NOTE: SNR/SDR calculation, time/size/memory estimation TO BE
%           UPDATED.
%           by Nin
%初期設定
if nargin == 1
    if isstruct(varargin{1})
    FS=varargin{1}.FS;DEVICE_ID=varargin{1}.DEVICE_ID;DLY=varargin{1}.DLY;
    NO_LSP=varargin{1}.NO_LSP;NO_MIC=varargin{1}.NO_MIC;TRIAL=varargin{1}.TRIAL;
    WARM_UP=varargin{1}.WARM_UP;rot=varargin{1}.rot;imp=varargin{1}.imp;sig=varargin{1}.sig;
    meas_name=varargin{1}.meas_name;file_dir=varargin{1}.file_dir;SAVE_RAW=varargin{1}.SAVE_RAW;
    GUI=true;
    end
end
if nargin ~= 1 || ( nargin == 1 && ~isstruct(varargin{1}))
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
meas_name=input('Measure name: ','s');
file_dir='';
SAVE_RAW=true;
GUI=false;
end
sig.L=sig.t*FS;
[sig.s sig.inv]=meas_sig_gen(sig,FS);
if length(NO_LSP)==1
    set_LSP=[1:NO_LSP];
else
    set_LSP=NO_LSP;
    NO_LSP=length(set_LSP);
end
if length(NO_MIC)==1
    set_MIC=[1:NO_MIC];
else
    set_MIC=NO_MIC;
    NO_MIC=length(set_MIC);
end
%測定用信号の確認
%figure; plot(sig.s);
%figure; plot([0:sig.L-1],sig.s);
%sound(sig.s,FS);
%figure; spectrogram(sig.s,hamming(64),32,256,FS,'yaxis'); 

noisetime=10;                                                               %暗騒音測定時間(sec)
WRM_TIME=1;                                                                 %スピーカーウォーミングアップ時間(min)

%IRファイル容量推定(GB)
estimated_file_size=...
imp.L*NO_LSP*NO_MIC*((rot.MAX-rot.MIN)/rot.INR+1)/1024/1024/1024/2*8;
size_estm=sprintf('Estimated IR file size: %f GB.\n',estimated_file_size);

%RAWファイル容量推定(GB)
estimated_raw_size=...
sig.L*NO_LSP*NO_MIC*((rot.MAX-rot.MIN)/rot.INR+1)/1024/1024/1024/2*8;
raw_estm=sprintf('Estimated RAW file size: %f GB.\n',estimated_raw_size);

%所要メモリ推定(GB)
estimated_memory_required=...                                                               %RAW2IR/CONV関数の呼び出しにより2倍のメモリが必要
(sig.L*(3*2+2*2)+imp.L*2)*NO_LSP*NO_MIC*8/1024/1024/1024;
memory_estm=sprintf('Estimated memory required: %f GB.\n',estimated_memory_required);

global stop_flag
stop_flag=false;
if GUI
fig = uifigure('Name','Measurement Status');
scrsize = get(0,'ScreenSize');
fig.Position=[scrsize(3)/2-400,scrsize(4)/2-300,800,600];
msg_estm=[size_estm,raw_estm,memory_estm];
selection = uiconfirm(fig,msg_estm,'Please Confirm',...
    'Options',{'Start Measurement','Cancel'},...
           'DefaultOption',1,'CancelOption',2);
if strcmp(selection,'Cancel')
    close(fig);
    return;
end
% pause_fig = figure('visible','off');
pause_button = uibutton(fig,'state','Text','PAUSE','FontSize',18,...
    'ValueChangedFcn', @(pause_button,event) pauseButtonChanged(pause_button,fig));
pause_button.Position=[fig.Position(3)/8,fig.Position(4)-45,fig.Position(3)/4,40];
stop_button = uibutton(fig,'Text','STOP','FontSize',18,...
    'ButtonPushedFcn', @(stop_button,event) stopButtonPushed(stop_button));
stop_button.Position=[fig.Position(3)/8*5,fig.Position(4)-45,fig.Position(3)/4,40];
status_id = uitextarea(fig,'Enable','on','Editable','off','Value','Measurement begin...','FontSize',16);
status_id.Position=[0,0,fig.Position(3),fig.Position(4)-50];
drawnow
else
    status_id = 1;
    fprintf(msg_estm);
end
tic
%ファイル名
date=datestr(now,'yymmdd');
s1 = strcat(meas_name,'-',sig.TYPE,num2str(sig.A),'-');
s2 = strcat('L_',num2str(imp.L));
s3 = strcat('_LSPNO_',num2str(NO_LSP));
s4 = strcat('_MICNO_',num2str(NO_MIC));
s6 = strcat('_TRIAL',num2str(TRIAL));
ss = strcat(s1,s2,s3,s4);

show_progress(status_id, ['Date: ',datestr(now)]);
if GUI
    show_progress(status_id, ['No. of loudspeakers: ', num2str(NO_LSP)]);
    show_progress(status_id, ['No. of microphones: ', num2str(NO_MIC)]);
    show_progress(status_id, ['Rotation range: [',num2str(rot.MIN),', ',num2str(rot.MAX),']']);
    show_progress(status_id, ['Rotation step: ', num2str(rot.INR)]);
    show_progress(status_id, ['Sampling frequency: ', num2str(FS)]);
    show_progress(status_id, ['ADDA Delay: ', num2str(DLY)]);
    show_progress(status_id, ['Length of the IR: ', num2str(imp.L)]);
    show_progress(status_id, ['Signal type: ',sig.TYPE]);
    if (strcmp(sig.TYPE,'BPLogSS'))
        show_progress(status_id, ['Frequency Band: [',num2str(sig.fmin),', ',num2str(sig.fmax),']']);
    end
    show_progress(status_id, ['Signal amplitude: ', num2str(sig.A)]);
    show_progress(status_id, ['Signal length (in sec) : ', num2str(sig.t)]);
    show_progress(status_id, ['Trial: ', num2str(TRIAL)]);
    show_progress(status_id, ['Loudspeaker warming up: ', WARM_UP]);
    show_progress(status_id, sprintf('Estimated IR file size: %f GB.',estimated_file_size));
    show_progress(status_id, sprintf('Estimated RAW file size: %f GB.',estimated_raw_size));
    show_progress(status_id, sprintf('Estimated memory required: %f GB.',estimated_memory_required));
end
drawnow
%logファイル
logfile=fopen(strcat(file_dir,ss,'.log'),'w');
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
fprintf(logfile, 'Estimated IR file size: %f GB.\n',estimated_file_size);
fprintf(logfile, 'Estimated RAW file size: %f GB.\n',estimated_raw_size);
fprintf(logfile, 'Estimated memory required: %f GB.\n',estimated_memory_required);

%配列の初期化
imp.raw = zeros(sig.L,NO_LSP,NO_MIC);
imp.full = zeros(sig.L*2-1,NO_LSP,NO_MIC);
imp.s = zeros(imp.L,NO_LSP,NO_MIC);
file_num = 0;

%回転台初期設定 佐藤さんからもらったプログラムを参考した
rot.port = serial('COM7'); %測定用機械とポート接続
fopen(rot.port);
get(rot.port);
set(rot.port,'Parity','odd','Terminator',{'CR/LF','CR/LF'},'StopBits',1,'DataBits',7);%重要!
get(rot.port);
pause(10);
%原点復帰を呼び出す。
fprintf(rot.port,'L16 0');fscanf(rot.port) %0番が原点復帰
fprintf(rot.port,'S1');fscanf(rot.port)
pause(10);
fprintf(rot.port,'S2');fscanf(rot.port)
%回転プログラムを呼び出す　3番が10度  2番が2.5度
if rem(rot.INR,10)==0
    fprintf(rot.port,'L16 3');fscanf(rot.port)
else
    fprintf(rot.port,'L16 2');fscanf(rot.port)
end 

initPlayrec(FS,DEVICE_ID,NO_LSP,NO_MIC);
%暗騒音測定 (10秒間)
show_progress(status_id, 'Measuring background noise...');drawnow
fprintf(logfile, 'Measuring background noise...\n');
% noise = recs(NO_MIC,10*FS,FS,DEVICE_ID);
noise = doPlayrec('rec',noisetime*FS,set_MIC);
show_progress(status_id, 'Done.');drawnow
fprintf(logfile, 'Done.\n');
show_progress(status_id, 'Saving noise data...');drawnow
fprintf(logfile, 'Saving noise data...');
%For old version MATLAB
if isempty(dir([file_dir,'BGN']))
    mkdir([file_dir,'BGN']);
end
filename_bgn = strcat(file_dir,'BGN\',meas_name,'-',s4,s6,'.float');
writebin(noise,filename_bgn,'float');
file_num=file_num+1;
saved_file{file_num}=filename_bgn;
show_progress(status_id, 'Done.');drawnow
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
    show_progress(status_id, ['Loudspeaker warming up(',num2str(WRM_TIME),' minutes)...']);drawnow
    fprintf(logfile, ['Loudspeaker warming up(',num2str(WRM_TIME),' minutes)...\n']);
%     plays(WN,NO_LSP,FS,DEVICE_ID);
    doPlayrec('play',WN,set_LSP);
    show_progress(status_id, 'Done.');drawnow
    fprintf(logfile, 'Done.\n');
end


for ang = rot.MIN:rot.INR:rot.MAX
    
    %測定
    show_progress(status_id, 'Measuring...');drawnow
    fprintf(logfile, 'Measuring...');
    for idx_LSP = 1:NO_LSP
    if stop_flag
        show_progress(status_id, 'Measurement has been cancelled!');drawnow
        fprintf(logfile, '\nMeasurement has been cancelled!');
        fclose(logfile);
        uialert(fig,'Measurement has been cancelled!','Warning!');
        fclose(rot.port); 
        delete(rot.port);
        clear rot.port;
        for file_idx=1:file_num;
            delete(saved_file{file_idx});
        end
        if length(dir('BGN'))==2
            rmdir('BGN');
        end
        if SAVE_RAW
        if length(dir(strcat(file_dir,'RAW',date)))==2
            rmdir(strcat(file_dir,'RAW',date));
        end
        end
        if length(dir('IR'))==2
            rmdir('IR');
        end
        return;
        return;
    end
        show_progress(status_id, sprintf('Ch: %d ',set_LSP(idx_LSP)));drawnow
        fprintf(logfile, '\nCh: %d ',set_LSP(idx_LSP));
%         imp.raw(:,idx_LSP,:) = play1_rec(sig.s,idx_LSP,NO_MIC,FS,DEVICE_ID);
        imp.raw(:,idx_LSP,:) = doPlayrec('playrec',sig.s,set_LSP(idx_LSP),set_MIC);
    end
    show_progress(status_id, 'Done.');drawnow
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
    
    %SNRの確認（偽）
   for idx_LSP=1:NO_LSP
       for idx_MIC=1:NO_MIC
%            P=abs(max(imp.s(:,idx_LSP,idx_MIC)).^2);
           S=abs(sum(imp.s(:,idx_LSP,idx_MIC).^2)/imp.L);
           N=abs(sum(noise(:,idx_MIC).^2)/(noisetime*FS-sig.L));
           D=abs(sum(imp.d(:,idx_LSP,idx_MIC).^2)/(DLY-1));
%            N=abs(sum(imp.full(imp.L/2+1:end,idx_LSP,idx_MIC).^2)/imp.L*2);
%            N=abs(max(imp.s(imp.L/2+1:end,idx_LSP,idx_MIC)).^2);
%            PNR(idx_LSP,idx_MIC)=10*log10(P/N);
           SNR(idx_LSP,idx_MIC)=10*log10(S/N);
           SDR(idx_LSP,idx_MIC)=10*log10(S/D);
           if low_SNR || low_SDR
               if ~exist('warning_fig')
                   warning_fig = uifigure('Name','Low SNR / Low SDR Warning');
                   warning_fig.Position=[scrsize(3)/2-500,scrsize(4)/2-400,1000,800];
                   tg=uitabgroup(warning_fig,'Position',[0,0,warning_fig.Position(3:4)]);
               end
               if low_SNR
                    err_msg=sprintf('Low SNR at LSP%d MIC%d.',set_LSP(idx_LSP),set_MIC(idx_MIC));
                    err_title=['Angle: ',num2str(ang),' degree LSP: ',num2str(set_LSP(idx_LSP)),' MIC: ',num2str(set_MIC(idx_MIC)),...
                   ' SNR: ',num2str(SNR(idx_LSP,idx_MIC)),' dB.'];
                    if low_SDR
                        err_msg=sprintf('Low SNR & SDR at LSP%d MIC%d.',set_LSP(idx_LSP),set_MIC(idx_MIC));
                        err_title=['Angle: ',num2str(ang),' degree LSP: ',num2str(set_LSP(idx_LSP)),' MIC: ',num2str(set_MIC(idx_MIC)),...
                        ' SNR: ',num2str(SNR(idx_LSP,idx_MIC)),' dB, SDR: ',num2str(SDR(idx_LSP,idx_MIC)),' dB.'];
                    end
               else
                    err_msg=sprintf('Low SDR at LSP%d MIC%d.',set_LSP(idx_LSP),set_MIC(idx_MIC));
                    err_title=['Angle: ',num2str(ang),' degree LSP: ',num2str(set_LSP(idx_LSP)),' MIC: ',num2str(set_MIC(idx_MIC)),...
                   ' SDR: ',num2str(SDR(idx_LSP,idx_MIC)),' dB.'];
               end
               show_warning(status_id, err_msg);drawnow
               fprintf(logfile, err_msg);
               tab=uitab(tg,'Title',[num2str(set_LSP(idx_LSP)),';',num2str(set_MIC(idx_MIC))]);
               tab_axes = axes('parent', tab);
               plot(tab_axes,imp.s(:,idx_LSP,idx_MIC)); 
               tab_axes.Title.String=err_title;
               drawnow;
           end
       end
   end
   minSNR=min(min(SNR));
   minSDR=min(min(SDR));
    
   show_progress(status_id, sprintf('Saving data...Angle: %f degree.',ang));
   fprintf(logfile, 'Saving data...Angle: %f degree.\n',ang);
   s5=strcat('_ANG_',num2str(ang));


    %ファイル保存
    if SAVE_RAW
    %For old version MATLAB
    if isempty(dir(strcat(file_dir,'RAW',date)))
        mkdir(strcat(file_dir,'RAW',date));
    end
    filename_raw = strcat(file_dir,'RAW',date,'\',s1,'L_',num2str(length(imp.raw)),s3,s4,s5,s6,'.float');
    writebin(imp.raw,filename_raw,'float');
    file_num=file_num+1;
    saved_file{file_num}=filename_raw;
    end

    %For old version MATLAB
    if isempty(dir([file_dir,'IR']))
        mkdir([file_dir,'IR']);
    end
    filename_imp = strcat(file_dir,'IR\',ss,s5,s6,'.float');
    writebin(imp.s,filename_imp,'float');
    file_num=file_num+1;
    saved_file{file_num}=filename_imp;
    show_progress(status_id, 'Done.');drawnow
    fprintf(logfile, 'Done.\n');

    if ~strcmp(rot.STAT,'ON')
        return;
    end
    
    %回転する 5度の場合は2.5度を2回
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

fclose(rot.port); %ポート接続解除 もしエラーが出たら必ずfcloseしてからデバッグ
delete(rot.port);
clear rot.port;
DUR=toc;
show_progress(status_id, 'Finished.');drawnow
fprintf(logfile, 'Finished.\n');
show_progress(status_id, sprintf('Duration of the measurement: %f min.\n',DUR/60));
fprintf(logfile, 'Duration of the measurement: %f min.\n',DUR/60);
fclose(logfile);
if GUI
uialert(fig,'Measurement finished!','Success!','Icon','success');
end
end

function stopButtonPushed(stop_button)
        global stop_flag
        stop_flag=true;
end

function pauseButtonChanged(pause_button,pause_fig)
    if pause_button.Value
        uiwait(pause_fig)
    else
        uiresume(pause_fig)
    end
end