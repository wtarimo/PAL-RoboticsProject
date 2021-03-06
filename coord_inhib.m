function coord = coord_inhib()
coord.combine_pop = @combine_pop;
coord.combine_gene = @combine_gene;
coord.combine_ind = @combine_ind;

function output = combine_pop(pop)
output = cellfun(@combine_ind,pop,'UniformOutput', false);

function output = combine_ind(ind)
output = [combine_ind2(ind{1},ind{2},ind{3}) -1 combine_ind2(ind{1},ind{2},ind{4})];

function output = get_moves(gene)
output = gene(1);

function output = combine_ind2(coords,inhibs,genes)
moves = sum(cellfun(@get_moves,genes));
index1 = 1;
out = zeros(1,moves);
for i=1:length(genes)
    gene_moves = combine_gene_moves(coords,inhibs,genes{i});
    index2 = length(gene_moves)+index1-1;
    out(index1:index2) = gene_moves;
    index1 = index2+1;
end
output = out;

function output = combine_gene_moves(coords,inhibs,gene)
global inhib_coord;
if inhib_coord
    output = combine_gene(coords,inhibs,gene)*ones(1,gene(1));
else
    output = gene(2)*ones(1,gene(1));
end

function output = combine_gene(coords,inhibs,gene)
combined_lists = add_coordinators(coords,inhibs,gene);
output = add_back(add_up(0,combined_lists{2}), combined_lists{1});

function output = add_coordinators(coords,inhibs,gene)
up_act_lst = get_up_act_lst(gene(2));
back_act_lst = add_inhibitors(get_back_act_lst(mod(gene(2),64)),inhibs);

coords = mod(coords,4096);
if floor(coords/2048) == 1  %BD0
    if any(ismember(back_act_lst,0)) && any(ismember(up_act_lst,0))
        up_act_lst = up_act_lst(up_act_lst~=0);
    end
end
coords = mod(coords,2048);
if floor(coords/1024) == 1  %FU0
    if ~any(ismember(back_act_lst,0)) && ~any(ismember(up_act_lst,0))
        up_act_lst = [0 up_act_lst];
    end
end
coords = mod(coords,1024);
if floor(coords/512) == 1  %BD1
    if any(ismember(back_act_lst,1)) && any(ismember(up_act_lst,1))
        up_act_lst = up_act_lst(up_act_lst~=1);
    end
end
coords = mod(coords,512);
if floor(coords/256) == 1  %FU1
    if ~any(ismember(back_act_lst,1)) && ~any(ismember(up_act_lst,1))
        up_act_lst = [1 up_act_lst];
    end
end
coords = mod(coords,256);
if floor(coords/128) == 1  %BD2
    if any(ismember(back_act_lst,2)) && any(ismember(up_act_lst,2))
        up_act_lst = up_act_lst(up_act_lst~=2);
    end
end
coords = mod(coords,128);
if floor(coords/64) == 1  %FU2
    if ~any(ismember(back_act_lst,2)) && ~any(ismember(up_act_lst,2))
        up_act_lst = [2 up_act_lst];
    end
end
coords = mod(coords,64);
if floor(coords/32) == 1  %BD3
    if any(ismember(back_act_lst,3)) && any(ismember(up_act_lst,3))
        up_act_lst = up_act_lst(up_act_lst~=3);
    end
end
coords = mod(coords,32);
if floor(coords/16) == 1  %FU3
    if ~any(ismember(back_act_lst,3)) && ~any(ismember(up_act_lst,3))
        up_act_lst = [3 up_act_lst];
    end
end
coords = mod(coords,16);
if floor(coords/8) == 1  %BD4
    if any(ismember(back_act_lst,4)) && any(ismember(up_act_lst,4))
        up_act_lst = up_act_lst(up_act_lst~=4);
    end
end
coords = mod(coords,8);
if floor(coords/4) == 1  %FU4
    if ~any(ismember(back_act_lst,4)) && ~any(ismember(up_act_lst,4))
        up_act_lst = [4 up_act_lst];
    end
end
coords = mod(coords,4);
if floor(coords/2) == 1  %BD5
    if any(ismember(back_act_lst,5)) && any(ismember(up_act_lst,5))
        up_act_lst = up_act_lst(up_act_lst~=5);
    end
end
coords = mod(coords,2);
if coords == 1          %FU5
    if ~any(ismember(back_act_lst,5)) && ~any(ismember(up_act_lst,5))
        up_act_lst = [5 up_act_lst];
    end
end
output = {back_act_lst up_act_lst};

