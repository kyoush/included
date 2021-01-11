function [p, n_xaxis] = spec(varargin)
% SPEC: 信号を読み込み振幅スペクトルを出力する
% Usage: [p,xaxis] = SPEC(x, [n])
% [Inputs]
%   - x: FFTをする信号
%   - n: FFTをする点数 [Default:4096]
% [Outputs]
%   - p: xの振幅スペクトル in dB
%   - n_xaxis: 正規化周波数軸
%       Argment in [] are optical
%
%       2020/6/27 by K.K.

%% 入力取得・定数設定
minArg = 1; maxArg = 2;
if nargin < minArg || nargin > maxArg
    error("Invalid number of Arguments");
elseif nargin == 1
    x = varargin{1};
    Frame_length = 4096;
elseif nargin == 2
    x = varargin{1};
    Frame_length = varargin{2};
end
a = size(x);
if a(1) == 1
    x = x';
end

n = length(x);
Frame_shift = 1024;
TotalFrameNum = n - Frame_length;
    
%% 平滑スペクトルの算出
cnt = 0;
SUMSig = 0;
win = hanning(Frame_length);
disp('Start Calc. FFT...')
fprintf('Frame_len = %d\nFrame_shift = %d\n', Frame_length, Frame_shift)
reverseStr = '';
for frame = 1 : Frame_shift : TotalFrameNum
    X = x(frame:frame+Frame_length-1).*win;
    Sig = abs(fft(X));
    SUMSig = SUMSig + Sig;
    cnt = cnt + 1;
    
    %%% -- Status --- %%%
    percentDone = (frame/TotalFrameNum)*100;
    msg = sprintf('%4.1f%%', percentDone);
    fprintf([reverseStr msg '%']);
    reverseStr = repmat(sprintf('\b'), 1, length(msg));
end
fprintf('\n')

p = 10*log10(((SUMSig/cnt).^2)./Frame_length);
n_xaxis = linspace(0, 1, length(p));
end