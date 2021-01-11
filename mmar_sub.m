function mmar_sub(varargin)
%   MMAR: 図の余白の最小化及びフォントサイズを設定[subplot用]
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

ax = gca;
set(ax, 'FontSize', fontsize)
set(ax, 'FontName', fontname)
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1) + 0.01;
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3) - 0.03;
ax_height = outerpos(4) - ti(2) - ti(4) - 0.02;
ax.Position = [left bottom ax_width ax_height];
end