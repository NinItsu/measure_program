function count = writebin(data, filename, precision);
% "Binary data download" by S.S.
%  count = writebin(data, filename, precision);
%
%  input 'filename' : apostrophe (') is needed. 
%  precision = { short(default), float, double }
if( nargin < 3 )
        precision = 'short';
end

fid = fopen(filename,'w');
count = fwrite(fid, data, precision);
status = fclose(fid);


