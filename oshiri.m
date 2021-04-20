function oshiri(varargin)
% OSHIRI:machigaisagashi
% Usage:oshiri([n])
% [Input]
%   n : Switch Game Mode
%       - 1 : Oshiri [Defaults]
%       - 2 : 
if nargin > 1
    error("Invalid Number of Input");
end


commandSize = matlab.desktop.commandwindow.size;
nRow = commandSize(2);
nCol = round(commandSize(1)/7);
ashiri = randi(nRow*nCol);
cnt = 1;
for row = 1:nRow
    for col = 1:nCol
        if cnt == ashiri
            fprintf("あしり ");
        else
            fprintf("おしり ");
        end
        cnt = cnt + 1;
    end
    fprintf("\n");
end
end