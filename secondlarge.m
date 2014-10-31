function output = secondlarge(lst)
l=lst(1);
x=lst(1);
for i=2:length(lst)
    if lst(i) > l
        x = l;
        l = lst(i);
    end
end
l
output = x;

