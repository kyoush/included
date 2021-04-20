 function hrir = loadhrir(varargin)
% LOADHRIR: 任意のelev, azimが与えられたとき、左右のhrirを返す関数
% Usage: hrir = LOADHRIR(elev, azim, [d, name])
% [Inputs]
%   elev : hrirの仰角
%   azim : hrirの方位角
%   d    : hrirの距離   :Default: 1.5m
%   name : 誰のhrirを読み込むか？[string OR char]
%       - 'kamura' (RIEC&TPU) [Default]
%       - 'sakai'  (RIEC)
%       - 'hirota' (TPU)  
% Arguments in [] are optional
%
% 2020/6/30   by K.K.
% 2020/11/30  ファイルが存在しない場合、1点目が1、それ以外が0の512点のただのインパルスを返す

if nargin < 2 || nargin > 4
    error('Invalid number of arguments')
else
    elev = string(varargin(1));
    azim = string(varargin(2));
    if nargin == 2
        name = 'kamura';
        d = 1.5;
    elseif nargin == 3
        name = 'kamura';
        d = varargin{3};
    elseif nargin == 4
        name = varargin{4};
        d = varargin{3};
    end
end

if name ~= "kamura" % kamura以外の相反法測定システムは距離が0.02m近くなった。(TPU)
    d = d - 0.02;
end

if d > 1.15
    azim = string(-str2double(azim) + 5);
    
    dir = strcat('D:/kamura/HRTF/RIEC/hrir/New_HRIR/', name, '/elev', elev, '/');
    
    fileL = sprintf('L%de%03da_new.dat', str2double(elev), str2double(azim));
    fileR = sprintf('R%de%03da_new.dat', str2double(elev), str2double(azim));
    
    fid = fopen(strcat(dir, fileL), 'r', 'b');
    if fid == -1
        impulse = zeros(512, 1); impulse(1) = 1;
        hrir.hrirL = impulse;
        hrir.hrirR = impulse;
    else
        hrir.hrirL = fread(fid, 'float');
        fid = fopen(strcat(dir, fileR), 'r', 'b');
        hrir.hrirR = fread(fid, 'float');
    end
    fclose('all');
else
    filename = strcat('D:/kamura/HRTF/TPU/', name,'/hrir/hrir_', num2str(d), '_l.mat');
    if exist(filename, 'file') == 0
%         warning('File does not exist');
        impulse = zeros(512, 1); impulse(1) = 1; impulse = circshift(impulse, 256);
        hrir.hrirL = impulse;
        hrir.hrirR = impulse;
    else
        load(filename, 'hrir')
        hrirL = circshift(hrir, 256, 1);
        load(strcat('D:/kamura/HRTF/TPU/', name, '/hrir/hrir_', num2str(d), '_r.mat'), 'hrir');
        hrirR = circshift(hrir, 256, 1);
        clear hrir
        index = circshift((-165:15:180)./15+12, 12);
        hrir.hrirL = hrirL(:, index(str2double(azim)/15+12));
        hrir.hrirR = hrirR(:, index(str2double(azim)/15+12));
    end
end
end
