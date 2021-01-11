function gennoise(varargin)
% GENNOISE: 指定した色のノイズをオーディオファイルに書き出す
%
% Usage: GENNOISE([color], [Fs], [minutes], [filename], [maxAmp])
%   - color: ノイズの色           Default: 'white';
%       'pink' | 'white' | 'brown' | 'blue' | 'purple'
%   - Fs:    サンプリング周波数   Default: 48000[Hz] 
%   - minutes:出力信号の長さ[分]  Default: 3[min]
%   - filename:保存するファイル名 Default: color + '.wav'
%   - maxAmp: 振幅の最大値        Default: 0.45
%   Arguments in [] are optional
%
%   2020/6/28   by.K.K.
n = length(varargin);
if n == 0
    color = 'white';
    Fs = 48000;
    min = 3;
    filename = [color '.wav'];
    ma = 0.45;
elseif n == 1
    color = char(varargin(1));
    Fs = 48000;
    min = 3;
    filename = [color '.wav'];
    ma = 0.45;
elseif n == 2
    color = char(varargin(1));
    Fs = str2double(string(varargin(2)));
    min = 3;
    filename = [color '.wav'];
    ma = 0.45;
elseif n == 3
    color = char(varargin(1));
    Fs = str2double(string(varargin(2)));
    min = str2double(string(varargin(3)));
    filename = [color '.wav'];
    ma = 0.45;
elseif n == 4
    color = char(varargin(1));
    Fs = str2double(string(varargin(2)));
    min = str2double(string(varargin(3)));
    filename = char(varargin(4));
    ma = 0.45;
elseif n == 5
    color = char(varargin(1));
    Fs = str2double(string(varargin(2)));
    min = str2double(string(varargin(3)));
    filename = char(varargin(4));
    ma = str2double(string(varargin(5)));
else
    disp('入力引数が正しくありません。デフォルトのパラメータを用います。')
    color = 'white';
    Fs = 48000;
    min = 3;
    filename = [color '.wav'];
    ma = 0.45;
end

points = Fs * min * 60;

seed = randi(10000, 1);
cn = dsp.ColoredNoise(...
    'Color', color,...
    'SamplesPerFrame', points,...
    'RandomStream', 'mt19937ar with seed',...
    'Seed', seed);
x = step(cn);
x = x ./ max(abs(x));
x = x .* ma;
audiowrite(filename, x, Fs);
end