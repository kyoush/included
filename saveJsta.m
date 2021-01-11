function saveJsta(varargin)
% SAVEONKYO : 雑誌をjstageからダウンロードする
% Usage SAVEONKYO(kan, gou, [zasshi])
%    - kan   :保存したい巻
%    - gou   :保存したい号
%    - zasshi:保存したい雑誌
%       * jasj      : 日本音響学会 [Default]
%       * audiology : 聴覚医学
%       * tvrsj     : VR学会

if nargin < 2
    error('invaild number of arguments');
elseif nargin < 3
    kan = double(string(varargin(1)));
    gou = double(string(varargin(2)));
    zasshi = 'jasj';
else
    kan = double(string(varargin(1)));
    gou = double(string(varargin(2)));
    zasshi = char(string(varargin(3)));
end

siteUrl = ['https://www.jstage.jst.go.jp/browse/', zasshi,'/', num2str(kan), '/', num2str(gou),'/_contents/-char/ja'];
data = webread(siteUrl);

fileTitle = "searchlist-title";
pdf = "PDF形式で";
filenum = 1;
for i = 1:length(data)-15
    if data(i:i+15) == fileTitle
        cnt = 0;
        j = i;
        while cnt < 7
            if data(j) == '"'
                cnt = cnt + 1;
                if cnt == 6
                    posFirst = j;
                elseif cnt == 7
                    filename = sprintf("%02d%s.pdf", filenum, data(posFirst+1:j-1));
                    if contains(filename, '&lt;')
                        pos = strfind(filename, '&lt;');
                        filename = char(filename);
                        filename = string([filename(1:pos-1) '＜' filename(pos+4:end)]);
                    end
                    if contains(filename, '&gt;')
                        pos = strfind(filename, '&gt;');
                        filename = char(filename);
                        filename = string([filename(1:pos-1) '＞' filename(pos+4:end)]);
                    end
                    if contains(filename, ':')
                        pos = strfind(filename, ':');
                        filename = char(filename);
                        filename(pos) = '_';
                    end
                    if contains(filename, '&amp;')
                        pos = strfind(filename, '&amp;');
                        filename = char(filename);
                        filename = [filename(1:pos-1) '&' filename(pos+5:end)];
                    end
                    if contains(filename, '&quot;')
                        pos = strfind(filename, '&quot;');
                        filename = char(filename);
                        filename = [filename(1:pos-1) '[' filename(pos+6:end)];
                    end
                    if contains(filename, '&quot;')
                        pos = strfind(filename, '&quot;');
                        filename = char(filename);
                        filename = [filename(1:pos-1) ']' filename(pos+6:end)];
                    end
                    if contains(filename, '/')
                        pos = strfind(filename, '/');
                        filename = char(filename);
                        filename(pos) = '_';
                    end
                    if contains(filename, '?')
                        pos = strfind(filename, '?');
                        filename = char(filename);
                        filename(pos) = '？';
                    end
                      
%                     if contains(filename, '&')
%                         pos = strfind(filename, '&');
%                         disp('& FIND!!!')
%                     end
                    filenum = filenum + 1;
                end
            end
            j = j + 1;
        end
    elseif data(i:i+5) == pdf
        flag = 1;
        j = i-1;
        cnt = 0;
        while(flag)
            if data(j) == '"'
                cnt = cnt + 1;
                if cnt == 3
                    posLast = j;
                elseif cnt == 4
                    url = data(j+1:posLast-1);
                    websave(filename, url);
                    fprintf("Saved : %s\n", filename);
                    flag = 0;
                end
            end
            j = j - 1;
        end
    end
end
end