function imp = LMACalibration(varargin)
    if nargin==2
        imp=varargin{1};
        MODE=varargin{2};
    else
        imp=varargin{1};
        MODE='default';
    end
    if strcmp(MODE,'default')
       gain = readbin('LMA_GAIN.float','float');
    elseif strcmp(MODE,'LPF')
       gain = readbin('LMA_GAIN_LPF.float','float');
    elseif strcmp(MODE,'809')
       gain = readbin('LMA_GAIN_809.float','float');
    end
    for m = 1:48
       imp.s(:,:,m,:,:)=imp.s(:,:,m,:,:)./gain(m);
    end
    
    if strcmp(MODE,'809')
       imp.s(:,:,17:32,:,:)=circshift(imp.s(:,:,17:32,:,:),2,1);
       imp.s(1:2,:,17:32,:,:)=0;
       imp.s(:,:,33:48,:,:)=circshift(imp.s(:,:,33:48,:,:),4,1);
       imp.s(1:4,:,33:48,:,:)=0;
    end
end