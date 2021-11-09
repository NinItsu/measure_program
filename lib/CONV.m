function w=CONV(u,v,MODE)
% 周波数領域畳み込み
% 2020/01/21 written by Nin
% 行列計算可能 ！！メモリー使用要注意！！
% u: 信号 v: フィルタ
% vの2番目以降の次元はuと一致するか，1次元のベクトルにならないといけない
% MODE: 'MATRIX' 行列計算(default) 'VECTOR' ベクトルごと計算
    
if nargin==2
    w=CONV(u,v,'MATRIX');
    return;
elseif nargin==3
    switch MODE
        case 'MATRIX'
            sz.u=size(u);
            sz.v=size(v);
            mem=prod([sz.u(1)+sz.v(1) sz.u(2:end)]);
            if mem>=1e8
                warning('Matrix too large, VECTOR mode will be used.\n');
                w=CONV(u,v,'VECTOR');
                return;
            end
            if ~isequal(sz.u(2:end),sz.v(2:end)) 
                if isequal(sz.v(2:end),1) %vが1列ベクトルの場合，後で拡張する
                    FLG=true;
                else
                    error('Different size!'); %配列サイズが異なる
                end
            else
                FLG=false;
            end
            sz.alt=prod(sz.u(2:end));
            u=reshape(u,sz.u(1),[]);
            u=[zeros(sz.v(1),sz.alt) ; u];
            v=reshape(v,sz.v(1),[]);
            v(sz.v(1)+sz.u(1),1)=0;
            U=fft(u,sz.v(1)+sz.u(1),1);
            V=fft(v,sz.v(1)+sz.u(1),1);
            if FLG
                V=repmat(V,1,sz.alt);
            end
            w=ifft(U.*V,sz.v(1)+sz.u(1),1);
            w=reshape(w,[sz.v(1)+sz.u(1) sz.u(2:end)]);
            w=circshift(w,-sz.v(1),1);
        case 'VECTOR'
            sz.u=size(u);
            sz.v=size(v);
            if ~isequal(sz.u(2:end),sz.v(2:end)) 
                if isequal(sz.v(2:end),1) %vが1列ベクトルの場合，後で拡張する
                    FLG=true;
                else
                    error('Different size!'); %配列サイズが異なる
                end
            else
                FLG=false;
            end
            sz.alt=prod(sz.u(2:end));
            u=reshape(u,sz.u(1),[]);
            u=[zeros(sz.v(1),sz.alt) ; u];
            v=reshape(v,sz.v(1),[]);
            v(sz.v(1)+sz.u(1),1)=0;
            for idx=1:sz.alt
                U=fft(u(:,idx),sz.v(1)+sz.u(1),1);
                if FLG
                    V=fft(v,sz.v(1)+sz.u(1),1);
                else
                    V=fft(v(:,idx),sz.v(1)+sz.u(1),1);
                end
                w(:,idx)=ifft(U.*V,sz.v(1)+sz.u(1),1);
            end
            w=reshape(w,[sz.v(1)+sz.u(1) sz.u(2:end)]);
            w=circshift(w,-sz.v(1),1);
        case 'VECTOR_PAR'
            sz.u=size(u);
            sz.v=size(v);
            if ~isequal(sz.u(2:end),sz.v(2:end)) 
                if isequal(sz.v(2:end),1) %vが1列ベクトルの場合，後で拡張する
                    FLG=true;
                else
                    error('Different size!'); %配列サイズが異なる
                end
            else
                FLG=false;
            end
            sz.alt=prod(sz.u(2:end));
            u=reshape(u,sz.u(1),[]);
            u=[zeros(sz.v(1),sz.alt) ; u];
            v=reshape(v,sz.v(1),[]);
            v(sz.v(1)+sz.u(1),1)=0;
            parfor idx=1:sz.alt
                U=fft(u(:,idx),sz.v(1)+sz.u(1),1);
                if FLG
                    V=fft(v,sz.v(1)+sz.u(1),1);
                else
                    V=fft(v(:,idx),sz.v(1)+sz.u(1),1);
                end
                w(:,idx)=ifft(U.*V,sz.v(1)+sz.u(1),1);
            end
            w=reshape(w,[sz.v(1)+sz.u(1) sz.u(2:end)]);
            w=circshift(w,-sz.v(1),1);
        otherwise
            warning('Unknown mode, MATRIX mode will be used.\n');
            w=CONV(u,v,'MATRIX');
    end
else
    error('Invalid input!');
end
end