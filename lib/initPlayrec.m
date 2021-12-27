function y = initPlayrec(varargin)
% Inputs: Sampling Frequency, Device ID, No. of Output channel, No. of Input channel. 
if playrec('isInitialised')  
    playrec('reset');
end

if nargin == 3
playrec('init',varargin{1},varargin{2},varargin{2},varargin{3});
elseif nargin == 4
playrec('init',varargin{1},varargin{2},varargin{2},varargin{3},varargin{4});
end
end