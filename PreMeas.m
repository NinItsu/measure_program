function imp = PreMeas(varargin)
%測定用信号を確認するプログラム(関数)
%2020/01/27 written by Nin
%2020/11/13 Updated: SNR/SDR calculation, high order distortion calculation. 
%           by Nin
%2021/11/02 Updated: Bandpass Log SS.
%           by Nin
%初期設定
if nargin == 1
    if isstruct(varargin{1})
    FS=varargin{1}.FS;DEVICE_ID=varargin{1}.DEVICE_ID;DLY=varargin{1}.DLY;
    NO_LSP=varargin{1}.NO_LSP;NO_MIC=varargin{1}.NO_MIC;
    imp=varargin{1}.imp;sig=varargin{1}.sig;
    GUI=true;
    end
end
if nargin ~= 1 || ( nargin == 1 && ~isstruct(varargin{1}))
        FS=input('Sampling frequency: ');
        DEVICE_ID=select_play_device;
        DLY=input('ADDA Delay (2150 for 809, 2150 for Anechoic Room) : ');
        NO_LSP=input('Index of loudspeakers: ');
        NO_MIC=input('Index of microphones: ');
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
GUI=false;
end
sig.L=sig.t*FS;
[sig.s sig.inv]=meas_sig_gen(sig,FS);

if GUI
fig = uifigure('Name','Measurement Status');
scrsize = get(0,'ScreenSize');
fig.Position=[scrsize(3)/2-400,scrsize(4)/2-300,800,600];
% movegui(fig,'center');
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
end

if GUI
    show_progress(status_id, ['No. of loudspeakers: ', num2str(NO_LSP)]);
    show_progress(status_id, ['No. of microphones: ', num2str(NO_MIC)]);
    show_progress(status_id, ['Sampling frequency: ', num2str(FS)]);
    show_progress(status_id, ['ADDA Delay: ', num2str(DLY)]);
    show_progress(status_id, ['Length of the IR: ', num2str(imp.L)]);
    show_progress(status_id, ['Signal type: ',sig.TYPE]);
    if (strcmp(sig.TYPE,'BPLogSS'))
        show_progress(status_id, ['Frequency Band: [',num2str(sig.fmin),', ',num2str(sig.fmax),']']);
    end
    show_progress(status_id, ['Signal amplitude: ', num2str(sig.A)]);
    show_progress(status_id, ['Signal length (in sec) : ', num2str(sig.t)]);
end
drawnow

%配列の初期化
imp.raw = zeros(sig.L,NO_LSP,NO_MIC);
imp.full = zeros(sig.L*2-1,NO_LSP,NO_MIC);
imp.s = zeros(imp.L,NO_LSP,NO_MIC);

initPlayrec(FS,DEVICE_ID,NO_LSP,NO_MIC);
%暗騒音測定 (10秒間)
show_progress(status_id, 'Measuring background noise...');drawnow
noisetime=10;
noise = doPlayrec('rec',noisetime*FS,NO_MIC);
show_progress(status_id, 'Done.');drawnow

%測定
show_progress(status_id, 'Measuring...');drawnow
show_progress(status_id, sprintf('Ch: %d ',NO_LSP));drawnow
imp.raw(:,1) = doPlayrec('playrec',sig.s,NO_LSP,NO_MIC);
show_progress(status_id, 'Done.');drawnow

%インパルス応答算出
imp = RAW2IR(imp,sig,DLY);
imp.d = imp.full(sig.L+1:sig.L+DLY-1,:,:);

if (strcmp(sig.TYPE,'LogSS'))
    [peak.v,peak.i]=max(abs(imp.full),[],1);
            imp.d2(:,1) = imp.full(...
        peak.i-floor(sig.L/2*log(2)/log(sig.L/2))-600:...
        peak.i-1200);
            imp.d3(:,1) = imp.full(...
        peak.i-floor(sig.L/2*log(3)/log(sig.L/2))-300:...
        peak.i-floor(sig.L/2*log(2)/log(sig.L/2))...
        -600);
            imp.d4(:,1) = imp.full(...
        peak.i-floor(sig.L/2*log(4)/log(sig.L/2))-150:...
        peak.i-floor(sig.L/2*log(3)/log(sig.L/2))...
        -300);
end
if (strcmp(sig.TYPE,'BPLogSS'))
    [peak.v,peak.i]=max(abs(imp.full),[],1);
            imp.d2(:,1) = imp.full(...
        peak.i-floor(sig.L/2*log(2)/log(sig.fmax/sig.fmin))-600:...
        peak.i-1200);
            imp.d3(:,1) = imp.full(...
        peak.i-floor(sig.L/2*log(3)/log(sig.fmax/sig.fmin))-300:...
        peak.i-floor(sig.L/2*log(2)/log(sig.fmax/sig.fmin))...
        -600);
            imp.d4(:,1) = imp.full(...
        peak.i-floor(sig.L/2*log(4)/log(sig.fmax/sig.fmin))-150:...
        peak.i-floor(sig.L/2*log(3)/log(sig.fmax/sig.fmin))...
        -300);
