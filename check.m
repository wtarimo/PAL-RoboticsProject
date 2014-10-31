function output = check(genes1,genes2,crossover_pt,count)
if (isempty(genes1) || isempty(genes2))
    output=[];
else
    if count < crossover_pt
        output = [genes1(1) check(genes1(2:end),genes2,crossover_pt,count+1)];
    else
        output = genes2(crossover_pt+1:end);
    end
end