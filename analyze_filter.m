function spec = analyze_filter(varargin)
%   ANALYZE_FILTER : フィルタのカットオフ周波数、通過帯域周波数、遮断帯域周波数を出力
%   Usage : spec = ANALYZE_FILTER(b, a);
%    - spec : 求めたフィルタの特性を格納した構造体
%    - b : デジタルフィルタの係数の分子
%    - a : デジタルフィルタの係数の分母
%
%   現状:バンドパスフィルタにしか対応していない
%   2020/8/1 by K.K.

%% 値の設定
Fs = 48000;                     % サンプリング周波数
n = 4096;                       % インパルス信号の長さ
imp_pos = 128;                  % インパルス信号におけるインパルスの位置 [point]

if length(varargin) == 2
    b = cell2mat(varargin(1));
    a = cell2mat(varargin(2));
    npeak = 2;
end

%% Gen Impulse & Filtering Impulse
imp = zeros(n, 1);
imp(imp_pos) = 1;                   % インパルス信号の生成

imp_resp = filter(b, a, imp);       % インパルス応答の取得

freq = linspace(0, Fs, n);        % 周波数軸
p = 20*log10(abs(fft(imp_resp)));   % フィルタの周波数応答の計算

%% Calc CutoffFrequency
tmp = -abs(6 + p(1:n/2));
[~, locs] = findpeaks(tmp, freq(1:n/2), 'NPeaks', npeak, 'SortStr', 'descend');
spec.CutoffFrequency1 = min(locs);
spec.CutoffFrequency2 = max(locs);

%% Calc PassbandFrequency

%% Calc StopbandFrequency



end