end
noise=CONV(noise,sig.inv);
noise=noise(sig.L+1:noisetime*FS,:);

%録音信号の確認
results_fig = uifigure('Name','Pre-Measure Results');
results_fig.Position=[scrsize(3)/2-scrsize(3)*0.4/2,scrsize(4)/2-scrsize(3)*0.4*0.75/2,scrsize(3)*0.4,scrsize(3)*0.4*0.75];
tg=uitabgroup(results_fig,'Position',[0,0,results_fig.Position(3:4)]);
%インパルス応答の確認
tab1=uitab(tg,'Title','Impulse Response');
tab_axes = axes('parent', tab1);
plot(tab_axes,imp.s); 
tab_axes.XLabel.String = 'Sample';
tab_axes.YLabel.String = 'Amplitude';
tab_axes.FontSize = 12;
%生録音データの確認
tab2=uitab(tg,'Title','Raw Record');
tab_axes = axes('parent', tab2);
plot(tab_axes,imp.raw);  
tab_axes.XLabel.String = 'Sample';
tab_axes.YLabel.String = 'Amplitude';
tab_axes.FontSize = 12;
%周波数特性の確認
tab3=uitab(tg,'Title','Frequency Response');
tab_axes = axes('parent', tab3);
s_fft=fft(imp.s,FS);
%暗騒音の周波数特性
noise_fft=fft(noise,FS);
distortion_fft=fft(imp.d,FS);
semilogx(tab_axes,20*log10(abs(s_fft(1:FS/2))));
tab_axes.XLim=[20 20000];
tab_axes.XGrid='on';
tab_axes.YGrid='on';
tab_axes.XMinorGrid='on';
tab_axes.YMinorGrid='on';
tab_axes.NextPlot='add';
semilogx(tab_axes,20*log10(abs(noise_fft(1:FS/2)))); 
if (strcmp(sig.TYPE,'LogSS')||strcmp(sig.TYPE,'BPLogSS'))
    distortion2_fft=fft(imp.d2,FS);
    semilogx(tab_axes,(1:FS/2)/2,20*log10(abs(distortion2_fft(1:FS/2))));
    distortion3_fft=fft(imp.d3,FS);
    semilogx(tab_axes,(1:FS/2)/3,20*log10(abs(distortion3_fft(1:FS/2))));
    distortion4_fft=fft(imp.d4,FS);
    semilogx(tab_axes,(1:FS/2)/4,20*log10(abs(distortion4_fft(1:FS/2))));
    legend(tab_axes,'IR','BGN','2nd DST','3rd DST','4th DST','Location','southeast','FontSize',12);
else
    semilogx(tab_axes,20*log10(abs(distortion_fft(1:FS/2))));
    legend(tab_axes,'IR','BGN','DST','Location','southeast','FontSize',12);
end
tab_axes.XLabel.String = 'Frequency (Hz)';
tab_axes.YLabel.String = 'Amplitude (dB)';
tab_axes.FontSize = 12;
%スペクトログラムの確認
tab4=uitab(tg,'Title','Spectrogram');
tab_axes = axes('parent', tab4);
[imp_spec,spec_f,spec_t,spec_ps]=spectrogram(imp.full,hamming(64),32,256,FS,'yaxis');
log_ps = 10*log10(spec_ps);
surf(tab_axes,spec_t(1:4:end),spec_f/1000,log_ps(:,1:4:end));
tab_axes.View=[0 90];
shading(tab_axes,'interp');
caxis(tab_axes,[max(log_ps,[],'all')-30,max(log_ps,[],'all')]);
cb=colorbar(tab_axes);
cb.Label.String = 'Power/Frequency (dB/Hz)';
tab_axes.YLim = [0 max(spec_f)/1000];
tab_axes.XLabel.String = 'Time (s)';
tab_axes.YLabel.String = 'Frequency (kHz)';
tab_axes.FontSize = 12;
% %非線形歪みの確認
% figure(3);spectrogram(imp.full(:,1,idx_MIC),hamming(64),32,256,FS,'yaxis');

%SNRの確認（偽）
       S=abs(sum(imp.s.^2)/imp.L);
       N=abs(sum(noise.^2)/(noisetime*FS-sig.L));
       D=abs(sum(imp.d.^2)/(DLY-1));
       SDR=10*log10(S/D);
       SNR=10*log10(S/N);
       low_SNR = SNR<=20;
       low_SDR = SDR<=20;
       if low_SNR || low_SDR
           if low_SNR
                err_msg=sprintf('Low SNR at LSP%d MIC%d.',NO_LSP,NO_MIC);
                if low_SDR
                    err_msg=sprintf('Low SNR & SDR at LSP%d MIC%d.',NO_LSP,NO_MIC);
                end
           else
                err_msg=sprintf('Low SDR at LSP%d MIC%d.',NO_LSP,NO_MIC);
           end
           show_warning(status_id, err_msg);drawnow
       end
show_progress(status_id, sprintf('SNR: %f dB; SDR: %f dB.\n',SNR,SDR));
show_progress(status_id, 'Finished!');
uialert(fig,'Measurement finished!','Success!','Icon','success');
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