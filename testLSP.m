function x = testLSP(setting)
%スピーカをテストするプログラム(関数)
%2020/01/27 written by Nin
%初期設定
switch setting
    case 'default'
        FS=48000; %サンプリング周波数
        DEVICE_ID=102; %デバイスID
        NO_LSP=1; %スピーカ数
        sig.A=0.1; %測定用信号の振幅
        sig.t=2; %測定用信号の長さ（秒）
        dt=3; %間の時間
    case 'manual'
        FS=input('Sampling frequency: ');
        DEVICE_ID=select_play_device;
        NO_LSP=input('No. of loudspeakers: ');
        sig.A=input('Signal amplitude: ');
        sig.t=input('Signal length (in sec) : ');
        dt=input('Time interval: ','s');
end

sig.s = randn(sig.t*FS,1); %ホワイトノイズ生成
sig.s = (sig.s/max(abs(sig.s)))*sig.A; %振幅正規化

%音を再生
for i = 1:NO_LSP
    pause(str2num(dt));
    x = play1(sig.s,i,FS,DEVICE_ID);  
end

end