function xlabel_freq(varargin)
% XLABEL_FREQ : X軸が周波数軸のときいい感じにラベルつける

xl = [20 20000];
if length(varargin) == 1
    xl = cell2mat(varargin(1));
end
xlim(xl)
xticks([20 50 100 200 500 1000 2000 5000 10000 20000])
xticklabels({'20', '50', '100', '200', '500', '1k', '2k', '5k', '10k', '20k'})
grid on
xlabel('Frequency [Hz]')
end