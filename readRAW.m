function raw=readRAW()
%ファイルから生データを読み込むプログラム(関数)
%2020/01/27 written by Nin
    filename=dir('RAW*.float');
    PARAM = strsplit(filename(1).name,'_');
    sig.L = str2double(PARAM{2});
    NO_LSP = str2double(PARAM{4});
    NO_MIC = str2double(PARAM{6});
    if length(PARAM)==7 && length(filename)==1
        raw = readbin(filename(1).name,'float');
        raw = reshape(raw,sig.L,NO_LSP,NO_MIC);
    elseif length(PARAM)==9
        for i=1:length(filename)
            raw(:,i) = readbin(filename(i).name,'float');
        end
        raw = reshape(raw,sig.L,NO_LSP,NO_MIC,length(filename));
    else
        error('Wrong format!');
    end
end