function shutdown(varargin)
% SHUTDOWN : shutdown windows
% Usage:SHUTDOWN([s])
%   - s:シャットダウンするまでの時間[秒](default:1s)

tweet('shutdown breen')
if length(varargin) == 1
    time = char(string(varargin(1)));
else
    time = '1';
end

command = ['shutdown /s /t ' num2str(time)];

system(command)

time = str2double(time);
reverseStr = '';
tic
while toc < (time - 1)
    t = toc;
    Done = t;
    msg = sprintf('In : %d [s]', round(time - Done));
    fprintf([reverseStr msg '%']);
    reverseStr = repmat(sprintf('\b'), 1, length(msg));
end
fprintf([reverseStr '\n----- Good Bye ------\n'])
end