function output = get_up_act_lst(act)
if floor(act/2048)==1
    output = [3 get_up_act_lst(mod(act,2048))];
elseif floor(act/1024)==1
    output = [4 get_up_act_lst(mod(act,1024))];
elseif floor(act/512)==1
    output = [5 get_up_act_lst(mod(act,512))];
elseif floor(act/256)==1
    output = [2 get_up_act_lst(mod(act,256))];
elseif floor(act/128)==1
    output = [1 get_up_act_lst(mod(act,128))];
elseif floor(act/64)==1
    output = [0 get_up_act_lst(mod(act,64))];
else
    output = [];
end

function output = get_back_act_lst(act)
if floor(act/32)==1
    output = [2 get_back_act_lst(mod(act,32))];
elseif floor(act/16)==1
    output = [1 get_back_act_lst(mod(act,16))];
elseif floor(act/8)==1
    output = [0 get_back_act_lst(mod(act,8))];
elseif floor(act/4)==1
    output = [3 get_back_act_lst(mod(act,4))];
elseif floor(act/2)==1
    output = [4 get_back_act_lst(mod(act,2))];
elseif act==1
    output = [5 get_back_act_lst(0)];
else
    output = [];
end

function output = add_inhibitors(bl,inhib)
if floor(mod(inhib,32768)/16384)==1
    bl=add_inhibitors2(bl,0,1);
end
if floor(mod(inhib,16384)/8192)==1
    bl=add_inhibitors2(bl,0,2);
end
if floor(mod(inhib,8192)/4096)==1
    bl=add_inhibitors2(bl,0,3);
end
if floor(mod(inhib,4096)/2048)==1
    bl=add_inhibitors2(bl,0,4);
end
if floor(mod(inhib,2048)/1024)==1
    bl=add_inhibitors2(bl,0,5);
end
if floor(mod(inhib,1024)/512)==1
    bl=add_inhibitors2(bl,1,2);
end
if floor(mod(inhib,512)/256)==1
    bl=add_inhibitors2(bl,1,3);
end
if floor(mod(inhib,256)/128)==1
    bl=add_inhibitors2(bl,1,4);
end
if floor(mod(inhib,128)/64)==1
    bl=add_inhibitors2(bl,1,5);
end
if floor(mod(inhib,64)/32)==1
    bl=add_inhibitors2(bl,2,3);
end
if floor(mod(inhib,32)/16)==1
    bl=add_inhibitors2(bl,2,4);
end
if floor(mod(inhib,16)/8)==1
    bl=add_inhibitors2(bl,2,5);
end
if floor(mod(inhib,8)/4)==1
    bl=add_inhibitors2(bl,3,4);
end
if floor(mod(inhib,4)/2)==1
    bl=add_inhibitors2(bl,3,5);
end
if mod(inhib,2)==1
    bl=add_inhibitors2(bl,4,5);
end
output = bl;


function output = add_inhibitors2(lst,x,y)
if any(ismember(lst,x)) && any(ismember(lst,y))
    output = lst(lst~=y);
else
    if ~any(ismember(lst,x)) && ~any(ismember(lst,y))
        output = [y lst];
    else
        output = lst;
    end
end

function output = add_up(new_gene,lst)
if isempty(lst)
    output = new_gene;
else
    switch lst(1)
        case 3
            output = add_up(2048+new_gene,lst(2:end));
        case 4
            output = add_up(1024+new_gene,lst(2:end));
        case 5
            output = add_up(512+new_gene,lst(2:end));
        case 2
            output = add_up(256+new_gene,lst(2:end));
        case 1
            output = add_up(128+new_gene,lst(2:end));
        case 0
            output = add_up(64+new_gene,lst(2:end));
    end
end

function output = add_back(new_gene,lst)
if isempty(lst)
    output = new_gene;
else
    switch lst(1)
        case 2
            output = add_back(32+new_gene,lst(2:end));
        case 1
            output = add_back(16+new_gene,lst(2:end));
        case 0
            output = add_back(8+new_gene,lst(2:end));
        case 3
            output = add_back(4+new_gene,lst(2:end));
        case 4
            output = add_back(2+new_gene,lst(2:end));
        case 5
            output = add_back(1+new_gene,lst(2:end));
    end
end

function check_pop(pop)
if isempty(pop)
    fprintf('\n OK \n');
else
    chech_ind(pop{1});
    check_pop(pop(2:end));
end

function check_ind(ind)
if isempty(ind)
    disp('-');
elseif length(ind{1})==1
    disp('*************************************************');
    disp(cell2str(ind));
else
    check_ind(ind(2:end));
end