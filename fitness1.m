function myfitness = fitness1()
myfitness.evaluate = @evaluate;
myfitness.get_ind_fitness = @get_ind_fitness;
myfitness.get_gene_fitness = @get_gene_fitness;

function popfitness = evaluate(pop)
inhbcoord = coord_inhib();
popfitness = evaluate2(inhbcoord.combine_pop(pop));

function fitness2 = evaluate2(pop)
state = robot_state();
state.reset_robot();
fits = zeros(1,length(pop));
for i=1:length(pop)
    fits(i) = get_ind_fitness(pop{i},pop{i});
end
fitness2 = fits;
    
function indfitness = get_ind_fitness(ind,ind_org)
global num_moves;
indfitness = get_ind_fitness1(ind,ind_org,num_moves) * 0.560019774097047;

function indfitness1 = get_ind_fitness1(ind,ind_org,num)
if isempty(ind)
    if ~isempty(find(ind_org==-1, 1))
        indfitness1 = get_ind_fitness2(ind_org(2:end),ind_org(2:end),num);
    else
        disp(ind_org);
    end
elseif (ind(1) == -1)
    indfitness1 = get_ind_fitness2(ind(2:end),ind(2:end),num);
else
    indfitness1 = get_gene_fitness(ind(1)) + get_ind_fitness1(ind(2:end),ind_org,num-1);
end

function indfitness2 = get_ind_fitness2(ind,ind_org,num)
if (num <= 0)
    indfitness2 = 0;
elseif isempty(ind)
    indfitness2 = get_ind_fitness2(ind_org,ind_org,num);
else
    indfitness2 = get_gene_fitness(ind(1)) + get_ind_fitness2(ind(2:end),ind_org,num-1);
end

function gene_fitness = get_gene_fitness(gene)
gene_fitness = get_gene_fitness2(gene,0);

function gene_fitness2 = get_gene_fitness2(gene,show)
next_gene = movev(gene);
legs_on_ground = get_legs_on_ground();
down_bonus = get_down_bonus(legs_on_ground);
moveh_lst = moveh(next_gene);
r_fit = get_side_fit(moveh_lst,legs_on_ground,5,0,0);
l_fit = get_side_fit(moveh_lst,legs_on_ground,6,0,0);
fitness = down_bonus * 1.000000000 * check_balance(legs_on_ground) * get_balanced_fitness(r_fit,l_fit) * zero_log_adjust(legs_on_ground,moveh_lst);
if show
    show_gene_fitness2(next_gene,legs_on_ground,moveh_lst,fitness);
else
    gene_fitness2 = fitness;
end

function zla = zero_log_adjust(log,mhl)
if (isempty(log))
    zla = 1;
elseif (mhl(log(1)) == 0)
    zla = 0.25;
else
    zla = zero_log_adjust(log(2:end),mhl);
end

function [balance] = check_balance(log)
even_over1 = get_over1(log,6,0);
odd_over1 = get_over1(log,5,0);
x = ((~isempty(find(log==2,1)) && ~isempty(find(log==6,1))) && (~isempty(find(log==3,1)) || odd_over1));
y = ((~isempty(find(log==1,1)) && ~isempty(find(log==5,1))) && (~isempty(find(log==4,1)) || even_over1));
z = ((~isempty(find(log==1,1)) && ~isempty(find(log==3,1))) && (~isempty(find(log==4,1)) && ~isempty(find(log==6,1))));
a = ((~isempty(find(log==3,1)) && ~isempty(find(log==5,1))) && (~isempty(find(log==2,1)) && ~isempty(find(log==4,1))));
b = ((~isempty(find(log==1,1)) && ~isempty(find(log==6,1))) || (~isempty(find(log==2,1)) && ~isempty(find(log==5,1))));
if (x || y || z || a)
    balance = 1;
elseif (length(log)>2 && b)
    balance = 0.75;
elseif ((~isempty(find(log==1,1)) && ~isempty(find(log==6,1))) || (~isempty(find(log==2,1)) && ~isempty(find(log==5,1))))
    balance = 0.55;
elseif (length(log)>2 && ~isempty(find(log==3,1)) && ~isempty(find(log==4,1)))
    balance = 0.45;
elseif (~isempty(find(log==3,1)) && ~isempty(find(log==4,1)))
    balance = 0.3;
else
    balance = 0.15;
end

function output = collect(gene)
output = gene(2);

