function eqedit
fontsize = 26;

v = get(0, 'MonitorPosition');
X_MIN = v(1, 3)*0.2;
Y_MIN = v(1, 4)*0.2;
WIDTH = v(1, 3)*0.4;
HEIGHT = v(1, 3)*0.2;
H = GUIobject;
H.Params = '$$$$';

H.Mainfig = figure(...
    'Position', [X_MIN Y_MIN WIDTH HEIGHT],...
    'NumberTitle', 'off',...
    'Name', 'Equation Editor',...
    'Units', 'pixels',...
    'MenuBar', 'none');

xm = 0.05; ym = 0.05;
w = 0.8; h = 0.7;
H.Axes = axes(H.Mainfig,...
    'Position', [xm ym w h]);
H.Text = text(0, 0.5, '',...
    'Interpreter', 'latex',...
    'FontSize', 40);
axis off

xm = WIDTH*0.08; ym = HEIGHT*0.85;
w = 440; h = 40;
hint = 'LaTeXマークアップを記述します';
H.EditBox = uicontrol(H.Mainfig,...
    'Style', 'edit',...
    'String', '',...
    'Position', [xm ym w h],...
    'FontSize', fontsize,...
    'FontName', 'Ricty Diminished',...
    'Tooltip', hint,...
    'KeyPressFcn', @(obj,eve)keypress);
xm = WIDTH*0.085 + w; w = 50;
uicontrol(H.Mainfig,...
    'Style', 'text',...
    'String', '$$$$',...
    'Position', [xm ym w h],...
    'FontSize', fontsize,...
    'FontName', 'Ricty Diminished');
xm = WIDTH*0.01;
uicontrol(H.Mainfig,...
    'Style', 'text',...vz
    'String', '$$',...
    'Position', [xm ym w h],...
    'FontSize', fontsize,...
    'FontName', 'Ricty Diminished');

xm = xm + 550; w = 120;
uicontrol(H.Mainfig,...
    'Position', [xm ym w h],...
    'String', 'Copy',...
    'FontSize', fontsize,...
    'FontName', 'Ricty Diminished',...
    'Callback', @(obj, eve)copy_callback(H));
uicontrol(H.EditBox)

    function keypress
        H.EditBox
        str = ['$$' H.EditBox.String '$$'];
        H.Text.String
        set(H.Text, 'String', str);
    end

    function copy_callback(H)
        copygraphics(H.Axes, 'ContentType', 'vector', 'BackgroundColor', 'none')
    end
end