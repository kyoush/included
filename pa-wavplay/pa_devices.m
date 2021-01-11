function id = pa_devices(varargin)
%   pa_devices: pa_wavで用いるDeviceIDを決定する関数
%
%   Usage: pa_devices([devicetype])
%
%   - devicetype   determines which sound driver to use
%   Arguments in [] are optional
%
%   2020/6/24 by K.K.


if isempty(varargin) == 0
    type = char(varargin);
else
    disp('[Device Type]')
    disp('''win''   :Windows Multimedia Device')
    disp('''dx''    :DirectX DirectSound driver')
    disp('''wasapi'':Windows WASAPI Device')
    disp('''asio''  : ASIO Driver (default)');
    type = input('Type>> ', 's');
end

pa_wavplay(type)
id = input('ID>> ');
end