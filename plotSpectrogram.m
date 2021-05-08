function varargout = plotSpectrogram(sig, Fs, scale, frameLength, overlap, NFFT, dBLim)
% PLOTSPECTROGRAM:plot spectrogram of audio signal
% Usage; [spec, time, freq] = PLOTSPECTROGRAM(sig, [Fs, YScale, frameLength, overlap, NFFT, dBLim])
%
% [Input] arguments in [] are optional
%   sig         :audio signal
%   Fs          :Sample Rate [Hz]                   Default:48 kHz
%   YScale      :scale of yaxis ['log' or 'linear'] Default:'linear'
%   frameLength :frame length [points]              Default:1024
%   overlap     :overlap of frame (ex. 1/2, 3/4, 1) Default:1/2
%   NFFT        :length of FFT                      Default:4096
%   dBLim       :limits of colormap [dB]            Default:[-60 40]
%
% [Output]
%   spec  :spectrogram data
%   time  :time axis
%   freq  :frequency axis

% - Release Notes -
% #[1.0] -2021/4/20 by K.Kamura

arguments
    sig double
    Fs (1, 1) double = 48000
    scale string = 'linear'
    frameLength (1, 1) double = 1024
    overlap (1, 1) double = 1/2;
    NFFT (1, 1) = 4096;
    dBLim (1, 2) double = [-60 40];
end

if nargout == 3
    plotFlag = 0;
elseif nargout == 0
    plotFlag = 1;
else
    error("Invalid number of Output");
end

frameShift = ceil(overlap * frameLength);
nChannel = size(sig, 2);
nFrame = ceil((size(sig, 1) - frameLength)/frameShift);
lengthSignal = frameLength + frameShift * nFrame;
sig = [sig;
    zeros(lengthSignal-size(sig, 1), nChannel)];
time = linspace(0, size(sig, 1)/Fs, nFrame);
df = Fs/NFFT; freq = 0:df:Fs-df;

for channel = 1:nChannel
    if plotFlag == 1
        plotSig = sig(:, channel);
        spec = plotSpectrogramFnc;
        figname = strcat("Channel ", num2str(channel));
        f = figure('Name', figname,...
            'Toolbar', 'none');
        fp = f.Position;
        xm = 70; ym = fp(4)-25; w = fp(3)*0.1; h = fp(4)*0.05;
        bt = uicontrol(f,...
            'Position', [xm ym w h],...
            'String', 'Play',...
            'Callback', 'sound(sig, Fs)');
        ax = axes;
        surf(ax, time, freq, spec,...
            'LineStyle', 'none'); view(0, 90);
        T = length(plotSig)/Fs; xlim([0 T])
        xlabel('Time [s]')
        if scale == "log"
            ylim([0 Fs/2])
            yticks([20 100 200 500 1000 2000 5000 10000 20000]);
            yticklabels({'20', '100', '200', '500', '1k', '2k', '5k', '10k', '20k'})
        else
            ylim([0 10000])
            yticks(0:1000:10000)
            yticklabels([{'0'} cellstr(strcat(string((1000:1000:10000)./1000), 'k'))])
        end
        ylabel('Frequency [Hz]')
        caxis(dBLim)
        ax.YScale = scale;
        colormap jet
        colorbar
    else
        spec(:, :, :, channel) = plotSpectrogram;
    end
    msgStr = strcat("Channel ",  num2str(channel), " done.");
    disp(msgStr)
end
varargout = {};
if plotFlag == 0
    varargout = {time, freq, spec};
end

    function spec = plotSpectrogramFnc
        spec = zeros(NFFT, nFrame);
        cntFrame = 1;
        win = hann(frameLength);
        
        % Status
        reverseStr = '';
        sizeCommand = matlab.desktop.commandwindow.size;
        col = sizeCommand(1) - 2;
        msgstr = '%5.1f%%%%';
        c = length(sprintf(msgstr, 100.0));
        for startPoint = 1:frameShift:nFrame*frameShift
            tmp = plotSig(startPoint:startPoint+frameLength-1);
            spec(:, cntFrame) = 20*log10(abs(fft(win.*tmp, NFFT)));
            
            % Status
            percentDone = cntFrame/nFrame;
            cntFrame = cntFrame + 1;
            msg0 = sprintf(msgstr, percentDone*100);
            msg1 = repmat('#', 1, round((col-c)*percentDone));
            msg2 = repmat('.', 1, round((col-c)*(1-percentDone)));
            msg = [msg0 '[' msg1 msg2 ']'];
            fprintf([reverseStr msg]);
            reverseStr = repmat(sprintf('\b'), 1, length(msg)-1);
        end
    end
end