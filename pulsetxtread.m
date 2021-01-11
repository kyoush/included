function [Z,xaxis] = pulsetxtread(filepath, stline)
% [Z,freq] = PULSETXTREAD(filepath, stline)
%   filepath : input text file path
%   stline   : absolute or relative path
%   Z        : complex spectrum
%   xaxis    : frequency or time

fid = fopen(filepath);
if fid == -1
    fprintf('Not found file\n')
    return
end

txtline = 0;
while txtline < stline
    txtline = txtline+1;
    readline = fgetl(fid);
    if findstr(readline,'X-Axis size:') > 0
        edline = sscanf(readline(13:end),'%d');
        edline = edline+stline-1;
        break
    end
end

Z = zeros(edline-stline+1,1);
xaxis = Z;
analyzer = -1;
while txtline < edline
    txtline = txtline + 1;
    if (txtline >= 1 && txtline < stline)
        readline = fgetl(fid);
        if findstr(readline,'AnalyzerName:	SSR Analyzer') > 0
            fprintf('SSR Analyzer\n')
            analyzer = 0;
        elseif findstr(readline,'AnalyzerName:	FFT Analyzer') > 0
            fprintf('FFT Analyzer\n')
            analyzer = 1;
        elseif findstr(readline, 'X-Axis unit:	s') > 0
            fprintf('Signal\n')
            analyzer = 2;
        else
            if analyzer == -1
                analyzer = -1;
            end
        end
    else
        if analyzer == -1
            fprintf('Unknown Analyzer\n')
            return
        end
        readline = fgetl(fid);
        s = sscanf(readline,'%d%f%f%f');
        xaxis(s(1),1) = s(2);
        if analyzer == 0
            Z(s(1),1) = s(3) + 1i * s(4);
        elseif analyzer == 1
            Z(s(1),1) = sqrt(s(3));
        else
            Z(s(1),1) = s(3);
        end
    end
end
fclose(fid);
end