%データ確認用プログラム
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%単一IR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
idx_LSP=1;
idx_MIC=48;
idx_ROT=1;

%%
%録音信号の確認
figure; plot(imp.raw(:,idx_LSP,idx_MIC,idx_ROT)); 

%%
%インパルス応答の確認
figure; plot(imp.s(:,idx_LSP,idx_MIC,idx_ROT)); 

%%
%周波数特性の確認
s_fft=fft(squeeze(imp.s(:,idx_LSP,idx_MIC,idx_ROT)),48000);

%%
%暗騒音の周波数特性
noise_fft=fft(noise(:,idx_MIC),48000);
figure; semilogx(20*log10(abs(s_fft(1:48000/2))));
hold on; semilogx(20*log10(abs(noise_fft(1:48000/2)))); hold off;

%%
%スペクトログラムの確認
figure; spectrogram(imp.s(:,idx_LSP,idx_MIC,idx_ROT),hamming(64),32,256,FS,'yaxis'); 

%%
%SNRの確認（偽）
P=abs(max(imp.s(:,idx_LSP,idx_MIC,idx_ROT)).^2);
S=abs(sum(imp.s(:,idx_LSP,idx_MIC,idx_ROT).^2)/imp.L);
N=abs(sum(noise(:,idx_MIC).^2)/FS/10);
%  N=abs(sum(imp.full(imp.L/2+1:end,idx_LSP,idx_MIC).^2)/imp.L*2);
%  N=abs(max(imp.s(imp.L/2+1:end,idx_LSP,idx_MIC)).^2);
PNR=10*log10(P/N)
SNR=10*log10(S/N)

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%複数IR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NO_LSP=12;
NO_MIC=36;
NO_ROT=72;
PHI=[0:2*pi/NO_ROT:2*pi];
THETA=[0:pi/NO_MIC:2*pi];

%%
%SNRの確認（偽）
for idx_LSP=1:NO_LSP
   for idx_MIC=1:NO_MIC
       for idx_ROT=1:NO_ROT
       P=abs(max(imp.s(:,idx_LSP,idx_MIC,idx_ROT)).^2);
       S=abs(sum(imp.s(:,idx_LSP,idx_MIC,idx_ROT).^2)/imp.L);
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

%%
%水平面指向特性
idx_LSP=1;
IR_horz = squeeze(imp.s(:,idx_LSP,19,:));
DIR_horz = 10*log10(sum(IR_horz.^2,1));
DIR_horz(NO_ROT+1) = DIR_horz(1);
figure;
polarplot(PHI,DIR_horz-max(DIR_horz)+30);

%%
%垂直面指向特性
idx_LSP=1;
IR_vert = squeeze(imp.s(:,idx_LSP,:,1));
IR_vert = [IR_vert flip(squeeze(imp.s(:,idx_LSP,:,NO_ROT/2+1)),2)];
IR_vert = circshift(IR_vert,-NO_MIC/2,2);
DIR_vert = 10*log10(sum(IR_vert.^2,1));
DIR_vert(NO_MIC*2+1) = DIR_vert(1);
figure;
polarplot(THETA,DIR_vert-max(DIR_vert)+30);

%%
%単一周波数指向性
idx_LSP=1;
freq=500;
IR_horz = squeeze(imp.s(:,idx_LSP,19,:));
IR_freq = fft(IR_horz,48000,1);
DIR_freq = 10*log10(abs(IR_freq(freq,:).^2));
DIR_freq(NO_ROT+1) = DIR_freq(1);
figure;
polarplot(PHI,DIR_freq-max(DIR_freq)+30);