function w=CONV(u,v,MODE)
% ���g���̈��ݍ���
% 2020/01/21 written by Nin
% �s��v�Z�\ �I�I�������[�g�p�v���ӁI�I
% u: �M�� v: �t�B���^
% v��2�Ԗڈȍ~�̎�����u�ƈ�v���邩�C1�����̃x�N�g���ɂȂ�Ȃ��Ƃ����Ȃ�
% MODE: 'MATRIX' �s��v�Z(default) 'VECTOR' �x�N�g�����ƌv�Z
    
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
                if isequal(sz.v(2:end),1) %v��1��x�N�g���̏ꍇ�C��Ŋg������
                    FLG=true;
                else
                    error('Different size!'); %�z��T�C�Y���قȂ�
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
                if isequal(sz.v(2:end),1) %v��1��x�N�g���̏ꍇ�C��Ŋg������
                    FLG=true;
                else
                    error('Different size!'); %�z��T�C�Y���قȂ�
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
                if isequal(sz.v(2:end),1) %v��1��x�N�g���̏ꍇ�C��Ŋg������
                    FLG=true;
                else
                    error('Different size!'); %�z��T�C�Y���قȂ�
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