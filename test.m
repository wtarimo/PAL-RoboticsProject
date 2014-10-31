function eqle = test(x,lst)
list = cell(1,length(lst));
for i=1:length(lst)
    if (x==lst{i}(2) && mod(lst{i}(1),2)==0)
        list(i) = lst(i);
    end
end
list(cellfun(@(list) isempty(list),list)) = [];
eqle = list;