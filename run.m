function output = run(inds,gens)
state = robot_state();
gen = pop_generation();
evolution = train_pop1();
fit = fitness();

constants();
global robot; robot=load('robot.txt');
global leg_height_equiv_dist; 
leg_height_equiv_dist = state.get_height_equiv_dist();
global ind_per_pop; ind_per_pop = inds;
global prob_of_mutate; prob_of_mutate = 300;
global generations; generations = gens;
global start; start = 0;
global temp; temp = 0;
global start_length; start_length = 1;
global loop_length; loop_length = 12;


pop = gen.make_random_pop(ind_per_pop,loop_length);
out = evolution.train(pop,generations);
state.reset_robot();
fits = fit.evaluate(out);
best = out{fits==max(fits)};
printpop(out,best);
output = out;

