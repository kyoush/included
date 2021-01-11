function filt = invfilt(varargin)
% INVFILT:使うヘッドホンを選択したときに、その逆フィルタのFIRフィルタオブジェクトを返す
% Usage:filt = INVFILT(headphone, [Fs, N, Freq1st, Freq2nd, Ch])
% [Inputs]
%   headphone:ヘッドホンの型番[char OR string]
%      - 'hda200'         :HDA200#3               [Sennheiser]     [Default]
%      - 'hda200_blocked' :HDA200#3@Ent. of Canal [Sennheiser]
%      - 'ad500'          :ATH-AD500X             [audio-technica]
%      - 'ad1000'         :ATH-AD1000X            [audio-technica]
%      - 'earpods'        :EarPods                [Apple]
%      - 'a3000'          :A3000                  [Final]
%      - 'e3000'          :E3000                  [Final]
%   Fs       :FIRフィルタのサンプリング周波数      default:48 kHz
%   N        :逆フィルタのデータ点数               default:2048 points
%   Freq1st  :設計する周波数範囲の最小値 in Hertz  default:100 Hz
%   Freq2nd  :設計する周波数範囲の最大値 in Hertz  default:20000 Hz
%   Ch       :設計するフィルタのチャンネル数
%       - 1 :左右のドライバのカプラレスポンスを平均して1chのフィルタを作成
%       - 2 :左右のドライバそれぞれの2chのフィルタを作成 [Default]
% [Output]
%   filt     :FIRフィルタオブジェクトを格納した構造体

%% 入力引数の処理・定数設定
% Default value
headphone = 'hda200';
Fs = 48000;
N = 2048;
range = [100 20000];
ch = 2;
% Input value
maxArgs = 6;
if nargin > maxArgs
    error('invalid number of arguments');
elseif nargin == 0
    fprintf("Headphone is HDA200 #3\n");
elseif nargin == 1
    headphone = varargin{1};
    if headphone == "hda200_blocked"
        load('resp.mat', 'freq_blocked', 'hda200_blocked_Lch', 'hda200_blocked_Rch');
        range = [100 17000];
        filt.L = inverseFilterDesign(hda200_blocked_Lch, range, freq_blocked, N, Fs);       % Lチャンネルの逆フィルタ設計
        filt.R = inverseFilterDesign(hda200_blocked_Rch, range, freq_blocked, N, Fs);       % Rチャンネルの逆フィルタ設計
        return
    end
elseif nargin == 2
    headphone = varargin{1};
    Fs = varargin{2};
elseif nargin == 3
    headphone = varargin{1};
    Fs = varargin{2};
    N = varargin{3};
elseif nargin == 4
    headphone = varargin{1};
    Fs = varargin{2};
    N = varargin{3};
    range = [varargin{4} 20000];
elseif nargin == 5
    headphone = varargin{1};
    Fs = varargin{2};
    N = varargin{3};
    range = [varargin{4} varargin{5}];
elseif nargin == 6
    headphone = varargin{1};
    Fs = varargin{2};
    N = varargin{3};
    range = [varargin{4} varargin{5}];
    tmpCh = varargin{6};
    if tmpCh ~= 1 && tmpCh ~= 2
        error('Invalid Argument Value of "Ch"')
    else
        ch = tmpCh;
    end
else
    error('Internal error : error code [1]');
end

%% データ読み込み
if headphone == "hda200"
    headphone = 'hda200no3';
end
l = strcat(headphone, '_l');
r = strcat(headphone, '_r');
tmp = load('resp.mat', l, r, 'xaxis');
[resp_l, resp_r] = myEval(tmp, l, r);
xaxis = tmp.xaxis;

%% 周波数軸等設定
if ch == 1
    resp = (resp_l + resp_r)./2;                                     % 左右のドライバのレスポンスの平均化
    filt = inverseFilterDesign(resp, range, xaxis, N, Fs);           % 1chの逆フィルタ設計
elseif ch == 2
    filt.L = inverseFilterDesign(resp_l, range, xaxis, N, Fs);       % Lチャンネルの逆フィルタ設計
    filt.R = inverseFilterDesign(resp_r, range, xaxis, N, Fs);       % Rチャンネルの逆フィルタ設計
else
    error('Internal Error : error code[2]')
end

    %% 逆フィルタ設計関数
    function inverseFilter = inverseFilterDesign(resp, range, xaxis, N, Fs)
        a = (xaxis == 1000);
        [~, p_1khz] = max(a);
        a = (xaxis == range(1));
        [~, p_Freq1st] = max(a);                          % x軸のFreq1st Hzの位置検出
        n_freq = 0:1/(N-1):1;                             % 正規化周波数
        x = xaxis/(Fs/2);
        freq = n_freq*(Fs/2);                             % N点の周波数軸 in Hertz
        [~, pFreq1stINHertz] = min(abs(freq-range(1)));   % range(1)以下の周波数はrange(1)と同じゲインにする
        [~, pFreq2ndINHertz] = min(abs(freq-range(2)));   % range(2)以上の周波数はrange(2)と同じゲインにする
        
        p_db = 20*log10(resp);                                          % 再生系の周波数特性(パワースペクトル)
        np_db = p_db - p_db(p_1khz);                                    % 正規化伝達特性(パワースペクトル)[0dB(@1khz)]
        np = 10.^(np_db/20);                                            % 正規化伝達特性(振幅スペクトル)
        inv_np = np(p_1khz)./np;                                        % 正規化逆伝達特性(振幅スペクトル)[0dB(@1khz)]
        inv_np(1:p_Freq1st-1) = inv_np(p_Freq1st);                      % Freq1st[Hz]以下はFreq1st[Hz]の正規化伝達特性とする
        inv_np_N = interp1(...                                          % 2048点に逆フィルタを線形内挿を用いて補完(振幅スペクトル)
            x, inv_np, n_freq);
        inv_np_N(1:pFreq1stINHertz-1) = inv_np_N(pFreq1stINHertz);      % freq1st[Hz]以下をfreq1st[Hz]の振幅にする
        inv_np_N(pFreq2ndINHertz:end) = inv_np_N(pFreq2ndINHertz-1);    % freq2nd[kHz]以上をfreq2nd[kHz]の振幅にする
        inverseFilter = fir2(N, n_freq, inv_np_N);                      % FIRフィルタ
    end

    %% evalの代替(より良い方法要検討)
    function [l, r] = myEval(strc, nameL, nameR)
        str = strcat('l = strc.', nameL, ';');
        eval(str)
        str = strcat('r = strc.', nameR, ';');
        eval(str)
    end
end