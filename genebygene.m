function gbyg = genebygene()
gbyg.gene_by_gene_pop = @gene_by_gene_pop;
gbyg.gene_by_gene = @gene_by_gene;
gbyg.gene_by_gene_ind = @gene_by_gene_ind;

function output = gene_by_gene_pop(pop)
output = cellfun(@gene_by_gene_p,pop,'UniformOutput',false);

function output = gene_by_gene_p(ind)
r = floor(rand*15);
if r==0
    output =  gene_by_gene(ind);
elseif r==1
    output = condense(ind);
elseif r==2
    output = condense_ci(ind);
elseif r==3
    output = all_down_one(ind);
elseif r==4
    output = all_up_one(ind);
else
    output = ind;
end

function output = gene_by_gene(ind)
new_ind = gene_by_gene_ind(ind);
output = [ind{1} ind{2} new_ind(3) add_random(weed_out(new_ind{4})) ind{5}];

function output = gene_by_gene_ind(ind)
state = robot_state();
state.reset_robot();
output = [ind{1} ind{2} {gene_by_gene_genes(ind{1},ind{2},ind{3})} {gene_by_gene_genes(ind{1},ind{2},ind{4})} ind{5}];

function output = gene_by_gene_genes(coord,inhib,genes)
need_reduce_list = gene_by_gene_genes2(coord,inhib,genes);
output = reduce_genes(crazy_length(need_reduce_list,100000),length(need_reduce_list),wrev(genes),[]);

function output = crazy_length(lst,value)
if ~isempty(find(lst==value, 1))
    output = length(find(lst,value));
else
    output = 0;
end
    
function output = reduce_genes(count,tcount,rgenes,ngenes)
gen = pop_generation();
if isempty(rgenes)
    output = ngenes;
elseif count == 0
    output = wrev(rgenes);
elseif ((count < tcount) || (rgenes{1}(1) < 1))
    output = reduce_genes(count,tcount-1,rgenes(2:end),[rgenes(1) ngenes]);
elseif (count == tcount) && (floor(rand*3) < 1)
    output = [rgenes(2:end) {[rgenes{1}(1)-1 rgenes{1}(2)]} ngenes];
elseif floor(rand*3) < 1
    output = reduce_genes(count,tcount-1,rgenes(2:end),[{gen.set_moves(rgenes{1},(gen.get_moves(rgenes{1})-1))} ngenes]);
else
    output = reduce_genes(count,tcount-1,rgenes(2:end),[rgenes(1) ngenes]);
end

function output = gene_by_gene_genes2(coord,inhib,genes)
global inhib_coord;
mycoord = coord_inhib();

out = zeros(1,length(genes));
for i=1:length(genes)
    gene = genes{i};
    if inhib_coord
        out(i) = gene_by_gene_gene(mycoord.combine_gene(coord,inhib,gene),gene,gene(1),0,2,-100000);
    else
        out(i) = gene_by_gene_gene(gene(2),gene,gene(1),0,2,-100000);
    end
end
output = out;

function output = gene_by_gene_gene(gene_c,gene,moves,count,last,need_reduce)
fit = fitness();
eval = fit.get_gene_fitness(gene_c);
if count >= (moves - 1)
    output = need_reduce;
elseif (eval+2) < last
    output = gene_by_gene_gene(gene_c,gene,moves,count+1,eval,100000);
elseif eval < (last * 0.5)
    output = gene_by_gene_gene(gene_c,gene,moves,count+1,eval,100000);
else
    output = gene_by_gene_gene(gene_c,gene,moves,count+1,eval,need_reduce);
end

function output = weed_out(genes)
genes = cellfun(@weed,genes,'UniformOutput',false);
genes(cellfun(@(genes) isempty(genes),genes)) = [];
output = genes;

function output = weed(gene)
if gene(1)~=0;
    output = gene;
else
    output = [];
end

function output = add_random(genes)
output = {add_random2(genes,0,0)};

function output = add_random2(genes,move_count,gene_count)
gen = pop_generation();
if isempty(genes)
    output = [];
else
    gene = genes{1};
    rest = genes(2:end);
    if ((gene(1) == 0) && (move_count < 15 || gene_count < 4))
        output = [{gen.set_moves(gen.make_random_gene(),5)} add_random2(rest,move_count+5,gene_count+1)];
    else
        output = [{gene} add_random2(rest,move_count+gene(1),gene_count+1)];
    end
end

function output = all_down_one(ind)
output = [ind{1} ind{2} {cellfun(@all_down_one_gene,ind{3},'UniformOutput',false)} add_random(weed_out(cellfun(@all_down_one_gene,ind{4},'UniformOutput',false))) ind{5}];

function output = all_down_one_gene(gene)
new_moves = gene(1) - 1;
if new_moves >= 0;
    output = [new_moves gene(2)];
else
    output = gene;
end

function output = all_up_one(ind)
output = [ind{1} ind{2} {cellfun(@all_up_one_gene,ind{3},'UniformOutput',false)} add_random(weed_out(cellfun(@all_up_one_gene,ind{4},'UniformOutput',false))) ind{5}];

function output = all_up_one_gene(gene)
new_moves = gene(1) + 1;
if new_moves ~= 1;
    output = [new_moves gene(2)];
else
    output = gene;
end

function output = condense_ci(ind)
output = [0 0 {condense1(ind{1},ind{2},ind{3})} {condense1(ind{1},ind{2},ind{4})} ind{5}];

function output = condense(ind)
output = [ind{1} ind{2} {condense1(ind{1},ind{2},ind{3})} {condense1(ind{1},ind{2},ind{4})} ind{5}];

function output = condense1(c,i,genes)
new_genes = condense2(c,i,genes);
output = condense3(new_genes{1},new_genes(2:end));

function output = condense2(c,i,genes)
coord = coord_inhib();
out = cell(1,length(genes));

for j=1:length(genes)
    gene = genes{j};
    new_act = coord.combine_gene(c,i,gene);
    out{j} = [gene(1) new_act];
end
output = out;

function output = condense3(last_gene,genes)
if isempty(genes)
    output = {last_gene};
else
    gene = genes{1};
    if gene(2) == last_gene(2)
        output = condense3([gene(1)+last_gene(1) last_gene(2)],genes(2:end));
    else
        output = [last_gene condense3(gene,genes(2:end))];
    end
end  