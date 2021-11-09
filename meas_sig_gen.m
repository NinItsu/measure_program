function [s inv] = meas_sig_gen(sig,FS)
%����p�M�������v���O����
%2020/01/19 written by Nin
%sig { TYPE �M����� A �U�� L ���� } FS �T���v�����O���g��
%s ����p�M�� inv �t�M��

switch sig.TYPE
    case {'TSP','UPTSP'}
        s=up_TSP(sig.L).';
        s=s./max(s).*sig.A;
        inv=down_TSP(sig.L).';
        inv=inv./max(inv).*sig.A;
    case 'DWTSP'
        s=down_TSP(sig.L).';
        s=s./max(s).*sig.A;
        inv=up_TSP(sig.L).';
        inv=inv./max(inv).*sig.A;
    case 'LogSS'
        s=log_SS(sig.L).';
        s=s./max(s).*sig.A;
        inv=ilog_SS(sig.L).';
        inv=inv./max(inv).*sig.A;
    case 'BPLogSS'
        [s,inv]=BP_log_SS(sig.L,sig.fmin,sig.fmax,FS);
        s=s.'./max(s.').*sig.A;
        inv=inv.'./max(inv.').*sig.A;
    otherwise
        warning('Unknown signal type: %s. Default TSP signal is used.\n',sig.TYPE);
        s=up_TSP(sig.L).';
        s=s./max(s).*sig.A;
        inv=down_TSP(sig.L).';
        inv=inv./max(inv).*sig.A;
end 

end