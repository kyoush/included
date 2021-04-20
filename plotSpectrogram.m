function varargout = plotSpectrogram(varargin)
% PLOTSPECTROGRAM:plot spectrogram of audio signal
% [spec, time, freq] = PLOTSPECTROGRAM(sig, [Fs, YScale])
%
% [Input] arguments in [] are optional
%   sig   :audio signal
%   Fs    :Sample Rate [Hz] Default:48 kHz
%   YScale:scale of yaxis ['log'[Defalut] or 'linear']
%
% [Output]
%   spec  :spectrogram data
%   time  :time axis
%   freq  :frequency axis
nInMin = 1; nInMax = 3;
if nargin < nInMin || nargin > nInMax
    error("Invalid number of Input");
else
    sig = varargin{1};
    Fs = 48000;
    scale = "log";
    if nargin == 2
        Fs = varargin{2};
    elseif nargin == 3
        tmpStr = varargin{3};
        if tmpStr == "log" || tmpStr == "linear"
            scale = tmpStr;
        end
    end
end
if nargout == 3
    plotFlag = 0;
elseif nargout == 0
    plotFlag = 1;
else
    error("Invalid number of Output");
end

frameLength = 1024;
overlap = 3/4;
frameShift = ceil(overlap * frameLength);
NFFT = 4096;

dBLim = [-60 40];

nChannel = size(sig, 2);
nFrame = ceil((size(sig, 1) - frameShift)/frameLength);
lengthSignal = frameShift + nFrame * frameLength;
sig = [sig;
    zeros(lengthSignal-size(sig, 1), nChannel)];
time = linspace(0, size(sig, 1)/Fs, nFrame);
df = Fs/NFFT; freq = 0:df:Fs-df;

for channel = 1:nChannel
    if plotFlag == 1
        plotSig = sig(:, channel);
        spec = plotSpectrogramFnc;
        figure;
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
        
        % Status
        reverseStr = '';
        sizeCommand = matlab.desktop.commandwindow.size;
        col = sizeCommand(1) - 2;
        msgstr = '%5.1f%%%%';
        c = length(sprintf(msgstr, 100.0));
        for startPoint = 1:frameLength:nFrame*frameLength - frameLength
            tmp = plotSig(startPoint:startPoint+frameLength-1);
            spec(:, cntFrame) = 20*log10(abs(fft(tmp, NFFT)));
            
            % Status
            percentDone = (cntFrame/(nFrame-1));
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