function tweet(str)
%   TWEET : 自分のアカウントから文字列をツイートする
%   Usage: TWEET(str)
%       - str : ツイートしたい文字列
%   2020/7/30 by K.K.

url = 'https://api.thingspeak.com/apps/thingtweet/1/statuses/update';
api_key = '6SR806AS5W08YY7E';
s = num2str(randi([0, 9]));
data = unicode2native(['@25Op ' str s]);
data = ['api_key=',api_key,'&status=',data];
webwrite(url,data);
end