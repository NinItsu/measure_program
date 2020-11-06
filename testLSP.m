function x = testLSP(setting)
%�X�s�[�J���e�X�g����v���O����(�֐�)
%2020/01/27 written by Nin
%�����ݒ�
switch setting
    case 'default'
        FS=48000; %�T���v�����O���g��
        DEVICE_ID=102; %�f�o�C�XID
        NO_LSP=1; %�X�s�[�J��
        sig.A=0.1; %����p�M���̐U��
        sig.t=2; %����p�M���̒����i�b�j
        dt=3; %�Ԃ̎���
    case 'manual'
        FS=input('Sampling frequency: ');
        DEVICE_ID=select_play_device;
        NO_LSP=input('No. of loudspeakers: ');
        sig.A=input('Signal amplitude: ');
        sig.t=input('Signal length (in sec) : ');
        dt=input('Time interval: ','s');
end

sig.s = randn(sig.t*FS,1); %�z���C�g�m�C�Y����
sig.s = (sig.s/max(abs(sig.s)))*sig.A; %�U�����K��

%�����Đ�
for i = 1:NO_LSP
    pause(str2num(dt));
    x = play1(sig.s,i,FS,DEVICE_ID);  
end

end