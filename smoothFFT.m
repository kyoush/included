function varargout = smoothFFT(sig, Fs, frameLength, overlap, NFFT)
% SMOOTHFFT:フレームシフト平滑化スペクトル
% Usage; [p, f] = smoothFFT(sig, [Fs, frameLength, overlap, NFFt])
%   [Inputs]
%   sig         :input audio signal
%   Fs          :sample rate [Hz]                   Default:48kHz
%   frameLength :frame length [points]              Default:2048
%   overlap     :overlap of frame (ex. 1/2, 3/4, 1) Default:1/2
%   NFFT        :length of FFT                      Default:4096
%
%   [Outputs]
%   p  ;Power in dB
%   f  ;Frequency in Hertz

% - Release Notes -
% #[1.0] -2021/1/19-  by K.Kamura
% #[1.1] -2021/4/20-  by K.Kamura
%   - Support for multi-channel signal input

% - Known Bugs & Issues -
%   - Support for arbitrary sample rate

arguments
    sig double
    Fs (1, 1) double = 48000
    frameLength (1, 1) double = 2048
    overlap (1, 1) double = 1/2
    NFFT (1, 1) double = 4096
end

if nargout == 2
    plotFlag = 0; % plot off
elseif nargout == 0
    plotFlag = 1; % plot on
else
    error("Invalid number of output")
end    

nChannel = size(sig, 2);
frameShift = frameLength*overlap;
nFrame = ceil((size(sig, 1) - frameLength)/frameShift);
lengthSignal = frameLength + frameShift * nFrame;
sig = [sig; zeros(lengthSignal - size(sig, 1), nChannel)];

df = Fs/NFFT; freq = 0:df:Fs-df;
specOut = zeros(NFFT, nChannel);
for channel = 1:nChannel
    fftSig = sig(:, channel);
    spec = smoothFFTCaluculation(fftSig);
    if plotFlag == 1
        figname = strcat("Channel ", num2str(channel)); figure('Name', figname);
        semilogx(freq, spec)
        xlabel_freq
        ylabel('Power [dB]')
        grid on
    else
        specOut(:, channel) = spec;
    end
    msgTxt = strcat("Channel ", num2str(channel), " done"); disp(msgTxt);
end
varargout = {};
if plotFlag == 0
    varargout = {specOut, freq};
end

    function spec = smoothFFTCaluculation(fftSig)
        spec = zeros(NFFT, 1);
        win = hann(frameLength);

        %%% --- Status --- %%%
        reverseStr = '';
        sizeCommand = matlab.desktop.commandwindow.size;
        col = sizeCommand(1) - 2;
        msgstr = '%5.1f%%%%';
        c = length(sprintf(msgstr, 100.0));
        cnt = 0;
        %%% -------------- %%%
        for startP = 1:frameShift:nFrame*frameShift
            tmp = fftSig(startP:startP+frameLength-1);
            spec = spec + 20*log10(abs(fft(win.*tmp, NFFT)));
            
            % --- Status --- %%%
            percentDone = cnt/nFrame;
            cnt = cnt + 1;
            msg0 = sprintf(msgstr, percentDone*100);
            msg1 = repmat('#', 1, round((col-c)*percentDone));
            msg2 = repmat('.', 1, round((col-c)*(1-percentDone)));
            msg = [msg0 '[' msg1 msg2 ']'];
            fprintf([reverseStr msg]);
            reverseStr = repmat(sprintf('\b'), 1, length(msg)-1);
        end
        fprintf("\n")
        spec = spec ./ cnt;
    end
end