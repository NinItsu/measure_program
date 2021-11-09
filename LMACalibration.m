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
    end
    for m = 1:48
       imp.s(:,:,m,:,:)=imp.s(:,:,m,:,:)./gain(m);
    end
end