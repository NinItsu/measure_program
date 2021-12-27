function y = doPlayrec(varargin)
% MODE(playrec/rec/play)
% Inputs for playrec: 'playrec', output signal (N*L), output channel (1*L), input channel (1*M);
% Output for rec: input data (L*M);
% Inputs for rec: 'rec', input length (L), input channel (1*M);
% Output for rec: input data (L*M);
% Inputs for play: 'play', output signal (N*L), output channel (1*L).
pageList=playrec('getPageList');
if strcmp(varargin{1},'playrec')
pageList=[pageList playrec('playrec',varargin{2},varargin{3},-1,varargin{4})];
 while(playrec('isFinished', pageList(1)) == 0)
 end
 % playrec('block',pageNumber)と同じだが、レスポンスの速さが違う
 %
y=playrec('getRec',pageList(1));
playrec('delPage',pageList(1));
pageList=pageList(2:end);

elseif strcmp(varargin{1},'rec')
pageList=[pageList playrec('rec',varargin{2},varargin{3})];
 while(playrec('isFinished', pageList(1)) == 0)
 end
 % playrec('block',pageNumber)と同じだが、レスポンスの速さが違う
 %
y=playrec('getRec',pageList(1));
playrec('delPage',pageList(1));
pageList=pageList(2:end);

elseif strcmp(varargin{1},'play')
pageList=[pageList playrec('play',varargin{2},varargin{3})];
 while(playrec('isFinished', pageList(1)) == 0)
 end
 % playrec('block',pageNumber)と同じだが、レスポンスの速さが違う
 %
playrec('delPage',pageList(1));
pageList=pageList(2:end);
end