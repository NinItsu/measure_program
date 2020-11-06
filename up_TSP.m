function [s] = up_TSP(N)
%UpTSP生成プログラム
%2020/01/19 written by Nin
%金田先生の「インパルス応答計測の基礎」を参考した
%信号長N
%時間波形振幅はsqrt(2/J)

J=N/2; %実効長（偶数） 3/4*N - 1/2*N 程度とすることが多い
if rem(J,2)~=0
    error('Effective length is not an even number!\n');
end
k=0:N/2;
s(1:N/2+1)=exp(-1i*2*pi*J*(k/N).^2);
s(N/2+2:N)=conj(s(N/2:-1:2));
s=real(ifft(s));

%円状シフト
s = circshift(s,[0,(N-J)/2]); 

end