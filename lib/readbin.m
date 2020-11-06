function retvec = readbin(filename, precision);
% "Binary data upload" by S.S.
%  retvec = readbin(filename, precision);
%
%  input 'filename' : apostrophe (') is needed. 
%  precision = { short(default), float, double }
if( nargin < 2 )
        precision = 'short';
end

fid = fopen(filename,'r');
retvec = fread(fid, precision);
status = fclose(fid);


