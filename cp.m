function cp
% CP : copy figure as EMF
%
% 2020/10/02 by K.Kamura
% --- RELEASE NOTE ---
% 2020/12/24 subplotに対応

%% Figureオブジェクトの存在有無を確認
h = findobj;
root = h(1);
child = root.Children;
figNum = size(child);
figNumArrOld = zeros(1, figNum(1));

for i = 1:figNum(1)
    figNumArrOld(i) = child(i).Number;
end
[figNumArr, I] = sort(figNumArrOld);

if figNum == 0
    error('No Figure to copy')
elseif figNum == 1
    answer = 1;
else
    for i = 1:figNum(1)
        fprintf('fig(%d)\n', figNumArr(i));
    end
    answer = input('Choose Figure[Default (1)]>> ');
    if isempty(answer)
        answer = 1;
    end
end

axesNum = 1;
fig = child(I(answer));
N = numel(fig.Children);
if N  == 0
    error('No Axes in Figure to copy');
elseif N > 1
    axesNum = input('Choose Axes[Default 1]>> ');
    if isempty(axesNum)
        axesNum = 1;
    end
    tmpNum = axesNum;
    axesNum = N - axesNum + 1;
end
copyObj = fig.Children(axesNum);

copygraphics(copyObj, 'ContentType', 'vector', 'BackgroundColor', 'none');
if N > 1
    fprintf('Copied "Axes %d of Figure %d"!!\n', tmpNum, answer);
else
    fprintf('Copied "Figure %d"!!\n', answer);
end