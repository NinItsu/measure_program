function imp=readIR()
%ファイルからインパルス応答を読み込むプログラム(関数)
%2020/01/27 written by Nin
    filename=dir('IR\*.float');
    PARAM = strsplit(filename(1).name,'-');
    PARAM = strsplit(PARAM{end},'_');
    imp.L = str2double(PARAM{2});
    NO_LSP = str2double(PARAM{4});
    NO_MIC = str2double(PARAM{6});
    if length(PARAM)==7 && length(filename)==1
        imp.s = readbin(strcat('IR\',filename(1).name),'float');
        imp.s = reshape(imp.s,imp.L,NO_LSP,NO_MIC);
    elseif length(PARAM)==9
        for i=1:length(filename)
            imp.s(:,i) = readbin(strcat('IR\',filename(i).name),'float');
        end
        imp.s = reshape(imp.s,imp.L,NO_LSP,NO_MIC,length(filename));
    elseif length(PARAM)==11
        pos=strfind(filename(1).name,'_Z_');
        fn=string({filename(:).name});
        NO_Z=sum(strncmp(fn,fn(1),pos));
        NO_X=length(filename)./NO_Z;
        for i=1:length(filename)
            PARAM = strsplit(filename(i).name,'-');
            PARAM = strsplit(PARAM{end},'_');
            X_pos = str2double(PARAM{8});
            Z_pos = str2double(PARAM{10});
            X_list(i) = X_pos;
            Z_list(i) = Z_pos;
        end
        X_list = unique(X_list);
        Z_list = unique(Z_list);
        for i=1:length(filename)
            PARAM = strsplit(filename(i).name,'-');
            PARAM = strsplit(PARAM{end},'_');
            X_pos = str2double(PARAM{8});
            Z_pos = str2double(PARAM{10});
            X_idx = find(X_list==X_pos);
            Z_idx = find(Z_list==Z_pos);
            imp.s(:,X_idx,Z_idx) = single(readbin(strcat('IR\',filename(i).name),'float'));
        end
        imp.s = reshape(imp.s,imp.L,NO_LSP,NO_MIC,NO_X,NO_Z);
    else
        error('Wrong format!');
    end
end