function noise=readBGN()
%ファイルから生データを読み込むプログラム(関数)
%2020/01/27 written by Nin
    filename=dir('BGN*.float');
    PARAM = strsplit(filename(1).name,'_');
    NO_MIC = str2double(PARAM{3});
    noise = readbin(filename(1).name,'float');
    noise = reshape(noise,[],NO_MIC);
end