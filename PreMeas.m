function imp = PreMeas(setting)
%測定用信号を確認するプログラム(関数)
%2020/01/27 written by Nin
%初期設定
switch setting
    case 'default'
        FS=48000; %サンプリング周波数
        DEVICE_ID=102; %デバイスID
        DLY=2150; %機器の遅延数 809:2150; 無響室:2150
        NO_MIC=1; %マイク数
        NO_LSP=1; %スピーカ数
        imp.L=2400; %インパルス応答長(サンプル数)
        sig.TYPE='TSP'; %測定用信号の種類（TSP=UPTSP/DWTSP/LogSS）
        sig.A=0.1; %測定用信号の振幅
        sig.t=2; %測定用信号の長さ（秒）
        sig.L=sig.t*FS; %測定用信号の長さ（サンプル数）
        [sig.s sig.inv]=meas_sig_gen(sig,FS); %測定用信号の生成
    case 'manual'
        FS=input('Sampling frequency: ');
        DEVICE_ID=select_play_device;
        DLY=input('ADDA Delay (2150 for 809, 2150 for Anechoic Room) : ');
        NO_LSP=input('No. of loudspeakers: ');
        NO_MIC=input('No. of microphones: ');
        imp.L=input('Length of the IR: ');
        sig.TYPE=input('Signal type (TSP=UPTSP/DWTSP/LogSS) : ','s');
        if (~strcmp(sig.TYPE,'TSP'))&&(~strcmp(sig.TYPE,'UPTSP'))&(~strcmp(sig.TYPE,'DWTSP'))&&(~strcmp(sig.TYPE,'LogSS'))
            warning('Unknown command, use default TSP.\n');
            sig.TYPE='TSP';
        end
        sig.A=input('Signal amplitude: ');
        sig.t=input('Signal length (in sec) : ');
        sig.L=sig.t*FS;
        [sig.s sig.inv]=meas_sig_gen(sig,FS);
end

%配列の初期化
imp.raw = zeros(sig.L,NO_LSP,NO_MIC);
imp.full = zeros(sig.L*2-1,NO_LSP,NO_MIC);
imp.s = zeros(imp.L,NO_LSP,NO_MIC);

%暗騒音測定 (10秒間)
fprintf('Measuring background noise...\n');
noise = recs(NO_MIC,10*FS,FS,DEVICE_ID);
fprintf('Done.\n');

%測定
fprintf('Measuring...');
for idx_LSP = 1:NO_LSP
    fprintf('\nCh: %d ',idx_LSP);
    imp.raw(:,idx_LSP,:) = play1_rec(sig.s,idx_LSP,NO_MIC,FS,DEVICE_ID);
end
fprintf('Done.\n');

%インパルス応答算出
fprintf('Calculating convolution...');
%    for idx_LSP = 1:NO_LSP
%        for idx_MIC = 1:NO_MIC
%             imp.full(:,idx_LSP,idx_MIC) = conv(imp.raw(:,idx_LSP,idx_MIC),sig.inv);
%           imp.full(:,idx_LSP,idx_MIC) = conv_fft(imp.raw(:,idx_LSP,idx_MIC),sig.inv,sig.L); %周波数領域conv
%        end
%    end
imp.full=CONV(imp.raw,sig.inv);
fprintf('Done.\n');

%機器の遅延を取り除いたインパルス応答長
imp.s = imp.full(sig.L+DLY:sig.L+DLY+imp.L-1,:,:);
impnoise = imp.full(sig.L+1:sig.L+DLY-1,:,:);


%録音信号の確認
figure; subplot(2,2,1); plot(imp.raw(:,1,1)); 
%インパルス応答の確認
subplot(2,2,2); plot(imp.s(:,1,1)); 
%周波数特性の確認
s_fft=fft(squeeze(imp.s(:,1,1)),FS);
%暗騒音の周波数特性
noise_fft=fft(noise(:,1),FS);
subplot(2,2,3); semilogx(20*log10(abs(s_fft(1:FS/2))));
hold on; semilogx(20*log10(abs(noise_fft(1:FS/2)))); hold off;
%スペクトログラムの確認
subplot(2,2,4); spectrogram(imp.s(:,1,1),hamming(64),32,256,FS,'yaxis'); 

%全てのインパルス応答の確認
f1=figure(2);
set(f1,'position',get(0,'screensize'));
for idx_LSP = 1:NO_LSP
   for idx_MIC = 1:NO_MIC
       subplot(NO_MIC,NO_LSP,idx_LSP+(idx_MIC-1)*NO_LSP,'replace');
       plot(imp.s(:,idx_LSP,idx_MIC));
   end
end 

%SNRの確認（偽）
for idx_LSP=1:NO_LSP
   for idx_MIC=1:NO_MIC
       P=abs(max(imp.s(:,idx_LSP,idx_MIC)).^2);
       S=abs(sum(imp.s(:,idx_LSP,idx_MIC).^2)/imp.L);
%        N=abs(sum(noise(:,idx_MIC).^2)/FS/10);
       N=abs(sum(impnoise(:,idx_LSP,idx_MIC).^2)/(DLY-1));
%            N=abs(sum(imp.full(imp.L/2+1:end,idx_LSP,idx_MIC).^2)/imp.L*2);
%            N=abs(max(imp.s(imp.L/2+1:end,idx_LSP,idx_MIC)).^2);
       PNR(idx_LSP,idx_MIC)=10*log10(P/N);
       SNR(idx_LSP,idx_MIC)=10*log10(S/N);
       if SNR(idx_LSP,idx_MIC)<=20
           warning('Low SNR at LSP%d MIC%d.',idx_LSP,idx_MIC);
           figure; plot(imp.s(:,idx_LSP,idx_MIC)); 
           title(['LSP: ',num2str(idx_LSP),' MIC: ',num2str(idx_MIC),...
               ' SNR: ',num2str(SNR(idx_LSP,idx_MIC)),' dB.']);
           drawnow;
       end
   end
end
maxSNR=max(max(SNR))
minSNR=min(min(SNR))

end