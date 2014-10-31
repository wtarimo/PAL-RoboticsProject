function pop = pop_generation()
pop.make_random_pop = @make_random_pop;
pop.make_random_gene = @make_random_gene;
pop.make_random_ind = @make_random_ind;
pop.get_lengths = @get_lengths;
pop.get_coordinators = @get_coordinators;
pop.get_activations = @get_activations;
pop.get_inhibitors = @get_inhibitors;
pop.get_start = @get_start;
pop.get_loop = @get_loop;
pop.get_moves = @get_moves;
pop.set_moves = @set_moves;
pop.ind_equal = @ind_equal;
pop.set_bias = @set_bias;
pop.get_bias = @get_bias;

function random_pop = make_random_pop(ind_count,loop_size)
pop = cell(1,ind_count);
for i=1:ind_count
    coordinhib = {floor(rand*4096) floor(rand*32768) {[0 0]}};
    loopsection = {make_section(loop_size)};
    pop{i} = [coordinhib loopsection 1];
end
random_pop = pop;

function output = make_random_ind()
pop = make_random_pop(1,12);
output = pop{1};

function output = make_section(section_size)
section{1,section_size}=[];
for i=1:section_size
    section{i} = [floor(50*rand) floor(4096*rand)];
end
output = section;

function output = make_random_gene()
output = [floor(rand*50) floor(rand*4096)];

function output = get_moves(gene)
output = gene(1);

function output = get_bias(ind)
output = ind{5};

function output = set_bias(ind,bias)
ind{5} = bias;
output = ind;

function output = get_activations(gene)
output = gene(2);

function output = get_coordinators(ind)
output = ind{1};

function output = get_inhibitors(ind)
output = ind{2};

function output = get_start(ind)
output = ind{3};

function output = get_loop(ind)
output = ind{4};

function output = get_total_gene(pop)
if isempty(pop)
    output = 0;
else
    output = get_gene_per_ind(pop{1}) + get_total_gene(pop(2:end));
end

function output = set_moves(gene,num)
output = [num gene(2)];

function [output] = ind_equal(ind1,ind2)
ind1 = cell2str(ind1);
ind2 = cell2str(ind2);
if length(ind1) ~= length(ind2)
    output = 0;
else
    output = all((ind1==ind2)==1);
end
