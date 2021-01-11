function mmar(varargin)
%   MMAR: 図の余白の最小化及びフォントサイズを設定
%       - Minimize Margin -
%   gca, gcfがある状態で呼び出す
%   Usage: MMAR([fontsize], [fontname])
%       - fontsize: フォントサイズ Default = 14pt
%       - fontname: フォント名     Default = 'Arial'
%   Arguments in [] are optional

if length(varargin) == 1
    fontsize = str2double(string(varargin(1)));
    fontname = 'Arial';
elseif length(varargin) == 2
    fontsize = str2double(string(varargin(1)));
    fontname = string(varargin(2));
else
    fontsize = 14;
    fontname = 'Arial';
end

f = gcf;
child = f.Children;
tmp = size(child); axesNum = tmp(1);

if axesNum == 0
    countinue;
elseif axesNum >= 1
    ax = gca;
    xTicks = ax.XTick;
    yTicks = ax.YTick;
    set(ax, 'FontSize', fontsize)
    set(ax, 'FontName', fontname)
    set(ax, 'XTick', xTicks)
    set(ax, 'YTick', yTicks)
    
    pos = ax.Position;
    tightInset = ax.TightInset;
    enhPos = tightInset(1:2) - pos(1:2);
    ax.OuterPosition(1:2) = enhPos + 0.04;
    margin = 0.05; % [%]
    ax.Position(3) = 1 - ax.Position(1) - margin;
    ax.Position(4) = 1 - ax.Position(2) - margin;
% else % === subplotに対応 ===
%     for i = 1:axesNum
%         ax = child(i);
%         xTicks = ax.XTick;
%         yTicks = ax.YTick;
%         set(ax, 'FontSize', fontsize)
%         set(ax, 'FontName', fontname)
%         outerPos = fix(ax.OuterPosition .* 10)/10;
%         pos = ax.Position;
%         tightInset = ax.TightInset;
%         
%         ax.Position(2) = outerPos(2) + tightInset(2);
%         w_margin = 0.88;
%         ax.Position(3) = outerPos(3) * w_margin;
%         h_margin = 0.95;
%         ax.Position(4) = outerPos(4) * h_margin;
%     end
    
end
end