function imp = RAW2IR(imp,sig,DLY)
%録音した生データからインパルス応答を算出するプログラム(関数)
%2020/01/27 written by Nin
%imp: インパルス応答構造体(imp.Lインパルス応答長，imp.raw生データが必要)
%sig: 測定信号構造体(sig.L信号長，sig.inv逆フィルタが必要)
%DLY: 機械遅延

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

end