function hallelujah(varargin)
%   HALLELUJAH : Play hallelujah
%   Usage : HALLELUJAH([time, Amp])
%   [Input]
%       time : sound duration in second [Default:4.3 sec]
%       Amp  : sound Amplitude [Default:0.4]
%   Argument in [] is optional.

maxArg = 2; minArg = 0;
% Initial Value
t = 4.3;
Amp = 0.4;
if maxArg < nargin || minArg > nargin
    error('Invalid number of Arguments');
elseif nargin == 1
    t = varargin{1};
elseif nargin == 2
    t = varargin{1};
    Amp = varargin{2};
end

load('handel.mat', 'y', 'Fs')
out = Amp * y(1:round(Fs*t)) ./ max(abs(y(1:round(Fs*t))));
sound(out, Fs)
end