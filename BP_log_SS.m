function [s,inv] = BP_log_SS(N,fmin,fmax,FS)
%Bandpass Log-SS生成プログラム
%2020/01/20 written by Nin
%金田先生の「インパルス応答計測の基礎」を参考した
%信号長N

J=N/2; %実効長（整数） 3/4*N - 1/2*N 程度とすることが多い
if rem(J,1)~=0
    error('Effective length is not an integer!\n');
end
k1=fmin/FS*N;
k2=fmax/FS*N;
a=log((k2/k1).^(1/J));
b=log(k1);
s(1)=1;
k=1:N/2;
C1=-rem(-2/N/a*(log(N/2-1-b)*N/2),1);
s(2:N/2+1)=1./sqrt(k).*exp(1i*(-2*pi/N/a.*(log(k)-1-b).*k+C1*pi));
s(N/2+2:N)=conj(s(N/2:-1:2));
inv=1./s;
s=real(ifft(s));
inv=real(ifft(inv));

%円状シフト
s = circshift(s,[0,(N-J)/2]); 
inv = circshift(inv,[0,-(N-J)/2]); 

end