function [s] = ilog_SS(N)
%Log-SS生成プログラム
%2020/01/19 written by Nin
%金田先生の「インパルス応答計測の基礎」を参考した
%信号長N

J=N/2; %実効長（整数） 3/4*N - 1/2*N 程度とすることが多い
if rem(J,1)~=0
    error('Effective length is not an integer!\n');
end
a=J*pi/(N/2)/log(N/2);
s(1)=1;
k=1:N/2;
s(2:N/2+1)=sqrt(k).*exp(1i*a.*k.*log(k));
s(N/2+2:N)=conj(s(N/2:-1:2));
s=real(ifft(s));

%円状シフト
s = circshift(s,[0,-(N-J)/2]); 

end