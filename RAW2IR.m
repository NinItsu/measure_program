function imp = RAW2IR(imp,sig,DLY)
%�^���������f�[�^����C���p���X�������Z�o����v���O����(�֐�)
%2020/01/27 written by Nin
%imp: �C���p���X�����\����(imp.L�C���p���X�������Cimp.raw���f�[�^���K�v)
%sig: ����M���\����(sig.L�M�����Csig.inv�t�t�B���^���K�v)
%DLY: �@�B�x��

%�C���p���X�����Z�o
fprintf('Calculating convolution...');
%    for idx_LSP = 1:NO_LSP
%        for idx_MIC = 1:NO_MIC
%             imp.full(:,idx_LSP,idx_MIC) = conv(imp.raw(:,idx_LSP,idx_MIC),sig.inv);
%           imp.full(:,idx_LSP,idx_MIC) = conv_fft(imp.raw(:,idx_LSP,idx_MIC),sig.inv,sig.L); %���g���̈�conv
%        end
%    end
imp.full=CONV(imp.raw,sig.inv);
fprintf('Done.\n');

%�@��̒x������菜�����C���p���X������
imp.s = imp.full(sig.L+DLY:sig.L+DLY+imp.L-1,:,:);

end