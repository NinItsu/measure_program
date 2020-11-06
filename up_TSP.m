function [s] = up_TSP(N)
%UpTSP�����v���O����
%2020/01/19 written by Nin
%���c�搶�́u�C���p���X�����v���̊�b�v���Q�l����
%�M����N
%���Ԕg�`�U����sqrt(2/J)

J=N/2; %�������i�����j 3/4*N - 1/2*N ���x�Ƃ��邱�Ƃ�����
if rem(J,2)~=0
    error('Effective length is not an even number!\n');
end
k=0:N/2;
s(1:N/2+1)=exp(-1i*2*pi*J*(k/N).^2);
s(N/2+2:N)=conj(s(N/2:-1:2));
s=real(ifft(s));

%�~��V�t�g
s = circshift(s,[0,(N-J)/2]); 

end