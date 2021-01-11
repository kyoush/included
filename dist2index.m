function i = dist2index(dist)
if dist == 1.5
    i = 1;
else
    i = 6.75 - 5 * dist + 1;
end
end