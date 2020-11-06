function [s] = ilog_SS(N)
%Log-SS�����v���O����
%2020/01/19 written by Nin
%���c�搶�́u�C���p���X�����v���̊�b�v���Q�l����
%�M����N

J=N/2; %�������i�����j 3/4*N - 1/2*N ���x�Ƃ��邱�Ƃ�����
if rem(J,1)~=0
    error('Effective length is not an integer!\n');
end
a=J*pi/(N/2)/log(N/2);
s(1)=1;
k=1:N/2;
s(2:N/2+1)=sqrt(k).*exp(1i*a.*k.*log(k));
s(N/2+2:N)=conj(s(N/2:-1:2));
s=real(ifft(s));

%�~��V�t�g
s = circshift(s,[0,-(N-J)/2]); 

end