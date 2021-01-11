function out = taper(varargin)
% TAPER:信号の前後にn点の直線テーパをかける
% 複数チャンネルに対応し、全てのチャンネルに同じテーパをかける
% Usage: out = TAPER(x, [n])
%   [Inputs]
%       x:入力信号
%       n:直線テーパを前後にかける点数 [Default:2048];
%   Arguments in [] is optimal;

maxArg = 2; minArg = 1;
if nargin > maxArg || nargin < minArg
    error('Invalid number of Arguments');
elseif nargin == 1
    x = varargin{1};
    n = 2048;
elseif nargin == 2
    x = varargin{1};
    n = varargin{2};
else
    error('Internal Error 1');
end

xSiz = size(x);
if xSiz(1) < xSiz(2)
    error('Invalid size of "x"');
end

c = repmat(linspace(0, 1, n)', 1, xSiz(2));
x(1:n, :) = x(1:n, :) .* c;
c = flipud(c);
x(end-n+1:end, :) = x(end-n+1:end, :) .* c;
out = x;
end