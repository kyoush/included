function plotfft(varargin)
% PLOTFFT: オーディオファイルを読み込みパワースペクトルを表示する
% 
% Usage: PLOTFFT(filename, [yl])
%   - filename: スペクトルを表示したいオーディオファイル名
%   - yl:   Y軸の表示範囲
%   Arguments in [] are optional
%
% 2020/6/27 by K.K.

%% データ読み込み
filename = char(varargin(1));
[x, Fs] = audioread(filename);
n = length(x);
x = x(:, 1);

%% 平滑化
cnt = 0;
SUMSig = 0;
Frame_shift = 1024;
Frame_length = 8192;
TotalFrameNum = n - Frame_length;
disp('Start Calc. FFT...')
fprintf('Frame_len = %d\nFrame_shift = %d\n', Frame_length, Frame_shift)
reverseStr = '';
for frame = 1 : Frame_shift : TotalFrameNum
    X = x(frame:frame+Frame_length-1).*hanning(Frame_length);
%     p = p0(frame:frame+Frame_length-1) .*hanning(Frame_length);
    Sig = abs(fft(X,Frame_length*2));
    SUMSig = SUMSig + Sig;
%     sig2 = abs(fft(p, Frame_length*2));
%     sump = sump + sig2;
    cnt = cnt + 1;
    percentDone = (frame/TotalFrameNum)*100;
    msg = sprintf('%4.1f%%', percentDone);
    fprintf([reverseStr msg '%']);
    reverseStr = repmat(sprintf('\b'), 1, length(msg));
end
fprintf('\n')

p = SUMSig/cnt;

%% パワースペクトルの表示
N = length(p);   % 信号 sig の要素数 N
K = 0:N-1;
freq = K*Fs/N;   % 周波数軸ベクトルを設定
db = 20*log10(p);

figure(1)
semilogx(freq,db);   % x軸を10を底とする対数スケールでプロット
grid on
xlabel('Frequency [Hz]'); ylabel('Power [dB]');
xlim([20 22000]); ylim([-100 60]);   % 表示する周波数範囲とパワー範囲を設定
set(gca, 'FontSize', 10);
ax = gca;
ax.XTick = [20 50 100 200 500 1000 5000 10000 20000];
ax.XTickLabels = ({'20', '50', '100', '200', '500', '1k', '5k', '10k', '20k'});
if length(varargin) > 1
    ylim(cell2mat(varargin(2)))
end
mmar(12)
end