function lst = less_leg(list)
[idx,idx] = sort(cellfun(@collect,list));
lst = list(idx);

function over1 = get_over1(log,index,count)
if index>0
    over1 = count > 1;
else
    if ~isempty(find(log==index,1))
        over1 = get_over1(log,index-2,count+1);
    else
        over1 = get_over1(log,index-2,count);
    end
end

function switch_delay = get_switch_delay()
global robot;
switch_delay = get_switch_delay2(robot(1:6,1)');

function switch_delay2 = get_switch_delay2(lld)
if (length(lld) < 4)
    switch_delay2 = 1;
elseif (get_switch_delay3(1,lld(1),lld(2:end)) < 0)
    switch_delay2 = 0.5;
else
    switch_delay2 = get_switch_delay2(lld(2:end));
end

function switch_delay3 = get_switch_delay3(num_down,leg,list_legs)
global leg_height_equiv_dist;
if isempty(list_legs)
    if num_down > 3
        switch_delay3 = -2;
    else
        switch_delay3 = 0;
    end
elseif abs(leg - list_legs(1)) < leg_height_equiv_dist
    switch_delay3 = get_switch_delay3(num_down+1,leg,list_legs(2:end));
else
    switch_delay3 = get_switch_delay3(num_down,leg,list_legs(2:end));
end

function sidefit = get_side_fit(moveh_lst,log,index,count,fit)
if 0 > index
    sidefit = fit/count;
else
    if ~isempty(find((log==index), 1))
        sidefit = get_side_fit(moveh_lst,log,index-2,count+1,fit+moveh_lst(index));
    else
        sidefit = get_side_fit(moveh_lst,log,index-2,count,fit);
    end
end

function newgene = movev(gene)
state=robot_state();
if floor(gene/2048) == 1
    state.move_leg_v(4,'up');
else
    state.move_leg_v(4,'down');
end
gene = mod(gene,2048);
if floor(gene/1024) == 1
    state.move_leg_v(5,'up');
else
    state.move_leg_v(5,'down');
end
gene = mod(gene,1024);
if floor(gene/512) == 1
    state.move_leg_v(6,'up');
else
    state.move_leg_v(6,'down');
end
gene = mod(gene,512);
if floor(gene/256) == 1
    state.move_leg_v(3,'up');
else
    state.move_leg_v(3,'down');
end
gene = mod(gene,256);
if floor(gene/128) == 1
    state.move_leg_v(2,'up');
else
    state.move_leg_v(2,'down');
end
gene = mod(gene,128);
if floor(gene/64) == 1
    state.move_leg_v(1,'up');
else
    state.move_leg_v(1,'down');
end
newgene = mod(gene,64);


function list = moveh(gene)
state = robot_state();
lst = [-100 -100 -100 -100 -100 -100];
if floor(gene/32) == 1
    lst(3)=state.move_leg_h(3,'back');
else
    lst(3)=state.move_leg_h(3,'forward');
end
gene = mod(gene,32);
if floor(gene/16) == 1
    lst(2)=state.move_leg_h(2,'back');
else
    lst(2)=state.move_leg_h(2,'forward');
end
gene = mod(gene,16);
if floor(gene/8) == 1
    lst(1)=state.move_leg_h(1,'back');
else
    lst(1)=state.move_leg_h(1,'forward');
end
gene = mod(gene,8);
if floor(gene/4) == 1
    lst(4)=state.move_leg_h(4,'back');
else
    lst(4)=state.move_leg_h(4,'forward');
end
gene = mod(gene,4);
if floor(gene/2) == 1
    lst(5)=state.move_leg_h(5,'back');
else
    lst(5)=state.move_leg_h(5,'forward');
end
gene = mod(gene,2);
if gene == 1
    lst(6)=state.move_leg_h(6,'back');
else
    lst(6)=state.move_leg_h(6,'forward');
end
list = lst;

function log = get_legs_on_ground()
length_list = less_leg(current_up_pairs([1 2 3 4 5 6]));
on_ground_list = get_eq_list(length_list{1}(2),length_list);
num_og = length(on_ground_list);
first_leg = length_list{1}(1);
second_leg = length_list{2}(1);
second_leg_length = length_list{2}(2);
third_leg_pair = length_list{3};
legs_remaining = length_list(3:end);
fourth_leg_pair = length_list{4};
if 3 < num_og
    log = sort(cellfun(@legs_only,on_ground_list));
elseif 3==num_og
    legs_only_list = sort(cellfun(@legs_only,on_ground_list));
    if (all(mod(legs_only_list,2)==1) || all(mod(legs_only_list,2)==0))
        log = sort([legs_only_list get_next(fourth_leg_pair,legs_remaining(2:end))]);
    else
        log = legs_only_list;
    end
elseif (first_leg + second_leg) == 7
    log = sort(dynamic_gait(first_leg,second_leg,second_leg_length,legs_remaining));
elseif mod(first_leg,2)==0
    if mod(second_leg,2)==0
        log = sort([[first_leg second_leg] get_next_odd(third_leg_pair,legs_remaining)]);
    else
        log = sort([[first_leg second_leg] get_next(third_leg_pair,legs_remaining)]);
    end
else
    if mod(second_leg,2)==1
        log = sort([[first_leg second_leg] get_next_even(third_leg_pair,legs_remaining)]);
    else
        log = sort([[first_leg second_leg] get_next(third_leg_pair,legs_remaining)]);
    end
end

function output = get_balanced_fitness(rf,lf)
global temp;
if temp > 97
    output = (rf + lf)/2;
elseif temp > 94
    output = ((rf + lf)/2) * get_switch_delay();
else
    output = min(rf,lf) * get_switch_delay();
end

function output = current_up_pairs(indices)
global robot;
list = cell(1,length(indices));
for i=1:length(indices)
    list{i} = [indices(i) robot(indices(i),1)];
end
output = list;

function dg = dynamic_gait(fl,sl,sll,lr)
dg = [[fl sl] sort(cellfun(@legs_only,get_eq_list_spec(sll,lr,3)))];

function next = get_next(tlp,lr)
next = sort(cellfun(@legs_only,get_eq_list(tlp(2),lr)));

function next_odd = get_next_odd(tlp,lr)
if mod(tlp(1),2)==1
    next_odd = sort(cellfun(@legs_only,get_eq_list_odd(tlp(2),lr)));
else
    next_odd = get_next_odd(lr{2},lr(2:end));
end

function next_even = get_next_even(tlp,lr)
if mod(tlp(1),2)==0
    next_even = sort(cellfun(@legs_only,get_eq_list_even(tlp(2),lr)));
else
    next_even = get_next_even(lr{2},lr(2:end));
end

function output = legs_only(pair)
output = pair(1);

function eql = get_eq_list(x,lst)
xx = zeros(1,length(lst)); xx(:)=x; xx = num2cell(xx);
list = cellfun(@get_eql,xx,lst,'UniformOutput',false);
list(cellfun(@(list) isempty(list),list)) = [];
eql = list;

function output = get_eql(x,lst)
if x==lst(2)
    output = lst;
else
    output = [];
end

function output = get_eqlo(x,lst)
if (x==lst(2) && mod(lst(1),2)==1)
    output = lst;
else
    output = [];
end

function output = get_eqle(x,lst)
if (x==lst(2) && mod(lst(1),2)==0)
    output = lst;
else
    output = [];
end

function eqlo = get_eq_list_odd(x,lst)
xx = zeros(1,length(lst)); xx(:)=x; xx = num2cell(xx);
list = cellfun(@get_eqlo,xx,lst,'UniformOutput',false);
list(cellfun(@(list) isempty(list),list)) = [];
eqlo = list;

function eqle = get_eq_list_even(x,lst)
xx = zeros(1,length(lst)); xx(:)=x; xx = num2cell(xx);
list = cellfun(@get_eqle,xx,lst,'UniformOutput',false);
list(cellfun(@(list) isempty(list),list)) = [];
eqle = list;

function eqls = get_eq_list_spec(x,lst,spec)
list = cell(1,length(lst));
for i=1:length(lst)
    if abs(x - lst{i}(2)) <= spec
        list(i) = lst(i);
    end
end
list(cellfun(@(list) isempty(list),list)) = [];
eqls = list;

function db = get_down_bonus(log)
global robot;
if isempty(log)
    db = 1.0;
elseif (robot(log(1),1) == robot(log(1),3))
    db = get_down_bonus(log(2:end));
else
    db = 0.5;
end

function remain = get_remain(x,lst)
if isempty(lst)
    remain = [];
else
    if x == lst{1}(1)
        remain = get_remain(x,lst(2:end));
    else
        remain = lst;
    end
end

