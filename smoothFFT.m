function [p, f] = smoothFFT(sig, Fs)
% SMOOTHFFT:フレームシフト平滑化スペクトル
% Usage; [p, f] = smoothFFT(sig, [Fs]) *Fsの入力を任意にする改良をする
%   [Inputs]
%       sig;入力信号(1chのみ対応)
%       Fs ;入力信号のサンプリング周波数
%   [Outputs]
%       p  ;Power in dB
%       f  ;Frequency in Hertz
%       2021/1/19  by K.Kamura

ratio = 3/4;    % 前のフレームと何%重ねるか
frameLength = 4096;

frameShift = frameLength*(1-ratio);
frameNum = fix((length(sig)-frameLength+frameShift)/frameShift) + 1;
sig = [sig; zeros((frameLength - frameShift + frameShift*frameNum) - length(sig), 1)];
win = hann(frameLength);
p = zeros(frameLength, 1);

%%% --- Status --- %%%
reverseStr = '';
sizeCommand = matlab.desktop.commandwindow.size;
col = sizeCommand(1) - 2;
msgstr = '%5.1f%%%%';     % ←ここに任意の文字を追加可
c = length(sprintf(msgstr, 100.0));
cnt = 0;
%%% -------------- %%%
for startP = 1:frameShift:(length(sig)-frameLength)
    p = p + 20*log10(abs(fft(win.*sig(startP:startP+frameLength-1))));
    cnt = cnt + 1;
    
    % --- Status --- %%%
    percentDone = (cnt/frameNum);
    msg0 = sprintf(msgstr, percentDone*100);
    msg1 = repmat('#', 1, round((col-c)*percentDone));
    msg2 = repmat('.', 1, round((col-c)*(1-percentDone)));
    msg = [msg0 '[' msg1 msg2 ']'];
    fprintf([reverseStr msg]);
    reverseStr = repmat(sprintf('\b'), 1, length(msg)-1);
end
fprintf("\n")
p = p ./ cnt;
df = Fs./frameLength;
f = linspace(0, Fs-df, frameLength);
end